close all
clear all

load test_11_demux.mat
Fs = 50000 / (18 * 3);
data = EEGbandpass(data,1,30,Fs);
%data = EEGbandstop(data, 55, 65, Fs);


start_corr = 10000;
stop_corr = 100000;

numRow = 18;


% Scale EEG channel
% eeg channel
eeg_chan = 23;
eeg_gain = 2000;
eeg = data((eeg_chan-1)*numRow+1:eeg_chan*numRow,:);
eeg = mean(eeg,1) / (eeg_gain*2);




for i=1:size(data,1)
    % invert to match eeg channel negative up?
    corr_val(i) = corr(eeg(start_corr: stop_corr)',data(i, start_corr: stop_corr)');
end

[y, idx] = sort(corr_val(1:360));

str = '';

for j = 1:360     % channel labels start with 1, like matlab
    ch_num = idx(j);
    str = strvcat(str, ['Ch' num2str(ceil(ch_num/numRow)) 'R' num2str(ch_num - (ceil(ch_num/numRow)-1) * numRow)]);
end

num_good_ch = 5;

% highest corr val
 % invert to match eeg channel negative up?
%best_ch  = [data(idx(360-num_good_ch+1:end),:); -eeg];

% lowest corr val
best_ch  = [data(idx(1:num_good_ch),:); eeg];


spacer = 3e-4;
spacer = 0:spacer:spacer*(num_good_ch);
spacer = repmat(spacer',1,size(best_ch,2));

best_ch = best_ch + spacer;


x = 0:1/Fs:(size(best_ch,2)-1)/Fs;

plot(x,best_ch');


