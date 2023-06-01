function SpikeWaveform = saveSessSpikeWaveform_pd(Sess,CondParams)
%
%  saveSessSpikeWaveform_pd(Sess,CondParams)
%
%   SESS    =   Cell array.  Session information
%   CONDPARAMS =   Data structure.  Parameter information 
%   CondParams.bn  =   minimum and maximum fractions across which to comute mean and sd.

global MONKEYDIR

if nargin<3
  forceSave = 0; 
end

SpikeWaveform.Session = Sess;

Type = getSessionType(Sess);
dirPath = [MONKEYDIR '/mat/' Type '/SpikeWaveform'];

if ~exist(dirPath,'dir');
    eval(['mkdir ' dirPath]);
end

SN = getSessionNumbers(Sess);

Params.CondParams = CondParams;
Params.AnalParams = [];

fNameRoot = ['SpikeWaveform.Sess' num2str(SN) ];

[p,pMax] = getParamFileIndex([dirPath '/' fNameRoot],Params.CondParams,Params.AnalParams);
if p==0 || forceSave
    if p>0
        pMax = p-1;
        disp('--> ForceSave: Overwriting previous data file.');
    end
    %Now compute and save data
    
    [Waveform,mWave,sdWave] = sessSpikeWaveform(Sess, CondParams);

    SpikeWaveform.Waveform = Waveform;
    SpikeWaveform.mWaveform = mWave;
    SpikeWaveform.sdWaveform = sdWave;
    SpikeWaveformSNR.Params = Params;
        
    eval(['save ' dirPath '/' fNameRoot '.d' num2str(pMax+1) '.mat SpikeWaveform']);
    eval(['save ' dirPath '/' fNameRoot '.p' num2str(pMax+1) '.mat Params']);
    disp(['saved ' fNameRoot ]);
else
    disp('--> Data file already saved.');
end

