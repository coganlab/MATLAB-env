function [avgcvr] = lfpspikebin(spec, cvr, width_ms)

nbins = size(spec,2);

for i = 1:nbins
    start_ts = i-1*(floor(width_ms/2));
    end_ts   = i*(floor(width_ms/2));
    
    for iCvr = 1:length(cvr)
        idx = find(cvr{iCvr}(:,1) >= start_ts & cvr{iCvr}(:,1) < end_ts);
        avgcvr(i,iCvr) = mean(cvr{iCvr}(idx,2));
    end
end
