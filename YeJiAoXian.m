function YeJi_d = YeJiAoXian(tu,ZhongXin,YeJian)
% 求边界到重心最近距离的点，就是叶基的位置
% 输入tu是边界有序点集，ZhongXin是重心坐标，YeJian是叶尖坐标
r = size(tu,1);
d0 = ((tu(1,1)-ZhongXin(1))^2+(tu(1,2)-ZhongXin(2))^2)^0.5; % 这是边界第一个点与重心的距离
YeJi = tu(1,:);
for i=1:r-1
    d = ((tu(i,1)-ZhongXin(1))^2+(tu(i,2)-ZhongXin(2))^2)^0.5;
    if d<d0
        YeJi = tu(i,:);
        d0 = d; % 刷新最小距离
    end
end
YeJi_d = norm(YeJi-YeJian);
end