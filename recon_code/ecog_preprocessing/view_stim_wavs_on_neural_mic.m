load trigTimes_audioAligned.mat
h = edfread_fast(edf_filename);
load trialInfo; trialInfo = c2s(trialInfo);
load trigger;
load mic;
global TASKSTIM;

big_wav = zeros(1, length(trigger));
for t = 1:numel(trialInfo)
    [wav, Fs] = audioread(fullfile(TASKSTIM, taskstim, trialInfo(t).sound));
    wav = resample(wav, round(h.frequency(1)), Fs);
    wav = rescale(wav, -8000, 8000);
    big_wav(trigTimes_audioAligned(t):trigTimes_audioAligned(t)+length(wav)-1) = wav;
    
end

figure; plot(mic);hold on; plot(big_wav);gca_playsound(gca_fast, round(h.frequency(1)));
