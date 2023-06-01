
load trialInfo.mat
load block_wav_onsets.mat

offset = 0.0234; % seconds
is_picture_naming = 1;

if iscell(trialInfo)
    trialInfo = cellfun(@(a) a, trialInfo);
end

rc = scantext('first_stims.txt', '\t', 0, '%f %f %s');
first_stims_onset = rc{1};
%first_stims_onset(1)=first_stims_onset(1)+5;
% fid = fopen('go_events.txt', 'w');
fid2 = fopen('cue_events.txt', 'w');
b = 0;
for t = 1:numel(trialInfo)
    
    %     on = trialInfo(t).goStart - anchor + first_stims_onset(b);
    %     off = on + trialInfo(t).goEnd - trialInfo(t).goStart;
    % %     off = on + 2;
    %     fwrite(fid, sprintf('%f\t%f\t%d_%s\n', on, off, t, trialInfo(t).sound));
    
    % on = trialInfo(t).cueStart - anchor + first_stims_onset(b);
    if is_picture_naming == 1
        if trialInfo(t).block ~= b
            b = b + 1;
            first = NaN;
            tr=t;
            while isnan(first)
                if endsWith(trialInfo(tr).stim,'.wav')
                    first = trialInfo(tr).stimuliAlignedTrigger;
                else
                    tr = tr+1;
                end
            end
            diffs = first - first_stims_onset(b);
            first_stims_onset(b) = (trialInfo(t).stimuliAlignedTrigger - diffs);
            anchor = (trialInfo(t).stimuliAlignedTrigger - diffs);
        end
        on1 = (trialInfo(t).stimuliAlignedTrigger - diffs);
        durr = (trialInfo(t).stimuliEnd - trialInfo(t).stimuliAlignedTrigger);
    else
        if isfield(trialInfo,'audiostart')
            on1 = trialInfo(t).audiostart+offset; %Start;
        elseif isfield(trialInfo,'audioStart')
            on1 = trialInfo(t).audioStart+offset; %Start;
        elseif isfield(trialInfo,'stimulusAudioStart')
            on1 = trialInfo(t).stimulusAudioStart+offset; %Start;
        elseif isfield(trialInfo,'cueStart')
            on1 = trialInfo(t).cueStart+offset;
        end
    
        if trialInfo(t).block ~= b
            b = b + 1;
            %  anchor = trialInfo(t).cueStart;
            anchor = on1;
        end
        durr = .5;
    end
    % on = trialInfo(t).audioStart - anchor + first_stims_onset(b);
    on = on1 - anchor + first_stims_onset(b);
    off = on + durr;
   
    if isfield(trialInfo,'sound')
        stimstr = 'sound';
    elseif isfield(trialInfo,'stim')
        stimstr = 'stim';
    else
        error("trialInfo fieldnames do not include 'stim or 'sound' fields")
    end
    fwrite(fid2, sprintf('%f\t%f\t%d_%s\n', on, off, t, trialInfo(t).(stimstr)));
end
% fclose(fid);
fclose(fid2);

% tfactor = [];
% diffs = [];
% if is_picture_naming == 1
%     blocklen = numel(trialInfo)/(length(first_stims_onset));
%     for block = 1:length(first_stims_onset)
%         first = NaN;
%         last = NaN;
%         t=1+blocklen*(block-1);
%         while isnan(first)
%             if endsWith(trialInfo(t).stim,'.wav')
%                 first = trialInfo(t).stimuliAlignedTrigger;
% %             elseif strcmp(trialInfo(t).condition,'ListenSpeak')
% %                 first = trialInfo(t).goStart + 0.25;
%             else
%                 t = t+1;
%             end
%         end
% %         t = blocklen*block;
% %         while isnan(last)
% %             if endsWith(trialInfo(t).stim,'.wav')
% %                 last = trialInfo(t).stimuliAlignedTrigger;
% % %             elseif strcmp(trialInfo(t).condition,'ListenSpeak')
% % %                 last = trialInfo(t).goStart + 0.25;
% %             else
% %                 t = t-1;
% %             end
% %         end
%         diffs(block) = first - first_stims_onset(block);
% %         tfactor(block) = (first_stims_onset(ind+1)-first_stims_onset(ind))/(last-first);
%         first_stims_onset(block) = (trialInfo(1+blocklen*(block-1)).stimuliAlignedTrigger - diffs(block));
%     end
% end