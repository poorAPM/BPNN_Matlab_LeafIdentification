%***************** ��ȡҶƬ�ĳ�����Ტ����ƫ���� ���� **********************
% 1,�ҳ����ĵ㣨�ֳɺ��������ҳ�Ҷ�⣨����ͼ�����ߵ㣬Ҫ��֤ͼ������ֱ�ģ�
% 2,Ҷ�������ĵ�������ҶƬ���ᣬҶƬ�������������������ĳ����ǳ���
% 3,�������������ᴹֱ��ֱ���Ǻ��ᣬ������ҶƬ�����Ľ�������Ƕ���
% 4,�󽻵�ʱ��Ӧ��ֱ�����ľ��빫ʽ������ҶƬ��Ե�㼯Ѱ����ֱ������ĵ㣬����һ���������ľ��볬��ҶƬһ��ľ����һ���ֱ�߾�������ĵ�
% Ȼ��ֱ�Ӽ���������ľ��뼴��

% ����ҶƬ��Ե�㼯data�Ͷ�ֵ��֮���ҶƬͼ��I�����Ϊ������Ⱥ����ĵ�����
function [eccentricity,ZhongXin1] = ChangDuanZhou(data,I)
% ҶƬ��ߵ� = Ҷ��
[r,c] = size(data);
x = data(1,:);      % ��ҶƬ��Ե�㼯��һ����洢Ϊһ��һ�����е�����x
for i=1:r-1
    if x(2) < data(i+1,2)     % ���x��y�����data�ĵ�i+1��������y����ҪС����������x��д����x�����򲻱�
        x = data(i+1,:);
    end  
end
x;       % ���x��x��ΪҶ�������

% ����
% I=rgb2gray(I);    % ������ע��������Ϊ����Ҫ���Ѿ���ͼ���ֵ����
% imshow(I)
% I=double(I);
[rowss,colss]=size(I);
x1=ones(rowss,1)*[1:colss];
y=[1:rowss]'*ones(1,colss);
areaA=sum(sum(I));
meanx=sum(sum(I.*x1))/areaA;
meany=sum(sum(I.*y))/areaA;    % meanx��meany��Ϊ���ĵ�����
ZhongXin = [meanx,meany];
meanx;
meany;
ZhongXin;
data(1,:);
% ZhongXin-x
% ����Ҷ����������ӵ�ֱ�ߺ���
% Zhu_line = @(xx)((meany-x(1,1))/(meanx-x(1,2))*(xx-x(1,1))+x(1,1));

% ���㳤��
 % ֱ�����ľ��빫ʽ
%!���ϵ� d = abs(det([Q2-Q1,P-Q1]))/norm(Q2-Q1);
%�Լ��� d = abs(cross([Q2-Q1,0],[P-Q1,0]))/norm(Q2-Q1);
% ���У�P�ǵ����ꣻQ1, Q2��������������
d0 = abs(norm(cross([ZhongXin-x,0],[data(1,:)-x,0])))/norm(ZhongXin-x);
ZuiXiao=data(1,:);
for i=1:r
    d = abs(norm(cross([ZhongXin-x,0],[data(i,:)-x,0])))/norm(ZhongXin-x);
    if(d<d0)
        d0=d;
        ZuiXiao=data(i,:);      % ������С�ĵ�
    end
end
% d0        % d0������ľ��볤����С����
d2 = abs(norm(cross([ZhongXin-x,0],[data(1,:)-x,0])))/norm(ZhongXin-x);
ZuiXiao2=data(1,:);
for i=1:r
    d = abs(norm(cross([ZhongXin-x,0],[data(i,:)-x,0])))/norm(ZhongXin-x);
    d1 = norm(ZuiXiao-data(i,:));       % ֮ǰ��õ���С����data�е�ľ���
    if(d<d2 && d1>10)        % �����10����Ҫ�����Ĳ�������׼��ƽ��Ҷ����һ��
        d2=d;
        ZuiXiao2=data(i,:);
    end
end
D = norm(ZuiXiao-ZuiXiao2);     % ���᳤��

% ���촹ֱ�������ҽ������ĵĺ���
 % �����ҵ��������������
  % ��Ҷ��x������ZhongXin��ת90�ȣ�������һ������任��ת������ΪZhuan_x
  % ������������Ϊ(x0,y0)����Ҷ������Ϊ(x1,y1)��ת90��֮������Ϊ(x2,y2)
  % ����㹫ʽΪ��x2=x0-y0+y1��y2=y0+x0-x1
Zhuan_x = zeros(1,2);       % ��ʼ��
Zhuan_x(1,1) = ZhongXin(1,1)-ZhongXin(1,2)+x(1,2);
Zhuan_x(1,2) = ZhongXin(1,2)+ZhongXin(1,1)-x(1,1);

% �������
d0 = abs(norm(cross([ZhongXin-Zhuan_x,0],[data(1,:)-Zhuan_x,0])))/norm(ZhongXin-Zhuan_x);
Heng_ZuiXiao=data(1,:);
for i=1:r
    d = abs(norm(cross([ZhongXin-Zhuan_x,0],[data(i,:)-Zhuan_x,0])))/norm(ZhongXin-Zhuan_x);
    if(d<d0)
        d0=d;
        Heng_ZuiXiao=data(i,:);      % ������С�ĵ�
    end
end
d2 = abs(norm(cross([ZhongXin-Zhuan_x,0],[data(1,:)-Zhuan_x,0])))/norm(ZhongXin-Zhuan_x);
Heng_ZuiXiao2=data(1,:);
for i=1:r
    d = abs(norm(cross([ZhongXin-Zhuan_x,0],[data(i,:)-Zhuan_x,0])))/norm(ZhongXin-Zhuan_x);
    d1 = norm(Heng_ZuiXiao-data(i,:));       % ֮ǰ��õ���С����data�е�ľ���
    if(d<d2 && d1>10)        % �����10����Ҫ�����Ĳ�������׼��ƽ��Ҷ���һ��
        d2=d;
        Heng_ZuiXiao2=data(i,:);
    end
end
D2 = norm(Heng_ZuiXiao-Heng_ZuiXiao2);     % ���᳤��

% ����Ҷ�����ݳ̶�
eccentricity = D/D2;
ZhongXin1=ZhongXin;
end