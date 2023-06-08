function saveSessSelectivitySeries(SelSeries,CondParams,AnalParams,forceSave)

global MONKEYDIR

if nargin<4
  forceSave = 0; 
end

Session = SelSeries.Session;

sType = sessType(Session);

dirPath = [ MONKEYDIR '/mat/' sType '/selectivity' ];

if ~exist([dirPath],'dir');
    eval(['mkdir ' dirPath ]);
end

Params = [];
Params.CondParams = CondParams;
Params.AnalParams = AnalParams;

fNameRoot = ['Selectivity.Sess' num2str(SelSeries.Session{6}) ];

if isequal(sType,'SpikeSpike') | isequal(sType,'SpikeField') | isequal(sType,'FieldField') 
  fNameRoot = ['Selectivity.Sess' num2str(Session{6}(1)) '.Sess' num2str(Session{6}(2)) ];
end

[p,pMax] = getParamFileIndex([dirPath '/' fNameRoot],CondParams,AnalParams);
if p==0 || forceSave
    if p>0
        pMax = p-1;
        disp('--> ForceSave: Overwriting previous data file.');
    end
    eval(['save ' dirPath '/' fNameRoot '.d' num2str(pMax+1) '.mat SelSeries']);
    eval(['save ' dirPath '/' fNameRoot '.p' num2str(pMax+1) '.mat Params']);
    disp(['saved ' fNameRoot ]);
else
    disp('--> Data file already saved.');
end