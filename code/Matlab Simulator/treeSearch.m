%% Tree search
clear all
close all
state = [0,0,0,0,0,0,0,0,0,0.2,0.2,0,0];
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
timeStep = 0.02;
L = 0.6;
states = state;
for i = 1:100
    [action, reward] = getAction2(state, timeStep);
    newState = getSuccessor(action, states(i,:), timeStep);
    states(i+1,:) = newState;
    actions(i,:) = action;
    rewards(i) = reward;
    r = newState(10);
    s = newState(11); 
    if sqrt(r^2+s^2) > sqrt(2)/2*L 
        break
    end
end


function [bestAction, reward] = getAction1(state, timeStep)
oldReward = -Inf;
g = 9.81;
bestAction = [g,0,0,0];
for index = 1:5^4
    action = ind2action(index);
    newState = getSuccessor(action, state, timeStep);
    r = newState(10);
    s = newState(11);
    r_dot = newState(12);
    s_dot = newState(13);
    newState(10) = r+timeStep*r_dot;
    newState(11) = s+timeStep*s_dot;
    reward = reward_std(newState);
    if reward > oldReward
       oldReward = reward;
       bestAction = action;
    end 
end
reward = oldReward;
end 

function [bestAction, reward] = getAction2(state, timeStep)
oldReward = -Inf;
g = 9.81;
bestAction = [g,0,0,0];
for index1 = 1:5^4
    action1 = ind2action(index1);
    newState1 = getSuccessor(action1, state, timeStep);
    for index2 = 1:5^4
        action2 = ind2action(index2);
        newState2 = getSuccessor(action2, newState1, timeStep);
        r = newState2(10);
        s = newState2(11);
        r_dot = newState2(12);
        s_dot = newState2(13);
        newState2(10) = r+timeStep*r_dot;
        newState2(11) = s+timeStep*s_dot;
        reward = reward_std(newState2);
        if reward > oldReward
            oldReward = reward;
            bestAction = action1;
        end
    end
end
reward = oldReward;
end