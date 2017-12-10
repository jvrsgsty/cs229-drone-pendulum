function [U] = ind2action(a)
%Returns state vector from index <5^4
[ii,kk,ll]=ind2sub([3,3,3],a);
om=[-0.05,0,0.05];
acc=[0,1,2]*9.81;
U=[acc(ii);om(kk);om(ll);0];
end

