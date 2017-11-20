function [r] = reward_std(state)
%reward=-||r||-||r_dot||-K||rho||-K||rho_dot||
%where r is the drone position -reference altitude and rho is the r,s vector
K=100;
r=-norm(state(7:9))-norm(state(1:3)-[0;0;20])-K*norm(state(10:11))-K*norm(state(12:13));
%-norm(state(7:9))-norm(state(1:3)-[0;0;20])-norm(state(4:6))
end

