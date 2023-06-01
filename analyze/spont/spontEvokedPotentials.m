function stimTrig = spontEvokedPotentials(fields, stimSignal, stim, bn, thresh, Fs, N)

%output: stimTrig (channels x time x trials)

if stim
    %get trigger signal from stimSignal
    onIdx = find(stimSignal(1:end-1) < thresh & stimSignal(2:end)>thresh);
else
    %randomly pick time-points for triggering. 
    x = randperm(size(fields,2));
    
    onIdx = x(1:N);
end

stimTrig = zeros(size(fields,1), diff(bn)*Fs/1000+1, length(onIdx));

rmvTr = false(length(onIdx),1);
for iStim = 1:length(onIdx)
    %fprintf('iStim: %d/%d\n', [iStim length(onIdx)])
    stimTime = onIdx(iStim);

    if stimTime+bn(1)*Fs/1000 > 0 && stimTime+bn(2)*Fs/1000 <= length(fields)
        stimTrig(:, :, iStim) = fields(:, stimTime+bn(1)*Fs/1000:stimTime+bn(2)*Fs/1000);
    else
        rmvTr(iStim) = true;
    end
end

stimTrig = stimTrig(:,:,~rmvTr);
%sum(rmvTr)


