function [LFP_noartifact, ind]=Lfp_artifact_remov(LFP)

maxLfp = max(abs(LFP),[],2);
ind = find(maxLfp < 2*median(maxLfp));
LFP_noartifact = LFP(ind,:);
return
