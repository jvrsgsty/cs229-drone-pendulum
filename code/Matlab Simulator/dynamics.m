function [ dX ] = dynamics( t, X, U )

%State X
phi = X(1);
phi_dot = X(2);
theta = X(3);
theta_dot = X(4);
psi = X(5);
psi_dot = X(6);
z = X(7);
z_dot = X(8);
x = X(9);
x_dot = X(10);
y = X(11);
y_dot = X(12);

%Action U
U1 = U(1);
U2 = U(2);
U3 = U(3);
U4 = U(4);

%Parameters

g = 9.81;
m = 0.650; %mass
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
omegar = 475; %overall residual propeller angular speed, this is an ORDER OF MAGNITUDE
%The overall residual angular speed is taken as 475 rad/s. This angular speed is the
%speed produced by the rotor used in Parrot drone [19], specified under the topic “Technical
%Specifications”. from https://support.dce.felk.cvut.cz/mediawiki/images/5/5e/Dp_2017_gopalakrishnan_eswarmurthi.pdf

%Computed parameters

a1 = (Iyy - Izz)/Ixx; 
b1 = l/Ixx;
a2 = Jr/Ixx; 
b2 = l/Iyy;
a3 = (Izz - Ixx)/Iyy; 
b3 = 1/Izz;
a4 = Jr/Iyy;
a5 = (Ixx - Iyy)/Izz;

ux = (cos(phi)*sin(theta)*cos(psi) + sin(phi)*sin(psi));
uy = (cos(phi)*sin(theta)*sin(psi) - sin(phi)*cos(psi));

dX(1) = phi_dot;
dX(2) = theta_dot*psi_dot*a1 + theta_dot*a2*omegar + b1*U2;
dX(3) = theta_dot;
dX(4) = phi_dot*psi_dot*a3 - phi_dot*a4*omegar + b2*U3;
dX(5) = psi_dot;
dX(6) = theta_dot*phi_dot*a5 + b3*U4;
dX(7) = z_dot;
dX(8) = g - cos(phi)*cos(theta)*U1/m;
dX(9) = x_dot;
dX(10) = ux*U1/m;
dX(11) = y_dot;
dX(12) = uy*U1/m;

dX = dX';

end

