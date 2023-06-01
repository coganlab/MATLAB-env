function [pc,fet] = onSpikepcs(sp)
%
%  [pc,fet] = onSpikepcs(sp)
%

[pc,scorestmp,latenttmp] = ...
    princomp(sp(1:min([2e3,end]),:));
if nargout == 2 fet = sp*pc; end
% fet = fet';