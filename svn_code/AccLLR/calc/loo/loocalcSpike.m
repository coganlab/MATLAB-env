function [Results, Model] = loocalcSpike(SpikesEvent, SpikesNull, InputParams, SpikeParams)
%
%  [Results, Model] = loocalcSpike(SpikesEvent, SpikesNull, InputParams, SpikeParams)
%

    if ~isfield(InputParams,'Hist')
        HistFlag = 0;
    else
        HistFlag = InputParams.Hist;
    end
    if ~isfield(InputParams,'NoHist')
        NoHistFlag = 1;
    else
        NoHistFlag = InputParams.NoHist;
    end
    if ~isfield(InputParams,'VarNoHist')
        VarNoHistFlag = 0;
    else
        VarNoHistFlag = InputParams.VarNoHist;
    end
    if ~isfield(InputParams,'TrialAvgdDetect')
        TrialAvgdFlag = 0;
    else
        TrialAvgdFlag = InputParams.TrialAvgdDetect;
    end


nSess = length(InputParams.Event.Target);

if nSess > 1
    nTrEvent = zeros(1,nSess);
    nTrNull = zeros(1,nSess);
    nTrMin = zeros(1,nSess);
  for iSess = 1:nSess
    nTrEvent(iSess) = length(SpikesEvent{iSess});
    nTrNull(iSess) = length(SpikesNull{iSess});
    nTrMin(iSess) = min([nTrEvent(iSess),nTrNull(iSess)]);
  end
else
  nTrEvent = length(SpikesEvent);
  nTrNull = length(SpikesNull);
  nTrMin = min([nTrEvent,nTrNull]);
end

if ~isfield(InputParams,'TrialAvNumTrials')
    tmp_nTrMin = cell(1,nSess);
    for iSess = 1:nSess
        tmp_nTrMin{iSess} = [2,5:5:min([25,round(nTrMin(iSess)./2)])];
    end
   InputParams.TrialAvNumTrials = tmp_nTrMin;
end

if ~isfield(InputParams,'TrialAvIterations')
    for iSess = 1:nSess
        tmp_AvTrials = InputParams.TrialAvNumTrials{iSess};
        for iNumTrials = 1:length(tmp_AvTrials)
            NumTrials = tmp_AvTrials(iNumTrials);
            if nTrMin(iSess) < 50
                InputParams.TrialAvIterations{iNumTrials}(iSess) = ...
                    min([50,round(0.5*factorial(nTrMin(iSess))./(factorial(nTrMin(iSess)-NumTrials).*factorial(NumTrials)))]);
            else
                InputParams.TrialAvIterations{iNumTrials}(iSess)=50;
            end
        end
    end
    TrialAvIterations = zeros(1,length(InputParams.TrialAvIterations));
    for iNumTrials = 1:length(InputParams.TrialAvIterations)
      tmp = InputParams.TrialAvIterations{iNumTrials};
      TrialAvIterations(iNumTrials) = min(tmp(find(tmp)));
    end
  InputParams.TrialAvIterations = TrialAvIterations;
end

if isfield(InputParams,'StartofAccumulationTime')
    StartofAccumulationTime = InputParams.StartofAccumulationTime;
    OnsetParams.StartofAccumulationTime = StartofAccumulationTime;
else
    StartofAccumulationTime = 0;
    OnsetParams.StartofAccumulationTime = StartofAccumulationTime;
end
if isfield(InputParams,'MaximumTimetoOnsetDetection')
    MaximumTimetoOnsetDetection = InputParams.MaximumTimetoOnsetDetection;
    OnsetParams.MaximumTimetoOnsetDetection = MaximumTimetoOnsetDetection;
else
    MaximumTimetoOnsetDetection = 200;
    OnsetParams.MaximumTimetoOnsetDetection = MaximumTimetoOnsetDetection;
end
% 
% if isfield(InputParams,'compbound2')
%     compbound2 = InputParams.compbound2;
% else
%     compbound2 = 200;
% end
% if isfield(InputParams,'MaxGLMOrder')
%     Morder = InputParams.MaxGLMOrder;
% else
%     Morder = 20;
% end

