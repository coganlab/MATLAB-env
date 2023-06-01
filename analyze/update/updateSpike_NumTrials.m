function updateSpike_NumTrials(SessNum)
%
%   updateSpike_NumTrials(SessNum)
%
%   Adds NumTrials data structure to Spike_Database Session file
%
%   Modified to accept sessnum list

if nargin == 0
  updateType_NumTrials('Spike');
else
  updateType_NumTrials('Spike',SessNum);
end
