function [handlocx handlocy eyelocx eyelocy] = getHandEyeLoc(Trials,Field,bn)

% Returns the average eye and hand locations for a time bin around a given alignment field
%   FIELD   =   String Alignment field
%                   Defaults to 'TargsAq'.
%   BN      =   Vector.  Analysis interval in ms
%                   Defaults to [5:50]
%

if nargin < 2
    Field = 'TargAq';
    bn = [5,50];
elseif nargin < 3
    bn = [5,50];
end

[E,H] = trialEyeHand(Trials,Field,bn,1,0);

handlocx = squeeze(H(:,1,:));
handlocx = mean(handlocx,2);

handlocy = squeeze(H(:,2,:));
handlocy = mean(handlocy,2);

eyelocx = squeeze(E(:,1,:));
eyelocx = mean(eyelocx,2);

eyelocy = squeeze(E(:,2,:));
eyelocy = mean(eyelocy,2);

return
