actions = csvread('actions0.txt');
numActions = size(actions,1)-1;
state = csvread('episode0.txt');
timeStep = 0.2;
x = [state(1)];
y = [state(2)];
z = [state(3)];
x_dot = [state(4)];
y_dot = [state(5)];
z_dot = [state(6)];
alpha = [state(7)];
beta = [state(8)];
gamma = [state(9)];
r = [state(10)];
s = [state(11)];
r_dot = [state(12)];
s_dot = [state(13)];

for i = 1:numActions
    newState = getSuccessor(actions(i,:),state, timeStep);
    state = newState;
    x(i+1) = state(1);
    y(i+1) = state(2);
    z(i+1) = state(3);
    x_dot(i+1) = state(4);
    y_dot(i+1) = state(5);
    z_dot(i+1) = state(6);
    alpha(i+1) = state(7);
    beta(i+1) = state(8);
    gamma(i+1) = state(9);
    r(i+1) = state(10);
    s(i+1) = state(11);
    r_dot(i+1) = state(12);
    s_dot(i+1) = state(13);
end


    
