function LRSpike = LR_InhPoisson(SpikeTimes, Rate1, Rate2, bin)
% LRSpike = LR_InhPoisson(SpikeTimes, Rate1, Rate2, bin)
% This computes trial by trial log-likelihood ratios on SpikeTimes data using
% inhomogeneous Poisson (no history) models.  
% It is up to the user to make sure the rates are trained with data not in the test set.
%
% Inputs: SpikeTimes: Data in spike times on which likelihood ratio is
%                     computed
%        Rate1: PSTH for model 1 
%        Rate2: PSTH for model 2 
%        bin: Time in bins [Start, Stop, binlength], for example
%                     [1, 1500,1] means  1 to 1500 time points with an interval
%                      of 1 ms
%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
% Outputs: Likelihood ratios in (no of trials X bin(2)) dimensional matrix.


nTr = length(SpikeTimes);
Spikes = sp2ts(SpikeTimes,bin);
if length(bin) < 3
    binlen = 1./1e3;
else
    binlen = bin(3)./1e3;
end

LRSpike = zeros(nTr,size(Spikes,2));
for iTr = 1:nTr
    %  factorial(Spikes(tr,:)) is always 1, so denominator is always 1.
    %PoissProb1 = ((Rate1.*binlen).^Spikes(iTr,:)).*exp(-Rate1.*binlen);
    %PoissProb2 = ((Rate2.*binlen).^Spikes(iTr,:)).*exp(-Rate2.*binlen);
    %PoissProb2(PoissProb2==0) = 10.^(-16);
    %LRSpike(iTr,:) = PoissProb1./PoissProb2;
    Rate1(Rate1==0) = 0.001;
    Rate2(Rate2==0) = 0.001;
    LRSpike(iTr,:) = (Rate2-Rate1)*binlen + Spikes(iTr,:).*log(Rate1./Rate2);
end
