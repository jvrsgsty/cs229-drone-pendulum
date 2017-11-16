clear
close all
%% Quadrotor simulator for CS 229 Final Project 
% Dynamic model from “Design and control of quadrotors with application to
%autonomous flying”,  S. Bouabdallah

%Parameters
g = 9.81;
m = 0.650;
Ixx = 7.5e-3;
Iyy = 7.5e-3;
Izz = 1.3e-2;
b = 3.13e-5; %thrust coefficient 
d = 7.5e-7; %drag coefficient 
Rrad = 0.15; %propeller radius
c = 0.04; %propeller chord
theta0 = 0.26; %pitch of incidence 
thetatw = 0.045; %twist pitch 
Jr = 6e-5; %rotor inertia
l = 0.23; %arm length 
omegar = 475; % ORDER OF MAGNITUDE because not given in paper, represents the overall residual propeller angular speed

%%Dynamic model of quadrotor ALONE

% %State X
% X = [phi, phi_dot, theta, theta_dot, psi, psi_dot, z, z_dot, x, x_dot, y, y_dot]';
% 
% %Xdot = f(X,U)
% f = [phi_dot, theta_dot*psi_dot*a1 + theta_dot*a2*omegar + b1*U2, 
%     theta_dot, phi_dot*psi_dot*a3 - phi_dot*a4*omegar + b2*U3,
%     psi_dot, theta_dot*phi_dot*a5 + b3*U4,
%     z_dot, g - cos(phi)*cos(theta)*U1/m,
%     x_dot, ux*U1/m,
%     ydot, uy*U1/m]';

% %Action U
% U1 = b*(omega1^2 + omega2^2 + omega3^2 + omega4^2);
% U2 = b*(-omega2^2 + omega4^2);
% U3 = b*(omega1^2 - omega3^2);
% U4 = d*(-omega1^2 + omega2^2 - omega3^2 + omega4^2);
%omegai represents the angular velocity of the ith propeller

tspan=[0 5];
%Initial condition
X0 = [0, 0, 0, 0, 0, 0, -3, 0, 1, 0, 2, 0]';
U0 = [1000, 100, 100, 0]'; %U0(1) represents translation

[t, X] = ode45(@(t,X) dynamics(t,X,U0), tspan, X0);


%% Plotting 
close all

figure(1)
title('Positions')
plot(t,X(:,9))
hold on
plot(t,X(:,11))
plot(t,-X(:,7)) %z in quadrotor frame is pointing downwards
legend('x','y','z')
xlabel('t')
ylabel('position (m)')

figure(2)
title('Velocities')
plot(t,X(:,10))
hold on
plot(t,X(:,12))
plot(t,-X(:,8)) %z in quadrotor frame is pointing downwards
legend('x dot','y dot','z dot')
xlabel('t')
ylabel('velocities (m/s)')

figure(3)
title('Angles')
plot(t,X(:,1))
hold on
plot(t,X(:,3))
plot(t,-X(:,5))
legend('\phi','\theta','\psi')
xlabel('t')
ylabel('angles (rad)')

figure(4)
title('Angular rates')
plot(t,X(:,2))
hold on
plot(t,X(:,4))
plot(t,-X(:,6))
legend('\phi dot','\theta dot','\psi dot')
xlabel('t')
ylabel('angular rates (rad/s)')