function [spikeMap,startingSpikeMap] = getSemiChronicChannelSpikeMap(Sess,ch)
%
%  [spikeMap,startingSpikeMap] = getSemiChronicChannelSpikeMap(SESS,CH)
%
%  Returns a binary matrix indicating whether spikes were observed on each
%  channel at the END of the specified sessions. Optionally returns a
%  matrix named startingSpikeMap that indicates spike observations at the
%  BEGINNING of the specified sessions.
%  
%  If CHANNEL is specified, the spikeMap is returned for the relevant channel(s) only.

spikeMap = [];
startingSpikeMap = [];
for s=1:length(Sess)
  curDay = Sess{s}{1};
  eval(['Movement_' curDay]);
  startingSpikeMap = [ startingSpikeMap; startSP ];
  spikeMap = [ spikeMap; endSP ];
end

if exist('ch','var')
  startingSpikeMap = startingSpikeMap(:,ch);
  spikeMap = spikeMap(:,ch);
end
