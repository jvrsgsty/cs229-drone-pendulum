function phi = feature_map(state)
x = state(1);
y = state(2);
z= state(3);
x_dot = state(4);
y_dot = state(5);
z_dot = state(6);
alpha = state(7);
beta = state(8);
gamma = state(9);
r = state(10);
s = state(11);


phi = [1,x^2, y^2, z^2,...
    x_dot^2, y_dot^2, z_dot^2, ...
    beta^2, gamma^2]'; %, r, s, r^2, s^2]';
end