function logP = probPoisson(SpikeTimes, Rate, bin, binwidth, binlen)
% logP = probPoisson(SpikeTimes, Rate, bin, binwidth, binlen)
% This computes trial by trial log-probabilities on SpikeTimes data using
% static Poisson (no history) models.  
% It is up to the user to make sure the rates are trained with data not in the test set.
%
% Inputs: SpikeTimes: Data in spike times on which likelihood ratio is
%                     computed
%        Rate: PSTH for model 1 
%        bin: Time in bins [Start, Stop, samplerate], for example
%                     [1, 1500,1] means  1 to 1500 time points with an interval
%                      of 1 ms
%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
% Outputs: Probabilities in (no of trials X bin(2)) dimensional matrix.


nTr = length(SpikeTimes);
SpikeHist = sp2ts(SpikeTimes,bin, binwidth);
if nargin < 5 binlen = binwidth./bin(3); end

logP = zeros(nTr,size(SpikeHist,2));
Rate(Rate==0)=0.001;
for iTr = 1:nTr
    logP(iTr,:) = SpikeHist(iTr,:).*log(Rate.*binlen) + ...
        (-Rate.*binlen) - log(factorial(SpikeHist(iTr,:)));
end
