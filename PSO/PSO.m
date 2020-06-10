clc;clear all;close all;
tic;
figure
set(gcf,'Renderer','OpenGL');

x=[-5:0.1:5];
y=x;
[x_new, y_new] = meshgrid(x,y);%生成网络采样点
for k1 = 1: size(x_new, 1)
    for k2 = 1 : size(x_new , 2)
        X = [ x_new(k1,k2) , y_new(k1, k2) ];
        z(k1,k2) = Ackley( X );%代入Ackley函数
    end
end
h = contour(x_new, y_new, z , 20);%绘制等高线
set(gca,'XLimMode','manual');
set(gca,'YLimMode','manual');
axis([-5,5,-5,5])
hold on
view(2)
shading interp %色彩平滑
noP =36;%粒子群规模
nVar = 2;%目标函数的自变量个数
%%
fobj = @Ackley;
lb = -5 * ones(1,nVar) ;%最小边界为-5
ub = 5 * ones(1,nVar);%最大边界为+5
%%
% PSO paramters
Max_iteration = 100;%粒子最大迭代数
Vmax=6;%粒子的最大飞行速度
wMax=0.9;%最大惯性因子
wMin=0.2;%最小惯性因子
c1=2;%个体学习因子
c2=2;%社会学习因子
cg_curve = zeros(1,Max_iteration);%初始化收敛曲线convergence
x = -5:2:5;%在给定区间[-5，5]里取点
y= x;
idx = 1;
for t1 = 1: length (x)
    for t2 =  1: length (y)
        Swarm.Particles(idx).X = [x(t1) y(t2)];
        idx = idx+1;
    end
end
%%
% Initializations
for k = 1: noP
    Swarm.Particles(k).V = rand(1,nVar);%每个粒子速度随机分配
    Swarm.Particles(k).PBEST.X = rand(1,nVar)*Vmax;
    Swarm.Particles(k).PBEST.O= inf; % for minimization problems
    h(k) = plot(Swarm.Particles(k).X(1),Swarm.Particles(k).X(2),'ok', 'markerFaceColor','k');
end
Swarm.GBEST.X=ones(1,nVar);%随意设 但最好不要设成zeros（1，nVar）因为这恰好就是全局最优的位置
Swarm.GBEST.O= inf;
%%
for t=1:Max_iteration % 主循环程序
    for k=1:noP
        %对每个粒子计算目标函数的值
        Swarm.Particles(k).O=fobj( Swarm.Particles(k).X );%调用Ackley计算在当前位置下函数的output
        
        if(Swarm.Particles(k).O < Swarm.Particles(k).PBEST.O)%如果当前位置是粒子所经历的最优位置，则更换粒子所经历的最优位置
            Swarm.Particles(k).PBEST.O = Swarm.Particles(k).O;
            Swarm.Particles(k).PBEST.X = Swarm.Particles(k).X;
        end
        if(Swarm.Particles(k).O < Swarm.GBEST.O)%如果当前位置是全局最优位置，则更换全局最优位置
            Swarm.GBEST.O = Swarm.Particles(k).O;
            Swarm.GBEST.X = Swarm.Particles(k).X;
        end
    end
    %保存第1、5、10、20、50、100次迭代时粒子的分布图
    if(t==1)
        saveas(gcf,'1.jpg');
    end   
    if(t==5)
        saveas(gcf,'5.jpg');
    end
    if(t==10)
        saveas(gcf,'10.jpg');
    end
    if(t==20)
        saveas(gcf,'20.jpg');
    end
    if(t==50)
        saveas(gcf,'50.jpg');
    end 
    if(t==100)
        saveas(gcf,'100.jpg');
    end
    %更新惯性权重
    w=wMax-t*((wMax-wMin)/Max_iteration);%惯性权重由wMax递减到wMin
    
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
   %预描点     
        nn = 20;
        moving_x(k,:) =  linspace(first_loc(k,1),second_loc(k,1),nn);
        moving_y(k,:) = linspace(first_loc(k,2),second_loc(k,2),nn);
        
    end
    %画图
    for rr = 1: nn
        for JJ = 1:noP;
            set(h(JJ),'XData', moving_x(JJ,rr),'YData', moving_y(JJ,rr));
        end       
        drawnow
    end
    cg_curve(t) = Swarm.GBEST.O;%更新收敛情况
    fprintf('第%d次迭代的全局最优值为%4f\n',t,Swarm.GBEST.O);%输出当前全局最优情况
end
figure
plot(cg_curve)%绘制收敛图
xlabel('Iteration')
toc;%计时完成
