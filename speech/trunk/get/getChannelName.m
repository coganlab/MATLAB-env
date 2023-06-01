function ChannelName = getChannelName(ChannelNumber);
%
%  ChannelName = getChannelName(ChannelNumber)
%
%
%  Inputs:
%    ChannelNumber = Scalar or array of scalars.  Indices in experiment global
%
%  Outputs:
%    ChannelName = String or cell array of strings.  Names of channels
%

global experiment

channels = experiment.channels;

ChannelName = channels(ChannelNumber).name;
