% ���ǽ�����ͺ��������ڽ�һ�����������ͽ��м򵥵���ʾ
% ���룺ԭѵ�����ķ�����ۣ�Ҳ����˵�����yֵ�������������õ��Ľ�����ķ�����ۣ�Ҳ����˵�����yֵ��
% ������Խ���ıȶ�ͼ��ֱ�Ӵ��ڿ���̨�ϣ���ʶ��ɹ���
function s = conclusion_maker(y,y_out,q)
    %********************* �Խ�����з��� *****************
    featureNum = size(y_out); % �õ���������
    yOut_final = zeros(1,featureNum(2)); % ����ʶ������Ľ���ĳ�ʼ��
    y_final = zeros(1,featureNum(2)); % ԭ������ģʽ���
    for ii = 1:featureNum(2) % �������������һ������Ϊ�����ձ�ʶ�������ģʽ
        [m,indexYOut] = max(y_out(:,ii)); % �ҵ�����ģʽ�������������е�λ��index
        [m,indexY] = max(y(:,ii)); % �Խ��yҲ����ͬ����
        yOut_final(ii) = indexYOut; % ���λ�þ��ǡ��ڼ���ģʽ��
        y_final(ii) = indexY;
    end

    %********************* ��ͼ�Ƚ� ***********************
    x = 1:size(yOut_final,2);
    plot(x,yOut_final); % ������
    hold on
    plot(x,y_final,'r'); % ԭѵ����
    
    %***************** ���ͳ�� *******************
    leafSize = size(y_out); %������������
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
    % ����ͳ��
    n = 1;
    for ii = 1:size(jilu,1)
        if jilu(ii) == jilu2(ii)
            n = n+1;
        end
    end
    s = n/(leafSize(1)*q); % ����ʶ��ɹ���
end