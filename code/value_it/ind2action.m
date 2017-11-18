function [U] = ind2action(action)
%Returns action vector from index <5^4
[ii,jj,kk,ll]=ind2sub([5,5,5,5],action);
om=[-5,-2.5,0,2.5,5];
acc=[0.5,1,1.5,2,2.5]*9.81;
U=[acc(ii);om(jj);om(kk);om(ll)];
end

