function Value = calcWaveformSNRS1(Session,CondParams,AnalParams)
%
%  Value = calcWaveformSNR(Session,CondParams,AnalParams)

global MONKEYDIR

SSess = splitSession(Session);
Sess = SSess{1};

Type = getSessionType(Sess);

dirPath = [MONKEYDIR '/mat/' Type '/SpikeWaveformSNR'];
fNameRoot = ['SpikeWaveformSNR.Sess' num2str(Sess{6}) ];

[p,pMax] = getParamFileIndex([dirPath '/' fNameRoot],CondParams,AnalParams);

if p > 0 
    SpikeWaveformSNR = loadSessSpikeWaveformSNR(Sess,CondParams,AnalParams);
else
    SpikeWaveformSNR = saveSessSpikeWaveformSNR(Sess,CondParams,AnalParams);
end

%load up saved SNR information
Value = SpikeWaveformSNR.SNR;


