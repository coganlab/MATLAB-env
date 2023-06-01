function H = getHandTargetLocation(Trials);
%
%  H = getHandTargetLocation(Trials)
%
%	Returns x,y position of hand target for each trial
%

H = reshape([Trials.HandTargetLocation],[2,length(Trials)])';

