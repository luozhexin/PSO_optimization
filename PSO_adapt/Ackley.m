
%Ackley
function [ O ] = Ackley ( X )
[row,col]=size(X);
O=-20*exp(-0.2*sqrt((1/col)*(sum(X.^2))))-exp((1/col)*sum(cos(2*pi.*X)))+exp(1)+20;

% %X = X + 5;
% dim = length(X);
% O = sum(X.^2-10*cos(2*pi.*X))+10*dim;
end