clear
clc
%% controling paramters of the GA algortihm
Problem.obj = @Sphere;
Problem.nVar = 20;
M = 20; % number of chromosomes (cadinate solutions)
N = Problem.nVar;  % number of genes (variables)
MaxGen = 100;
Pc = 0.85;
Pm = 0.01;
Er = 0.05;
visualization = 1; % set to 0 if you do not want the convergence curve 
[BestChrom]  = GeneticAlgorithm (M , N, MaxGen , Pc, Pm , Er , Problem.obj , visualization)
disp('The best chromosome found: ')
BestChrom.Gene
disp('The best fitness value: ')
BestChrom.Fitness