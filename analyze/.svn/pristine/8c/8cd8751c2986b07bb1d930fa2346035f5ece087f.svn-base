function [ Spectrum, Params ] = loadSessSpec(Session,CondParams,AnalParams)

%  [SpectrumData, Params] = loadSessSpec(SESSION,CONDPARAMS,ANALPARAMS)
% 
%  Load most recent SpectrumData for specified Session.
%  If Cond/AnalParams are specified and a previous analysis using these
%  params is found, the appropriate Tuning data will be returned;
%  
%  SESSION = The session metadata
%  CONDPARAMS = Optional parameter
%  ANALPARAMS = Optional parameter

ProjectDir = sessMonkeyDir(Session);

sessType = getSessionType(Session);
      dirPath = [ ProjectDir '/mat/' sessType '/Spec' ];

SpectrumData = [];
Params = [];

notFoundMessage = '--> LoadSessSpectrum: No spectrum files found.';

if ~exist([dirPath],'dir');
  disp(notFoundMessage);
  return;
end

fNameRoot = ['Spec.Sess' num2str(Session{6}(1))];

if nargin<=2
  CondParams = [];
  AnalParams = [];
end

[p,pMax] = getParamFileIndex([dirPath '/' fNameRoot],CondParams,AnalParams);
if pMax>0 && (p>0 || nargin<=2)
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

