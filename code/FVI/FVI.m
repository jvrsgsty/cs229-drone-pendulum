%%% Fitted Value Iteration %%%

% Randomly sample states
num_states = 10^4;
num_actions = 3^3;
num_features = 9;
rand_states = zeros(13,num_states);
y_states = zeros(1,num_states);
timeStep = 0.1;
TOLERANCE = 0.0001;
Gamma = 0.995;
for i = 1:num_states
    x = -6 + 12*rand(1,1);
    y = -6 + 12*rand(1,1);
    z = -1.5 + 3*rand(1,1);
    x_dot = -5 + (5+5)*rand(1,1);
    y_dot = -5 + (5+5)*rand(1,1);
    z_dot = -5 + (5+5)*rand(1,1);
    alpha = rand(1,1)*2*pi;
    beta = -pi/6+pi/3*rand(1,1);
    gamma = -pi/6+pi/3*rand(1,1);
    r = -0.386 + 0.386*2*pi/3*rand(1,1); % max angle of 40deg for the pole
    s = -0.386 + 0.386*2*pi/3*rand(1,1); 
    r_dot = -5 + (5+5)*rand(1,1);
    s_dot = -5 + (5+5)*rand(1,1);
    rand_states(:,i) = [x,y,z,...
                      x_dot,y_dot,z_dot,...
                      alpha,beta,gamma,...
                      r,s,...
                      r_dot,s_dot]';
end

% Initialize theta
theta = zeros(num_features,1);
while (1)
    for  i = 1:num_states
        state = rand_states(:,i);
        q = zeros(num_actions,1);
        for index = 1:num_actions
            action = ind2action(index);
            new_state = getSuccessor(action, state, timeStep);
            q(index) = reward(state) + Gamma*theta'*feature_map(new_state);
        end
        y_states(index) = max(q);
    end
    
    theta_new = gradient_descent(rand_states,y_states);
    check = norm(theta_new-theta);
    theta = theta_new;
    if check < TOLERANCE
        break  
    end
    
end


