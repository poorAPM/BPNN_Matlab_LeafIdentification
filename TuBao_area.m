%*************** ��͹��������� ����һ��͹���ܳ� *******************%
% ˼�룺�����������һ��ľ���ֵ����ɵ������ε������������������㼯�����нṹ
function [area,zhouchang] = TuBao_area(tubao) 
%**************** ����tubao�������͹���㼯�����������еĵ��У������area��͹�������
s=0; % ���ǳ�ʼ�����Ϊ0��׼���ۼ�
for i = 2:size(tubao,1)-1 % ����ʹ��size(tubao,2)����tubao���������������Ĳ���Ϊ1����������
    a = [tubao(i,:)-tubao(1,:),0];
    b = [tubao(i+1,:)-tubao(1,:),0];
    s = s+0.5*abs(norm(cross(a,b),2));
end
s1=0;
for i = 1:size(tubao,1)-1
    s1 = s1+abs(norm(tubao(i,:)-tubao(i+1,:)));
end
area=s; % ������
zhouchang=s1; % ����ܳ�
end