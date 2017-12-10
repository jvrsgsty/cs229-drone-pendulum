function [U] = ind2action_acc(a)
%Returns state vector from index <5^4
[ii,kk,ll]=ind2sub([4,4,4],a);
acc_h=[-2,-1,1,2];
acc_v=[0.5,0.75,1.25, 1.5]*9.81;
U=[acc_h(ii);acc_h(kk);acc_v(ll)];
end
