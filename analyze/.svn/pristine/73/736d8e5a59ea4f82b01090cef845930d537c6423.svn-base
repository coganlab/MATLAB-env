function SpikeWaveformSNR = saveSessSpikeWaveformSNR(Sess, CondParams, AnalParams, forcesave)
%
%  saveSessSpikeWaveformSNR(Session, CondParams, AnalParams)
%
%  Saves a mat/Spike/SpikeWaveformSNR/SpikeWaveformSNR.SessNum.mat file
%  based on saveSessPSTH(Session)

global MONKEYDIR

if nargin<4
  forceSave = 0; 
end

SpikeWaveformSNR.Session = Sess;

Type = getSessionType(Sess);
dirPath = [MONKEYDIR '/mat/' Type '/SpikeWaveformSNR'];

if ~exist(dirPath,'dir');
    eval(['mkdir ' dirPath]);
end

SN = getSessionNumbers(Sess);

Params.CondParams = CondParams;
Params.AnalParams = AnalParams;

fNameRoot = ['SpikeWaveformSNR.Sess' num2str(SN) ];

[p,pMax] = getParamFileIndex([dirPath '/' fNameRoot],Params.CondParams,Params.AnalParams);
if p==0 || forceSave
    if p>0
        pMax = p-1;
        disp('--> ForceSave: Overwriting previous data file.');
    end
    %Now compute and save data
    
    [SNR, mWaveform, sd, Waveforms] = sessSpikeWaveformSNR(Sess, CondParams, AnalParams);
    
    SpikeWaveformSNR.SNR = SNR;
    SpikeWaveformSNR.mWaveform = mWaveform;
    SpikeWaveformSNR.sd = sd;
    SpikeWaveformSNR.Waveforms = Waveforms;
    SpikeWaveformSNR.Params = Params;
        
    eval(['save ' dirPath '/' fNameRoot '.d' num2str(pMax+1) '.mat SpikeWaveformSNR']);
    eval(['save ' dirPath '/' fNameRoot '.p' num2str(pMax+1) '.mat Params']);
    disp(['saved ' fNameRoot ]);
else
    disp('--> Data file already saved.');
end
