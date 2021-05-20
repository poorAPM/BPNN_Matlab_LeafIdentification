%*************** 求凸包面积函数 再求一下凸包周长 *******************%
% 思想：两向量叉积的一半的绝对值是组成的三角形的面积，问题在于输入点集的排列结构
function [area,zhouchang] = TuBao_area(tubao) 
%**************** 这里tubao是输入的凸包点集，是纵向排列的点列，输出的area是凸包的面积
s=0; % 这是初始化面积为0，准备累加
for i = 2:size(tubao,1)-1 % 这里使用size(tubao,2)返回tubao的列数，如果后面的参数为1，返回行数
    a = [tubao(i,:)-tubao(1,:),0];
    b = [tubao(i+1,:)-tubao(1,:),0];
    s = s+0.5*abs(norm(cross(a,b),2));
end
s1=0;
for i = 1:size(tubao,1)-1
    s1 = s1+abs(norm(tubao(i,:)-tubao(i+1,:)));
end
area=s; % 输出面积
zhouchang=s1; % 输出周长
end