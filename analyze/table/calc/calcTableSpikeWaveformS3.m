function Value = calcSpikeWaveformS3(Session,CondParams,AnalParams)
%
%  Value = calcSpikeWaveform(Session,CondParams,AnalParams)


global MONKEYDIR

SSess = splitSession(Session);
Sess = SSess{3};

Type = getSessionType(Sess);

dirPath = [MONKEYDIR '/mat/' Type '/SpikeWaveform'];
fNameRoot = ['SpikeWaveform.' num2str(Sess{6}) '.mat'];

if exist([dirPath '/' fNameRoot],'file');
    SpikeWaveform = loadSessSpikeWaveform(Sess);
else
    SpikeWaveform = saveSessSpikeWaveform(Sess);
end

%load up saved tuning information
Value = SpikeWaveform;


