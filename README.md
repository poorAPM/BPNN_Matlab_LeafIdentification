# BPNN_Matlab_LeafIdentification
这是一个通过使用matlab神经网络工具箱中的bpnn，解决叶片分类问题的使用例，额外包括特征提取部分和结果解释部分，封装后使用单独一个txt文件调试参数

整个例子的使用方法和注意事项：  
1. 打开配置文件init.txt进行配置时，注意**不要自行增删空格和%的数量**，这两者是区分参数的重要依据，只需要根据注释内容改变数值即可，即使发现matlab中打开后注释显示为乱码也是不影响使用的  
2. 手动更改配置文件中的目录leafPath，这是存储图像样本（训练集）的**完整**文件路径（从根目录开始的），注意**不要有中文路径**，因为每人的电脑路径都不相同，所以**必须更改此项**  
3. 其中的excelPath也是**必须更改的项**，但需要注意的是，这个是一个**路径名+文件名**的组合（也就是说是Excel文件自身的地址而不是所在文件夹的地址），不要只写文件夹的路径而忘了把所使用的Excel文件名称加上去，
这个Excel的内容是每个图像样本（训练集）所对应的类别（模式），
以下是该**Excel文件的内容约定**：
    * A列是图片名字、B列是其所属类别（模式）
    * 图片名字的表示方法是“**文本格式**”（也就是**字符串格式**，如果像本例中原本是数字的形式，在Excel中可以在数字前面加上单引号转换成字符串）
    * 类别（模式）的表示方法为**数字**（第几类就是数字几，再严格点说是整形）  
4. featureM和conclusionM分别对应特征提取函数的m文件名称和结果解释函数的m文件名称，这两者放在参数中的意义是可以快速装卸想使用的方法，
我们通常在模式识别中会因为如何提取模式而烦恼，会有一些需要测试的备选方法，但每次修改+注释m文件就会非常麻烦，使用配置文件直接调换方法所在的m文件就会比较方便一点，
另外，默认的结果解释函数只是为了更加直观的看到拟合效果（画了图）和统计准确度（对结果进行解析并归类汇总），
如果只需要神经网络工具箱中的结果报告，解释函数可以置为一个空方法的m文件（但仍然需要方法体结构和参数，不能是纯空的m文件）  
5. 若要使用自定义的方法，请参照此条，**m文件的接口约定**：  
    * featureOut = featureM(excelPath,leafPath,varargin)，其中featureOut是将特征存储为一个2维矩阵，行表示每一个样本，
第1列表示样本的数字编号，第2列至第n+1列为n个特征，第n+1列到第m+n+1列（末尾）为m个特征（这里约定特征表示方法为01向量，比如共6个特征，样本x为特征3，就表示为(0,0,1,0,0,0)）
，excelPath和leafPath不再赘述，varargin为fileExtension（详见init.txt中说明）  
    * s = conclusionM(y,y_out,bpnnTrainRate)，其中s为模式识别成功率，y为原始特征集合，y_out为仿真后特征集合，bpnnTrainRate详见init.txt  
6. 配置文件更改完成，记得**保存**后再启动程序，否则无效  
7. ye_pian_xin文件夹内包含115张叶片的图像及其所属模式的Excel表，测试此程序可以参考此文件夹
8. 打开matlab后，按上述方式修改好init.txt后，运行centercode.m即可
