clear
close all
%% Quadrotor simulator for CS 229 Final Project 
% "A Flying Inverted Pendulum" by Markus Hehn and Raffaello D’Andrea
% http://www.flyingmachinearena.org/wp-content/uploads/2012/fma-publications/hehn_dandrea_flying_inverted_pendulum.pdf


%%COUPLED dynamic model of quadrotor and inverted pendulum 

% %State X
% X = [x, y, z, x_dot, y_dot, z_dot, alpha, beta, gamma, r, s, rdot, sdot]';

tspan=[0 2];
%Initial condition
X0 = [1, 1, 10, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0]';
U0 = [5, 5, 5, 0]'; %U0(1) represents acceleration, U0(2), U0(3), U0(4) the rotations in the body frame (rad/s)

[t, X] = ode45(@(t,X) coupled_dynamics(t,X,U0), tspan, X0);


%% Plotting 
close all

figure(1)
title('Positions')
plot(t,X(:,1))
hold on
plot(t,X(:,2))
plot(t,X(:,3)) 
legend('x','y','z')
xlabel('t')
ylabel('position (m)')

figure(2)
title('Velocities')
plot(t,X(:,4))
hold on
plot(t,X(:,5))
plot(t,X(:,6)) 
legend('x dot','y dot','z dot')
xlabel('t')
ylabel('velocities (m/s)')

figure(3)
title('Angles')
plot(t,X(:,7))
hold on
plot(t,X(:,8))
plot(t,X(:,9))
legend('\alpha','\beta','\phi')
xlabel('t')
ylabel('angles (rad)')

