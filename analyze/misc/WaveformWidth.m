function HalfWidth = WaveformWidth(Waveform)
%
%   HalfWidth = WaveformWidth(Waveform)
%   Returns halfwidth for each session
%   in units of Waveform sent in

Ndiv = 50;
nSess = size(Waveform,1);
[dum,~] = min(Waveform,[],2);
ndum = repmat(dum,[1,size(Waveform,2)]);
nWaveform = Waveform./ndum;
HalfWidth = zeros(1,nSess);
for iWave = 1:nSess
    tmpWaveform = interp(nWaveform(iWave,:),Ndiv);
    [~,I1] = min(abs(tmpWaveform(1:8*Ndiv)-0.5));
    [~,I2] = min(abs(tmpWaveform(8*Ndiv+1:end)-0.5));
    I2 = I2 + 8*Ndiv;
    HalfWidth(iWave) = (I2-I1)/Ndiv;
    if HalfWidth(iWave) < 0
        pause
    end
end
    


