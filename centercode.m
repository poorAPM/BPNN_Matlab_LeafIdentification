% ���ܣ����Ե���������͵�ѵ�����Ͳ��Լ�����ѵ��������ٷֱ��и���������֣����Լ�������һ�����ò�����һ��ini����������Ϊ�Ƿ����Ե�bp�������װ��
% ���룺ѵ�����������ò����ļ���ַ��Ϊ�˷���͵���д��txt�ļ��У�
% ��������������������

clc;
clear; % ��տ���̨
disp('������ʼ���������ļ�');
%******************* ���������ļ� ***********************
parameterNum = 17; % �����ļ���������
filename = 'init.txt';
fid = fopen(filename,'r'); % fid���ļ��ı�ţ��������Ϊĳ�־��
f = fscanf(fid,'%c'); % ���ļ���ascii������ʽ��һά����char��ʾ��f��
% �������ļ����з���
fSplit = strsplit(f); % �Կո���ļ����зָ�
ii = 0; % �������������Ѱָ��
jj = 1; % ����ǲ���ָ�����
parameterList = cell(1,parameterNum); % �洢�����ļ������parameterNum������
while(ii<=length(fSplit))
    ii = ii+1;
    if strcmp(fSplit{ii},'%')
        ii = ii+4; % �����м������ַ��ļ���
        if ii > length(fSplit) % ��ֹ�����������
            break;
        end
        parameterList{jj} = fSplit{ii};
        jj = jj+1;
    end
end
fclose(fid); % ���ùر��ͷ���Դ

disp('������ʼ������������');
%***************** �������������� ********************
str = ['featureOut','=',parameterList{6},'(''',parameterList{3},''',''',parameterList{1},''',',parameterList{2},');']; % matlab������ַ�����ʾ�������������������
eval(str); % ͨ���ַ�����ʽ��������ע��ķ�ʽ����matlab����õ���featureOutѵ��������
% �Ե������������������ɸ�飬��NaN������ȫ������
for ii = 1:size(featureOut,1)
    for jj = 1:size(featureOut,2)
        if isnan(featureOut(ii,jj))
            featureOut(ii,jj) = 0;
        end
    end
end
% �����������ʼ����������������Ϊx��y��
x = featureOut(:,2:2+str2double(parameterList{4})-1)'; % newff()�����õ��Ա�������Ҫ����ת��
y = featureOut(:,2+str2double(parameterList{4}):1+str2double(parameterList{4})+str2double(parameterList{5}))'; % newff()�����õ����������Ҫ����ת��
q = str2double(parameterList{8}); % ������ѵ������ռ����ı���
leafSize = size(featureOut); % leafSize(1)������������
% ѵ�����ݹ��࣬���Ƿֳ�ѵ�������Ͳ�������
[XunLian_x,BianLiang_x,CeShi_x] = dividerand(x,q,(1-q)/2,(1-q)/2);
[XunLian_y,BianLiang_y,CeShi_y] = dividerand(y,q,(1-q)/2,(1-q)/2);

disp('������ʼ���ݹ�һ��');
%******************* ���ݹ�һ�� *******************
% ʵ�ʾ���ͨ��һ������ӳ����򽫳���01���������ת��Ϊ01�����ڵ�����
[x1,tx] = mapminmax(x);
[y1,ty] = mapminmax(y);
[XunLian_x1,tXunLian_x] = mapminmax(XunLian_x);
[XunLian_y1,tXunLian_y] = mapminmax(XunLian_y);
[CeShi_x1,tCeShi_x] = mapminmax(CeShi_x);
[CeShi_y1,tCeShi_y] = mapminmax(CeShi_y);

disp('������ʼ��������');
%******************* �������� **********************
% 2�����㣬ʹ�ú����ֱ�Ϊtansig��tan����purelin�����ԣ���ѵ������ʹ��trainglm�������½��ݶ��㷨��
str = ['net_1 = newff(minmax(x),[',parameterList{9},',',parameterList{5},'],{''',parameterList{10},''',''',parameterList{11},'''},''',parameterList{12},''');'];
eval(str); % ͨ���ַ�����ʽ��������ע��ķ�ʽ����matlab���������һ����ѵ����������
% ��������
net_1.trainParam.epochs = str2double(parameterList{13}); % ѵ������
net_1.trainParam.goal = str2double(parameterList{14}); % ѵ��Ŀ�꾫��
net_1.trainParam.lr = str2double(parameterList{15}); % ѧϰ����
net_1.trainParam.mc = str2double(parameterList{16}); % �������ӣ�ֱ��ʹ��Ĭ��ֵ����
net_1.trainParam.show = str2double(parameterList{17}); % ������ٴ�����ʾ����Ļ��һ�α���
% ѵ������
[net_1,tr] = train(net_1,XunLian_x1,XunLian_y1);
% ���棬y_out�ǲ�������ѵ���õ��Ľ��
y_out2 = sim(net_1,x1);
% ����һ����ԭ����
y_out = mapminmax('reverse',y_out2,ty);

disp('������ʼ�������������');
%********************* ��������� **********************
str = ['s=',parameterList{7},'(y,y_out,q);']; % ʹ���������ļ��еĵ�7����������Ϊ���������ͺ����ĺ�����
eval(str);
disp(['ʶ��ɹ���Ϊ��',num2str(s)]) % ���ʶ��ɹ���