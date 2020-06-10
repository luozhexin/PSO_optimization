
%%������ʼ��

    clc;
    clear all;
    c1=1.49445;
    c2=1.49445;
    bc=0.8;%�ӽ�����
    bs=0.1;%�ӽ��ش�С����
    w=0.8;
    maxg=1000;     %��������
    %--------------------------------------------------------------------------
    sizepop=80;    %��Ⱥ��ģ  N=20/80
    par_num=30;    %best_particle number  D=10/30
    popmax=1;      %��Ⱥ���±߽�ֵ
    %  32      5.21       600       10      100     30          10      
    %  Ackley  Rastrigin  Griewank  Alpine  Sphere  Rosenbrock  Schwefel
    %
    %  1
    %  Sum_of_Different_Power
    %--------------------------------------------------------------------------
    popmin=-popmax;
    Vmax=0.15*popmax;
    Vmin=0.15*popmin;


    wmax=0.8;
    wmin=0.6;

%�ظ�50��
for t=1:50
    %%������ʼ���Ӻ��ٶ�
    for i=1:sizepop
        pop(i,:)=popmax.*rands(1,par_num);    %��ʼλ��
        V(i,:)=Vmax.*rands(1,par_num);        %��ʼ�ٶ�
        fitness(i)=Sum_of_Different_Power(pop(i,:));%��Ӧ��-----------------------------------------------------------------
    end

    %Ѱ�����Ÿ���
    [bestfitness bestindex]=min(fitness);
    pBest=pop;                  %�������
    gBest=pop(bestindex,:);     %ȫ�����
    fitnesspbest=fitness;       %���������Ӧ��
    fitnessgbest=bestfitness;   %ȫ�������Ӧ��

    %%����Ѱ��
    for i=1:maxg
        for j=1:sizepop
            
            %�ٶȸ���
            V(j,:)=w*V(j,:)+c1*rand*(pBest(j,:)-pop(j,:))+c2*rand*(gBest-pop(j,:));
            V(j,find(V(j,:)>Vmax))=Vmax;
            V(j,find(V(j,:)<Vmin))=Vmin;

            %��Ⱥ����
            pop(j,:)=pop(j,:)+V(j,:);
            pop(j,find(pop(j,:)>popmax))=popmax;
            pop(j,find(pop(j,:)<popmin))=popmin;

            %��Ӧ��ֵ
            fitness(j)=Sum_of_Different_Power(pop(j,:));%-----------------------------------------------

            %�������Ÿ���
            if fitness(j)<fitnesspbest(j)
                pBest(j,:)=pop(j,:);
                fitnesspbest(j)=fitness(j);
            end

            %Ⱥ�����Ÿ���
            if fitness(j)<fitnessgbest
                gBest=pop(j,:);
                fitnessgbest=fitness(j);
            end
            r1=rand();
            if r1<bc
                numPool=round(bs*sizepop);
                PoolX=pop(1:numPool,:);
                PoolVX=V(1:numPool,:);
                for z=1:numPool
                    seed1=floor(rand()*(numPool-1)+1);
                    seed2=floor(rand()*(numPool-1)+1);
                    pb=rand();
                    childx1(z,:)=pb*PoolX(seed1,:)+(1-pb)*PoolX(seed2,:);
                    childv1(z,:)=(PoolVX(seed1,:)+PoolVX(seed2,:))*norm(PoolVX(seed1,:))/norm(PoolVX(seed1,:)+PoolVX(seed2,:));
                end 
            end
        end
        result(i)=fitnessgbest;
    end
time(t)=result(maxg);
end


    
    
        
        
        
        
        
        
        
        
        
    
    
    