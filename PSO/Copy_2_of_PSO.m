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
% Objective function details
fobj = @Ackley;
lb = -5 * ones(1,nVar) ;
ub = 5 * ones(1,nVar);
%%
% PSO paramters
Max_iteration = 100;%粒子最大迭代数
Vmax=6;%粒子的最大飞行速度
wMax=0.9;%最大惯性因子
wMin=0.2;%最小惯性因子
c1=2;%个体学习因子
c2=2;%社会学习因子
cg_curve = zeros(1,Max_iteration);%初始化收敛曲线convergence
%x = -10:4:10;
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
    h(k) = plot(Swarm.Particles(k).X(1),Swarm.Particles(k).X(2),'ok', 'markerFaceColor','k')
end
Swarm.GBEST.X=zeros(1,nVar);
Swarm.GBEST.O= inf;
%%
for t=1:Max_iteration % main loop
    for k=1:noP
        %Calculate objective function for each particle
        Swarm.Particles(k).O=fobj( Swarm.Particles(k).X );
        
        if(Swarm.Particles(k).O < Swarm.Particles(k).PBEST.O)
            Swarm.Particles(k).PBEST.O = Swarm.Particles(k).O;
            Swarm.Particles(k).PBEST.X = Swarm.Particles(k).X;
        end
        if(Swarm.Particles(k).O < Swarm.GBEST.O)
            Swarm.GBEST.O = Swarm.Particles(k).O;
            Swarm.GBEST.X = Swarm.Particles(k).X;
        end
    end
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
    %Update the inertia weight
    w=wMax-t*((wMax-wMin)/Max_iteration);%惯性权重由wMax递减到wMin
    
    %Update the Velocity and Position of particles
    for k=1:noP
        first_vel(k,:) = Swarm.Particles(k).V;
        Swarm.Particles(k).V  = w .* Swarm.Particles(k).V + ...  % inertia
            c1 .* rand(1,nVar) .* (Swarm.Particles(k).PBEST.X - Swarm.Particles(k).X ) +  ...   % congnitive
            c2 .* rand(1,nVar).* (Swarm.GBEST.X - Swarm.Particles(k).X) ;  % social
        
        second_vel(k,:) = Swarm.Particles(k).V;
        
        index = find(Swarm.Particles(k).V > Vmax);
        Swarm.Particles(k).V(index) = Vmax*rand;
        
        index = find(Swarm.Particles(k).V < -Vmax);
        Swarm.Particles(k).V(index) = -Vmax*rand;
        
        first_loc(k,:) = Swarm.Particles(k).X ;

        Swarm.Particles(k).X = Swarm.Particles(k).X + Swarm.Particles(k).V;
        indx = find( Swarm.Particles(k).X  > ub);
        Swarm.Particles(k).X (indx) = ub(1);
        
        indx = find( Swarm.Particles(k).X  < lb);
        Swarm.Particles(k).X (indx) = lb(1);
        
        second_loc(k,:) = Swarm.Particles(k).X ;
        
        nn = 20;
        moving_x(k,:) =  linspace(first_loc(k,1),second_loc(k,1),nn);
        moving_y(k,:) = linspace(first_loc(k,2),second_loc(k,2),nn);
        
    end
    
    
    for rr = 1: nn
        for JJ = 1:noP;
            set(h(JJ),'XData', moving_x(JJ,rr),'YData', moving_y(JJ,rr));
        end
        
        drawnow
    end
    cg_curve(t) = Swarm.GBEST.O;
    Swarm.GBEST.O
end
figure
plot(cg_curve)
xlabel('Iteration')
toc;
