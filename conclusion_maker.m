% 这是结果解释函数，用于进一步处理结果，就进行简单的演示
% 输入：原训练集的分类结论（也就是说因变量y值）、神经网络仿真得到的结果集的分类结论（也就是说因变量y值）
% 输出：对结果的比对图像（直接打在控制台上）、识别成功率
function s = conclusion_maker(y,y_out,q)
    %********************* 对结果进行翻译 *****************
    featureNum = size(y_out); % 得到样本总数
    yOut_final = zeros(1,featureNum(2)); % 最终识别出来的结果的初始化
    y_final = zeros(1,featureNum(2)); % 原样本的模式结果
    for ii = 1:featureNum(2) % 结果向量中最大的一个被认为是最终被识别出来的模式
        [m,indexYOut] = max(y_out(:,ii)); % 找到最大的模式对于向量数组中的位置index
        [m,indexY] = max(y(:,ii)); % 对结果y也做相同处理
        yOut_final(ii) = indexYOut; % 这个位置就是“第几个模式”
        y_final(ii) = indexY;
    end

    %********************* 画图比较 ***********************
    x = 1:size(yOut_final,2);
    plot(x,yOut_final); % 仿真结果
    hold on
    plot(x,y_final,'r'); % 原训练集
    
    %***************** 结果统计 *******************
    leafSize = size(y_out); %这是样本总数
    y_out = y_out';
    jilu = ones(leafSize(1),1);
    for ii = 1:leafSize(1)
        n = y_out(ii,1);
        for jj = 1:5
            if y_out(ii,jj+1) > n
                n = y_out(ii,jj+1);
                jilu(ii) = jj+1;
            end
        end
    end
    jilu2 = ones(leafSize(1),1);
    y = y';
    for ii = 1:leafSize(1)
        n = y(ii,1);
        for jj = 1:5
            if y(ii,jj+1) > n
                n = y(ii,jj+1);
                jilu2(ii) = jj+1;
            end
        end
    end
    % 数据统计
    n = 1;
    for ii = 1:size(jilu,1)
        if jilu(ii) == jilu2(ii)
            n = n+1;
        end
    end
    s = n/(leafSize(1)*q); % 这是识别成功率
end