function Mag = WaveformMag(Waveform)
%
%   Mag = WaveformMag(Waveform) 
%   Returns min from each Waveform

[Mag] = min(Waveform,[],2);


