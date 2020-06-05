% Author: Seyedali Mirjalili
% www.alimirjalili.com
% https://scholar.google.com/citations?user=TJHmrREAAAAJ&hl=en
clear all
close all
clc
testfunctionNo = 4; % 1, 2, 3, or 4 test function
initial =  [ 0.8  -0.5 ] ; % You can start with a random position too
cost_initial = objectiveFunction(initial, testfunctionNo);
lb = [-1 -1];
ub = [1 1];
stepSize = [0.05 , 0.05]
nVar = length(initial);
minimumFound = 0;
A.position = initial;
A.cost = cost_initial;
iteration = 0;
while minimumFound == 0
    improvement = 0;
    
    iteration = iteration + 1;
    trajectory(iteration).position = A.position;
    trajectory(iteration).cost = A.cost;
    
    Neighbours = generateNeighbours4HC(A , stepSize, lb, ub, testfunctionNo)
    
    for k = 1 : length(Neighbours)
        B = Neighbours( k );
        if B.cost > A.cost 
            improvement  = 1;
            A.cost = B.cost;
            A.position = B.position;
        end
    end
   
    if improvement == 0
        minimumFound = 1;
        trajectory(iteration).position = A.position;
        trajectory(iteration).cost = A.cost;
    end 
end
A.position
A.cost
figure
set(gcf,'position' , [50,50,700,700])
subplot(2,2,1) % 3d surface
x = lb(1):stepSize(1):ub(1);
y = lb(2):stepSize(2):ub(2);
[x_new , y_new] = meshgrid(x,y);
for i = 1: length(x)
    for j = 1 : length(y)
        X = [x_new(i,j) , y_new(i,j)];
        z_new(i,j) = objectiveFunction(X, testfunctionNo);
    end
end
surfc(x_new, y_new, z_new)
hold on
xlabel('p1')
ylabel('p2')
zlabel('cost')
shading interp
colormap jet
box on
%alpha(0.5)
for k = 1 : length(trajectory);
    traj_final_x(k) = trajectory(k).position(1);
    traj_final_y(k) = trajectory(k).position(2);
    traj_final_z(k) = trajectory(k).cost;
end
plot3(traj_final_x,traj_final_y,traj_final_z, '- .k', 'lineWidth' , 1)
plot3(initial(1),initial(2),cost_initial, '-dk', 'markerSize' , 10 , ...
                                       'markerFaceColor', 'k')
plot3(traj_final_x(end),traj_final_y(end),traj_final_z(end), '- dk', ...
                                       'markerSize' , 10 , 'markerFaceColor', 'k')
subplot(2,2,2) % Top view of the 3d surface
hold on
pcolor(x_new, y_new, z_new)
view(0,90)
plot(traj_final_x,traj_final_y, '- .k', 'lineWidth' , 1)
plot(initial(1),initial(2), '-dk', 'markerSize' , 10 , 'markerFaceColor', 'k')
plot(traj_final_x(end),traj_final_y(end), '- dk', 'markerSize' , 10 , ...
                                                       'markerFaceColor', 'k')
%alpha(0.5)
shading interp
colormap jet
subplot(2,2,[3 4]) % Covergence curve 
plot([trajectory.cost] );
xlabel('Iteration')
ylabel('Cost')