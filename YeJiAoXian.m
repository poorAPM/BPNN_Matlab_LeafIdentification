function YeJi_d = YeJiAoXian(tu,ZhongXin,YeJian)
% ��߽絽�����������ĵ㣬����Ҷ����λ��
% ����tu�Ǳ߽�����㼯��ZhongXin���������꣬YeJian��Ҷ������
r = size(tu,1);
d0 = ((tu(1,1)-ZhongXin(1))^2+(tu(1,2)-ZhongXin(2))^2)^0.5; % ���Ǳ߽��һ���������ĵľ���
YeJi = tu(1,:);
for i=1:r-1
    d = ((tu(i,1)-ZhongXin(1))^2+(tu(i,2)-ZhongXin(2))^2)^0.5;
    if d<d0
        YeJi = tu(i,:);
        d0 = d; % ˢ����С����
    end
end
YeJi_d = norm(YeJi-YeJian);
end