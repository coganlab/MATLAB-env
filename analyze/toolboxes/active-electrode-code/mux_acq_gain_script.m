
which_channels = 33:2:55;
dataf = EEGbandpass(data(which_channels,round(10*Fs):end-round(10*Fs)),1,floor(Fs/2),Fs);

headstage_gain = 10;

%std(dataf,0,2) * 2 * sqrt(2) / headstage_gain

% report noise in uV RMS for sample 2,
Fs
noise_rms = (std(dataf,0,2) * 1000 * 1000) / headstage_gain
mean_noise = mean(noise_rms(2:end))