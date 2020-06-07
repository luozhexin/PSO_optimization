clear;clc;
load('matlab.mat');
plot(ans2,'DisplayName','ans2');hold on;plot(ans4,'DisplayName','ans4');plot(ans8,'DisplayName','ans8');plot(ans16,'DisplayName','ans16');plot(ans25,'DisplayName','ans25');plot(ans36,'DisplayName','ans36');plot(ans64,'DisplayName','ans64');hold off;
legend('nop=2','nop=4','nop=8','nop=16','nop=25','nop=36','nop=64');
xlabel('iteration');