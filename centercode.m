% 功能：可以导入神经网络和的训练集和测试集（（训练集矩阵百分比切割成这两部分），以及神经网络一般配置参数做一个ini）（可以认为是泛用性的bp神经网络封装）
% 输入：训练集矩阵、配置参数文件地址（为了方便就单纯写在txt文件中）
% 输出：神经网络仿真结果报告

clc;
clear; % 清空控制台
disp('即将开始加载配置文件');
%******************* 加载配置文件 ***********************
parameterNum = 17; % 配置文件参数个数
filename = 'init.txt';
fid = fopen(filename,'r'); % fid是文件的编号，可以理解为某种句柄
f = fscanf(fid,'%c'); % 把文件以ascii编码形式的一维数组char表示到f中
% 对配置文件进行翻译
fSplit = strsplit(f); % 以空格对文件进行分割
ii = 0; % 这个用来计数搜寻指针
jj = 1; % 这个是参数指针计数
parameterList = cell(1,parameterNum); % 存储配置文件里面的parameterNum个参数
while(ii<=length(fSplit))
    ii = ii+1;
    if strcmp(fSplit{ii},'%')
        ii = ii+4; % 跳过中间三个字符的检索
        if ii > length(fSplit) % 防止数组溢出保险
            break;
        end
        parameterList{jj} = fSplit{ii};
        jj = jj+1;
    end
end
fclose(fid); % 最后得关闭释放资源

disp('即将开始特征函数调用');
%***************** 调用特征处理函数 ********************
str = ['featureOut','=',parameterList{6},'(''',parameterList{3},''',''',parameterList{1},''',',parameterList{2},');']; % matlab命令的字符串表示，这里调用特征处理函数
eval(str); % 通过字符串方式，类似于注入的方式调用matlab命令，得到了featureOut训练集矩阵
% 对导出特征矩阵进行数据筛查，把NaN的数字全部置零
for ii = 1:size(featureOut,1)
    for jj = 1:size(featureOut,2)
        if isnan(featureOut(ii,jj))
            featureOut(ii,jj) = 0;
        end
    end
end
% 神经网络参数初始化（将特征矩阵拆分为x、y）
x = featureOut(:,2:2+str2double(parameterList{4})-1)'; % newff()函数用的自变量，不要忘了转置
y = featureOut(:,2+str2double(parameterList{4}):1+str2double(parameterList{4})+str2double(parameterList{5}))'; % newff()函数用的因变量，不要忘了转置
q = str2double(parameterList{8}); % 神经网络训练数据占总体的比重
leafSize = size(featureOut); % leafSize(1)就是样本总数
% 训练数据归类，就是分成训练样本和测试样本
[XunLian_x,BianLiang_x,CeShi_x] = dividerand(x,q,(1-q)/2,(1-q)/2);
[XunLian_y,BianLiang_y,CeShi_y] = dividerand(y,q,(1-q)/2,(1-q)/2);

disp('即将开始数据归一化');
%******************* 数据归一化 *******************
% 实质就是通过一套线性映射规则将超出01区间的数据转化为01区间内的数据
[x1,tx] = mapminmax(x);
[y1,ty] = mapminmax(y);
[XunLian_x1,tXunLian_x] = mapminmax(XunLian_x);
[XunLian_y1,tXunLian_y] = mapminmax(XunLian_y);
[CeShi_x1,tCeShi_x] = mapminmax(CeShi_x);
[CeShi_y1,tCeShi_y] = mapminmax(CeShi_y);

disp('即将开始建立网络');
%******************* 建立网络 **********************
% 2个隐层，使用函数分别为tansig（tan）和purelin（线性），训练函数使用trainglm（动量下降梯度算法）
str = ['net_1 = newff(minmax(x),[',parameterList{9},',',parameterList{5},'],{''',parameterList{10},''',''',parameterList{11},'''},''',parameterList{12},''');'];
eval(str); % 通过字符串方式，类似于注入的方式调用matlab命令，创造了一个可训练的神经网络
% 参数设置
net_1.trainParam.epochs = str2double(parameterList{13}); % 训练次数
net_1.trainParam.goal = str2double(parameterList{14}); % 训练目标精度
net_1.trainParam.lr = str2double(parameterList{15}); % 学习速率
net_1.trainParam.mc = str2double(parameterList{16}); % 动量因子，直接使用默认值即可
net_1.trainParam.show = str2double(parameterList{17}); % 间隔多少次数显示在屏幕上一次报告
% 训练网络
[net_1,tr] = train(net_1,XunLian_x1,XunLian_y1);
% 仿真，y_out是测试数据训练得到的结果
y_out2 = sim(net_1,x1);
% 反归一化还原数据
y_out = mapminmax('reverse',y_out2,ty);

disp('即将开始结果处理函数调用');
%********************* 结果处理函数 **********************
str = ['s=',parameterList{7},'(y,y_out,q);']; % 使用了配置文件中的第7个参数，作为结果输出解释函数的函数名
eval(str);
disp(['识别成功率为：',num2str(s)]) % 输出识别成功率