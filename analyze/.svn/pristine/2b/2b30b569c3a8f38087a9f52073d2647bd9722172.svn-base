function SpecDiff = saveSessTestSpecDiff(Sess,CondParams1,CondParams2,AnalParams,forceSave)
%
%   saveSessTestSpecDiff(Sess,CondParams1,CondParams2,AnalParams,forceSave)
%
%   SESS    =   Cell array.  Session information
%   CONDPARAMS1 =   Data structure.  Parameter information for 1st condition
%   CONDPARAMS2 =   Data structure.  Parameter information for 2nd condition
%   ANALPARAMS  =   Data structure.  Analysis parameter information.
%
%   CondParams.Task    =   String/Cell.  Tasks to pool and compare.
%	    			To pool Task = {{'Task1','Task2'}};
%   CondParams.conds    =   Eye,Hand,Target conds {[],[],[]}
%   CondParams.Delay   =  Vector. Select trials according to delay interval (s).
%                    Delay = [DelayStart,DelayStop].
%   CondParams.Field   =   String.  Alignment field
%   CondParams.bn      =   Alignment time.
%
%   AnalParams.Tapers  =   [N,W].  Defaults to [.5,10]
%   AnalParams.fk      =   Vector.  Select frequency band to test in Hz.
%

global MONKEYDIR

if nargin<5
  forceSave = 0; 
end

SpecDiff.Session = Sess;

dirPath = [MONKEYDIR '/mat/Field/SpecDiff'];


if ~exist(dirPath,'dir');
    eval(['mkdir ' dirPath]);
end

Params = [];
Params.CondParams{1} = CondParams1;
Params.CondParams{2} = CondParams2;
Params.AnalParams = AnalParams;

fNameRoot = ['SpecDiff.Sess' num2str(SpecDiff.Session{6}) ];

[p,pMax] = getParamFileIndex([dirPath '/' fNameRoot],Params.CondParams,Params.AnalParams);
if p==0 || forceSave
    if p>0
        pMax = p-1;
        disp('--> ForceSave: Overwriting previous data file.');
    end
    % Now compute and save data
    [p,D,PD,S_X1,S_X2] = sessTestSpecDiff(Sess,CondParams1,CondParams2,AnalParams);
    SpecDiff.p = p;
    SpecDiff.D = D;
    SpecDiff.PD = PD;
    SpecDiff.S_X1 = S_X1;
    SpecDiff.S_X2 = S_X2;
    eval(['save ' dirPath '/' fNameRoot '.d' num2str(pMax+1) '.mat SpecDiff']);
    eval(['save ' dirPath '/' fNameRoot '.p' num2str(pMax+1) '.mat Params']);
    disp(['saved ' fNameRoot ]);
else
    disp('--> Data file already saved.');
end
