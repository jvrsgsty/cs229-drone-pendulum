function [phi] = feature_map_2(state)
%second order polynomial feature mapping
phi_temp=[1;state];
M=state*state';
for ii=1:size(state)
    phi_temp=[phi_temp;M(1:ii,ii)];
end
phi=phi_temp;
end

