
%Rastrigin
function [ O ] = ObjectiveFunction ( X )
%X = X + 5;
dim = length(X);
O = sum(X.^2-10*cos(2*pi.*X))+10*dim;
end