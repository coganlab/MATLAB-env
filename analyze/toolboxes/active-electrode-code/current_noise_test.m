
function [signal, meanVal, medianVal, dataf]  = current_noise_test(data, numRow, numCol, numChan, Fs, pathStr, filename, noise_low, noise_high)



 dataf = EEGbandstop(data, 59, 61, Fs);
 %dataf = EEGbandstop(dataf, 39, 41, Fs);
 dataf = EEGbandstop(dataf, 119, 121, Fs);
 dataf = EEGbandstop(dataf, 179, 181, Fs);
 dataf = EEGbandstop(dataf, 239, 241, Fs);
 dataf = EEGbandstop(dataf, 299, 301, Fs);
 dataf = EEGbandstop(dataf, 355, 362, Fs);
 dataf = EEGbandstop(dataf, 479, 481, Fs);
 dataf = EEGbandstop(dataf, 599, 601, Fs);
 

% dataf = data;

%dataf = EEGhighpass(dataf,2,Fs);

if strfind(filename, 'noise')
    disp('Filtering 2 to 150 Hz');
    dataf = EEGbandpass(dataf,2,150,Fs);
else
    disp('Filtering 2 to 150 Hz');
    dataf = EEGbandpass(dataf,2,150,Fs);
end

if strfind(filename, '5Hz')
    disp('Filtering for 5 Hz sine');
    dataf = EEGbandpass(dataf,2,10,Fs);
end

if strfind(filename, '40Hz')
    disp('Filtering for 40 Hz sine');
    dataf = EEGbandpass(dataf,35,45,Fs);
end

if strfind(filename, '100Hz')
    disp('Filtering for 100 Hz sine');
    dataf = EEGbandpass(dataf,95,105,Fs);
end




    %dataf = EEGbandpass(dataf,35,45,Fs);

%dataf = EEGbandpass(dataf,2,700,Fs);

% discard edge effects
dataf = dataf(:,round(3*Fs):end-round(3*Fs));

figure;
which_channel = 2;

disp(['  Noise on channel ' num2str(which_channel) ' (fC RMS) :' num2str(std(dataf(which_channel,:)) * 1e15)     ]);

nfft = 2^nextpow2(length(dataf(which_channel,:)));
Pxx = abs(fft(dataf(which_channel,:), nfft)).^2/length(dataf(which_channel,:))/Fs;
Hpsd = dspdata.psd(Pxx(1:length(Pxx)/2), 'Fs', Fs);
plot(Hpsd);


figure;
which_channel = 7;
disp(['  Noise on channel ' num2str(which_channel) ' (fC RMS) :' num2str(std(dataf(which_channel,:)) * 1e15)     ]);


nfft = 2^nextpow2(length(dataf(which_channel,:)));
Pxx = abs(fft(dataf(which_channel,:), nfft)).^2/length(dataf(which_channel,:))/Fs;
Hpsd = dspdata.psd(Pxx(1:length(Pxx)/2), 'Fs', Fs);
plot(Hpsd);


signalType = 'NOISE';
startSec = 0.001;
endSec = 0.001;
save_fig = 'TRUE';
%headstage_gain = 1e6 / ((1 / 2^20) * range * 1000);  % output in fC
%headstage_gain = 1e6 ;  % output in ppm
headstage_gain = 1;
BncChannel = 1;
gain_working_threshold = 0.1;


%[signal, meanVal, medianVal]  = calcSignal(data, 'NOISE', 1, 1, numRow, numCol, 1, Fs, 'TRUE', pathStr, filename, 1, 1, 1);
[signal, meanVal, medianVal]  = calcSignal(dataf, signalType, startSec, endSec, numRow, numCol, numChan, Fs, save_fig, pathStr, filename, headstage_gain, BncChannel, gain_working_threshold, noise_low, noise_high);
%[signal, meanVal, medianVal]  = calcSignal(data, 'SIGNAL', 10, 10, numRow, numCol, 1, Fs, 'TRUE', pathStr, filename, 10, 5, 0.1);

end
