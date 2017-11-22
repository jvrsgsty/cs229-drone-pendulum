function [r] = reward_std(state)

%Different versions of the reward, uncomment the one you want to work with

alpha = state(7);
beta = state(8);
gamma = state(9);
Rx= [1, 0, 0; 0, cos(gamma), -sin(gamma); 0, sin(gamma), cos(gamma)];
Ry = [cos(beta), 0, sin(beta);0, 1, 0; -sin(beta), 0, cos(beta)];
Rz = [cos(alpha), -sin(alpha), 0; sin(alpha), cos(alpha), 0; 0 0 1];
Ro = Rz*Ry*Rx;
state(7:9)=Ro*[0;0;1];

%% No pendulum, step function version
% K=0;
% r_temp=0;
% if norm(state(1:3))<=0.1
%     r_temp=r_temp+1;
% end
% if norm(state(4:6))<=0.1
%     r_temp=r_temp+1;
% end
% if norm(state(8:9))<=0.1
%     r_temp=r_temp+1;
% end
% r=r_temp;
%% Standard norm L2 version
%K=1;
%r=-norm(state(1:3))^2-1*norm(state(4:6))^2-K*norm(state(10:11))^2-K*norm(state(12:13))^2;

%% With pendulum, step function
r_temp=0;
K=3;
if norm(state(1:3))<=0.1
    r_temp=r_temp+1;
end
if norm(state(4:6))<=0.1
    r_temp=r_temp+1;
end
if norm(state(8:9))<=0.1
    r_temp=r_temp+1;
end
if norm(state(10:11))<=0.02
    r_temp=r_temp+1;
end
if norm(state(12:13))<=0.02
    r_temp=r_temp+1;
end
if abs(state(3))>=0.5
    r_temp=r_temp-3;
end
r=r_temp;

end

