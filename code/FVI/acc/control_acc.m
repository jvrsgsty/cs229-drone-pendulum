%% CS 229 - Machine Learning Project %%
% Inverted Pendulum on a drone

%%% Simulation parameters %%%

pause_time = 0.0;
num_trial_length_to_start_display = 0;
display_started = 0;

GAMMA = 0.995;

TOLERANCE = 0.01;

NO_LEARNING_THRESHOLD = 20; 

num_actions = 4^3;
timeStep = 0.01;

%%% End parameter list %%%

% Time cycle of the simulation
time=0;

% These variables perform bookkeeping (how many cycles was the pole
% balanced for before it fell). Useful for plotting learning curves.
time_steps_to_failure=[];
num_failures=0;
time_at_start_of_current_trial=0;

max_failures=500; % May have to modify  

% x, x_dot, theta, theta_dot represents the actual continuous state vector
x = -0.05 + 0.1*rand(1,1);
y = -0.05 + 0.1*rand(1,1);
z = -0.5 + rand(1,1);
x_dot = -0.5 + rand(1,1);
y_dot = -0.5 + rand(1,1);
z_dot = -0.5 + rand(1,1);
r = 0; 
s = 0; 
r_dot = 0;
s_dot = 0;


% state is the number given to this state - you only need to consider
% this representation of the state
state = [x,y,z,...
        x_dot,y_dot,z_dot,...
        r,s,...
        r_dot,s_dot]';
states = [state];
actions = [];
time = [0];
while (1)
    V_star = -Inf;
    action = [];
    for index = 1:num_actions
        action_temp = ind2action_acc(index);
        new_state = getSuccessor_acc(action_temp, state, timeStep);
        q = theta'*feature_map_acc(new_state);
        if q > V_star
            V_star = q;
            action = [action_temp];
        elseif q == V_star
            action = [action action_temp]; 
        end
    end
    size(action,2);
    index = randi([1 size(action,2)],1,1);
    new_state = getSuccessor_acc(action(:,index), state, timeStep);
    states = [states new_state'];
    actions = [actions, action(:,index)];
    time = [time time(end)+ timeStep];
    
    if abs(new_state(1)) > 5 || abs(new_state(2)) > 5 || ...
            abs(new_state(3)) > 5 || time(end) > 60   ...
             || abs(new_state(7)) > 0.3 || abs(new_state(8)) > 0.3
        break
    else
        state = new_state;
    end
end
actions;
subplot(1,3,1)
plot(states(1,:),states(2,:))
title('Drone trajectory')
xlabel('x')
ylabel('y')
subplot(1,3,2)
plot(time, states(3,:))
title('Drone altitude')
xlabel('Time')
ylabel('z')
subplot(1,3,3)
plot(states(7,:),states(8,:))
title('Pole COM trajectory')
xlabel('r')
ylabel('s')


