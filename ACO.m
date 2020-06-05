clc;
clear all;
close all;
%----------------���õ�������----------------%
%������Ϣ��Ȩ��
a = 2;
%����������Ȩ��
b = 2;
%������Ϣ�ػӷ�����
p = 0.8;
%������С����
r = 0.8;
%�������ѭ������NC_max
NC_max = 100;
%������������
Ant_Quantity = 20; 
%----------------����Ŀ�꺯������----------------%
%����ά��
D = 2;
%�Ͻ�
ub = 5;
%�½�
lb = -5;

%----------------��ʼ��Ϣ��ȫ��Ϊ1����ʼ��Ϣ����ȫ��Ϊ0----------------%
%���ó�ʼ��Ϣ��
t = ones(1, Ant_Quantity);       %��ʼ��Ϣ����һ��1��Ant_Quantity�е�ȫ1����
%���ó�ʼ��Ϣ������
dt = zeros(1, Ant_Quantity);    %��ʼ��Ϣ��������һ��1��Ant_Quantity�е�ȫ0����


%----------------����λ�þ���----------------%
Ant_Position = [];        %Ant_Position��һ��D��Ant_Quantity�еľ���ÿ��Ԫ�ؾ������½��ڣ���ÿһ�д���һ�����ϵ�����
temp_Ant_Position = [];   %temp_Ant_Position��ʱ�洢����λ�þ�����ÿֻ���Ͻ��Լ�����λ�ô洢��ȥ����ÿ�ε�����ʼ�ٸ���Ant_Position

%----------------�������½�����������ϵ���ʼλ��----------------%
for i = 1:Ant_Quantity
    for ii = 1:D
        temp_Ant_Position(ii,i) = lb + rand * (ub - lb);  
    end
end

%*********************************************************************************%
%**********************************��ѭ��**��ѭ��***********************************%
%*********************************************************************************%
for NC = 1:NC_max
    %----------------������Ϣ��----------------%
    t = p * t + dt;
    %----------------��������λ��----------------%
    Ant_Position = temp_Ant_Position;
    %----------------����̽��----------------%
    for i = 1:Ant_Quantity      %����ÿһֻ���Ͻ���̽��
        %����������
        ETA_zero_num = 0;       %������Ϊ0����ͳ��ֵ��ʼ��
        for ii = 1:Ant_Quantity   %����ÿһֻ���ϼ��㺯��ֵ��ֵ���Ӷ����������
            temp = func(Ant_Position(:,i),D) - func(Ant_Position(:,ii),D);    %����ֵ��ֵ������ʱ����temp�������ظ�����
            if temp > 0
                Ant_ETA(i,ii) = temp;         %Ant_ETA��һ��Ant_Quantity�׵ķ�����i��ii�б�ʾ��i��ii��������
            else
                Ant_ETA(i,ii) = 0;            %�������ֵ���½���������Ϊ0���ᵼ�º���÷������Ϊ0��
                ETA_zero_num = ETA_zero_num + 1;    %ͳ��������Ϊ0�ĸ���    
            end
        end
        
        if ETA_zero_num == Ant_Quantity        %���������ȫΪ0����˵���������Ǳ��������к���ֵ��С����������
            next = i;                         %������һ��λ����������
        else
            %��������i�����ii���ƶ�����
            sum_p = 0;
            for ii = 1:Ant_Quantity   %����ÿһֻ���ϼ��㣬�Ӷ�����ƶ����ʷ�ĸ�ϵ����
                sum_p = sum_p + t(ii)^a * Ant_ETA(i,ii)^b;
            end
            for ii = 1:Ant_Quantity   %����ÿһֻ���ϼ��㣬�Ӷ�����ƶ�����
                Ant_Possibility(i,ii) =  t(ii)^a * Ant_ETA(i,ii)^b / sum_p;    %Ant_Possibility��һ��Ant_Quantity�׵ķ�����i��ii�б�ʾ��i��ii�ĸ���
            end

            %���̶ķ���ѡ��õ���һλ��
            k = 0;
            for ii = 1:Ant_Quantity   %����ÿһֻ����ii���ҳ�����i��ii���ʲ�Ϊ0�ģ������洢���ź͸���ֵ
                if Ant_Possibility(i,ii) ~=0
                    k = k + 1;
                    K(k) = ii;                                   %�洢���ʲ�Ϊ������ϱ��
                    K_Possibility(k) = Ant_Possibility(i,ii);       %�洢��Ϊ0�ĸ���ֵ
                end
            end
            K_Possibility = cumsum(K_Possibility);
            random_p = rand;
            next = 0;
            for ii = 1:k
                if random_p < K_Possibility(ii)
                    next = K(ii);
                end
                if next ~= 0
                    break
                end
            end
        end
        
        %�����ƶ�����next��ĳһ�������ƶ�
        dt(i) =  func(Ant_Position(:,i), D) - func(Ant_Position(:,next), D);        %���±����ϵ���Ϣ������
        temp_Ant_Position(:,i) = Ant_Position(:,next) + (-1 + 2 * rand(D,1)) * r^NC;    %�ƶ���next�����е�ĳ��
    end
    %�����ƶ�֮�����������к���ֵ��С�ģ��Լ���С����ֵ
    for i = 1:Ant_Quantity
        FUNC(i) = func(temp_Ant_Position(:,i), D);
    end
    [FUNC_min(NC), FUNC_min_n] = min(FUNC);
    Position_min(:,NC) = temp_Ant_Position(:, FUNC_min_n);   
end

[MIN, MIN_n] = min(FUNC_min);
MIN_Position = Position_min(:,MIN_n);
fprintf('��Ⱥ�㷨��⺯����ֵ��\n')
fprintf('��Сֵ��Ϊ��[%f; %f; %f; %f; %f]\n', MIN_Position)
fprintf('��СֵΪ��%f\n',MIN)
figure
plot(FUNC_min)