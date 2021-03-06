clear all;clc;
tic;
noP=80;
nVar=30;
fobj=@Ackley;
lb = -5 * ones(1,nVar) ;%最小边界为-5
ub = 5 * ones(1,nVar);%最大边界为+5
Max_iteration = 1000;%粒子最大迭代数
Vmax=1.5;%粒子的最大飞行速度
wMax=0.9;%最大惯性因子
wMin=0.4;%最小惯性因子
c1=1.5;%个体学习因子
c2=1.5;%社会学习因子
cg_curve = zeros(1,Max_iteration);%初始化收敛曲线convergence
for idx=1:noP
Swarm.Particles(idx).X =-5+5*rand(1,nVar);
end
for k = 1: noP
    Swarm.Particles(k).V = rand(1,nVar);%每个粒子速度随机分配
    Swarm.Particles(k).PBEST.X = rand(1,nVar)*Vmax;
    Swarm.Particles(k).PBEST.O= inf; % for minimization problems
    %h(k) = plot(Swarm.Particles(k).X(1),Swarm.Particles(k).X(2),'ok', 'markerFaceColor','k');
end
Swarm.GBEST.X=ones(1,nVar);%随意设 但最好不要设成zeros（1，nVar）因为这恰好就是全局最优的位置
Swarm.GBEST.O= inf;
for t=1:Max_iteration % 主循环程序
    succcess_count=0;
    for k=1:noP
        %对每个粒子计算目标函数的值
        Swarm.Particles(k).O=fobj( Swarm.Particles(k).X );%调用Ackley计算在当前位置下函数的output
        
        if(Swarm.Particles(k).O < Swarm.Particles(k).PBEST.O)%如果当前位置是粒子所经历的最优位置，则更换粒子所经历的最优位置
            succcess_count=succcess_count+1;
            Swarm.Particles(k).PBEST.O = Swarm.Particles(k).O;
            Swarm.Particles(k).PBEST.X = Swarm.Particles(k).X;
        end
        if(Swarm.Particles(k).O < Swarm.GBEST.O)%如果当前位置是全局最优位置，则更换全局最优位置
            Swarm.GBEST.O = Swarm.Particles(k).O;
            Swarm.GBEST.X = Swarm.Particles(k).X;
        end
    end
    %更新惯性权重
    PS=succcess_count/noP;
    w=(wMax-wMin)*PS+wMax;
    
    %更新粒子的速度与位置
    for k=1:noP
        first_vel(k,:) = Swarm.Particles(k).V;%$v_{id}$
        %$v_{id+1}=w*v_{id}+c_1*rand()*(p_{id}-x_{id}+c_2*Rand()*(p_{gd}-x_{id})$
        Swarm.Particles(k).V  = w .* Swarm.Particles(k).V + ...  % 惯性
            c1 .* rand(1,nVar) .* (Swarm.Particles(k).PBEST.X - Swarm.Particles(k).X ) +  ...   % 认知
            c2 .* rand(1,nVar).* (Swarm.GBEST.X - Swarm.Particles(k).X) ;  % 社会
        
        second_vel(k,:) = Swarm.Particles(k).V;%v_{id+1}
        
        index = find(Swarm.Particles(k).V > Vmax);%将超过vMax的粒子的速度调整为vMax
        Swarm.Particles(k).V(index) = Vmax*rand;
        
        index = find(Swarm.Particles(k).V < -Vmax);%将超过-vMax的粒子的速度调整为-vMax
        Swarm.Particles(k).V(index) = -Vmax*rand;
        
        %$x_{id+1}=x_{id}+v_{id}$
        first_loc(k,:) = Swarm.Particles(k).X ;%$x_{id}$

        Swarm.Particles(k).X = Swarm.Particles(k).X + Swarm.Particles(k).V;
        indx = find( Swarm.Particles(k).X  > ub);%将超过最大边界的粒子的位置调整为5
        Swarm.Particles(k).X (indx) = ub(1);
        
        indx = find( Swarm.Particles(k).X  < lb);%将超过最小边界的粒子的位置调整为-5
        Swarm.Particles(k).X (indx) = lb(1);
        
        second_loc(k,:) = Swarm.Particles(k).X ;%$x_{id+1}$
    end
     cg_curve(t) = Swarm.GBEST.O;%更新收敛情况
    fprintf('第%d次迭代的全局最优值为%4f\n',t,Swarm.GBEST.O);%输出当前全局最优情况
end
figure
plot(cg_curve)%绘制收敛图
xlabel('Iteration')
toc;%计时完成