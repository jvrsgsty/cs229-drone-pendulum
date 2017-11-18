function [ dX ] = coupled_dynamics( t, X, U )

%State X
x = X(1);
y = X(2);
z = X(3);
x_dot = X(4);
y_dot = X(5);
z_dot = X(6);
alpha = X(7);
beta = X(8);
gamma = X(9);
r = X(10); %translational position of the pendulum center of mass relative to its base (along x)
s = X(11); %translational position of the pendulum center of mass relative to its base (along y)
r_dot = X(12);
s_dot = X(13);

%Control inputs (= Actions)
a = U(1); %mass-normalized collective thrust 
wx = U(2); %desired rotational rates about the vehicle body axes
wy = U(3);
wz = U(4);

%Parameters
g = 9.81;
L = 0.6; %ARBITRARY L denotes the length from the base of the pendulum to its center of mass
ksi = sqrt(L^2- r^2 - s^2);

%Rotation matrices
Rx= [1, 0, 0; 0, cos(gamma), -sin(gamma); 0, sin(gamma), cos(gamma)];
Ry = [cos(beta), 0, sin(beta);0, 1, 0; -sin(beta), 0, cos(beta)];
Rz = [cos(alpha), -sin(alpha), 0; sin(alpha), cos(alpha), 0; 0 0 1];
Ro = Rz*Ry*Rx;

R_eulerToOmega = [cos(beta)*cos(gamma), -sin(gamma), 0;
                  cos(beta)*sin(gamma), cos(gamma), 0;
                  -sin(beta), 0, 1];

dX(1) = x_dot;
dX(2) = y_dot;
dX(3) = z_dot;

acceleration = Ro*[0, 0, a]' + [0, 0, -g]'; 
dX(4) = acceleration(1);
dX(5) = acceleration(2);
dX(6)= acceleration(3);

angular_rates = inv(R_eulerToOmega)*[wx, wy, wz]';
dX(7) = angular_rates(1);
dX(8) = angular_rates(2);
dX(9) = angular_rates(3);


dX(10) = r_dot;
dX(11) = s_dot;


%Decoupling the equations on r_dotdot and s_dotdot

%r_dotdot = A*s_dotdot + B
A = (1/((L^2-s^2)*ksi^2))*( r^3*s + r*(-L^2*s + s^3) );
B = (1/((L^2-s^2)*ksi^2))*( -r^4*dX(4) - (L^2-s^2)^2*dX(4) - 2*r^2*( s*s_dot*r_dot + ...
(-L^2+s^2)*dX(4) ) + r^3*( s_dot^2 - ksi*(g+dX(6)) ) + r*( s^2*(r_dot^2-ksi*(g+dX(6))) + ...
L^2*(-r_dot^2-s_dot^2+ksi*(g+dX(6))) ) );

%s_dotdot = C*r_dotdot + D
C = (1/((L^2-r^2)*ksi^2))*( s^3*r + s*(-L^2*r + r^3) );
D = (1/((L^2-r^2)*ksi^2))*(  -s^4*dX(5) - (L^2-r^2)^2*dX(5) - 2*s^2*( r*s_dot*r_dot + ...
(-L^2+r^2)*dX(5) ) + s^3*( r_dot^2 - ksi*(g+dX(6)) ) + s*( r^2*(s_dot^2-ksi*(g+dX(6))) + ...
L^2*(-r_dot^2-s_dot^2+ksi*(g+dX(6))) ) );

%Solve the system of equations and decouple r_dotdot from s_dotdot
dX(12) = (A*D+B)/(1-A*C);
dX(13) = (C*B+D)/(1-A*C);

dX = dX';


end

