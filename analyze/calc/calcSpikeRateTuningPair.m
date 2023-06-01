function z = calcSpikeRateTuningPair(Trials, Sys, Ch, Cl, Dir);
%
%  z = calcSpikeRateTuningPair(Trials, Sys, Ch, Cl, Dir);
%
%  z = z-score for Tuning in preferred direction
%

Rate = []; 
mRate = zeros(1,2);
for i = 1:2
  ind = find([Trials.Target]==Dir(i)); N(i) = length(ind);
  Rate_tmp = trialRate(Trials(ind),Sys,Ch,Cl,'TargsOn',[0,300]);
  mRate(i) = mean(Rate_tmp);
  Rate = [Rate Rate_tmp];
end
RateCR = (mRate(1)-mRate(2))./(mRate(1)+mRate(2));
NTrial = size(Rate,2);
Rate_Perm = zeros(1e3,2);
for iPerm = 1:1e3
  ind = randperm(NTrial); 
  Rate_Perm(iPerm,1) = sum(Rate(ind(1:floor(NTrial./2))))./floor(NTrial./2);
  Rate_Perm(iPerm,2) = sum(Rate(ind(ceil(NTrial./2):end)))./(NTrial-floor(NTrial./2));
end
RateCR_Null = (Rate_Perm(:,1)-Rate_Perm(:,2))./(Rate_Perm(:,1)+Rate_Perm(:,2));
z = RateCR./std(RateCR_Null);

