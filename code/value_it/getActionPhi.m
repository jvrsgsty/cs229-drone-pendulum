function actionInd = getActionPhi(state,theta,timeStep,gamma)
%Get best action based on value estimation V=theta'*phi(s)
%make sure to have the correct feature map function
for aa=1:5^4
    next_state=getSuccessor(ind2action(aa),state,timeStep)';
    Q(aa)=reward_std(next_state)+gamma*theta'*feature_map_with_projection(next_state);
end
[V,actionInd]=max(Q);
end

