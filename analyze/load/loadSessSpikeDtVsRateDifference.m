function [ DtVsRateDiff, Params ] = loadSessSpikeDtVsRateDifference(Session1,Session2,CondParams,AnalParams);

%  [DtVsRateDiff, Params] = loadSessSpikeDtVsRateDifference(SESSION,CONDPARAMS,ANALPARAMS)
% 
%  Load most recent DtVsRateDiff data for specified Session.
%  If Cond/AnalParams are specified and a previous analysis using these
%  params is found, the appropriate data will be returned;
%  
%  SESSION = The session metadata
%  CONDPARAMS = Optional parameter
%  ANALPARAMS = Optional parameter

global MONKEYDIR

dirPath = [ MONKEYDIR '/mat/Spike/dtvsrate'];

DtVsRateDiff = [];
Params = [];

notFoundMessage = '--> LoadSessSpikeDtVsRateDifference: No DtVsRateDiff files found.';

if ~exist([dirPath],'dir');
  disp(notFoundMessage);
  return;
end

fNameRoot = ['DtVsRateDiff.Sess' num2str(Session1{6}) '-Sess' num2str(Session2{6}) ];

if nargin<=2
  CondParams = [];
  AnalParams = [];
end

[p,pMax] = getParamFileIndex([dirPath '/' fNameRoot],CondParams,AnalParams);
if pMax>0 & (p>0 | nargin<=2)
  if p==0
    p = pMax; % Return last used Params.
    if nargin>2
      disp(notFoundMessage); % return null only if Cond/AnalParams specified
      return;
    end
  end
  eval(['load ' dirPath '/' fNameRoot '.d' num2str(p) '.mat']);
  eval(['load ' dirPath '/' fNameRoot '.p' num2str(p) '.mat']);
else
  disp(notFoundMessage);
  return;
end

