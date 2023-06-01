function Session = SFforS(SFSession,SSessNum)
%
%   SFforS returns the SpikeField Session for a SpikeSession Number
%

SN=sessNumber(SFSession);
ind = find(SN(:,1)==SSessNum);

if ~isempty(ind)
    Session = SFSession(ind);
else
    disp(['No SF Sessions for Spike Session ' num2str(SSessNum)]);
    Session = [];
end