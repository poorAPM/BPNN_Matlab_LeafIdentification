%************************* Ҷ��Ƕ� **********************%
% ˼�룺ȷ��Ҷ��ĵ㣬Ȼ�����Ҷ���������ȡһ����������Ϊ����Ҷ���ͼ��
 % ȷ����ͼ��Ȼ������ĵ�ֱ����������ϣ���ϳ�����ֱ��
  % �ֱ�ȷ������ֱ���Ϸ�����ȷ�ķ�������
   % Ȼ���������ֱ���ϵķ�������ȷ��Ҷ���
function [YeJianJiao,Jian] = YeJian(data,ZhongXin,zhouchang,YouXu)        
%�����ֵ����ҶƬ��Ե�㼯������ͼ������ģ������ܳ������������߽�㼯���ڻ�ͼ
% ҶƬ��ߵ� = Ҷ��
[r,c] = size(data);
x1 = data(1,:);      % ��ҶƬ��Ե�㼯��һ����洢Ϊһ��һ�����е�����x
n=1;        % ��¼�����ȡ��Ҷ�����ԭ����Ե���е�λ�����
for i=1:r-1
    if x1(1) > data(i+1,1)     % ���x1��y�����data�ĵ�i+1��������y����ҪС����������x��д����x�����򲻱�
        x1 = data(i+1,:);
        n=i+1;
    end
end
% x1;n;     % ���x1ΪҶ�⣬���nΪҶ����ԭ��Ե����λ��

% ��Ҷ���ֱ���ǰ����50���㣬�������50����
Qian = zeros(floor(zhouchang/12),2);     % ���м����б�ʾ�������ĵ㼯
Hou = zeros(floor(zhouchang/12),2);
% % �ɼ�������
% n1=1;       % ���ѭ������
% nn1=1;       % �����Լ���һ���������Ѱ�ҵ��ĵ��ڱ�Ե���е�λ��
% nn2=1;
% while(n1<=zhouchang/6)       % ѭ�����������洢Ҷ�⴦�ɼ���ǰ���1/6�ܳ������ĵ�
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
% ��Ĳɼ���������
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

% ������ϣ��������зֱ��ʾǰ������ɼ��ĵ���ϳ�����ֱ�ߵĴӸߴε��ʹε�ϵ��
nihe1 = polyfit(Qian(:,1),Qian(:,2),1);
nihe2 = polyfit(Hou(:,1),Hou(:,2),1);

% %! ��Ҷ��ǳ�ʼ���Ϸ���
% % ȷ�������߽��㣬����ȷ����Ҫ�жϵ��ĸ�����
% syms xxx
% JiaoDian = vpa(solve(nihe1(1)*xxx+nihe1(2)==0,nihe2(1)*xxx+nihe2(2)==0,xxx,true,'Real',true)) % 'ReturnConditions',
% p1 = JiaoDian - [JiaoDian(1)+10,nihe1(1)*(JiaoDian(1)+10)+nihe1(2)];
% p2 = JiaoDian - [JiaoDian(1)-10,nihe1(1)*(JiaoDian(1)-10)+nihe1(2)];
% p3 = JiaoDian - [JiaoDian(1)+10,nihe2(1)*(JiaoDian(1)+10)+nihe2(2)];
% p4 = JiaoDian - [JiaoDian(1)-10,nihe2(1)*(JiaoDian(1)-10)+nihe2(2)];
% p0 = JiaoDian - ZhongXin;       % �ο���������Ϊ�ҵ���ȷ�ķ��������Ļ�׼
% 
% % �ж������ķ���������������
% syms k1 k2;
% m1 = [];        % m1,m2���ڴ洢ʶ�����������
% m2 = [];
% m = solve(p1*k1+p3*k2==p0);
% % ���ĸ��Ƚϴ���if���Ƿ���д�ˣ�Ŀ�����ж��������������ķ����������������
%  % ԭ���ǣ�p0��Ҷ�⵽���ĵ��������������һ���ǳ�����ǵ�
%   % �������ȷ�ķ�������ȥ��ʾp0�Ļ���һ������������������ϵ����������
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
% % ��н�
% YeJianJiao = acos(dot(m1,m2)/(norm(m1)*norm(m2)));        %������,ת�Ƕ��Ƴ�180/pi

% ������
y1 = ZhongXin(1)*nihe1(1)+nihe1(2);
y2 = ZhongXin(1)*nihe2(1)+nihe2(2);
xiangliang1 = [ZhongXin(1),y1];
xiangliang2 = [ZhongXin(1),y2];
YeJianJiao = dot(x1-xiangliang1,x1-xiangliang2)/(norm(x1-xiangliang1)*norm(x1-xiangliang2));
Jian = x1;

end  