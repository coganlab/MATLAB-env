function saveSessSpikeTuning(Tuning,CondParams,AnalParams,forceSave)

global MONKEYDIR

if nargin<4
  forceSave = 0; 
end

Session = Tuning.Session;

dirPath = [ MONKEYDIR '/mat/Spike/tuning' ];

Cl = Session{5};
if iscell(Cl)
    dirPath = [ MONKEYDIR '/mat/Multiunit/tuning' ];
    Cl = 1;
end

if ~exist([dirPath],'dir');
    eval(['mkdir ' dirPath ]);
end

Params = [];
Params.CondParams = CondParams;
Params.AnalParams = AnalParams;

fNameRoot = ['Tuning.Sess' num2str(Tuning.Session{6}) ];

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