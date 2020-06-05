% Author: Seyedali Mirjalili
% www.alimirjalili.com
% https://scholar.google.com/citations?user=TJHmrREAAAAJ&hl=en
function [ Neighbours ] = generateNeighbours4HC(currentSolution , stepSize,  lb, ub , testfunctionNo)
nVar = length(currentSolution.position);
idx = 0;
    for i = 1 : nVar
        idx = idx + 1;
        
        stepVector = zeros(1,nVar);
        stepVector(i) = stepSize(i);
        Neighbours( idx ).position = currentSolution.position + stepVector;
        
        if Neighbours( idx ).position(i) > ub(i)
            Neighbours( idx ).position(i) = ub(i);
        end
        if Neighbours( idx ).position(i) < lb(i)
            Neighbours( idx ).position(i) = lb(i);
        end
        
        Neighbours( idx ).cost       = objectiveFunction(Neighbours( idx ).position , testfunctionNo );
        
        idx = idx + 1;
        
        stepVector = zeros(1,nVar);
        stepVector(i) = stepSize(i);
        Neighbours( idx ).position = currentSolution.position - stepVector;
        
        if Neighbours( idx ).position(i) > ub(i)
            Neighbours( idx ).position(i) = ub(i);
        end
        if Neighbours( idx ).position(i) < lb(i)
            Neighbours( idx ).position(i) = lb(i);
        end
        
        Neighbours( idx ).cost       = objectiveFunction(Neighbours( idx ).position , testfunctionNo);
    end
    
 
    
    