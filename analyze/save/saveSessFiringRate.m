function [FiringRate] = saveSessFiringRate(Sess,CondParams,forceSave)
%
%
%   saveSessFiringRate(Sess,CondParams,forceSave)
%
%   SESS    =   Cell array.  Session information
%   CONDPARAMS =   Data structure.  Parameter information 
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

if nargin<3
  forceSave = 0; 
end

FiringRate.Session = Sess;

Type = getSessionType(Sess);
if strcmp(Type,'Spike')
    dirPath = [MONKEYDIR '/mat/Spike/FiringRate'];
else
    dirPath = [MONKEYDIR '/mat/Multiunit/FiringRate'];
end

if ~exist(dirPath,'dir');
    eval(['mkdir ' dirPath]);
end

Params = [];
Params.CondParams = CondParams;
Params.AnalParams = [];

fNameRoot = ['FiringRate.Sess' num2str(FiringRate.Session{6}) ];

[p,pMax] = getParamFileIndex([dirPath '/' fNameRoot],Params.CondParams,Params.AnalParams);
if p==0 || forceSave
    if p>0
        pMax = p-1;
        disp('--> ForceSave: Overwriting previous data file.');
    end
    % Now compute and save data
    
    All_Trials = sessTrials(Sess);
    Trials = Params2Trials(All_Trials,CondParams);
    if iscell(Trials); Trials = Trials{1}; end
    
    Sys = sessTower(Sess); 
    Sys = Sys{1};
    if iscell(Sys); Sys = Sys{1}; end
    Ch = sessElectrode(Sess);
    Cl = sessCellDepthInfo(Sess);
    contact = sessContact(Sess);
    if iscell(contact); contact = contact{1}; end
    Rate = trialRate(Trials, Sys, Ch, contact, Cl, CondParams.Field, CondParams.bn);
    FiringRate.Rate = mean(Rate * diff(CondParams.bn) / 1e3);
    FiringRate.AllRates = Rate * diff(CondParams.bn) / 1e3;
    
    eval(['save ' dirPath '/' fNameRoot '.d' num2str(pMax+1) '.mat FiringRate']);
    eval(['save ' dirPath '/' fNameRoot '.p' num2str(pMax+1) '.mat Params']);
    disp(['saved ' fNameRoot ]);
else
    disp('--> Data file already saved.');
end
