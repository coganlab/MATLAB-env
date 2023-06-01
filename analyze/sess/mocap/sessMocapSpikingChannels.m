function [SpikingChannels, NumSpiking] = sessMocapSpikingChannels(Session, Tower);
%
%  [SpikingChannels, NumSpiking] = sessMocapSpikingChannels(Session, Tower);
%
%  Returns the information on whether spiking is present or absent on each channel
%  following electrode movement in Movement Log file. (MONKEYDIR/m/depth)

if ~iscell(Session{1})
  Session = {Session};
end

if ~iscell(Tower)
  Tower = {Tower};
end

nSess = length(Session);
for iSess = 1:nSess
  day = sessDay(Session{iSess});
  SpikingChannels_tmp = [];
  for iTower = 1:length(Tower)
    eval(['Movement_' Tower{iTower} '_' day]);
    SpikingChannels_tmp = [SpikingChannels_tmp endSP];
  end
  SpikingChannels(iSess,:) = SpikingChannels_tmp;
  NumSpiking(iSess) = sum(SpikingChannels_tmp);
end

