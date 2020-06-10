load('10D.mat')
load('20D.mat')
load('30D.mat')
load('40D.mat')
plot(cg_curve10,'DisplayName','cg_curve10');hold on;plot(cg_curve20,'DisplayName','cg_curve20');plot(cg_curve30,'DisplayName','cg_curve30');plot(cg_curve40,'DisplayName','cg_curve40');hold off;
xlabel('iteration')
ylabel('fitness')
legend('D=10','D=20','D=30','D=40')