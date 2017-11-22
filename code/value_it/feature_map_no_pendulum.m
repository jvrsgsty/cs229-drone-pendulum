function [phi] = feature_map_with_projection(state)
%second order polynomial feature mapping with projection
%no pendulum and no first order terms
alpha = state(7);
beta = state(8);
gamma = state(9);
Rx= [1, 0, 0; 0, cos(gamma), -sin(gamma); 0, sin(gamma), cos(gamma)];
Ry = [cos(beta), 0, sin(beta);0, 1, 0; -sin(beta), 0, cos(beta)];
Rz = [cos(alpha), -sin(alpha), 0; sin(alpha), cos(alpha), 0; 0 0 1];
Ro = Rz*Ry*Rx;
state(7:9)=Ro*[0;0;1];
state=state(1:9);

% x = state(1);
% y = state(2);
% z = state(3);
% x_dot = state(4);
% y_dot = state(5);
% z_dot = state(6);
% u1 = state(7);
% u2 = state(8);
% u3 = state(9);
% a = state(10);
% b = state(11);
% a_dot = state(12);
% b_dot = state(13);

%phi=[1,z^2,x_dot^2,y_dot^2,z_dot^2,u1*a,u2*b,u3*z,a^2,b^2,a_dot^2,b_dot^2]';

phi_temp=[1];
M=state*state';
for ii=1:size(state)
    phi_temp=[phi_temp;M(1:ii,ii)/10];
end
phi=phi_temp;
end

