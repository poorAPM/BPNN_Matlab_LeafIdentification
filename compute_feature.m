%对于单个叶片处理特征的程序
%输入：叶片图像矩阵
%输出：特征矩阵（单叶片）
%featureV是vector向量，imageM是matrix矩阵
function featureV = compute_feature(imageM)
    %******************** 预处理 **********************
    A = imread(imageM); %读入叶片图像矩阵imageM
    B = rgb2gray(A); %转为灰度图像
    
    %******************** 均值滤波 *********************
    [h,w] = size(B);
    n=9;
    f = double(B);
    a = ones(n,n);
    y=f;
    for i=1:h-n+1
        for j=1:w-n+1
            a = f(i:i+(n-1),j:j+(n-1));
            s = sum(sum(a));
            y(i+(n-1)/2,j+(n-1)/2) = s/(n*n);
        end
    end
    % 中值滤波
    x=f;
    for i=1:h-n+1
        for j=1:w-n+1
            c = f(i:i+(n-1),j:j+(n-1));
            e = c(1,:);
            for u=2:n
                e = [e,c(u,:)];
            end
            mm = median(e);
            x(i+(n-1)/2,j+(n-1)/2) = mm;
        end
    end
    % 二值化
    oo = uint8(x);
    leve = graythresh(oo);
    bw = im2bw(oo,0.98);
    tuu = edge(bw,'canny'); 
    % 求周长
    zhouchang=0;
    for i = 1:size(tuu,1)
        for j = 1:size(tuu,2)
            if tuu(i,j)==1
                zhouchang = zhouchang+1;
            end
        end
    end
    % zhouchang; % 输出周长
    % 最小包围盒和凸包
    stats = regionprops(bwlabel(tuu),'ConvexHull');
    tn = stats.ConvexHull; % 凸包
    [tubao_area,tubao_zhouchang] = TuBao_area(tn);
    stats = regionprops(bwlabel(tuu),'BoundingBox');
    tn1 = stats.BoundingBox; % 最小包围盒
    % 叶片面积
    sum1=0;
    threshhold=0.5;
    for  i = 1:size(bw,1)
        for j = 1:size(bw,2)
            if bw(i,j) <= threshhold
                sum1 = sum1+1;
            end
        end
    end
    Sum_area=sum1;

    %******************* 特征计算 **********************
    %面积凹凸比
    MianJi_AoToBi = Sum_area/tubao_area;
    %周长凹凸比
    ZhouChang_AoToBi = zhouchang/tubao_zhouchang;
    %形状参数
    XingZhuangCanShu = 4*pi*Sum_area/zhouchang^2;
    %长宽比
    ChangKuanBi = tn1(3)/tn1(4);
    %矩形度
    JuXingDu = Sum_area/(tn1(3)*tn1(4));
    %圆形度
    YuanXingDu = 4*pi*Sum_area/tubao_zhouchang^2;
    %偏心率
    [YouXu,Tu] = BianJie_arraying(tuu);
    [PianXinLv,ZhongXin] = ChangDuanZhou(YouXu,bw);
    %叶尖角度
    [YeJianJiao,Jian] = YeJian(YouXu,ZhongXin,zhouchang,YouXu);
    %叶基凹陷程度
    AoXian = YeJiAoXian(YouXu,ZhongXin,Jian)/tn1(4);

    %******************** 数据打包 ***********************
    featureV = [MianJi_AoToBi,ZhouChang_AoToBi,XingZhuangCanShu,ChangKuanBi,JuXingDu,YuanXingDu,PianXinLv,YeJianJiao,AoXian];
end