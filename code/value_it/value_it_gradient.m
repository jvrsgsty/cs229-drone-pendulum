% Gradient descent with regularization
%
% CS 229
% Stand:    11.19.2017

clear;
close all;
L=0.6;

stateInit=[0,0,5,0,0,0,0,0,0,0.02,-0.01,0,0]';
phiInit=feature_map_2(stateInit);
theta=zeros(length(phiInit),1);
dim_phi=length(phiInit);

m=1000;
n_action=5^4;
timeStep=0.03;
gamma=0.9;
alpha=0.0001;        %learning rate
lambda=.01;

for ii=1:m
    if rem(ii,1000)==0
        ii
    end
    q=zeros(n_action,1);
    r=randn(3,1)*2+[0;0;20];
    rdot=randn(3,1)*0.5;
    ang=rand(3,1)*2*pi;
    rho=randn(2,1)*0.05;
    rhodot=randn(2,1)*0.01;
    state=[r;rdot;ang;rho;rhodot];
    for aa=1:n_action
        next_state=getSuccessor(ind2action(aa),state,timeStep)';
        q(aa)=reward_std(next_state)+gamma*theta'*feature_map_2(next_state);
    end
    [y(ii),as]=max(q);
    if ii==1
        phi=feature_map_2(state);
    else phi=[phi,feature_map_2(state)];
    end
    %gradient descent
    thetaold=theta;
    theta=theta-alpha*(phi(:,ii)*(theta'*phi(:,ii)-y(ii))+lambda*theta);
    change(ii)=norm(thetaold-theta)/norm(theta);
    nt(ii)=norm(theta);
    if nt>1e10
        break;
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
state=[0,0,20,0,0,0,0,0,0,0.05,0.1,0,0]';
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
