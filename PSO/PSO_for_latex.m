clc;clear all;close all;
tic;
figure
set(gcf,'Renderer','OpenGL');

x=[-5:0.1:5];
y=x;
[xnew, ynew] = meshgrid(x,y);%�������������
for k1 = 1: size(xnew, 1)
    for k2 = 1 : size(xnew , 2)
        X = [ xnew(k1,k2) , ynew(k1, k2) ];
        z(k1,k2) = Ackley( X );%����Ackley����
    end
end
h = contour(xnew, ynew, z , 20);%���Ƶȸ���
set(gca,'XLimMode','manual');
set(gca,'YLimMode','manual');
axis([-5,5,-5,5])
hold on
view(2)
shading interp %ɫ��ƽ��
noP =36;%����Ⱥ��ģ
nVar = 2;%Ŀ�꺯�����Ա�������
fobj = @Ackley;
lb = -5 * ones(1,nVar) ;%��С�߽�Ϊ-5
ub = 5 * ones(1,nVar);%���߽�Ϊ+5
% PSO paramters
Maxiteration = 100;%������������
Vmax=6;%���ӵ��������ٶ�
wMax=0.9;%����������
wMin=0.2;%��С��������
c1=2;%����ѧϰ����
c2=2;%���ѧϰ����
cgcurve = zeros(1,Maxiteration);%��ʼ����������convergence
x = -5:2:5;%�ڸ�������[-5��5]��ȡ��
y= x;
idx = 1;
for t1 = 1: length (x)
    for t2 =  1: length (y)
        Swarm.Particles(idx).X = [x(t1) y(t2)];
        idx = idx+1;
    end
end
% Initializations
for k = 1: noP
    Swarm.Particles(k).V = rand(1,nVar);%ÿ�������ٶ��������
    Swarm.Particles(k).PBEST.X = rand(1,nVar)*Vmax;
    Swarm.Particles(k).PBEST.O= inf; % for minimization problems
    h(k) = plot(Swarm.Particles(k).X(1),Swarm.Particles(k).X(2),'ok', 'markerFaceColor','k');
end
Swarm.GBEST.X=ones(1,nVar);%������ ����ò�Ҫ���zeros��1��nVar����Ϊ��ǡ�þ���ȫ�����ŵ�λ��
Swarm.GBEST.O= inf;
for t=1:Maxiteration % ��ѭ������
    for k=1:noP
        %��ÿ�����Ӽ���Ŀ�꺯����ֵ
        Swarm.Particles(k).O=fobj( Swarm.Particles(k).X );%����Ackley�����ڵ�ǰλ���º�����output
        
        if(Swarm.Particles(k).O < Swarm.Particles(k).PBEST.O)%�����ǰλ��������������������λ�ã����������������������λ��
            Swarm.Particles(k).PBEST.O = Swarm.Particles(k).O;
            Swarm.Particles(k).PBEST.X = Swarm.Particles(k).X;
        end
        if(Swarm.Particles(k).O < Swarm.GBEST.O)%�����ǰλ����ȫ������λ�ã������ȫ������λ��
            Swarm.GBEST.O = Swarm.Particles(k).O;
            Swarm.GBEST.X = Swarm.Particles(k).X;
        end
    end
    %�����1��5��10��20��50��100�ε���ʱ���ӵķֲ�ͼ
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
    %���¹���Ȩ��
    w=wMax-t*((wMax-wMin)/Maxiteration);%����Ȩ����wMax�ݼ���wMin
    
    %�������ӵ��ٶ���λ��
    for k=1:noP
        firstvel(k,:) = Swarm.Particles(k).V;%$Vid$
        %$V{id+1}=w*v{id}+c1*rand()*(p{id}-x{id}+c2*Rand()*(p{gd}-x{id})$
        Swarm.Particles(k).V  = w .* Swarm.Particles(k).V + ...  % ����
            c1 .* rand(1,nVar) .* (Swarm.Particles(k).PBEST.X - Swarm.Particles(k).X ) +  ...   % ��֪
            c2 .* rand(1,nVar).* (Swarm.GBEST.X - Swarm.Particles(k).X) ;  % ���
        
        secondvel(k,:) = Swarm.Particles(k).V;%v{id+1}
        
        index = find(Swarm.Particles(k).V > Vmax);%������vMax�����ӵ��ٶȵ���ΪvMax
        Swarm.Particles(k).V(index) = Vmax*rand;
        
        index = find(Swarm.Particles(k).V < -Vmax);%������-vMax�����ӵ��ٶȵ���Ϊ-vMax
        Swarm.Particles(k).V(index) = -Vmax*rand;
        
        %$x{id+1}=x{id}+v{id}$
        firstloc(k,:) = Swarm.Particles(k).X ;%$x{id}$

        Swarm.Particles(k).X = Swarm.Particles(k).X + Swarm.Particles(k).V;
        indx = find( Swarm.Particles(k).X  > ub);%���������߽�����ӵ�λ�õ���Ϊ5
        Swarm.Particles(k).X (indx) = ub(1);
        
        indx = find( Swarm.Particles(k).X  < lb);%��������С�߽�����ӵ�λ�õ���Ϊ-5
        Swarm.Particles(k).X (indx) = lb(1);
        
        secondloc(k,:) = Swarm.Particles(k).X ;%$x{id+1}$
   %Ԥ���     
        nn = 20;
        movingx(k,:) =  linspace(firstloc(k,1),secondloc(k,1),nn);
        movingy(k,:) = linspace(firstloc(k,2),secondloc(k,2),nn);
        
    end
    %��ͼ
    for rr = 1: nn
        for JJ = 1:noP;
            set(h(JJ),'XData', movingx(JJ,rr),'YData', movingy(JJ,rr));
        end       
        drawnow
    end
    cgcurve(t) = Swarm.GBEST.O;%�����������
    fprintf('��%d�ε�����ȫ������ֵΪ%4f\n',t,Swarm.GBEST.O);%�����ǰȫ���������
end
figure
plot(cgcurve)%��������ͼ
xlabel('Iteration')
saveas(gcf,'result.jpg');
toc;%��ʱ���
