clc;clear all;close all;
tic;
figure
set(gcf,'Renderer','OpenGL');
 
%x = linspace(-10,10,30);
%y = linspace(-10,10,30);
%x = linspace(-5,5,100);
%y = linspace(-5,5,100);
x=[-5:0.1:5];
y=x;
[x_new, y_new] = meshgrid(x,y);%�������������
for k1 = 1: size(x_new, 1)
    for k2 = 1 : size(x_new , 2)
        X = [ x_new(k1,k2) , y_new(k1, k2) ];
        z(k1,k2) = Ackley( X );%����Ackley����
    end
end
h = contour(x_new, y_new, z , 20);%���Ƶȸ���
 set(gca,'XLimMode','manual');
set(gca,'YLimMode','manual');
%set(gca,'XLim',[-5,5]);
%set(gca,'YLim',[-5,5]);
%axis([-10,10,-10,10])
axis([-5,5,-5,5])
hold on
view(2)
shading interp %ɫ��ƽ��
noP =36;%����Ⱥ��ģ
nVar = 2;%Ŀ�꺯�����Ա�������
%set(h,'EraseMode','normal')
%%
% Objective function details
fobj = @Ackley;
lb = -5 * ones(1,nVar) ;
ub = 5 * ones(1,nVar);
%%
% PSO paramters
Max_iteration = 100;%������������
Vmax=6;%���ӵ��������ٶ�
wMax=0.9;%����������
wMin=0.2;%��С��������
c1=2;%����ѧϰ����
c2=2;%���ѧϰ����
cg_curve = zeros(1,Max_iteration);%��ʼ����������convergence
%x = -10:4:10;
x = -5:2:5;%�ڸ�������[-5��5]��ȡ��
y= x;
idx = 1;
% show_vel = 1;%��ʾ�ٶ�
for t1 = 1: length (x)
    for t2 =  1: length (y)
        Swarm.Particles(idx).X = [x(t1) y(t2)];
        idx = idx+1;
    end
end
%%
% Initializations
for k = 1: noP
    Swarm.Particles(k).V = rand(1,nVar);%ÿ�������ٶ��������
    Swarm.Particles(k).PBEST.X = rand(1,nVar)*Vmax;
    Swarm.Particles(k).PBEST.O= inf; % for minimization problems
    h(k) = plot(Swarm.Particles(k).X(1),Swarm.Particles(k).X(2),'ok', 'markerFaceColor','k')
    %set(h(k),'EraseMode','normal')
%     if show_vel == 1
%         p1 = [Swarm.Particles(k).X(1) Swarm.Particles(k).X(2)];                         % First Point
%         p2 = [Swarm.Particles(k).V(1) Swarm.Particles(k).V(2)];                         % Second Point
%         dp = p2-p1/100;                         % Difference
%         
%         %h2(k) = plot([p1(1) dp(1)],[p1(2) dp(2)],'-k' , 'LineWidth',2.5)
%         %set(h2(k),'EraseMode','normal')
%     end
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
    w=wMax-t*((wMax-wMin)/Max_iteration);%����Ȩ����wMax�ݼ���wMin
    
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
        if(Swarm.Particles(k).X + Swarm.Particles(k).V> ub)
            Swarm.Particles(k).X=ub(1);
        elseif(Swarm.Particles(k).X + Swarm.Particles(k).V < lb)
            Swarm.Particles(k).X=lb(1);
        else     
            Swarm.Particles(k).X = Swarm.Particles(k).X + Swarm.Particles(k).V;
        end
        second_loc(k,:) = Swarm.Particles(k).X ;
        
        %indx = find( Swarm.Particles(k).X  > ub);
        %Swarm.Particles(k).X (indx) = ub(1);
        
        %indx = find( Swarm.Particles(k).X  < lb);
        %Swarm.Particles(k).X (indx) = lb(1);
        
        nn = 20;
        moving_x(k,:) =  linspace(first_loc(k,1),second_loc(k,1),nn);
        moving_y(k,:) = linspace(first_loc(k,2),second_loc(k,2),nn);
        
        %moving_vx(k,:) =  linspace(first_vel(k,1),second_vel(k,1),nn);
        %moving_vy(k,:) = linspace(first_vel(k,2),second_vel(k,2),nn);
        
    end
    
    
    for rr = 1: nn
        for JJ = 1:noP;
            set(h(JJ),'XData', moving_x(JJ,rr),'YData', moving_y(JJ,rr));
            
%             if show_vel == 1
%                 p1 = [moving_x(JJ,rr) moving_y(JJ,rr)];                         % First Point
%                 p2 = [moving_x(JJ,end) moving_y(JJ,end)];
%                 dp = (p2+p1)/2;                         % Difference
%                 dp = (p1+dp)/2;
%                 %set(h2(JJ),'XData', [p1(1), dp(1)],'YData',  [p1(2), dp(2)]);
%             end
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
