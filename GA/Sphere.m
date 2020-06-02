
function  [fitness_value] = Sphere( X )
 % dim = length(X);
%fitness_value = sum(X.^2-10*cos(2*pi.*X))+10*dim;
   
   fitness_value = sum(X.^2);
end