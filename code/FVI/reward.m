function rew = reward(state)
x = state(1);
y = state(2);
z = state(3);
r = state(10);
s = state(11);
rew = 0;
if abs(x) > 5 || abs(y) > 5 || abs(z) > 1 || abs(r) > 0.3 || abs(s) > 0.3
    rew = -1;
end
end