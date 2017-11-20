%Gradien descent with regularization
clear;
close all;
L=0.6;

stateInit=[0,0,5,0,0,0,0,0,0,1,-0.01,0,0]';
phiInit=feature_map_2(stateInit);
theta=zeros(length(phiInit),1);
dim_phi=length(phiInit);

m=4000;
n_action=5^4;
timeStep=0.01;
gamma=0.9;         
alpha=0.0001;        %learning rate
lambda=.01;
n_episodes=100;
counter=1;
epsilon=0.1;

for ep=1:n_episodes
    r=randn(3,1)*2+[0;0;20];
    rdot=randn(3,1)*0.5;
    ang=rand(3,1)*2*pi;
    rho=randn(2,1)*0.05;
    rhodot=randn(2,1)*0.01;
    clear states
    state=[r;rdot;ang;rho;rhodot];
    for ii=1:1000
        states(ii,:)=state;
        q=zeros(n_action,1);
        for aa=1:n_action
            next_state=getSuccessor(ind2action(aa),state,timeStep)';
            q(aa)=reward_std(next_state)+gamma*theta'*feature_map_2(next_state);
        end
        [y,as]=max(q);
        phi=feature_map_2(state);
        %gradient descent
        thetaold=theta;
        theta=theta-alpha*(phi*(theta'*phi-y)+lambda*theta);
        change(counter)=norm(thetaold-theta)/norm(theta);
        nt(counter)=norm(theta);
        counter=counter+1;
        %Check if fallen
        r = state(10);
        s = state(11); 
        if sqrt(r^2+s^2) > sqrt(2)/2*L 
            disp("Episode ", ep, " over after ", ii/100, " seconds in flight")
            close all
            figure()
            plot(states(:,10),states(:,11))
            title('COM position')
            axis equal
            figure()
            plot(states(:,1),states(:,2))
            title('Drone xy position')
            axis equal
            figure()
            plot(states(:,3))
            title('z')
            break
        end
        %Build next state
        test=rand(1);
        if test<0.1
            next_action=randi(n_action);
        else next_action=as;
        end
        state=getSuccessor(
    
    end
end
%%
figure()
plot(change)
title('evolution of \theta')
figure()
semilogy(nt)
title('norm of theta')
%%
clear states
timeStep=0.01
state=[0,0,20,0,0,0,0,0,0,-0.02,0.03,0,0]';
states(1,:)=state;
for ii = 1:1000
    actionInd = getActionPhi(state, theta,timeStep,gamma);
    action=ind2action(actionInd);
    newState = getSuccessor(action, states(ii,:), timeStep);
    states(ii+1,:) = newState;
    actions(ii,:) = action;
    %rewards(i) = reward;
    r = newState(10);
    s = newState(11); 
    if sqrt(r^2+s^2) > sqrt(2)/2*L 
        ii
        break
    end
    state=newState;
end
figure()
plot(states(:,10),states(:,11))
title('COM position')
axis equal
figure()
plot(states(:,1),states(:,2))
title('Drone xy position')
axis equal
figure()
plot(states(:,3))
title('z')
