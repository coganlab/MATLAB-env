function [fet,pc,eigvalues] = spikepcs(sp,pcold)
%
%  [fet,pc,eigvalues] = spikepcs(sp,pcold)
%
%   Assumes first index of sp is time
    
[pc,scorestmp,latenttmp] = ...
    princomp(sp(1:min([2e3,end]),2:end));
if nargin ==1
    if pc(6,1)<0; pc(:,1) = -pc(:,1); end
    if pc(6,2)<0; pc(:,2) = -pc(:,2); end
    if pc(6,3)<0; pc(:,3) = -pc(:,3); end
elseif nargin ==2
    if pc(:,1)'*pcold(:,1)<0; pc(:,1) = -pc(:,1); end
    if pc(:,2)'*pcold(:,2)<0; pc(:,2) = -pc(:,2); end
    if pc(:,3)'*pcold(:,3)<0; pc(:,3) = -pc(:,3); end
end

eigvalues=latenttmp;
spk = sp(:,2:end);
fet = spk*pc;
% fet = fet';