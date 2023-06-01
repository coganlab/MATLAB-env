function SpikeWaveform = saveSessSpikeWaveform(Session)
%
%  saveSessSpikeWaveform(Session)
%
%  Saves a mat/Spike/SpikeWaveform/SpikeWaveform.SessNum.mat file
%  based on sessSpikeWaveform(Session)

global MONKEYDIR

Data = sessSpikeWaveform(Session);
Type = getSessionType(Session);

mD = mean(Data);
[dum,peakind] = min(mD);

[dum,peakinds] = sort(Data(:,peakind),'descend');

SpikeWaveform = mean(Data(peakinds(1:peakinds(1:min(300,end))),:));

SN = getSessionNumbers(Session);

if ~exist([MONKEYDIR '/mat/' Type '/SpikeWaveform'])
    mkdir([MONKEYDIR '/mat/' Type '/SpikeWaveform']);
end

save([MONKEYDIR '/mat/' Type '/SpikeWaveform/SpikeWaveform.' num2str(SN) '.mat'],'SpikeWaveform');

