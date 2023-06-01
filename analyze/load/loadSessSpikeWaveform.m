function SpikeWaveform = loadSessSpikeWaveform(Session)
%
%  SpikeWaveform = loadSessSpikeWaveform(Session)
%
%  Loads saved file from saveSessSpikeWaveform

ProjectDir = sessMonkeyDir(Session)
SN = getSessionNumbers(Session);
Type = getSessionType(Session);

load([ProjectDir '/mat/' Type '/SpikeWaveform/SpikeWaveform.' num2str(SN) '.mat']);

