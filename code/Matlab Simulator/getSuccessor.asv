function newState = getSuccessor(action, state, timeStep)
x = state(1);
y = state(2);
z = state(3);
x_dot = state(4);
y_dot = state(5);
z_dot = state(6);
alpha = state(7);
beta = state(8);
gamma = state(9);
r = state(10);
s = state(11);
r_dot = state(12);
s_dot = state(13);

%Parameters
g = 9.81;
L = 0.6; %ARBITRARY L denotes the length from the base of the pendulum to its center of mass
ksi = sqrt(L^2- r^2 - s^2);

%Control inputs (= Actions)
a = action(1); %mass-normalized collective thrust 
wx = action(2); %desired rotational rates about the vehicle body axes
wy = action(3);
wz = action(4);

%Rotation matrices
Rx= [1, 0, 0; 0, cos(gamma), -sin(gamma); 0, sin(gamma), cos(gamma)];
Ry = [cos(beta), 0, sin(beta);0, 1, 0; -sin(beta), 0, cos(beta)];
Rz = [cos(alpha), -sin(alpha), 0; sin(alpha), cos(alpha), 0; 0 0 1];
Ro = Rz*Ry*Rx;

R_eulerToOmega = [cos(beta)*cos(gamma), -sin(gamma), 0;
                  cos(beta)*sin(gamma), cos(gamma), 0;
                  -sin(beta), 0, 1];
              
acceleration = Ro*[0, 0, a]' + [0, 0, -g]'; 
angular_rates = inv(R_eulerToOmega)*[wx, wy, wz]';

%Decoupling the equations on r_dotdot and s_dotdot

%r_dotdot = A*s_dotdot + B
A = (1/((L^2-s^2)*ksi^2))*( r^3*s + r*(-L^2*s + s^3) );
B = (1/((L^2-s^2)*ksi^2))*( -r^4*acceleration(1) - (L^2-s^2)^2*acceleration(1) - 2*r^2*( s*s_dot*r_dot + ...
(-L^2+s^2)*acceleration(1)) + r^3*( s_dot^2 - ksi*(g+acceleration(3)) ) + r*( s^2*(r_dot^2-ksi*(g+acceleration(3))) + ...
L^2*(-r_dot^2-s_dot^2+ksi*(g+acceleration(3)))));

%s_dotdot = C*r_dotdot + D
C = (1/((L^2-r^2)*ksi^2))*( s^3*r + s*(-L^2*r + r^3) );
D = (1/((L^2-r^2)*ksi^2))*(  -s^4*acceleration(2) - (L^2-r^2)^2*acceleration(2) - 2*s^2*( r*s_dot*r_dot + ...
(-L^2+r^2)*acceleration(2) ) + s^3*( r_dot^2 - ksi*(g+acceleration(3)) ) + s*( r^2*(s_dot^2-ksi*(g+acceleration(3))) + ...
L^2*(-r_dot^2-s_dot^2+ksi*(g+acceleration(3))) ) );

x = x + timeStep*x_dot;
y = y+timeStep*y_dot;
z = z+timeStep*z_dot;

x_dot = x_dot + timeStep*acceleration(1);
y_dot = y_dot + timeStep*acceleration(2);
z_dot = z_dot + timeStep*acceleration(3);

alpha = alpha + timeStep*angular_rates(3);
beta = beta + timeStep*angular_rates(2);
gamma = gamma + timeStep*angular_rates(1);

r = r + timeStep*r_dot;
s = s + timeStep*s_dot;

r_dot = r_dot + timeStep*(A*D+B)/(1-A*C);
s_dot = s_dot + timeStep*(C*B+D)/(1-A*C);

newState = [x,y,z,x_dot,y_dot,z_dot,alpha,beta,gamma,r,s,r_dot,s_dot];

end