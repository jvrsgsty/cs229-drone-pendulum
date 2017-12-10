function theta = gradient_descent_acc(states, y)
m = size(states,2);
X = zeros(m,11);
for i = 1:m
    X(i,:) = feature_map_acc(states(:,i))';
end

theta = inv(X'*X)*X'*y';
end