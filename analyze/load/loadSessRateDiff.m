function [RateDiff, Params] = loadSessRateDiff(Session,CondParams,AnalParams)
%
%
%   loadSessRateDiff(Sess,CondParams,forceSave)
%
%   SESS    =   Cell array.  Session information
%   CONDPARAMS =   Data structure.  Parameter information 
%

ProjectDir = sessMonkeyDir(Session);

sType = sessType(Session);

dirPath = [ ProjectDir '/mat/' sType '/RateDiff' ];

notFoundMessage = '--> LoadSessRateDiff: No files found.';

RateDiff = [];
Params = [];

if ~exist([dirPath],'dir');
  disp(notFoundMessage);
  return;
end
 
fNameRoot = ['RateDiff.Sess' num2str(Session{6}) ];

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