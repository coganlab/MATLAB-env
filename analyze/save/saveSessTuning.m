function saveSessTuning(Tuning,CondParams,AnalParams,forceSave)

global MONKEYDIR

if nargin < 4
  forceSave = 0; 
end

Session = Tuning.Session;

Type = getSessionType(Session);

dirPath = [ MONKEYDIR '/mat/' Type '/tuning' ];

if ~exist(dirPath,'dir');
    eval(['mkdir ' dirPath ]);
end

Params = [];
Params.CondParams = CondParams;
Params.AnalParams = AnalParams;

SessionNumberString = getSessionNumberString(Session);
fNameRoot = ['Tuning.Sess' SessionNumberString];

[p,pMax] = getParamFileIndex([dirPath '/' fNameRoot],CondParams,AnalParams);
if p==0 || forceSave
    if p>0
        pMax = p-1;
        disp('--> ForceSave: Overwriting previous data file.');
    end
    eval(['save ' dirPath '/' fNameRoot '.d' num2str(pMax+1) '.mat Tuning']);
    eval(['save ' dirPath '/' fNameRoot '.p' num2str(pMax+1) '.mat Params']);
    disp(['saved ' fNameRoot ]);
else
    disp('--> Data file already saved.');
end