if NoHistFlag
    %  Processing the Spike No History model
    disp('Processing NoHist models')
    disp('... Processing Spike single trials');
    [LRSpikeNoHistEvent, LRSpikeNoHistNull, SpikeNoHistEventModel, SpikeNoHistNullModel] = ...
        likSpikeNoHistModel(SpikesEvent, SpikesNull, InputParams, SpikeParams);
    Results.NoHist.Null.LR = LRSpikeNoHistNull;
    Results.NoHist.Event.LR = LRSpikeNoHistEvent;

    Model.NoHist.Event = SpikeNoHistEventModel;
    Model.NoHist.Null = SpikeNoHistNullModel;
    Model.Type = 'Spike';
    if(nSess == 1)
        min_num_trials = length(SpikesNull);
    else
        min_num_trials = length(SpikesNull{1});
    end
    for iSess = 2:nSess
        min_num_trials = min(min_num_trials,length(SpikesNull{iSess}));
    end
    OnsetParams.ModelType = 'NoHist';
    OnsetParams.EndAcc = MaximumTimetoOnsetDetection*ones(1,min_num_trials);

    AccLLRSpikeNull = accLR(LRSpikeNoHistNull, ...
        OnsetParams.StartofAccumulationTime, OnsetParams.EndAcc);
    Results.NoHist.Null.AccLLR = AccLLRSpikeNull;
    if(nSess == 1)
        min_num_trials = length(SpikesEvent);
    else
        min_num_trials = length(SpikesEvent{1});
    end
    for iSess = 2:nSess
        min_num_trials = min(min_num_trials,length(SpikesEvent{iSess}));
    end
    OnsetParams.EndAcc = MaximumTimetoOnsetDetection*ones(1,min_num_trials);

    AccLLRSpikeEvent = accLR(LRSpikeNoHistEvent, ...
        OnsetParams.StartofAccumulationTime, OnsetParams.EndAcc);
    Results.NoHist.Event.AccLLR = AccLLRSpikeEvent;

    Results.NoHist.DataParams = SpikeParams;
    Results.NoHist.OnsetParams = OnsetParams;
    Results.NoHist.InputParams = InputParams;
    Results.Type = 'Spike';

    if TrialAvgdFlag
        maxAverage = max(InputParams.TrialAvNumTrials{end});
        disp(['... Processing up to ' num2str(maxAverage) ' Trial Averages']);
        Spike_TrialAv = likTrialAvSpikeNoHistModel(SpikesEvent, SpikesNull, ...
            InputParams, SpikeParams);
        %find minimum number of trials
        minNumTrials = length(InputParams.TrialAvNumTrials{1});
        for i = 2:length(InputParams.TrialAvNumTrials)
            minNumTrials = min(minNumTrials,length(InputParams.TrialAvNumTrials{i}));
        end
        for iNumTrials = 1:minNumTrials
            %fprintf(1,'%d ',InputParams.TrialAvNumTrials(iNumTrials))

            EndAcc = MaximumTimetoOnsetDetection*ones(1,InputParams.TrialAvIterations(iNumTrials));

            AccLLREvent = accLR(Spike_TrialAv.LREvent{iNumTrials}, ...
                OnsetParams.StartofAccumulationTime, EndAcc);
            AccLLRNull = accLR(Spike_TrialAv.LRNull{iNumTrials}, ...
                OnsetParams.StartofAccumulationTime, EndAcc);

            [Spike_p, Spike_ST, Spike_Levels] = performance_levels(AccLLREvent, ...
                AccLLRNull);
            Spike_TrialAv.AccLLREvent{iNumTrials} = AccLLREvent;
            Spike_TrialAv.AccLLRNull{iNumTrials} = AccLLRNull;
            Spike_TrialAv.p{iNumTrials} = Spike_p;
            Spike_TrialAv.ST{iNumTrials} = Spike_ST;
            Spike_TrialAv.Levels{iNumTrials} = Spike_Levels;
        end
        fprintf(1,'\n');
        Results.NoHist.TrialAv = Spike_TrialAv;
    end
end

