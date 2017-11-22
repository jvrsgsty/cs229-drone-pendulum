%Full regression
%now obsolete

warning('off')
clear;
close all;
L=0.6;

stateInit=[0,0,5,0,0,0,0,0,0,0.1,0,0,0]';
phiInit=feature_map_with_projection(stateInit);
theta=zeros(length(phiInit),1);
dim_phi=length(phiInit);

m=1000;
n_action=5^4;
timeStep=0.01;
gamma=0.9;         
alpha=0.001;        %learning rate
n_reg=300;          %number of examples the regression is done on

for ii=1:105
    q=zeros(n_action,1);
    r=randn(3,1);
    rdot=randn(3,1)*0.1;
    alpha=rand(1,1)*2*pi;
    ang=rand(2,1)*2*pi/20-pi/20;
    rho=randn(2,1)*0.05;
    rhodot=randn(2,1)*0.01;
    state=[r;rdot;alpha;ang;rho;rhodot];
    for aa=1:n_action
        next_state=getSuccessor(ind2action(aa),state,timeStep)';
        q(aa)=reward_std(next_state)+gamma*theta'*feature_map_with_projection(next_state);
    end
    [y(ii),as]=max(q);
    if ii==1
        phi=feature_map_with_projection(state);
    else phi=[phi,feature_map_with_projection(state)];
    end
    %gradient descent
    %theta=theta-alpha*phi(:,ii)*(theta'*phi(:,ii)-y(ii));
    %full regression
    %theta=regress(y,phi');
    change(ii)=0;
    nt(ii)=0;
end
disp('phase 1 end')
for ii=106:n_reg
    if rem(ii,1000)==0
        ii
    end
    q=zeros(n_action,1);
    r=randn(3,1);
    rdot=randn(3,1)*0.1;
    alpha=rand(1,1)*2*pi;
    ang=rand(2,1)*2*pi/20-pi/20;
    rho=randn(2,1)*0.05;
    rhodot=randn(2,1)*0.01;
    state=[r;rdot;alpha;ang;rho;rhodot];
    for aa=1:n_action
        next_state=getSuccessor(ind2action(aa),state,timeStep)';
        q(aa)=reward_std(next_state)+gamma*theta'*feature_map_with_projection(next_state);
    end
    [y(ii),as]=max(q);
    if ii==1
        phi=feature_map_with_projection(state);
    else phi=[phi,feature_map_with_projection(state)];
    end
    %gradient descent
    %theta=theta-alpha*phi(:,ii)*(theta'*phi(:,ii)-y(ii));
    %full regression
    thetaold=theta;
    theta=regress(y',phi');
    change(ii)=norm(thetaold-theta)/norm(theta);
    nt(ii)=norm(theta);
end
disp('phase 2 end')
for ii=n_reg+1:m
    if rem(ii,1000)==0
        ii
    end
    q=zeros(n_action,1);
    r=randn(3,1);
    rdot=randn(3,1)*0.1;
    alpha=rand(1,1)*2*pi;
    ang=rand(2,1)*2*pi/20-pi/20;
    rho=randn(2,1)*0.05;
    rhodot=randn(2,1)*0.01;
    state=[r;rdot;alpha;ang;rho;rhodot];
    for aa=1:n_action
        next_state=getSuccessor(ind2action(aa),state,timeStep)';
        q(aa)=reward_std(next_state)+gamma*theta'*feature_map_with_projection(next_state);
    end
    [y(ii),as]=max(q);
    if ii==1
        phi=feature_map_with_projection(state);
    else phi=[phi,feature_map_with_projection(state)];
    end
    %gradient descent
    %theta=theta-alpha*phi(:,ii)*(theta'*phi(:,ii)-y(ii));
    %full regression
    thetaold=theta;
    theta=regress(y(ii-n_reg:ii)',phi(:,ii-n_reg:ii)');
    change(ii)=norm(thetaold-theta)/norm(theta);
    nt(ii)=norm(theta);
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
state=[0,0,0,0,0,0,0,0,0,-0.05,0.1,0,0]';
states(1,:)=state;
for ii = 1:1000
    actionInd = getActionPhi(state, theta,timeStep,gamma);
    action=ind2action(actionInd);
    newState = getSuccessor(action, states(ii,:), timeStep)';
    states(ii+1,:) = newState;
    actions(ii,:) = action;
    %rewards(i) = reward;
    r = newState(10);
    s = newState(11); 
    if sqrt(r^2+s^2) > 2*sqrt(2)/2*L 
        ii
        break
    end
    state=newState;
end
figure()
subplot(2,2,1)
plot(states(:,10),states(:,11))
title('COM position')
axis equal
ax=gca;
ax.XAxisLocation = 'origin';
ax.YAxisLocation = 'origin';
xlabel('x (m)')
ylabel('y (m)')
subplot(2,2,2)
plot(states(:,1),states(:,2))
title('Drone xy position')
axis equal
ax=gca;
ax.XAxisLocation = 'origin';
ax.YAxisLocation = 'origin';
xlabel('x (m)')
ylabel('y (m)')
subplot(2,2,3)
plot(states(:,3))
title('z')
ylabel('z (m)')
xlabel('t (10^{-2}s)')
subplot(2,2,4)
plot(states(:,7)*180/pi)
hold
plot(states(:,8)*180/pi)
plot(states(:,9)*180/pi)
title('Euler angles (deg)')
ylabel('angle (deg)')
xlabel('t (10^{-2}s)')
legend('\alpha (z)','\beta (y)','\gamma (x)')