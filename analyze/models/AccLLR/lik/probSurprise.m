function [Onset,SI] = probSurprise(SpikeTimes, bin, ThresholdLevel)
%
% [Onset, SI] = probSurprise(SpikeTimes, bin)
%
% This computes spike-by-spike log-probabilities on SpikeTimes data using
% static Poisson (no history) model.  
% It is up to the user to make sure the rates are trained with data not in the test set.
%
% Inputs: SpikeTimes: Data in spike times on which Poisson surprise is
%                     computed
%        bin: Time in bins [Start, Stop, samplerate], for example
%                     [1, 1500,1] means  1 to 1500 time points with an interval
%                      of 1 ms
%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
% Outputs: Probabilities in (no of trials X bin(2)) dimensional matrix.

if nargin < 3; ThresholdLevel = 0.01; end

Onset = nan;
nSpikes = length(SpikeTimes);

if nSpikes < 3; SI = zeros(1,nSpikes); return; end

r = nSpikes./diff(bin(1:2)).*1e3;
chk = 0;

iSpike = 1;
while ~chk || iSpike == nSpikes-1
  iSpike = iSpike+1;
  ISI = (SpikeTimes(iSpike) - SpikeTimes(iSpike-1))./1e3;
  if 1./ISI > r
    chk = 1;
  end
end

if ~chk; disp('No event'); return; end

StartSpike = iSpike-1;

T = 0; SI = zeros(1,nSpikes);
for iSpike = StartSpike:nSpikes-1
  T = T + (SpikeTimes(iSpike+1)-SpikeTimes(iSpike))./1e3;
  n = iSpike - StartSpike + 1;
  Summation = 0;
  for in = n:floor(r)
    Summation = Summation + (r*T).^in./factorial(in);
  end
  SI(iSpike+1) = r*T - log(Summation);
end
[dum,EndSpike] = max(SI);

T = 0; SI = zeros(1,EndSpike-StartSpike+1);
for iSpike = StartSpike:EndSpike-1
  T = (SpikeTimes(EndSpike)-SpikeTimes(iSpike))./1e3;
  n = EndSpike - iSpike + 1;
  Summation = 0;
  for in = n:floor(r)
    Summation = Summation + (r*T).^in./factorial(in);
  end
  SI(iSpike) = r*T - log(Summation);
end

OnsetSpike = find(log10(exp(-SI))<log10(ThresholdLevel));
if isempty(OnsetSpike)
  return; 
else
  Onset = SpikeTimes(min(OnsetSpike));
end
