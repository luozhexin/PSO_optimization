clear all;clc;
tic;
noP=20;
nVar=30;
fobj=@Ackley;
lb = -5 * ones(1,nVar) ;%��С�߽�Ϊ-5
ub = 5 * ones(1,nVar);%���߽�Ϊ+5
Max_iteration = 1000;%������������
Vmax=1.5;%���ӵ��������ٶ�
wMax=0.9;%����������
wMin=0.4;%��С��������
c1=1.5;%����ѧϰ����
c2=1.5;%���ѧϰ����
cg_curve = zeros(1,Max_iteration);%��ʼ����������convergence
tempo=inf;
tempx=0;
 for idx=1:noP
    Swarm.Particles(idx).X =-5+5*rand(1,nVar);
    Swarm.Particles(idx).O=fobj( Swarm.Particles(idx).X );
    Swarm.Particles(idx).PBEST.X=Swarm.Particles(idx).X;
    Swarm.Particles(idx).PBEST.O=Swarm.Particles(idx).O;
    if(Swarm.Particles(idx).O<tempo)
        tempo=Swarm.Particles(idx).O;
        tempx=idx;
    end
        
 end
 Swarm.GBEST.X=Swarm.Particles(tempx).X;
 Swarm.GBEST.O=tempo;
% [bestfitness bestindex]=min(Swarm.Particles.O);
% Swarm.GBEST.X=Swarm.Particles(bestindex).X;
% Swarm.Particles.PBEST.O=Swarm.Particles.O;
% Swarm.GBEST.O=bestfitness;


for t=1:Max_iteration
    for j=1:noP
        mu=0.5*(Swarm.Particles(j).PBEST.X+Swarm.GBEST.X);
        sigma=abs(Swarm.Particles(j).PBEST.X-Swarm.GBEST.X);
        Swarm.Particles(j).X=normrnd(mu,sigma,[1,nVar]);
        
        indx = find( Swarm.Particles(j).X  > ub);%���������߽�����ӵ�λ�õ���Ϊ5
        Swarm.Particles(j).X (indx) = ub(1);
        indx = find( Swarm.Particles(j).X  < lb);%��������С�߽�����ӵ�λ�õ���Ϊ-5
        Swarm.Particles(j).X (indx) = lb(1);
        
        Swarm.Particles(j).O=fobj( Swarm.Particles(j).X );
      
        if(Swarm.Particles(j).O < Swarm.Particles(j).PBEST.O)%�����ǰλ��������������������λ�ã����������������������λ��
            Swarm.Particles(j).PBEST.O = Swarm.Particles(j).O;
            Swarm.Particles(j).PBEST.X = Swarm.Particles(j).X;
        end
        if(Swarm.Particles(j).O < Swarm.GBEST.O)%�����ǰλ����ȫ������λ�ã������ȫ������λ��
            Swarm.GBEST.O = Swarm.Particles(j).O;
            Swarm.GBEST.X = Swarm.Particles(j).X;
        end
    end
    cg_curve(t) = Swarm.GBEST.O;%�����������
end
figure
plot(cg_curve)%��������ͼ
xlabel('Iteration')
toc;
    
        
            
% for idx=1:noP
% Swarm.Particles(idx).X =-5+5*rand(1,nVar);
% end
% for k = 1: noP
%     Swarm.Particles(k).V = rand(1,nVar);%ÿ�������ٶ��������
%     Swarm.Particles(k).PBEST.X = rand(1,nVar)*Vmax;
%     Swarm.Particles(k).PBEST.O= inf; % for minimization problems
%     %h(k) = plot(Swarm.Particles(k).X(1),Swarm.Particles(k).X(2),'ok', 'markerFaceColor','k');
% end
% Swarm.GBEST.X=ones(1,nVar);%������ ����ò�Ҫ���zeros��1��nVar����Ϊ��ǡ�þ���ȫ�����ŵ�λ��
% Swarm.GBEST.O= inf;
% for t=1:Max_iteration % ��ѭ������
%     for k=1:noP
%         %��ÿ�����Ӽ���Ŀ�꺯����ֵ
%         Swarm.Particles(k).O=fobj( Swarm.Particles(k).X );%����Ackley�����ڵ�ǰλ���º�����output
%         
%         if(Swarm.Particles(k).O < Swarm.Particles(k).PBEST.O)%�����ǰλ��������������������λ�ã����������������������λ��
%             Swarm.Particles(k).PBEST.O = Swarm.Particles(k).O;
%             Swarm.Particles(k).PBEST.X = Swarm.Particles(k).X;
%         end
%         if(Swarm.Particles(k).O < Swarm.GBEST.O)%�����ǰλ����ȫ������λ�ã������ȫ������λ��
%             Swarm.GBEST.O = Swarm.Particles(k).O;
%             Swarm.GBEST.X = Swarm.Particles(k).X;
%         end
%     end
%     %���¹���Ȩ��
%     w=wMax-t*((wMax-wMin)/Max_iteration);%����Ȩ����wMax�ݼ���wMin
%     
%     %�������ӵ��ٶ���λ��
%     for k=1:noP
%         first_vel(k,:) = Swarm.Particles(k).V;%$v_{id}$
%         %$v_{id+1}=w*v_{id}+c_1*rand()*(p_{id}-x_{id}+c_2*Rand()*(p_{gd}-x_{id})$
%         Swarm.Particles(k).V  = w .* Swarm.Particles(k).V + ...  % ����
%             c1 .* rand(1,nVar) .* (Swarm.Particles(k).PBEST.X - Swarm.Particles(k).X ) +  ...   % ��֪
%             c2 .* rand(1,nVar).* (Swarm.GBEST.X - Swarm.Particles(k).X) ;  % ���
%         
%         second_vel(k,:) = Swarm.Particles(k).V;%v_{id+1}
%         
%         index = find(Swarm.Particles(k).V > Vmax);%������vMax�����ӵ��ٶȵ���ΪvMax
%         Swarm.Particles(k).V(index) = Vmax*rand;
%         
%         index = find(Swarm.Particles(k).V < -Vmax);%������-vMax�����ӵ��ٶȵ���Ϊ-vMax
%         Swarm.Particles(k).V(index) = -Vmax*rand;
%         
%         %$x_{id+1}=x_{id}+v_{id}$
%         first_loc(k,:) = Swarm.Particles(k).X ;%$x_{id}$
% 
%         Swarm.Particles(k).X = Swarm.Particles(k).X + Swarm.Particles(k).V;
%         indx = find( Swarm.Particles(k).X  > ub);%���������߽�����ӵ�λ�õ���Ϊ5
%         Swarm.Particles(k).X (indx) = ub(1);
%         
%         indx = find( Swarm.Particles(k).X  < lb);%��������С�߽�����ӵ�λ�õ���Ϊ-5
%         Swarm.Particles(k).X (indx) = lb(1);
%         
%         second_loc(k,:) = Swarm.Particles(k).X ;%$x_{id+1}$
%     end
%      cg_curve(t) = Swarm.GBEST.O;%�����������
%     fprintf('��%d�ε�����ȫ������ֵΪ%4f\n',t,Swarm.GBEST.O);%�����ǰȫ���������
% end
% figure
% plot(cg_curve)%��������ͼ
% xlabel('Iteration')
% toc;%��ʱ���