
%Ackley
function [ O ] = ObjectiveFunction ( X )
[row,col]=size(X);
O=-20*exp(-0.2*sqrt((1/col)*(sum(X.^2))))-exp((1/col)*sum(cos(2*pi.*X)))+exp(1)+20;
end