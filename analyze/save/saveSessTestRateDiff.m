function [RateDiff] = saveSessTestRateDiff(Sess,CondParams1,CondParams2,forceSave)
%
%
%   saveSessTestRateDiff(Sess,CondParams1,CondParams2,forceSave)
%
%   SESS    =   Cell array.  Session information
%   CONDPARAMS1 =   Data structure.  Parameter information for 1st condition
%   CONDPARAMS2 =   Data structure.  Parameter information for 2nd condition
%
%   CondParams.Task    =   String/Cell.  Tasks to pool and compare.
%	    			To pool Task = {{'Task1','Task2'}};
%   CondParams.conds    =   Eye,Hand,Target conds {[],[],[]}
%   CondParams.condstype = 'Choice'  - looks at eye/hand movement
%   not Target
%   CondParams.Delay   =  Vector. Select trials according to delay interval (s).
%                    Delay = [DelayStart,DelayStop].
%   CondParams.Field   =   String.  Alignment field
%   CondParams.bn      =   Alignment time.
%
%

global MONKEYDIR

if nargin<4
  forceSave = 0; 
end

RateDiff.Session = Sess;

Type = getSessionType(Sess);
if strcmp(Type,'Spike')
    dirPath = [MONKEYDIR '/mat/Spike/RateDiff'];
else
    dirPath = [MONKEYDIR '/mat/Multiunit/RateDiff'];
end

if ~exist(dirPath,'dir');
    eval(['mkdir ' dirPath]);
end

Params = [];
Params.CondParams{1} = CondParams1;
Params.CondParams{2} = CondParams2;
Params.AnalParams = [];

fNameRoot = ['RateDiff.Sess' num2str(RateDiff.Session{6}) ];

[p,pMax] = getParamFileIndex([dirPath '/' fNameRoot],Params.CondParams,Params.AnalParams);
if p==0 || forceSave
    if p>0
        pMax = p-1;
        disp('--> ForceSave: Overwriting previous data file.');
    end
    % Now compute and save data
    [p,D,PD,Rate1,Rate2] = sessTestRateDiff(Sess,CondParams1,CondParams2);
    RateDiff.p = p;
    RateDiff.D = D;
    RateDiff.PD = PD;
    RateDiff.Rate1 = Rate1;
    RateDiff.Rate2 = Rate2;
    eval(['save ' dirPath '/' fNameRoot '.d' num2str(pMax+1) '.mat RateDiff']);
    eval(['save ' dirPath '/' fNameRoot '.p' num2str(pMax+1) '.mat Params']);
    disp(['saved ' fNameRoot ]);
else
    disp('--> Data file already saved.');
end
