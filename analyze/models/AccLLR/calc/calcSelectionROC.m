function [ROC, se] = calcSelectionROC(Onset,TrialAverage)
%  Calc choice probabality analysis
%
%  calcSelectionROC(Onset)
%
%   Inputs: Onset      = Data structure
%           TrialAverage = scalar 0 - No trial average [1-6] index into
%           TrialAv.AccLLR

if nargin <2
    TrialAverage = 0;
end


Session = Onset.Session;
Params = Onset.Params;
MaxTime = Onset.Params.MaximumTimetoOnsetDetection;
    
for iType = 1:length(Onset.Results)
    if(TrialAverage == 0)      
        Results = Onset.Results(iType);
        AccLLRNull = Results.NoHist.Null.AccLLR;
        AccLLREvent = Results.NoHist.Event.AccLLR;
    else
         Results = Onset.Results.NoHist.TrialAv;
         AccLLRNull = Results.AccLLRNull{TrialAverage};
         AccLLREvent = Results.AccLLREvent{TrialAverage};
    end
    z = [-ones(1,MaxTime) ones(1,MaxTime)];
    ROC = zeros(1,MaxTime); se = zeros(1,MaxTime);
    for iT = 1:MaxTime
        [ROC(iT),se(iT)] = myroc(AccLLRNull(:,iT)'+rand(1,size(AccLLRNull,1))*0.04, ...
            AccLLREvent(:,iT)' + rand(1,size(AccLLREvent,1))*0.04);
    end
end
