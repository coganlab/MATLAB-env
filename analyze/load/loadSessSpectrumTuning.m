function [ SpectrumTuningData, Params ] = loadSessSpectrumTuning(Session,CondParams,AnalParams);

%  [SpectrumTuningData, Params] = loadSessSpectrumTuning(SESSION,CONDPARAMS,ANALPARAMS)
% 
%  Load most recent SpectrumTuningData for specified Session.
%  If Cond/AnalParams are specified and a previous analysis using these
%  params is found, the appropriate Tuning data will be returned;
%  
%  SESSION = The session metadata
%  CONDPARAMS = Optional parameter
%  ANALPARAMS = Optional parameter

ProjectDir = sessMonkeyDir(Session);

doCoherence = 0;
sessType = getSessionType(Session);
switch sessType
    case {'Field','Multiunit','Spike'}
      dirPath = [ ProjectDir '/mat/' sessType '/tuning' ];
end

SpectrumTuningData = [];
Params = [];

notFoundMessage = '--> LoadSessSpectrumTuning: No spectrum tuning files found.';

if ~exist([dirPath],'dir');
  disp(notFoundMessage);
  return;
end

if ~doCoherence
  fNameRoot = [ 'SpectrumTuning.Sess' num2str(Session{6}(1)) ];
else
  fNameRoot = [ 'SpectrumTuning.Sess' num2str(Session{6}(1)) '.Sess' num2str(Session{6}(2)) ];
end

if nargin<=2
  CondParams = [];
  AnalParams = [];
end

[p,pMax] = getParamFileIndex([dirPath '/' fNameRoot],CondParams,AnalParams);
if pMax>0 & (p>0 | nargin<=2)
  if p==0
    p = pMax; % Return last used Params.
    if nargin>1
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

