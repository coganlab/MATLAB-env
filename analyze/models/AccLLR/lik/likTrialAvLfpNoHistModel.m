function TrialAv = ...
    likTrialAvLfpNoHistModel(LfpEvent, LfpNull, InputParams)
%
% TrialAv = likTrialAvLfpNoHistModel(LfpEvent, LfpNull, InputParams)
%
%   Inputs:
%
%   Outputs:
%       LRLfpEvent
%       LRLfpNull
%       EventModel
%       NullModel

if(iscell(LfpEvent))
    nSess = length(LfpEvent);
else
    nSess = 1;
    myLfpNull{1} = LfpNull;
    myLfpEvent{1} = LfpEvent;
    LfpNull = myLfpNull; LfpEvent = myLfpEvent;
end

for iSess = 1:nSess
  LPLfpNull{iSess} = mtfilter(LfpNull{iSess},[.03,40],1e3,0);
  LPLfpEvent{iSess} = mtfilter(LfpEvent{iSess},[.03,40],1e3,0);

  LfpMeanEvent{iSess} = mean(LPLfpEvent{iSess},1);
  LfpMeanNull{iSess} = mean(LPLfpNull{iSess},1);

  nTrEvent(iSess) = size(LPLfpEvent{iSess},1);
  nTrNull(iSess) = size(LPLfpNull{iSess},1);
  nT = length(LfpMeanEvent{iSess});

  ResNull = LPLfpNull{iSess} - repmat(LfpMeanNull{iSess}, nTrNull(iSess),1);
  sigmaNull(iSess) = std(ResNull(:));

  ResEvent = LPLfpEvent{iSess} - repmat(LfpMeanEvent{iSess},nTrEvent(iSess),1);
  sigmaEvent(iSess) = std(ResEvent(:));

  sigmaEventNull(iSess) = (sigmaEvent(iSess)+sigmaNull(iSess))./2;
end

NumTrials = InputParams.TrialAvNumTrials;
nTestReps = InputParams.TrialAvIterations;

%find minimum number of trials
minNumTrials = length(NumTrials{1});
if nSess > 1
    for iSess = 2:nSess
        minNumTrials = min(minNumTrials,length(NumTrials{iSess}));
    end
end

total_LRLfpEvent = cell(1,minNumTrials);
total_LRLfpNull = cell(1,minNumTrials);

for iNumTrials = 1:minNumTrials
    LRLfpEvent = cell(1,nSess);
    for iSess = 1:nSess
        LRLfpEvent_tmp = zeros(nTestReps(iNumTrials),nT);
        for iRep = 1:nTestReps(iNumTrials)
            TrialPerm = randperm(nTrEvent(iSess));
            TrainTrials = TrialPerm(1:end-NumTrials{iSess}(iNumTrials));
            TestTrials = TrialPerm(end-NumTrials{iSess}(iNumTrials)+1:end);
            LfpMeanEventTr = sum(LPLfpEvent{iSess}(TrainTrials,:))./length(TrainTrials);
            nTestTrials = length(TestTrials);
            LRtmp = zeros(nTestTrials,nT);
            for iTr = 1:nTestTrials
                LRtmp(iTr,:) = ...
                    likLR_Gaussian(LPLfpEvent{iSess}(TestTrials(iTr),:), LfpMeanEventTr, ...
                    LfpMeanNull{iSess}, sigmaEventNull(iSess), sigmaEventNull(iSess));
            end
            LRLfpEvent_tmp(iRep,:) = mean(LRtmp);
        end
        LRLfpEvent{iSess} = LRLfpEvent_tmp;
    end
    total_LRLfpEvent{iNumTrials} = LRLfpEvent;
    
    LRLfpNull = cell(1,nSess);
    for iSess = 1:nSess
        LRLfpNull_tmp = zeros(nTestReps(iNumTrials),nT);
        for iRep = 1:nTestReps(iNumTrials)
            TrialPerm = randperm(nTrNull(iSess));
            TrainTrials = TrialPerm(1:end - NumTrials{iSess}(iNumTrials));
            TestTrials = TrialPerm(end - NumTrials{iSess}(iNumTrials) + 1:end);
            LfpMeanNullTr = sum(LPLfpNull{iSess}(TrainTrials,:))./length(TrainTrials);
            nTestTrials = length(TestTrials);
            LRtmp = zeros(nTestTrials,nT);
            for iTr = 1:nTestTrials
                LRtmp(iTr,:) = ...
                    likLR_Gaussian(LPLfpNull{iSess}(TestTrials(iTr),:), LfpMeanEvent{iSess}, ...
                    LfpMeanNullTr, sigmaEventNull(iSess), sigmaEventNull(iSess));
            end
            LRLfpNull_tmp(iRep,:) = mean(LRtmp);
        end
        LRLfpNull{iSess} = LRLfpNull_tmp;
    end
    total_LRLfpNull{iNumTrials} = LRLfpNull;
end


% Average across the sessions
for iNumTrials = 1:minNumTrials
    total_LRLfpEvent{iNumTrials} = averageLR(total_LRLfpEvent{iNumTrials});
    total_LRLfpNull{iNumTrials} = averageLR(total_LRLfpNull{iNumTrials});
end
TrialAv.LREvent = total_LRLfpEvent;
TrialAv.LRNull = total_LRLfpNull;


if nSess > 1
  TrialAv.EventModel.Mean = LfpMeanEvent;
  TrialAv.EventModel.sigma = sigmaEvent;

  TrialAv.NullModel.Mean = LfpMeanNull;
  TrialAv.NullModel.sigma = sigmaNull;
else
  TrialAv.EventModel.Mean = LfpMeanEvent{1};
  TrialAv.EventModel.sigma = sigmaEvent(1);

  TrialAv.NullModel.Mean = LfpMeanNull{1};
  TrialAv.NullModel.sigma = sigmaNull(1);
end
