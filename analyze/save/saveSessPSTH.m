function [PSTH] = saveSessPSTH(Sess,CondParams,forceSave)
%
%
%   saveSessPSTH(Sess,CondParams,forceSave)
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

smoothing = 50;
if nargin<3
  forceSave = 0; 
end

PSTH.Session = Sess;

Type = getSessionType(Sess);
if strcmp(Type,'Spike')
    dirPath = [MONKEYDIR '/mat/Spike/PSTH'];
else
    dirPath = [MONKEYDIR '/mat/Multiunit/PSTH'];
end

if ~exist(dirPath,'dir');
    eval(['mkdir ' dirPath]);
end

Params = [];
Params.CondParams = CondParams;
Params.AnalParams = [];

fNameRoot = ['PSTH.Sess' num2str(PSTH.Session{6}) ];

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
    bn(1) = CondParams.bn(1) - 3*smoothing;
    bn(2) = CondParams.bn(2) + 3*smoothing;
    %Rate = trialRate(Trials, Sys, Ch, contact, Cl, CondParams.Field, bn);
    Spike = trialSpike(Trials, Sys, Ch, contact, Cl, CondParams.Field, bn); 
    tPSTH = psth(Spike, bn, smoothing);
    PSTH.PSTH = tPSTH(3*smoothing+1:end-3*smoothing);

    eval(['save ' dirPath '/' fNameRoot '.d' num2str(pMax+1) '.mat PSTH']);
    eval(['save ' dirPath '/' fNameRoot '.p' num2str(pMax+1) '.mat Params']);
    disp(['saved ' fNameRoot ]);
else
    disp('--> Data file already saved.');
end
