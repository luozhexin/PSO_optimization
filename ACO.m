clc;
clear all;
close all;
%----------------设置迭代参数----------------%
%设置信息量权重
a = 2;
%设置启发量权重
b = 2;
%设置信息素挥发因子
p = 0.8;
%区间缩小因子
r = 0.8;
%设置最大循环次数NC_max
NC_max = 100;
%给定蚂蚁数量
Ant_Quantity = 20; 
%----------------设置目标函数参数----------------%
%设置维数
D = 2;
%上界
ub = 5;
%下界
lb = -5;

%----------------初始信息量全置为1，初始信息增量全置为0----------------%
%设置初始信息量
t = ones(1, Ant_Quantity);       %初始信息量是一个1行Ant_Quantity列的全1矩阵
%设置初始信息量增量
dt = zeros(1, Ant_Quantity);    %初始信息量增量是一个1行Ant_Quantity列的全0矩阵


%----------------蚂蚁位置矩阵----------------%
Ant_Position = [];        %Ant_Position是一个D行Ant_Quantity列的矩阵，每个元素均在上下界内；其每一列代表一个蚂蚁的坐标
temp_Ant_Position = [];   %temp_Ant_Position临时存储蚂蚁位置矩阵，在每只蚂蚁将自己的新位置存储进去，在每次迭代开始再赋给Ant_Position

%----------------根据上下界随机生成蚂蚁的起始位置----------------%
for i = 1:Ant_Quantity
    for ii = 1:D
        temp_Ant_Position(ii,i) = lb + rand * (ub - lb);  
    end
end

%*********************************************************************************%
%**********************************主循环**主循环***********************************%
%*********************************************************************************%
for NC = 1:NC_max
    %----------------更新信息量----------------%
    t = p * t + dt;
    %----------------更新蚂蚁位置----------------%
    Ant_Position = temp_Ant_Position;
    %----------------蚂蚁探索----------------%
    for i = 1:Ant_Quantity      %遍历每一只蚂蚁进行探索
        %计算启发量
        ETA_zero_num = 0;       %启发量为0个数统计值初始化
        for ii = 1:Ant_Quantity   %遍历每一只蚂蚁计算函数值差值，从而获得启发量
            temp = func(Ant_Position(:,i),D) - func(Ant_Position(:,ii),D);    %函数值差值赋给临时变量temp，避免重复计算
            if temp > 0
                Ant_ETA(i,ii) = temp;         %Ant_ETA是一个Ant_Quantity阶的方阵，其i行ii列表示从i到ii的启发量
            else
                Ant_ETA(i,ii) = 0;            %如果函数值不下降，启发量为0（会导致后面该方向概率为0）
                ETA_zero_num = ETA_zero_num + 1;    %统计启发量为0的个数    
            end
        end
        
        if ETA_zero_num == Ant_Quantity        %如果启发量全为0，则说明此蚂蚁是本轮蚂蚁中函数值最小的最优蚂蚁
            next = i;                         %它的下一个位置是他自身
        else
            %计算蚂蚁i向各点ii的移动概率
            sum_p = 0;
            for ii = 1:Ant_Quantity   %遍历每一只蚂蚁计算，从而获得移动概率分母上的求和
                sum_p = sum_p + t(ii)^a * Ant_ETA(i,ii)^b;
            end
            for ii = 1:Ant_Quantity   %遍历每一只蚂蚁计算，从而获得移动概率
                Ant_Possibility(i,ii) =  t(ii)^a * Ant_ETA(i,ii)^b / sum_p;    %Ant_Possibility是一个Ant_Quantity阶的方阵，其i行ii列表示从i到ii的概率
            end

            %轮盘赌法做选择得到下一位置
            k = 0;
            for ii = 1:Ant_Quantity   %遍历每一只蚂蚁ii，找出蚂蚁i到ii概率不为0的，单独存储其编号和概率值
                if Ant_Possibility(i,ii) ~=0
                    k = k + 1;
                    K(k) = ii;                                   %存储概率不为零的蚂蚁编号
                    K_Possibility(k) = Ant_Possibility(i,ii);       %存储不为0的概率值
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
        
        %蚂蚁移动，向next的某一邻域内移动
        dt(i) =  func(Ant_Position(:,i), D) - func(Ant_Position(:,next), D);        %留下本蚂蚁的信息量增量
        temp_Ant_Position(:,i) = Ant_Position(:,next) + (-1 + 2 * rand(D,1)) * r^NC;    %移动到next邻域中的某点
    end
    %计算移动之后所有蚂蚁中函数值最小的，以及最小函数值
    for i = 1:Ant_Quantity
        FUNC(i) = func(temp_Ant_Position(:,i), D);
    end
    [FUNC_min(NC), FUNC_min_n] = min(FUNC);
    Position_min(:,NC) = temp_Ant_Position(:, FUNC_min_n);   
end

[MIN, MIN_n] = min(FUNC_min);
MIN_Position = Position_min(:,MIN_n);
fprintf('蚁群算法求解函数极值：\n')
fprintf('最小值点为：[%f; %f; %f; %f; %f]\n', MIN_Position)
fprintf('最小值为：%f\n',MIN)
figure
plot(FUNC_min)