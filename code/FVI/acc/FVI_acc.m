%%% Fitted Value Iteration %%%

timeStep = 0.01;
TOLERANCE = 0.0001;
Gamma = 0.995;
num_states = 10^5;
num_actions = 4^3;
num_features = 16;
num_batches = 1;
theta = zeros(num_features,1);
theta_rec = [theta];

for batch = 1:num_batches
    % Randomly sample states
    rand_states = zeros(10,num_states);
    y_states = zeros(1,num_states);
    for i = 1:num_states
        x = -8 + 16*rand(1,1);
        y = -8 + 16*rand(1,1);
        z = -5 + 10*rand(1,1);
        x_dot = -5 + (5+5)*rand(1,1);
        y_dot = -5 + (5+5)*rand(1,1);
        z_dot = -5 + (5+5)*rand(1,1);
        r = -0.386 + 0.386*2*rand(1,1); % max angle of 40deg for the pole
        s = -0.386 + 0.386*2*rand(1,1);
        r_dot = -5 + (5+5)*rand(1,1);
        s_dot = -5 + (5+5)*rand(1,1);
        rand_states(:,i) = [x,y,z,...
                            x_dot,y_dot,z_dot,...
                            r,s,...
                            r_dot,s_dot]';
    end

    while (1)
        for i = 1:num_states
            state = rand_states(:,i);
            q = zeros(num_actions,1);
            for index = 1:num_actions
                action = ind2action_acc(index);
                new_state = getSuccessor_acc(action, state, timeStep);
                q(index) = reward_acc(state) + Gamma*theta'*feature_map_acc(new_state);
            end
            y_states(i) = max(q);
        end

        theta_new = gradient_descent_acc(rand_states,y_states);
        theta_rec = [theta_rec theta_new];
        check = norm(theta_new-theta)
        theta = theta_new;
        if check < TOLERANCE
            break
        end
    end
end

