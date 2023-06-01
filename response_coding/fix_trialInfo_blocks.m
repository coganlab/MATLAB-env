function fix_trialInfo_blocks(trialInfo_fn, blocks)
% run this to rename the blocks and to remove extra, incomplete trials in a trialInfo file
% e.g. fix_trialInfo_blocks('trialInfo1.mat', [1 2]);
% this make a copy of the original trialInfo*.mat file and modify
% trialInfo1.mat to make the blocks be 1 and 2, and drop any block 3
% trials, for example.

load(trialInfo_fn);
b = 1; % index into blocks[]
curb = trialInfo{1}.block; % current block
tidx = length(trialInfo);
for t = 1:numel(trialInfo)
    if trialInfo{t}.block ~= curb % change in block detected, so +1 to b and update curb
        b = b + 1;
        curb = trialInfo{t}.block;
    end
    if b > length(blocks)
        tidx = t-1; % extra trials detected, early exit
        break;
    end
    trialInfo{t}.block = blocks(b);
    
end
trialInfo = trialInfo(1:tidx);
copyfile(trialInfo_fn, [trialInfo_fn '_orig']);
save(trialInfo_fn, 'trialInfo');
