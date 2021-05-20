%ҶƬ������ȡ�ĺ�������������ѵ�����������ļ��������ͨ��ҶƬ�ļ���ͼƬ��ÿ��ҶƬ���ڵڼ����Excel�õ�������Լ��Excel��Ĺ淶�Ǵ�������ݱ����������У��ֱ���ҶƬ�ļ����ƣ����üӺ�׺�ģ��������ַ��ͣ���������������������ֱ�ʾ��
%���룺ҶƬͼƬ���ƺ����������Excel��·��+���֣���ҶƬ�ļ���·����varargin��ʾ��Ҫ������ͼƬ���ͣ��ǿɱ��������һ��cell�������飬Ĭ��ȫ��ͼƬ���ͣ�
%�����һ����ֱ�������������ѵ��������
function  featureOut = feature_maker(excelPath,leafPath,varargin)
    %****************** Ԥ���� ******************
    % ����һ��ͼƬ���͵ľ�̬�ַ�������
    persistent imageType; % ��̬��
    % �ж�varargin������ȷ���Ƿ�ѡ��Ĭ��ͼƬ��׺������
    if ~isempty(varargin)
        imageType = varargin; % varargin�����������滻Ĭ��ֵ
    else
        imageType = {'jpg','jpeg','png','bmp','pcx','tiff','gif','hdf','ico','cur','xwd','ras','pbm','pgm','ppm'}; % ��ʾͼƬ��׺��
    end
    imgTLength = length(imageType); % �洢�����鳤��
    leafName = cell(1); % cell�������ڴ洢������������ͼƬ����
    leafNameSplit = cell(1); % �����ʾ�Ѻ�׺�и���Ĵ��ļ�����������Excel��ƥ��ҶƬ����
    % ����leafPath·���е�����ͼƬ
    MyFolderInfo = dir(leafPath); % ����һ�����������ļ���Ϣ�Ľṹ�����飬���е�name������Ҫ�Ķ�����name�ǰ�����׺�������ļ���
    mfiLength = length(MyFolderInfo); % �䳤��
    % ��MyFolderInfo�е�name����ɨ�裬���˵����з�ͼƬ����
    aa = 0; % ������������leafName��Ԫ�صĽű�
    mfiNameLower = cell(mfiLength,1); % ��Ԫ������洢ת��Сд���MyFolderInfo.name
    for ii = 1:mfiLength
        mfiNameLower{ii} = lower(MyFolderInfo(ii).name); % ��MyFolderInfo.name������ļ�����ȫ��ת��ΪСд������ƥ��imageType
    end
    for ii = 1:imgTLength
        for jj = 1:mfiLength
            if ~isempty(strfind(mfiNameLower{jj},['.',imageType{ii}])) % strfind(a,b)��a��Ѱ���Ƿ����b����������λ�ã����������ؿ�
                aa = aa+1;
                leafName{aa} = MyFolderInfo(jj).name; % ��ɸ�������ͼƬ���ַ���leafName�У�ע�ⲻ��mfiNameLowerת����ϵģ���ΪҪԭ·����
                leafNameSplit{aa} = MyFolderInfo(jj).name(1:length(MyFolderInfo(jj).name)-length(imageType{ii})-1); % �൱�ڰѺ���ĺ�׺����ɾ�ˣ�ֻ����˺�׺����ǰ��ô���ַ���char�����ַ���
            end
        end
    end
    
    %**************************** ����ͼ�� ***************************
    leafNameLth = length(leafName); % �õ�leafName���ȱ��ã�����ȫ����������ͼƬ��������
    featureList = []; % ��ʼ���䳤����featureList
    % ����Excel���ҶƬ�������
    [excelListNum,excelListTxt] = xlsread(excelPath,1,['A1:B',num2str(leafNameLth)],'basic'); % ��excelPath·���е�sheet1��ǰ���е��������ݣ�����ȡ����ɸ�������ҶƬ���������൱����ҶƬ������ע��excelList�Ǹ�������Ԫ������
    % ͨ������leafPath+leafName·����ͨ��compute_feature()������ȡͼƬ����������ע������һ��1*n�������������õ�����ҶƬ��������ҶƬ����featureV���ٽ��������ϸ�ҶƬ�������࣬�õ�����ѵ��������
    for ii = 1:leafNameLth
        featureV = compute_feature([leafPath,'\',leafName{ii}]);
        for jj = 1:leafNameLth
            if strcmp(leafNameSplit{jj},excelListTxt{ii})
                featureList(ii,:) = [ii,featureV,excelListNum(ii)]; % ����ҶƬ��������ҶƬ����featureV���ٽ���ǰ�����ҶƬid��������ϸ�ҶƬ�������࣬�õ�������ѵ�������ݣ���������������������
            end
        end
    end
    % �����һλ�ķ��������������Ҳ���ǰѡ���6�֡���Ϊ(0,0,0,0,0,1)����������
    
    featureSum = max(excelListNum); % �õ�һ���ж��ٸ����࣬����˵ҶƬ�ж�����
    aa = size(featureList); % ���featureList�����г���
    for ii = 1:leafNameLth
        xx = zeros(1,featureSum); % ���ڱ�ʾ��δд�롰������һ��λ����1����ԭʼ������
        xx(excelListNum(ii)) = 1; % ��ʾ��n��ġ���־��������1��ʾ����Ӧ���ڵ�n��λ��
        featureList(ii,aa(2):aa(2)-1+featureSum) = xx; % ��˵����ii�����������һ��λ�ú�����featureSum-1��λ�ñ��滻����������01����
    end
    featureOut = featureList; % ���õ�һ������ҶƬ��ţ�����ҶƬid��������
end