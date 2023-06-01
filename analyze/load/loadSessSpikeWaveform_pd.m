function SpikeWaveform = loadSessSpikeWaveform_pd(Session,CondParams)
%
%  SpikeWaveform = loadSessSpikeWaveform_pd(Session)
%
%  Loads saved file from saveSessSpikeWaveform_pd

global MONKEYDIR

Params = [];
Params.CondParams = CondParams;
Params.AnalParams = [];

SN = getSessionNumbers(Session);
Type = getSessionType(Session);
dirPath = [MONKEYDIR '/mat/' Type '/SpikeWaveform'];
fNameRoot = ['SpikeWaveform.Sess' num2str(SN) ];
filename = [dirPath '/' fNameRoot];

[p,pMax] = getParamFileIndex(filename,Params.CondParams,Params.AnalParams);
if p>0
    disp(['loading ' filename ]);
    eval(['load ' filename '.d' num2str(p) '.mat']);
else
    disp('Data file not saved.');
end