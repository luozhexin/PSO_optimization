function f = func(x,D)      %DÎªÎ¬Êý
%     sum = 0;
%     for i = 1:D
%         sum = sum + x(i)^2;
%     end
%     f = sum;
f=-20*exp(-0.2*sqrt((1/D)*(sum(x.^2))))-exp((1/D)*sum(cos(2*pi.*x)))+exp(1)+20;
end
