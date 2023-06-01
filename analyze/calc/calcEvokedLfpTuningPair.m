function z = calcEvokedLfpTuningPair(Trials, Sys, Ch, Dir);
%
%  z = calcEvokedLfpTuningPair(Sess, Dir);
%
%  z = z-score for Tuning in preferred direction
%

Mlfp = []; 
for i = 1:2
  ind = find([Trials.Target]==Dir(i)); N(i) = length(ind);
  Mlfp_tmp = trialMlfp(Trials(ind),Sys,Ch,'TargsOn',[0,300]);
  sd(i) = std(mean(Mlfp_tmp)); 
  Mlfp = [Mlfp; Mlfp_tmp]; 
end
sdCR = (sd(1)-sd(2))./(sd(1)+sd(2));
NTrial = size(Mlfp,1);
for iPerm = 1:1e3
  ind = randperm(NTrial); 
  sd_Perm(iPerm,1) = std(sum(Mlfp(ind(1:floor(NTrial./2)),:))./floor(NTrial./2));
  sd_Perm(iPerm,2) = std(sum(Mlfp(ind(ceil(NTrial./2):end),:))./(NTrial-floor(NTrial./2)));
end
sdCR_Null = (sd_Perm(:,1)-sd_Perm(:,2))./(sd_Perm(:,1)+sd_Perm(:,2));
z = sdCR./std(sdCR_Null);

