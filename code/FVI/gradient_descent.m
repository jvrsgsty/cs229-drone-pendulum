function theta = gradient_descent(states, y)
m = size(states,2);
X = zeros(m,9);
for i = 1:m
    X(i,:) = feature_map(states(:,i))';
end

theta = inv(X'*X)*X'*y';
end