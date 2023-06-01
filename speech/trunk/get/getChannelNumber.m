function ChannelNumber = getChannelNumber(ChannelName);
%
%  ChannelNumber = getChannelNumber(ChannelName)
%
%
%  Inputs:
%    ChannelName = String or cell array of strings.  Names of channels
%
%  Outputs:
%    ChanneNumber = Scalar or array of scalars.  Indices in experiment global
%

global experiment

channels = experiment.channels;

a = cell(1,length(channels));
[a{1:length(a)}] = deal(channels.name);
[dum, ChannelNumber] = intersect(a,ChannelName);

if iscell(ChannelName)
  if length(ChannelNumber)~=length(ChannelName)
    error('ChannelName does not match experiment variable');
  end
elseif ischar(ChannelName)
  if isempty(ChannelNumber)
    error('ChannelName does not match experiment variable');
  end 
end
