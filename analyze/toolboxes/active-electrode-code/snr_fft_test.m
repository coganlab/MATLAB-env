snr = zeros(size(dataf,1),1);

for i = 1:size(dataf,1)

y = dataf(i,:);
L = length(y);

NFFT = 2^nextpow2(L); % Next power of 2 from length of y
Y = fft(y,NFFT)/L;
f = Fs/2*linspace(0,1,NFFT/2+1);

% Plot single-sided amplitude spectrum.
plot(f,2*abs(Y(1:NFFT/2+1))) 
title('Single-Sided Amplitude Spectrum of y(t)')
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')

signal = 2*abs(Y(1:NFFT/2+1));

start_F = 9; % hz
stop_F = 11; % hz
start_idx = find((f > start_F),1,'first');
stop_idx = find((f > stop_F),1,'first');
power_signal = sum(signal(start_idx:stop_idx));

% % clear signal
% signal(start_idx:stop_idx) = 0;
% power_noise = mean(signal);
% snr = power_signal / power_noise;

% power 60 hz
start_F = 59; % hz
stop_F = 61; % hz
start_idx = find((f > start_F),1,'first');
stop_idx = find((f > stop_F),1,'first');
power_60hz = sum(signal(start_idx:stop_idx));

snr(i) = power_signal / power_60hz;

end

% plot SNR
plot(20*log10(snr))
