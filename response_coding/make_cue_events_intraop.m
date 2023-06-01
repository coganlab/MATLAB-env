load trialInfo.mat
load block_wav_onsets.mat

if iscell(trialInfo)
    trialInfo = cellfun(@(a) a, trialInfo);
end

rc = scantext('first_stims.txt', '\t', 0, '%f %f %s');
first_stims_onset = rc{1};
% fid = fopen('go_events.txt', 'w');
fid2 = fopen('cue_events.txt', 'w');
b = 0;
for t = 1:numel(trialInfo)
    if trialInfo(t).block ~= b
        b = b + 1;
        anchor = trialInfo(t).stimAudioStart;
    end
%     on = trialInfo(t).goStart - anchor + first_stims_onset(b);
%     off = on + trialInfo(t).goEnd - trialInfo(t).goStart;
% %     off = on + 2;
%     fwrite(fid, sprintf('%f\t%f\t%d_%s\n', on, off, t, trialInfo(t).sound));
    
    %on = trialInfo(t).cueStart - anchor + first_stims_onset(b);
    on = trialInfo(t).stimAudioStart - anchor + first_stims_onset(b) ;
    off = on + .5;
    fwrite(fid2, sprintf('%f\t%f\t%d_%s\n', on, off, t, trialInfo(t).sound));
end
% fclose(fid);
fclose(fid2);