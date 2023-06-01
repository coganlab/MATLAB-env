function [w] = lrr_w(x)
% The function performs the linear regression referencing on ECoG data with
% multiple channels. 
% Reference
% Young, D., et al. "Signal processing methods for reducing artifacts in 
% microelectrode brain recordings caused by functional electrical stimulation."
% Journal of neural engineering 15.2 (2018): 026014.
% Created by Kumar Duraivel for Viventi and Cogan lab
% Input
% x(n x t) - Input signal with 'n' channels and 't' timepoints
% Output
% S(n x t) - Linear regression referenced signal % excluded in w version
% w(n x n-1) - Least square weights
% GBC edits 180910
n = size(x,1); % number of channels
c = 1:n;
%w=zeros(n,n);
% S=zeros(n,size(x,2));
    parfor i = 1:n %       
        R = x(i,:)'; % Reference channel
        X = (x(setdiff(c,i),:))'; % Channels to regress
        w(i,:) = ((X'*X)\(X'*R))'; % Least square weights estimation
     %   S(i,:) = R' - w(i,outIdx)*X'; % LRR referencing
     display(i)
    end


w2=zeros(n,n);
for i=1:n
      outIdx=setdiff(c,i);
      w2(i,outIdx)=w(i,:);
end
w=w2;
