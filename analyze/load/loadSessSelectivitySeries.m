function [ SelSeries, Params ] = loadSessSelectivitySeries(Session,CondParams,AnalParams);

%  [Tuning, Params] = loadSessSelectivitySeries(SESSION,CONDPARAMS,ANALPARAMS)
% 
%  Load most recent Selectivity data for specified Session.
%  If Cond/AnalParams are specified and a previous analysis using these
%  params is found, the appropriate Tuning data will be returned;
%  
%  SESSION = The session metadata
%  CONDPARAMS = Optional parameter
%  ANALPARAMS = Optional parameter

ProjectDir = sessMonkeyDir(Session);

sType = sessType(Session);

dirPath = [ ProjectDir '/mat/' sType '/selectivity' ];

notFoundMessage = '--> LoadSessSelectivitySeries: No files found.';

SelSeries = [];
Params = [];

if ~exist([dirPath],'dir');
  disp(notFoundMessage);
  return;
end
 
fNameRoot = ['Selectivity.Sess' num2str(Session{6}) ];

if isequal(sType,'SpikeSpike') | isequal(sType,'SpikeField') | isequal(sType,'FieldField') 
  fNameRoot = ['Selectivity.Sess' num2str(Session{6}(1)) '.Sess' num2str(Session{6}(2)) ];
end

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
