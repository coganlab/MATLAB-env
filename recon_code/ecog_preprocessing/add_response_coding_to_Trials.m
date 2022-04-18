load(fullfile(taskdate, 'mat', 'trialInfo.mat'));
load(fullfile(taskdate, 'mat', 'Trials.mat'));
global TASKSTIM;
[allblocks, Fs] = audioread('allblocks.wav');
cue_events = scantext('cue_events.txt', '\t', 0, '%f%f%s');
cue_onsets = floor(cue_events{1} * Fs);
response_events = scantext('response_coding.txt', '\t', 0, '%f%f%s');
response_durs = response_events{2}-response_events{1};
response_onsets = floor(response_events{1} * Fs);

big_wav = zeros(length(allblocks), 1);
all_stim_onsets = [];
for r = 1:numel(response_onsets)
    % find the event in cue_events that just come before the response
    idx = find((cue_onsets - response_onsets(r)) < 0, 1, 'last');
    stim_fn = trialInfo{idx}.sound;
    [stim_aud, sFs] = audioread(fullfile(TASKSTIM, taskstim, stim_fn));
    stim_aud = resample(stim_aud, Fs, sFs);
    range_idx_begin = floor(cue_onsets(idx)-1*Fs);
    range_idx_end = floor(cue_onsets(idx)+2*Fs);
    part_all_blocks = allblocks(range_idx_begin:range_idx_end);
    [x,lags] = xcorr(part_all_blocks, stim_aud);
    [~,lag_idx] = max(abs(x));
    offset = lags(lag_idx);
    stim_onset = range_idx_begin + offset;
    big_wav(stim_onset:stim_onset+length(stim_aud)-1,1) = stim_aud;
    all_stim_onsets = [all_stim_onsets; stim_onset];
    if 0
        f = figure;plot(part_all_blocks);hold on;plot([zeros(offset, 1); stim_aud]);gca_fast;
        pause();
        close(f);
    end
    
    Trials(idx).ResponseOnset = Trials(idx).Auditory + (response_onsets(r)-stim_onset) * 30000 / Fs;
    Trials(idx).ResponseOffset = Trials(idx).ResponseOnset + response_durs(r) * 30000;
end

figure;plot(allblocks);hold on; plot(big_wav);gca_fast;plottrigtimes(all_stim_onsets, 0);gca_nav(all_stim_onsets);

save('Trials.mat', 'Trials');