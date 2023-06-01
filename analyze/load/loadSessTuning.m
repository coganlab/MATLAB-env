function [ Tuning, Params ] = loadSessTuning(Session,CondParams,AnalParams);

%  [Tuning, Params] = loadSessTuning(SESSION,CONDPARAMS,ANALPARAMS)
% 
%  Load most recent Tuning data for specified Session.
%  If Cond/AnalParams are specified and a previous analysis using these
%  params is found, the appropriate Tuning data will be returned;
%  
%  SESSION = The session metadata
%  CONDPARAMS = Optional parameter
%  ANALPARAMS = Optional parameter

ProjectDir = sessProjectDir(Session)

sType = sessType(Session);

dirPath = [ ProjectDir '/mat/' sType '/tuning' ];

notFoundMessage = '--> LoadSessTuning: No tuning files found.';

Tuning = [];
Params = [];

if ~exist([dirPath],'dir');
  disp(notFoundMessage);
  return;
end

fNameRoot = ['Tuning.Sess' num2str(Session{6}) ];

if nargin<2
  CondParams = [];
  AnalParams = [];
end

[p,pMax] = getParamFileIndex([dirPath '/' fNameRoot],CondParams,AnalParams);
if pMax>0
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
