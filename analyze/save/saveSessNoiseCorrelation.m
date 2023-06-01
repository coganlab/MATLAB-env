function saveSessNoiseCorrelation(NoiseCorr,CondParams,AnalParams,forceSave);

global MONKEYDIR

if nargin<4
  forceSave = 0; 
end

dirPath = [ MONKEYDIR '/mat/SpikeSpike/noisecorr'];

if ~exist([dirPath],'dir');
  eval(['mkdir ' dirPath ]);
end

Params = [];
Params.CondParams = CondParams;
Params.AnalParams = AnalParams;

fNameRoot = ['NoiseCorr.Sess' num2str(NoiseCorr.Session1{6}) '.Sess' num2str(NoiseCorr.Session2{6}) ];

[p,pMax] = getParamFileIndex([dirPath '/' fNameRoot],CondParams,AnalParams);
if p==0 | forceSave
  if p>0
    pMax = p-1;
    disp('--> ForceSave: Overwriting previous data file.');
  end
  eval(['save ' dirPath '/' fNameRoot '.d' num2str(pMax+1) '.mat NoiseCorr']);
  eval(['save ' dirPath '/' fNameRoot '.p' num2str(pMax+1) '.mat Params']);
  disp(['saved ' fNameRoot ]);
else
  disp('--> Data file already saved.'); 
end