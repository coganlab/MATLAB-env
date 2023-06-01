function [SpecDiff] = loadSessTestSpecDiff(Session,CondParams1,CondParams2,AnalParams)
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

ProjectDir = sessMonkeyDir(Session);

Params = [];
Params.CondParams{1} = CondParams1;
Params.CondParams{2} = CondParams2;
Params.AnalParams = AnalParams;

Type = getSessionType(Session);
dirPath = [ProjectDir '/mat/' Type '/SpecDiff'];
fNameRoot = ['SpecDiff.Sess' num2str(Session{6}) ];
filename = [dirPath '/' fNameRoot];

[p,pMax] = getParamFileIndex(filename,Params.CondParams,Params.AnalParams);
if p>0
    disp(['loading ' filename ]);
    eval(['load ' filename '.d' num2str(p) '.mat']);
else
    disp('Data file not saved.');
end
