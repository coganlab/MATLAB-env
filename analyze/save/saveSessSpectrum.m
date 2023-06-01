function saveSessSpectrum(SpectrumData,CondParams,AnalParams,forceSave);

global MONKEYDIR

if nargin<4
  forceSave = 0; 
end

Session = SpectrumData.Session;

doCoherence = 0;
sessType = getSessionType(Session);
switch sessType
    case {'Field','Multiunit','Spike'}
        dirPath = [ MONKEYDIR '/mat/' sessType '/power' ];
    case {'FieldField','SpikeField','SpikeSpike','MultiunitField','MultiunitMultiunit'}
        doCoherence = 1;
        dirPath = [ MONKEYDIR '/mat/' sessType '/coherence' ];
end

if ~exist([dirPath],'dir');
    eval(['mkdir ' dirPath ]);
end

Params = [];
Params.CondParams = CondParams;
Params.AnalParams = AnalParams;

if ~doCoherence
    fNameRoot = [ 'Spectrum.Sess' num2str(Session{6}(1)) ];
else
    fNameRoot = [ 'Spectrum.Sess' num2str(Session{6}(1)) '.Sess' num2str(Session{6}(2)) ];
end

[p,pMax] = getParamFileIndex([dirPath '/' fNameRoot],CondParams,AnalParams);
if p==0 || forceSave
    if p>0
        pMax = p-1;
        disp('--> ForceSave: Overwriting previous data file.');
    end
    eval(['save ' dirPath '/' fNameRoot '.d' num2str(pMax+1) '.mat SpectrumData']);
    eval(['save ' dirPath '/' fNameRoot '.p' num2str(pMax+1) '.mat Params']);
    disp(['saved ' fNameRoot ]);
else
    disp('--> Data file already saved.');
end


