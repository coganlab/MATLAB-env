function [RateDiff] = saveSessRateDiff(Sess,CondParams,forceSave)
%
%
%   [RateDiff] = saveSessRateDiff(Sess,CondParams,forceSave)
%
%   SESS    =   Cell array.  Session information
%   CONDPARAMS =   Data structure with two cells.  Parameter information 
%   CondParams{1}.Task    =   String/Cell.  Tasks to pool and compare.
%	    			To pool Task = {{'Task1','Task2'}};
%   CondParams{1}.conds    =   Eye,Hand,Target conds {[],[],[]}
%   CondParams{1}.Delay   =  Vector. Select trials according to delay interval (s).
%                    Delay = [DelayStart,DelayStop].
%   CondParams{1}.Field   =   String.  Alignment field
%   CondParams{1}.bn      =   Alignment time.
%
%

ProjectDir = sessMonkeyDir(Session);

sType = sessType(Session);

if nargin<3
  forceSave = 0; 
end

RateDiff.Session = Sess;

dirPath = [ProjectDir '/mat/' sType '/RateDiff'];

if ~exist(dirPath,'dir');
    eval(['mkdir ' dirPath]);
end

Params = [];
Params.CondParams = CondParams;
Params.AnalParams = [];

fNameRoot = ['RateDiff.Sess' num2str(RateDiff.Session{6}) ];

[p,pMax] = getParamFileIndex([dirPath '/' fNameRoot],Params.CondParams,Params.AnalParams);
if p==0 || forceSave
    if p>0
        pMax = p-1;
        disp('--> ForceSave: Overwriting previous data file.');
    end
    % Now compute and save data
    
    [p,~,~,Rate1,Rate2]  = sessTestRateDiff(Sess,CondParams{1},CondParams{2});
    RateDiff.Rate1 = Rate1;
    RateDiff.Rate2 = Rate2;
    RateDiff.p = p;

    eval(['save ' dirPath '/' fNameRoot '.d' num2str(pMax+1) '.mat RateDiff']);
    eval(['save ' dirPath '/' fNameRoot '.p' num2str(pMax+1) '.mat Params']);
    disp(['saved ' fNameRoot ]);
else
    disp('--> Data file already saved.');
end
