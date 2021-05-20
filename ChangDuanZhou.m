%***************** 提取叶片的长轴短轴并计算偏心率 函数 **********************
% 1,找出重心点（现成函数），找出叶尖（整个图像的最高点，要保证图像是竖直的）
% 2,叶尖与重心的连线是叶片主轴，叶片轮廓与主轴的两个交点的长度是长轴
% 3,穿过重心与主轴垂直的直线是横轴，横轴与叶片轮廓的交点距离是短轴
% 4,求交点时，应用直线与点的距离公式，遍历叶片边缘点集寻找离直线最近的点，再找一个与这个点的距离超过叶片一半的距离且还与直线距离最近的点
% 然后直接计算这两点的距离即可

% 输入叶片边缘点集data和二值化之后的叶片图像I，输出为长短轴比和重心点坐标
function [eccentricity,ZhongXin1] = ChangDuanZhou(data,I)
% 叶片最高点 = 叶尖
[r,c] = size(data);
x = data(1,:);      % 将叶片边缘点集第一个点存储为一个一行两列的向量x
for i=1:r-1
    if x(2) < data(i+1,2)     % 如果x的y坐标比data的第i+1个坐标点的y坐标要小，放弃现有x，写入新x，否则不变
        x = data(i+1,:);
    end  
end
x;       % 输出x，x即为叶尖的坐标

% 重心
% I=rgb2gray(I);    % 这三句注释了是因为函数要求已经将图像二值化了
% imshow(I)
% I=double(I);
[rowss,colss]=size(I);
x1=ones(rowss,1)*[1:colss];
y=[1:rowss]'*ones(1,colss);
areaA=sum(sum(I));
meanx=sum(sum(I.*x1))/areaA;
meany=sum(sum(I.*y))/areaA;    % meanx和meany即为重心的坐标
ZhongXin = [meanx,meany];
meanx;
meany;
ZhongXin;
data(1,:);
% ZhongXin-x
% 构造叶尖和重心连接的直线函数
% Zhu_line = @(xx)((meany-x(1,1))/(meanx-x(1,2))*(xx-x(1,1))+x(1,1));

% 计算长轴
 % 直线与点的距离公式
%!网上的 d = abs(det([Q2-Q1,P-Q1]))/norm(Q2-Q1);
%自己的 d = abs(cross([Q2-Q1,0],[P-Q1,0]))/norm(Q2-Q1);
% 其中，P是点坐标；Q1, Q2是线上两点坐标
d0 = abs(norm(cross([ZhongXin-x,0],[data(1,:)-x,0])))/norm(ZhongXin-x);
ZuiXiao=data(1,:);
for i=1:r
    d = abs(norm(cross([ZhongXin-x,0],[data(i,:)-x,0])))/norm(ZhongXin-x);
    if(d<d0)
        d0=d;
        ZuiXiao=data(i,:);      % 距离最小的点
    end
end
% d0        % d0是输出的距离长轴最小距离
d2 = abs(norm(cross([ZhongXin-x,0],[data(1,:)-x,0])))/norm(ZhongXin-x);
ZuiXiao2=data(1,:);
for i=1:r
    d = abs(norm(cross([ZhongXin-x,0],[data(i,:)-x,0])))/norm(ZhongXin-x);
    d1 = norm(ZuiXiao-data(i,:));       % 之前求得的最小点与data中点的距离
    if(d<d2 && d1>10)        % 这里的10是需要调整的参量，基准是平均叶长的一半
        d2=d;
        ZuiXiao2=data(i,:);
    end
end
D = norm(ZuiXiao-ZuiXiao2);     % 长轴长度

% 构造垂直于主轴且交于重心的横轴
 % 就是找到横轴上两点就行
  % 将叶尖x绕重心ZhongXin旋转90度，即进行一个坐标变换，转后坐标为Zhuan_x
  % 若设重心坐标为(x0,y0)，设叶尖坐标为(x1,y1)，转90度之后坐标为(x2,y2)
  % 则计算公式为：x2=x0-y0+y1，y2=y0+x0-x1
Zhuan_x = zeros(1,2);       % 初始化
Zhuan_x(1,1) = ZhongXin(1,1)-ZhongXin(1,2)+x(1,2);
Zhuan_x(1,2) = ZhongXin(1,2)+ZhongXin(1,1)-x(1,1);

% 计算短轴
d0 = abs(norm(cross([ZhongXin-Zhuan_x,0],[data(1,:)-Zhuan_x,0])))/norm(ZhongXin-Zhuan_x);
Heng_ZuiXiao=data(1,:);
for i=1:r
    d = abs(norm(cross([ZhongXin-Zhuan_x,0],[data(i,:)-Zhuan_x,0])))/norm(ZhongXin-Zhuan_x);
    if(d<d0)
        d0=d;
        Heng_ZuiXiao=data(i,:);      % 距离最小的点
    end
end
d2 = abs(norm(cross([ZhongXin-Zhuan_x,0],[data(1,:)-Zhuan_x,0])))/norm(ZhongXin-Zhuan_x);
Heng_ZuiXiao2=data(1,:);
for i=1:r
    d = abs(norm(cross([ZhongXin-Zhuan_x,0],[data(i,:)-Zhuan_x,0])))/norm(ZhongXin-Zhuan_x);
    d1 = norm(Heng_ZuiXiao-data(i,:));       % 之前求得的最小点与data中点的距离
    if(d<d2 && d1>10)        % 这里的10是需要调整的参量，基准是平均叶宽的一半
        d2=d;
        Heng_ZuiXiao2=data(i,:);
    end
end
D2 = norm(Heng_ZuiXiao-Heng_ZuiXiao2);     % 短轴长度

% 计算叶基凹陷程度
eccentricity = D/D2;
ZhongXin1=ZhongXin;
end