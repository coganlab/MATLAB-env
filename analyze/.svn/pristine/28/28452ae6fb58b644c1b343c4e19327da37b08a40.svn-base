function SpikeWaveformSNR = loadSessSpikeWaveformSNR(Session,CondParams,AnalParams)
%
%  SpikeWaveformSNR = loadSessSpikeWaveformSNR(Session,CondParams,AnalParams)
%
%  Loads saved file from saveSessSpikeWaveformSNR

ProjectDir = sessMonkeyDir(Session);

Params = [];
Params.CondParams = CondParams;
Params.AnalParams = AnalParams;

SN = getSessionNumbers(Session);
Type = getSessionType(Session);
dirPath = [ProjectDir '/mat/' Type '/SpikeWaveformSNR'];
fNameRoot = ['SpikeWaveformSNR.Sess' num2str(SN) ];
filename = [dirPath '/' fNameRoot];

[p,pMax] = getParamFileIndex(filename,Params.CondParams,Params.AnalParams);
if p>0
    disp(['loading ' filename ]);
    eval(['load ' filename '.d' num2str(p) '.mat']);
else
    disp('Data file not saved.');
end


