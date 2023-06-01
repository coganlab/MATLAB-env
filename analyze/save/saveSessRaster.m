function saveSessRaster(Raster,CondParams,AnalParams,forceSave);

global MONKEYDIR

if nargin<4
  forceSave = 0; 
end

Session = Raster.Session;

dirPath = [ MONKEYDIR '/mat/Spike/raster'];

Cl = Session{5};
if iscell(Cl)
  dirPath = [ MONKEYDIR '/mat/Multiunit/raster' ];
  Cl = 1;
end

if ~exist([dirPath],'dir');
  eval(['mkdir ' dirPath ]);
end

Params = [];
Params.CondParams = CondParams;
Params.AnalParams = AnalParams;

fNameRoot = ['Raster.Sess' num2str(Raster.Session{6}) ];

[p,pMax] = getParamFileIndex([dirPath '/' fNameRoot],CondParams,AnalParams);
if p==0 | forceSave
  if p>0
    pMax = p-1;
    disp('--> ForceSave: Overwriting previous data file.');
  end
  eval(['save ' dirPath '/' fNameRoot '.d' num2str(pMax+1) '.mat Raster']);
  eval(['save ' dirPath '/' fNameRoot '.p' num2str(pMax+1) '.mat Params']);
  disp(['saved ' fNameRoot ]);
else
  disp('--> Data file already saved.'); 
end


