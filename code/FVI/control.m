%% CS 229 - Machine Learning Project %%
% Inverted Pendulum on a drone

%%% Simulation parameters %%%

pause_time = 0.0;
num_trial_length_to_start_display = 0;
display_started = 0;

GAMMA = 0.995;

TOLERANCE = 0.01;

NO_LEARNING_THRESHOLD = 20;

num_actions = 3^3;
timeStep = 0.1;

%%% End parameter list %%%

% Time cycle of the simulation
time=0;

% These variables perform bookkeeping (how many cycles was the pole
% balanced for before it fell). Useful for plotting learning curves.
time_steps_to_failure=[];
num_failures=0;
time_at_start_of_current_trial=0;

max_failures=500; % May have to modify

% Starting state is (0 0 0 0)
% x, x_dot, theta, theta_dot represents the actual continuous state vector
x = -0.05 + 0.1*rand(1,1);
y = -0.05 + 0.1*rand(1,1);
z = -0.5 + rand(1,1);
x_dot = -0.5 + rand(1,1);
y_dot = -0.5 + rand(1,1);
z_dot = -0.5 + rand(1,1);
alpha = 0;
beta = -pi/120+pi/60*rand(1,1);
gamma = -pi/120+pi/60*rand(1,1);
r = 0;
s = 0;
r_dot = 0;
s_dot = 0;


% state is the number given to this state - you only need to consider
% this representation of the state
state = [x,y,z,...
        x_dot,y_dot,z_dot,...
        alpha,beta,gamma,...
        r,s,...
        r_dot,s_dot]';

x_rec = [x];
y_rec = [y];
z_rec = [z];
beta_rec = [beta];
gamma_rec = [gamma];
r_rec = [r];
s_rec = [s];
actions = [];

while (1)
    V_star = -Inf;
    action = [];
    for index = 1:num_actions
        action_temp = ind2action(index);
        new_state = getSuccessor(action_temp, state, timeStep);
        q = theta'*feature_map(new_state);
        if q > V_star
            V_star = q;
            action = [action_temp];
        elseif q == V_star
            action = [action action_temp];
        end
    end
    size(action,2)
    index = randi([1 size(action,2)],1,1);
    new_state = getSuccessor(action(:,index), state, timeStep);
    x_rec = [x_rec new_state(1)];
    y_rec = [y_rec new_state(2)];
    z_rec = [z_rec new_state(3)];
    beta_rec = [beta_rec state(8)];
    gamma_rec = [gamma_rec state(9)];
    r_rec = [r_rec new_state(10)];
    s_rec = [s_rec new_state(11)];
    actions = [actions, action(:,index)];

    rew = reward(new_state);
    if abs(new_state(1)) > 5 || abs(new_state(2)) > 5 || abs(new_state(3)) > 5 %|| abs(r) > 0.3 || abs(s) > 0.3
        break
    else
        state = new_state;
    end
end
actions
subplot(1,3,1)
plot(x_rec,y_rec)
title('Drone trajectory')
xlabel('x')
ylabel('y')
subplot(1,3,2)
plot(z_rec)
title('Drone altitude')
xlabel('time')
ylabel('z')
subplot(1,3,3)
plot(r_rec,s_rec)
title('Pole COM trajectory')
xlabel('r')
ylabel('s')

exit
