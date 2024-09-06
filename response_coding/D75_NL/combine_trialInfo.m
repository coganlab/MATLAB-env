% run this to combine trialInfo files into one

ti = {};
i = 1;
while 1
    tn = sprintf('trialInfo%d.mat', i);
    if exist(tn, 'file')
        load(tn);
        ti{i} = trialInfo;
        i = i + 1;
    else
        break;
    end
end

trialInfo = horzcat(ti{:});
save('trialInfo', 'trialInfo');

trialInfo_struct = cellfun(@(a) a, trialInfo);