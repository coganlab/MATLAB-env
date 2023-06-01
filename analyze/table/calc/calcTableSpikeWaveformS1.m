function Value = calcSpikeWaveformS1(Session,CondParams,AnalParams)
%
%  Value = calcSpikeWaveform(Session,CondParams,AnalParams)


global MONKEYDIR

SSess = splitSession(Session);
Sess = SSess{1};

Type = getSessionType(Sess);

dirPath = [MONKEYDIR '/mat/' Type '/SpikeWaveform'];
fNameRoot = ['SpikeWaveform.Sess' num2str(Sess{6}) ];

[p,pMax] = getParamFileIndex([dirPath '/' fNameRoot],CondParams,[]);

if p > 0
    SpikeWaveform = loadSessSpikeWaveform_pd(Sess,CondParams);
else
    SpikeWaveform = saveSessSpikeWaveform_pd(Sess,CondParams);
end

%load up saved tuning information
Value = SpikeWaveform.mWaveform;


