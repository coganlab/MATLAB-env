function Data = calcTuningVonMises(Rate,TargetAngle,BaseRate,Target)
%
%  Data = calcTuningVonMises(Rate,TargetAngle)
%
%  Estimate parameters of a von Mises distribution with 4 parameters.
%  If BaseRate and Target parameters are specified, a more stringent analysis
%  will be performed to identify inverted tuning curves.
%
%    RATE          = Neural data (e.g. spike counts) for each sample 
%    TARGETANGLE   = Angular displacement of each presented target
%    BASERATE      = (Optional) Neural data during a baseline interval
%    TARGET        = (Optional, but required if BASERATE is specified)
%                    Target ID (1-8) associated with each BaseRate sample

Data = [];

% options = statset('mlecustom');
% options.GradObj = 'on';
% options.MaxIter = 1e3;

options = statset('Display','off','MaxIter',1e6,'MaxFunEval',1e6,'TolBnd',1e-6,'TolFun',1e-6 ...
    , 'TolX', 1e-6,'GradObj','on','DerivStep',6.0555e-06,'FunValCheck','on');

% Construct a negative log likelihood function for each xi
nloglf_alt = @(params,data,cens,freq) nloglfVonMisesPoisson(params,data,cens,freq,TargetAngle);
nloglf_null = @(params,data,cens,freq) nloglfConstantPoisson(params,data,cens,freq,TargetAngle);

% Choose parameter starting points
Astart = max(median(Rate),2); % minimum value of 2 prevents infinite nloglf during early iterations.
                              % (this crashes sometimes when Astart = 1)
Bstart = 1;
Brange = [ 0 Inf ];
Kstart = 1;

% This (initial) approach to finding inverted tuning curves is basically useless.
% The Poisson distribution has a long tail, so posDiff always ends up greater than negDiff.
% A single outlier biases the comparison.
posDiff = max(Rate)-Astart;
negDiff = Astart-min(Rate);
if negDiff>posDiff Bstart = -1; Brange = [ -Inf 0 ]; end

% This is a more rigorous (albeit computationally intensive) approach to
% finding inverted tuning curves.
if nargin==4
  % Identify inverted tuning curves by applying constraints from (XJ Wang et al, PNAS 2004)
  % - the unit must be inhibited in response to at least 1 target
  % - the unit must not be excited by any of the remaining targets
  % These criteria are tested by comparing target-specific
  % responses to the baseline firing rate.
  p = zeros(1,8);
  for k=1:8
    tInd = find(Target==k);
    p(k) = calcTimeSeriesPermutationTest(BaseRate',Rate(tInd)',1e3);
  end
  posDiffTotal = numel(find(p<0.05));
  negDiffTotal = numel(find(p>0.95));
  if negDiffTotal>0 & posDiffTotal==0 Bstart = -1; Brange = [ -Inf 0 ]; Kstart = 0.1; end          
end        
        
% S = Rate*sin(TargetAngle');
% C = Rate*cos(TargetAngle');
iEXP = Rate.*exp(1i.*TargetAngle);
% Mustart = atan2(S,C); % trigonometric moment
Mustart = angle(sum(iEXP)); % trigonometric moment
if Bstart < 0
  if Mustart < 0 Mustart = Mustart+pi; elseif Mustart > 0; Mustart = Mustart-pi; end
end
        
[phat_alt,pci_alt] = mle(Rate,'nloglf',nloglf_alt,'options',options,...
        'lowerbound',[0 Brange(1) 0 -pi],'upperbound',[Inf Brange(2) Inf pi],...
        'start',[Astart Bstart Kstart Mustart]);

Astart = mean(Rate);
%Pretty unnecessary since Astart is the MLE of lambda for constant poisson model
[phat_null,pci_null] = mle(Rate,'nloglf',nloglf_null,'options',options,...
	        'lowerbound',[0],'upperbound',[Inf],...
	        'start',[Astart]);

val_alt = nloglfVonMisesPoisson(phat_alt,Rate,[],[],TargetAngle);
val_null = nloglfConstantPoisson(phat_null,Rate,[],[],TargetAngle);
D = 2*(val_null-val_alt);

p = 1 - chi2cdf(real(D),3);

Data.phat_alt = phat_alt;
Data.pci_alt = pci_alt;
Data.phat_null = phat_null;
Data.pci_null = pci_null;
Data.p = p;
