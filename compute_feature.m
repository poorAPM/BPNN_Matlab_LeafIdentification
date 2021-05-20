%���ڵ���ҶƬ���������ĳ���
%���룺ҶƬͼ�����
%������������󣨵�ҶƬ��
%featureV��vector������imageM��matrix����
function featureV = compute_feature(imageM)
    %******************** Ԥ���� **********************
    A = imread(imageM); %����ҶƬͼ�����imageM
    B = rgb2gray(A); %תΪ�Ҷ�ͼ��
    
    %******************** ��ֵ�˲� *********************
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
    % ��ֵ�˲�
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
    % ��ֵ��
    oo = uint8(x);
    leve = graythresh(oo);
    bw = im2bw(oo,0.98);
    tuu = edge(bw,'canny'); 
    % ���ܳ�
    zhouchang=0;
    for i = 1:size(tuu,1)
        for j = 1:size(tuu,2)
            if tuu(i,j)==1
                zhouchang = zhouchang+1;
            end
        end
    end
    % zhouchang; % ����ܳ�
    % ��С��Χ�к�͹��
    stats = regionprops(bwlabel(tuu),'ConvexHull');
    tn = stats.ConvexHull; % ͹��
    [tubao_area,tubao_zhouchang] = TuBao_area(tn);
    stats = regionprops(bwlabel(tuu),'BoundingBox');
    tn1 = stats.BoundingBox; % ��С��Χ��
    % ҶƬ���
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

    %******************* �������� **********************
    %�����͹��
    MianJi_AoToBi = Sum_area/tubao_area;
    %�ܳ���͹��
    ZhouChang_AoToBi = zhouchang/tubao_zhouchang;
    %��״����
    XingZhuangCanShu = 4*pi*Sum_area/zhouchang^2;
    %�����
    ChangKuanBi = tn1(3)/tn1(4);
    %���ζ�
    JuXingDu = Sum_area/(tn1(3)*tn1(4));
    %Բ�ζ�
    YuanXingDu = 4*pi*Sum_area/tubao_zhouchang^2;
    %ƫ����
    [YouXu,Tu] = BianJie_arraying(tuu);
    [PianXinLv,ZhongXin] = ChangDuanZhou(YouXu,bw);
    %Ҷ��Ƕ�
    [YeJianJiao,Jian] = YeJian(YouXu,ZhongXin,zhouchang,YouXu);
    %Ҷ�����ݳ̶�
    AoXian = YeJiAoXian(YouXu,ZhongXin,Jian)/tn1(4);

    %******************** ���ݴ�� ***********************
    featureV = [MianJi_AoToBi,ZhouChang_AoToBi,XingZhuangCanShu,ChangKuanBi,JuXingDu,YuanXingDu,PianXinLv,YeJianJiao,AoXian];
end