function [FiringRate] = loadSessFiringRate(Session,CondParams)
%
%
%   loadSessFiringRate(Sess,CondParams1forceSave)
%
%   SESS    =   Cell array.  Session information
%   CONDPARAMS =   Data structure.  Parameter information 
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

Params = [];
Params.CondParams = CondParams;
Params.AnalParams = [];

Type = getSessionType(Session);
dirPath = [MONKEYDIR '/mat/' Type '/FiringRate'];
fNameRoot = ['FiringRate.Sess' num2str(Session{6}) ];
filename = [dirPath '/' fNameRoot];

[p,pMax] = getParamFileIndex(filename,Params.CondParams,Params.AnalParams);
if p>0
    disp(['loading ' filename ]);
    eval(['load ' filename '.d' num2str(p) '.mat']);
else
    disp('Data file not saved.');
end
