%************************* 叶尖角度 **********************%
% 思想：确定叶尖的点，然后根据叶尖点向两侧取一定数量点作为整个叶尖的图像
 % 确定了图像，然后两侧的点分别进行线性拟合，拟合出两条直线
  % 分别确定两条直线上方向正确的方向向量
   % 然后根据两条直线上的方向向量确定叶尖角
function [YeJianJiao,Jian] = YeJian(data,ZhongXin,zhouchang,YouXu)        
%输入二值化的叶片边缘点集，输入图像的重心，输入周长，输入的有序边界点集用于画图
% 叶片最高点 = 叶尖
[r,c] = size(data);
x1 = data(1,:);      % 将叶片边缘点集第一个点存储为一个一行两列的向量x
n=1;        % 记录最后提取的叶尖点在原来边缘集中的位置序号
for i=1:r-1
    if x1(1) > data(i+1,1)     % 如果x1的y坐标比data的第i+1个坐标点的y坐标要小，放弃现有x，写入新x，否则不变
        x1 = data(i+1,:);
        n=i+1;
    end
end
% x1;n;     % 输出x1为叶尖，输出n为叶尖在原边缘集中位置

% 从叶尖点分别向前搜索50个点，向后搜索50个点
Qian = zeros(floor(zhouchang/12),2);     % 这行及下行表示搜索到的点集
Hou = zeros(floor(zhouchang/12),2);
% % 采集方法旧
% n1=1;       % 标记循环次数
% nn1=1;       % 这行以及下一行用来标记寻找到的点在边缘集中的位置
% nn2=1;
% while(n1<=zhouchang/6)       % 循环是搜索并存储叶尖处采集的前后各1/6周长数量的点
%     n1 = n1+1;
%     nn1 = n-1;
%     nn2 = n+1;
%     if nn1<1
%         nn1=r;
%     elseif nn2>r
%         nn2=1;
%     end
%     Qian(n1,:) = data(nn1,:);
%     Hou(n1,:) = data(nn2,:);
% end
% 点的采集方法更新
for i=1:floor(zhouchang/12)
    k = n+i;
    if k>r
        k = k-r;
    end
    Qian(i,:) = data(k,:);
    k = n-i;
    if k<=0
        k = k+r;
    end
    Hou(i,:) = data(k,:);
end

% 线性拟合，下面两行分别表示前后两组采集的点拟合出来的直线的从高次到低次的系数
nihe1 = polyfit(Qian(:,1),Qian(:,2),1);
nihe2 = polyfit(Hou(:,1),Hou(:,2),1);

% %! 求叶尖角初始智障方法
% % 确定两条线交点，初步确定需要判断的四个向量
% syms xxx
% JiaoDian = vpa(solve(nihe1(1)*xxx+nihe1(2)==0,nihe2(1)*xxx+nihe2(2)==0,xxx,true,'Real',true)) % 'ReturnConditions',
% p1 = JiaoDian - [JiaoDian(1)+10,nihe1(1)*(JiaoDian(1)+10)+nihe1(2)];
% p2 = JiaoDian - [JiaoDian(1)-10,nihe1(1)*(JiaoDian(1)-10)+nihe1(2)];
% p3 = JiaoDian - [JiaoDian(1)+10,nihe2(1)*(JiaoDian(1)+10)+nihe2(2)];
% p4 = JiaoDian - [JiaoDian(1)-10,nihe2(1)*(JiaoDian(1)-10)+nihe2(2)];
% p0 = JiaoDian - ZhongXin;       % 参考向量，作为找到正确的方向向量的基准
% 
% % 判断真正的方向向量是哪两个
% syms k1 k2;
% m1 = [];        % m1,m2用于存储识别出来的向量
% m2 = [];
% m = solve(p1*k1+p3*k2==p0);
% % 这四个比较蠢的if就是方便写了，目的是判断哪两个是真正的方向向量，好求方向角
%  % 原理是：p0是叶尖到重心的向量，这个向量一定是朝向方向角的
%   % 如果用正确的方向向量去表示p0的话，一定是两个方向向量的系数都是正数
% if m(1)>0&&m(2)>0
%     m1=p1;
%     m2=p3;
% end
% m = solve(p2*k1+p3*k2==p0);
% if m(1)>0&&m(2)>0
%     m1=p2;
%     m2=p3;
% end
% m = solve(p1*k1+p4*k2==p0);
% if m(1)>0&&m(2)>0
%     m1=p1;
%     m2=p4;
% end
% m = solve(p2*k1+p4*k2==p0);
% if m(1)>0&&m(2)>0
%     m1=p2;
%     m2=p4;
% end
% 
% % 求夹角
% YeJianJiao = acos(dot(m1,m2)/(norm(m1)*norm(m2)));        %弧度制,转角度制乘180/pi

% 最新求法
y1 = ZhongXin(1)*nihe1(1)+nihe1(2);
y2 = ZhongXin(1)*nihe2(1)+nihe2(2);
xiangliang1 = [ZhongXin(1),y1];
xiangliang2 = [ZhongXin(1),y2];
YeJianJiao = dot(x1-xiangliang1,x1-xiangliang2)/(norm(x1-xiangliang1)*norm(x1-xiangliang2));
Jian = x1;

end  