function PtoT = WaveformPeaktoTrough(Waveform)
%
%   PtoT = WaveformPeaktoTrough(Waveform)
%   Returns peak-to-trough for each session
%   in units of Waveform sent in

Ndiv = 100;
nSess = size(Waveform,1);

for iWave = 1:nSess
    Wave = Waveform(iWave,:);
    tmpWave = interp(Wave,Ndiv);
    [dum,peak] = min(tmpWave);    
    [dum,trough] = max(tmpWave(peak:end));
    trough = trough + peak - 1;
    PtoT(iWave) = (trough-peak)/Ndiv;   
    if PtoT(iWave) < 0
        pause
    end
end


