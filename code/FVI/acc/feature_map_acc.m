function phi = feature_map_acc(state)
  x = state(1);
  y = state(2);
  z = state(3);
  x_dot = state(4);
  y_dot = state(5);
  z_dot = state(6);
  r = state(7);
  s = state(8);
  r_dot = state(9);
  s_dot = state(10);
  phi = [ 1,x^2, y^2, z^2, x*x_dot, y*y_dot, z*z_dot,...
          x_dot^2, y_dot^2, z_dot^2, ...
          r^2, s^2, r*r_dot, s*s_dot,...
          r_dot^2, s_dot^2]';
end