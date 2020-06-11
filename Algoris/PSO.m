clc;
clear;
c1=1.49445;
c2=1.49445;
maxg=1000;    %��������
sizepop=80;  %��Ⱥ��ģ

%��Ⱥ���±߽�ֵ
popmax=5;
popmin=-popmax;
Vmax=0.15*popmax;
Vmin=0.15*popmin;
%best_particle number
par_num=30;
wmax=0.9;
wmin=0.4;


%%������ʼ���Ӻ��ٶ�
for i=1:sizepop
    pop(i,:)=popmax.*rands(1,par_num);    %��ʼλ��
    V(i,:)=Vmax.*rands(1,par_num);        %��ʼ�ٶ�
    fitness(i)=Ackley(pop(i,:));%��Ӧ��
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
        %����PSO
        %�ٶȸ���
        w=wmax-i*(wmax-wmin)/maxg;
        %w=0.8;
        V(j,:)=w*V(j,:)+c1*rand*(pBest(j,:)-pop(j,:))+c2*rand*(gBest-pop(j,:));
        V(j,find(V(j,:)>Vmax))=Vmax;
        V(j,find(V(j,:)<Vmin))=Vmin;
        
        %��Ⱥ����
        pop(j,:)=pop(j,:)+V(j,:);
        pop(j,find(pop(j,:)>popmax))=popmax;
        pop(j,find(pop(j,:)<popmin))=popmin;
        
        %��Ӧ��ֵ
        fitness(j)=Ackley(pop(j,:));
        
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
    end
    result(i)=fitnessgbest;
end

    plot(result);
    title('��Ӧ������ ');
    grid on
    xlabel('��������');
    ylabel('��Ӧ��');















