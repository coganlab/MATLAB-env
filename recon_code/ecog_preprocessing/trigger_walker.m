% This function attempts to find peaks in the trigger.mat where it expects
% to see a trigger. It expects a peak based on the seeded trial, and
% extrapolation based on a time column in trialInfo. It picks a small
% window of time (variable window_to_find), and looks for a threshold
% crossing. It uses this new point an anchor to find the next peak. It can
% account of drift between neural and trialInfo output.
%    startT is a timepoint (in samples) of a peak you know
%    startT_trial is the trialnumber of that same peak
%    times_sec is the expected trialpeaks, in arbitrary time units (seconds).
% for example, times_sec can be the cueStart or audioalignedtrigger
% timecolumn in the trialInfo.
%    times_sec = [trialInfo.cueStart];
%    trials_to_extrap is which trials you wish to find. Sometimes you may have
% already found trial peaks reliably using another method, and maybe you
% only need to extract trial 140, for example, while keeping the rest
% intact.
%    frequency is sample rate of your trigger.mat
% trigger is simply trigger.mat, the neural channel in the edf with the
% peaks.
%    thresh is where the code will look for peaks
%    trials_to_force_estimate sometimes this code will still incorrectly identify peaks, and you can
% feed a list of trials that will force an extrapolation or interpolation,
% rather than finding it with a threshold.

function t_peaks = trigger_walker(t_peaks, startT, startT_trial, times_sec, trials_to_extrap, frequency, trigger, thresh, trials_to_force_estimate)

window_to_find = .25;

if isempty(t_peaks)
    t_peaks = zeros(length(times_sec), 1);
end


startT_idx = find(startT_trial == trials_to_extrap);
trials_sublistL = trials_to_extrap(1:startT_idx);
trials_sublistL = fliplr(trials_sublistL);
trials_sublistR = trials_to_extrap(startT_idx:end);

t_peaks(startT_trial) = startT;
try
small_walk(trials_sublistL);
small_walk(trials_sublistR);
catch ME
    disp(ME.message);
    return;
end


function small_walk(trials_to_extrap_part)
    estimates_in_a_row = 0;
    if ~isempty(trials_to_extrap_part)
        for t = 1:length(trials_to_extrap_part)-1
            disp(trials_to_extrap_part(t+1));
            estimate = (times_sec(trials_to_extrap_part(t+1)) - times_sec(trials_to_extrap_part(t)))*frequency + t_peaks(trials_to_extrap_part(t));
            trigger_segment = trigger;
            to_mask_segment = [1:(estimate-window_to_find*frequency) (estimate+window_to_find*frequency):length(trigger)];
            trigger_segment(floor(to_mask_segment)) = 0;
            idx = find(trigger_segment > thresh, 1, 'first');
            if isempty(idx) || ismember(trials_to_extrap_part(t+1), trials_to_force_estimate)
                idx = estimate;
                if ~ismember(trials_to_extrap_part(t+1), trials_to_force_estimate)
                    estimates_in_a_row = estimates_in_a_row + 1;
                end
                if estimates_in_a_row  > Inf
                    return;
                end
                fprintf('estimate %d\n', trials_to_extrap_part(t+1));
            end
            t_peaks(trials_to_extrap_part(t+1)) = idx;
        end
    end
end

end