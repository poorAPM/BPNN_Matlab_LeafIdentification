%叶片特征提取的函数（参数包含训练集样本的文件（这个是通过叶片文件夹图片和每个叶片属于第几类的Excel得到）），约定Excel表的规范是纯粹的数据表，仅包含两列，分别是叶片文件名称（不用加后缀的，并且是字符型）和其分类结果（分类用数字表示）
%输入：叶片图片名称和所属分类的Excel表（路径+名字）、叶片文件夹路径、varargin表示需要搜索的图片类型（是可变参数，是一个cell类型数组，默认全部图片类型）
%输出：一个可直接用于神经网络的训练集矩阵
function  featureOut = feature_maker(excelPath,leafPath,varargin)
    %****************** 预处理 ******************
    % 声明一个图片类型的静态字符串数组
    persistent imageType; % 静态的
    % 判断varargin参数以确定是否选用默认图片后缀名搜索
    if ~isempty(varargin)
        imageType = varargin; % varargin中有内容则替换默认值
    else
        imageType = {'jpg','jpeg','png','bmp','pcx','tiff','gif','hdf','ico','cur','xwd','ras','pbm','pgm','ppm'}; % 表示图片后缀名
    end
    imgTLength = length(imageType); % 存储其数组长度
    leafName = cell(1); % cell数组用于存储搜索到的所有图片名字
    leafNameSplit = cell(1); % 这个表示把后缀切割掉的纯文件名，用于在Excel中匹配叶片名称
    % 检索leafPath路径中的所有图片
    MyFolderInfo = dir(leafPath); % 这是一个包含所有文件信息的结构体数组，其中的name才是需要的东西，name是包含后缀的整个文件名
    mfiLength = length(MyFolderInfo); % 其长度
    % 对MyFolderInfo中的name进行扫描，过滤掉所有非图片名称
    aa = 0; % 计数器：访问leafName中元素的脚标
    mfiNameLower = cell(mfiLength,1); % 用元胞数组存储转换小写后的MyFolderInfo.name
    for ii = 1:mfiLength
        mfiNameLower{ii} = lower(MyFolderInfo(ii).name); % 把MyFolderInfo.name里面的文件名字全部转换为小写，用于匹配imageType
    end
    for ii = 1:imgTLength
        for jj = 1:mfiLength
            if ~isempty(strfind(mfiNameLower{jj},['.',imageType{ii}])) % strfind(a,b)在a中寻找是否包含b，包含返回位置，不包含返回空
                aa = aa+1;
                leafName{aa} = MyFolderInfo(jj).name; % 将筛查出来的图片名字放在leafName中，注意不是mfiNameLower转换完毕的，因为要原路径名
                leafNameSplit{aa} = MyFolderInfo(jj).name(1:length(MyFolderInfo(jj).name)-length(imageType{ii})-1); % 相当于把后面的后缀名给删了，只存除了后缀名的前那么多字符（char）的字符串
            end
        end
    end
    
    %**************************** 读入图像 ***************************
    leafNameLth = length(leafName); % 得到leafName长度备用，这是全部搜索到的图片样本总数
    featureList = []; % 初始化变长矩阵featureList
    % 读入Excel里的叶片结果数据
    [excelListNum,excelListTxt] = xlsread(excelPath,1,['A1:B',num2str(leafNameLth)],'basic'); % 对excelPath路径中的sheet1读前两列的所有数据，行数取上面筛查出来的叶片个数，就相当于是叶片总数，注意excelList是个矩阵不是元胞数组
    % 通过遍历leafPath+leafName路径，通过compute_feature()函数读取图片并作出处理（注意结果是一个1*n的行向量），得到不带叶片分类结果的叶片特征featureV，再将其后面加上该叶片所属分类，得到完整训练集数据
    for ii = 1:leafNameLth
        featureV = compute_feature([leafPath,'\',leafName{ii}]);
        for jj = 1:leafNameLth
            if strcmp(leafNameSplit{jj},excelListTxt{ii})
                featureList(ii,:) = [ii,featureV,excelListNum(ii)]; % 不带叶片分类结果的叶片特征featureV，再将其前面加上叶片id，后面加上该叶片所属分类，得到完整的训练集数据（单条，并且是行向量）
            end
        end
    end
    % 对最后一位的分类进行向量化，也就是把“第6种”变为(0,0,0,0,0,1)这样的向量
    
    featureSum = max(excelListNum); % 得到一共有多少个分类，就是说叶片有多少种
    aa = size(featureList); % 求出featureList的行列长度
    for ii = 1:leafNameLth
        xx = zeros(1,featureSum); % 用于表示还未写入“具体哪一个位置是1”的原始零向量
        xx(excelListNum(ii)) = 1; % 表示第n类的“标志（用数字1表示）”应该在第n个位置
        featureList(ii,aa(2):aa(2)-1+featureSum) = xx; % 是说，第ii行特征的最后一个位置和其后的featureSum-1个位置被替换成了类数的01向量
    end
    featureOut = featureList; % 最后得到一个行是叶片编号，列是叶片id和其特征
end