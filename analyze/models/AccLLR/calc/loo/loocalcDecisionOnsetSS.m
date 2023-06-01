function [Results, Data , Model] = loocalcDecisionOnsetSS(Session, InputParams)
%
%  [Results, Data, Model] = loocalcDecisionOnsetSS(Session, InputParams);
% Leave one out likelihood computation
%   Inputs:

%  Inputs:
%   Session              =   CellArray.  Spike-Field Session information.
%  InputParams.Task           = String.  Behavioral Task.
%                             Defaults to 'DelReachSaccade'
%  InputParams.Event.Target
%	       .Field
%	       .bn
%  InputParams.Null.Field
%	      .bn
%
%  InputParams.Hist = 0/1.  Calculate History results? (optional)
%                           Defaults to 1.  Calculate them
%  InputParams.NoHist = 0/1. Calculate No History results? (optional)
%                           Defaults to 1.  Calculate them.
%  InputParams.VarNoHist = 0/1. Calculate Variable Rate No History results? (optional)
%                           Defaults to 1.  Calculate them.
%
%  InputParams.TrialAvgdDetect = 0/1 Calculate the detection times using
%                             resampled trial averaged accumulated  log-lik ratios
%                           Defaults to 1. Calculate them
%  InputParams.TrialAvNumTrials = 
%

if nargin < 2 || isempty(InputParams)
    InputParams.Task = 'DelReachSaccade';
    HistFlag = 0;
    NoHistFlag = 1;
    VarNoHistFlag = 0;
else
    disp('Input Params exists')
    if ~isfield(InputParams,'Task')
        InputParams.Task = 'DelReachSaccade';
    end
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
    if ~isfield(InputParams,'Smoothing')
        SpikeParams.Smoothing = 5;
    else
        SpikeParams.Smoothing = InputParams.Smoothing;
    end
end

SysS1 = Session{3}{1};
ChS1 = Session{4}(1);
ClS1 = Session{5}{1};
SysS2 = Session{3}{2};
ChS2 = Session{4}(2);
ClS2 = Session{5}{2};

if ~iscell(InputParams.Task); InputParams.Task = {InputParams.Task}; end
if ~iscell(InputParams.Event.Task); InputParams.Event.Task = {InputParams.Event.Task}; end
if ~iscell(InputParams.Null.Task); InputParams.Null.Task = {InputParams.Null.Task}; end

[EventTrials, NullTrials] = calcDecisionOnsetTrials(Session, InputParams);
        
Spikes1Null = trialSpike(NullTrials, SysS1, ChS1, ClS1, InputParams.Null.Field, InputParams.Null.bn);
Spikes1Event = trialSpike(EventTrials, SysS1, ChS1, ClS1, InputParams.Event.Field, InputParams.Event.bn);

Spikes2Null = trialSpike(NullTrials, SysS2, ChS2, ClS2, InputParams.Null.Field, InputParams.Null.bn);
Spikes2Event = trialSpike(EventTrials, SysS2, ChS2, ClS2, InputParams.Event.Field, InputParams.Event.bn);

nTrEvent = length(Spikes1Event);
nTrNull = length(Spikes1Null);
nTrMin = min([nTrEvent,nTrNull]);
if ~isfield(InputParams,'TrialAvNumTrials')
   InputParams.TrialAvNumTrials = [2,5:5:min([25,round(nTrMin./2)])];
end
    
if ~isfield(InputParams,'TrialAvIterations')
    for iNumTrials = 1:length(InputParams.TrialAvNumTrials)
        NumTrials = InputParams.TrialAvNumTrials(iNumTrials);
        if nTrMin < 50
        InputParams.TrialAvIterations(iNumTrials) = ...
            min([50,round(0.5*factorial(nTrMin)./(factorial(nTrMin-NumTrials).*factorial(NumTrials)))]);
        else
            InputParams.TrialAvIterations(iNumTrials)=50;
        end
    end
end

 % Some parameters  for analysis
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
if isfield(InputParams,'compbound2')
    compbound2 = InputParams.compbound2;
else
    compbound2 = 200;
end
if isfield(InputParams,'MaxGLMOrder')
    Morder = InputParams.MaxGLMOrder;
else
    Morder = 20;
end

% ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
% Parameters for Spike Params
%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
GoCue = 0;
SpikeParams.maxorder = Morder;            % maximum model order in ms
SpikeParams.compbound = GoCue:GoCue+compbound2;  % time points between latency needs to be tested
SpikeParams.lags = -50:100;     % the limits of latency jitters for max likelihood computation
SpikeParams.M = 5; % Total number of iterations made
SpikeParams.errorchk = 0.01; % if improvement in consecutive iterations doesn't improve by 1% or if it gets worse fitting stops
SpikeParams.MaxSmoothing = 30; % Checks for smoothing up to 50 ms
SpikeParams.Event.bn = [1, abs(diff(InputParams.Event.bn)), 1];  % binning of spike trains for event
SpikeParams.Null.bn = [1, abs(diff(InputParams.Null.bn)), 1];     % binning of spike trains for null


if NoHistFlag
    %  Processing the Spike1 and Spike2 No History models
    disp('Processing NoHist models')
    disp('... Processing Spike1 single trials')
    [LRSpike1NoHistEvent, LRSpike1NoHistNull, Spike1NoHistEventModel, Spike1NoHistNullModel] = ...
        likSpikeNoHistModel(Spikes1Event, Spikes1Null, SpikeParams);
    disp('... Processing Spike2 single trials');
    [LRSpike2NoHistEvent, LRSpike2NoHistNull, Spike2NoHistEventModel, Spike2NoHistNullModel] = ...
        likSpikeNoHistModel(Spikes2Event, Spikes2Null, SpikeParams);
    Results(1).NoHist.Null.LR = LRSpike1NoHistNull;
    Results(1).NoHist.Event.LR = LRSpike1NoHistEvent;
    Results(1).Type = 'Spike';
    Results(2).NoHist.Null.LR = LRSpike2NoHistNull;
    Results(2).NoHist.Event.LR = LRSpike2NoHistEvent;
    Results(2).Type = 'Spike'; 

    Model(1).NoHist.Event = Spike1NoHistEventModel;
    Model(1).NoHist.Null = Spike1NoHistNullModel;
    Model(1).Type = 'Spike';
    Model(2).NoHist.Event = Spike2NoHistEventModel;
    Model(2).NoHist.Null = Spike2NoHistNullModel;
    Model(2).Type = 'Spike';

    OnsetParams.ModelType = 'NoHist';
    OnsetParams.EndAcc = MaximumTimetoOnsetDetection*ones(1,length(NullTrials));
    AccLLRSpike1Null = accLR(LRSpike1NoHistNull,  ...
        OnsetParams.StartofAccumulationTime, OnsetParams.EndAcc);
    AccLLRSpike2Null = accLR(LRSpike2NoHistNull,  ...
        OnsetParams.StartofAccumulationTime, OnsetParams.EndAcc);
    Results(1).NoHist.Null.AccLLR = AccLLRSpike1Null;
    Results(2).NoHist.Null.AccLLR = AccLLRSpike2Null;
    
    OnsetParams.EndAcc = MaximumTimetoOnsetDetection*ones(1,length(EventTrials));
    AccLLRSpike1Event = accLR(LRSpike1NoHistEvent,  ...
        OnsetParams.StartofAccumulationTime, OnsetParams.EndAcc);
    AccLLRSpike2Event = accLR(LRSpike2NoHistEvent,  ...
        OnsetParams.StartofAccumulationTime, OnsetParams.EndAcc);
    Results(1).NoHist.Event.AccLLR = AccLLRSpike1Event;
    Results(2).NoHist.Event.AccLLR = AccLLRSpike2Event;

    Results(1).NoHist.DataParams = SpikeParams;
    Results(2).NoHist.DataParams = SpikeParams;
    Results(1).NoHist.OnsetParams = OnsetParams;
    Results(1).NoHist.InputParams = InputParams;
    Results(2).NoHist.OnsetParams = OnsetParams;
    Results(2).NoHist.InputParams = InputParams;

    if TrialAvgdFlag
        disp(['... Processing up to ' num2str(InputParams.TrialAvNumTrials(end)) ' Trial Averages']);
 
        Spike1_TrialAv = likTrialAvSpikeNoHistModel(Spikes1Event, Spikes1Null, ...
            InputParams, SpikeParams);
        Spike2_TrialAv = likTrialAvSpikeNoHistModel(Spikes2Event, Spikes2Null, ...
            InputParams, SpikeParams);

        
        for iNumTrials = 1:length(InputParams.TrialAvNumTrials)
            fprintf(1,'%d ',InputParams.TrialAvNumTrials(iNumTrials));

            EndAcc = MaximumTimetoOnsetDetection*ones(1,InputParams.TrialAvIterations(iNumTrials));
            
            AccLLRSpike1Event = accLR(Spike1_TrialAv.LREvent{iNumTrials},  ...
                OnsetParams.StartofAccumulationTime, EndAcc);
            AccLLRSpike1Null = accLR(Spike1_TrialAv.LRNull{iNumTrials},  ...
                OnsetParams.StartofAccumulationTime, EndAcc);
            AccLLRSpike2Event = accLR(Spike2_TrialAv.LREvent{iNumTrials},  ...
                OnsetParams.StartofAccumulationTime, EndAcc);
            AccLLRSpike2Null = accLR(Spike2_TrialAv.LRNull{iNumTrials},  ...
                OnsetParams.StartofAccumulationTime, EndAcc);

            [Spike1_p, Spike1_ST, Spike1_Levels] = performance_levels(AccLLRSpike1Event, ...
                AccLLRSpike1Null);
            [Spike2_p, Spike2_ST, Spike2_Levels] = performance_levels(AccLLRSpike2Event, ...
                AccLLRSpike2Null);

            Spike1_TrialAv.AccLLREvent{iNumTrials} = AccLLRSpike1Event;
            Spike1_TrialAv.AccLLRNull{iNumTrials} = AccLLRSpike1Null;
            Spike1_TrialAv.p{iNumTrials} = Spike1_p;
            Spike1_TrialAv.ST{iNumTrials} = Spike1_ST;
            Spike1_TrialAv.Levels{iNumTrials} = Spike1_Levels;
            Spike2_TrialAv.AccLLREvent{iNumTrials} = AccLLRSpike2Event;
            Spike2_TrialAv.AccLLRNull{iNumTrials} = AccLLRSpike2Null;
            Spike2_TrialAv.p{iNumTrials} = Spike2_p;
            Spike2_TrialAv.ST{iNumTrials} = Spike2_ST;
            Spike2_TrialAv.Levels{iNumTrials} = Spike2_Levels;

        end
        fprintf(1,'\n');
        Results(1).NoHist.TrialAv = Spike1_TrialAv;
        Results(2).NoHist.TrialAv = Spike2_TrialAv;
    end
end

if HistFlag
    %  Processing the Spike and LFP History models.
    disp('Processing Hist models')
    disp('... Processing Lfp');
    [LRLfpHistEvent, LRLfpHistNull, LfpHistEventModel, LfpHistNullModel] = ...
       loolikLfpHistModel(LfpEvent, LfpNull, LfpParams);
    disp('... Processing Spike');
    [LRSpikeHistEvent, LRSpikeHistNull, SpikeHistEventModel, SpikeHistNullModel] = ...
       loolikSpikeHistModel(SpikesEvent, SpikesNull, SpikeParams);
    Results.Hist.Null.LRLfp = LRLfpHistNull;
    Results.Hist.Null.LRSpike = LRSpikeHistNull;
    Results.Hist.Event.LRLfp = LRLfpHistEvent;
    Results.Hist.Event.LRSpike = LRSpikeHistEvent;
    
    Model.Hist.Lfp.Event = LfpHistEventModel;
    Model.Hist.Lfp.Null = LfpHistNullModel;
    Model.Hist.Spike.Event = SpikeHistEventModel;
    Model.Hist.Spike.Null = SpikeHistNullModel;

    OnsetParams.tauLfp = LfpHistEventModel.tau;
    OnsetParams.tauSpike = SpikeHistEventModel.tau;

    OnsetParams.ModelType = 'Hist';

    OnsetParams.EndAcc = MaximumTimetoOnsetDetection*ones(1,length(NullTrials));
    AccLLRLfpNull = accLR(LRLfpHistNull, OnsetParams.GoCue + OnsetParams.StartofAccumulationTime, OnsetParams.EndAcc);
    AccLLRSpikeNull = accLR(LRSpikeHistNull, OnsetParams.GoCue + OnsetParams.StartofAccumulationTime, OnsetParams.EndAcc);
    Results.Hist.Null.AccLLRLfp = AccLLRLfpNull;
    Results.Hist.Null.AccLLRSpike = AccLLRSpikeNull;

    Results.Hist.SpikeParams = SpikeParams;
    Results.Hist.LfpParams = LfpParams;
    Results.Hist.OnsetParams = OnsetParams;
    
    if TrialAvgdFlag
        disp('... Processing Trial average');
        NullTotTrials = size(AccLLRLfpNull, 1); 
        EventTotTrials = size(AccLLRLfpEvent, 1);
        OnsetParams.Iterations = Iterations;
        OnsetParams.ResampleSize = ResampleSize;
 
        AccLLRLfpNullTrialAved = zeros(Iterations,size(AccLLRLfpNull,2));
        AccLLRSpikeNullTrialAved = zeros(Iterations,size(AccLLRSpikeNull,2));
        AccLLRLfpEventTrialAved = zeros(Iterations,size(AccLLRLfpEvent,2));
        AccLLRSpikeEventTrialAved = zeros(Iterations,size(AccLLRSpikeEvent,2));
        for niters = 1:Iterations;
            ResampledTrIndices = randperm(NullTotTrials);
            AccLLRLfpNullTrialAved(niters,:) = mean(AccLLRLfpNull(ResampledTrIndices(1:ResampleSize),:),1);
            AccLLRSpikeNullTrialAved(niters,:) = mean(AccLLRSpikeNull(ResampledTrIndices(1:ResampleSize),:),1);
            ResampledTrIndices = randperm(EventTotTrials);
            AccLLRLfpEventTrialAved(niters,:) = mean(AccLLRLfpEvent(ResampledTrIndices(1:ResampleSize),:),1);
            AccLLRSpikeEventTrialAved(niters,:) = mean(AccLLRSpikeEvent(ResampledTrIndices(1:ResampleSize),:),1);
        end
        Results.Hist.TrialAv.Null.AccLLRSpike = AccLLRSpikeNullTrialAved;
        Results.Hist.TrialAv.Null.AccLLRLfp = AccLLRLfpNullTrialAved;
        Results.Hist.TrialAv.Event.AccLLRSpike = AccLLRSpikeEventTrialAved;
        Results.Hist.TrialAv.Event.AccLLRLfp = AccLLRLfpEventTrialAved;
        
        Results.Hist.TrialAv.SpikeParams = SpikeParams;
        Results.Hist.TrialAv.LfpParams = LfpParams;
        Results.Hist.TrialAv.OnsetParams = OnsetParams;
    end
end

if VarNoHistFlag
    %  Processing the Spike and LFP No History Poisson models with variable
    %  rate and evoked potentials.
    disp('Processing VarNoHist models')
    disp('... Processing Lfp');
    [LRLfpVarNoHistEvent, LRLfpVarNoHistNull, LfpVarNoHistEventModel, LfpVarNoHistNullModel] = ...
       loolikLfpVarNoHistModel(LfpEvent, LfpNull, LfpParams);
   disp('... Processing Spikes');
    [LRSpikeVarNoHistEvent, LRSpikeVarNoHistNull, SpikeVarNoHistEventModel, SpikeVarNoHistNullModel] = ...
       loolikSpikeVarNoHistModel(SpikesEvent, SpikesNull, SpikeParams);

    Results.VarNoHist.Null.LRLfp = LRLfpVarNoHistNull;
    Results.VarNoHist.Null.LRSpike = LRSpikeVarNoHistNull;
    Results.VarNoHist.Event.LRLfp = LRLfpVarNoHistEvent;
    Results.VarNoHist.Event.LRSpike = LRSpikeVarNoHistEvent;

    Model.VarNoHist.Lfp.Event = LfpVarNoHistEventModel;
    Model.VarNoHist.Lfp.Null = LfpVarNoHistNullModel;
    Model.VarNoHist.Spike.Event = SpikeVarNoHistEventModel;
    Model.VarNoHist.Spike.Null = SpikeVarNoHistNullModel;

    %OnsetParams.tauLfp = LfpVarNoHistEventModel.tau;
    %OnsetParams.tauSpike = SpikeVarNoHistEventModel.tau;

    OnsetParams.ModelType = 'VarNoHist';

    OnsetParams.EndAcc = MaximumTimetoOnsetDetection*ones(1,length(NullTrials));
    AccLLRLfpNull = accLR(LRLfpVarNoHistNull, OnsetParams.GoCue + OnsetParams.StartofAccumulationTime, OnsetParams.EndAcc);
    AccLLRSpikeNull = accLR(LRSpikeVarNoHistNull, OnsetParams.GoCue + OnsetParams.StartofAccumulationTime, OnsetParams.EndAcc);
    
    OnsetParams.EndAcc = MaximumTimetoOnsetDetection*ones(1,length(EventTrials));
    AccLLRLfpEvent = accLR(LRLfpVarNoHistEvent, OnsetParams.GoCue + OnsetParams.StartofAccumulationTime, OnsetParams.EndAcc);
    AccLLRSpikeEvent = accLR(LRSpikeVarNoHistEvent, OnsetParams.GoCue + OnsetParams.StartofAccumulationTime, OnsetParams.EndAcc);
    
    Results.VarNoHist.Null.AccLLRLfp = AccLLRLfpNull;
    Results.VarNoHist.Null.AccLLRSpike = AccLLRSpikeNull;
    Results.VarNoHist.Event.AccLLRLfp = AccLLRLfpEvent;
    Results.VarNoHist.Event.AccLLRSpike = AccLLRSpikeEvent;

    Results.VarNoHist.SpikeParams = SpikeParams;
    Results.VarNoHist.LfpParams = LfpParams;
    Results.VarNoHist.OnsetParams = OnsetParams;
    
    if TrialAvgdFlag
        disp('... Processing Trial average');
        NullTotTrials = size(AccLLRLfpNull, 1); 
        EventTotTrials = size(AccLLRLfpEvent, 1);
        OnsetParams.Iterations = Iterations;
        OnsetParams.ResampleSize = ResampleSize;
        
        AccLLRLfpNullTrialAved = zeros(Iterations,size(AccLLRLfpNull,2));
        AccLLRSpikeNullTrialAved = zeros(Iterations,size(AccLLRSpikeNull,2));
        AccLLRLfpEventTrialAved = zeros(Iterations,size(AccLLRLfpEvent,2));
        AccLLRSpikeEventTrialAved = zeros(Iterations,size(AccLLRSpikeEvent,2));
        for niters = 1:Iterations;
            ResampledTrIndices = randperm(NullTotTrials);
            AccLLRLfpNullTrialAved(niters,:) = mean(AccLLRLfpNull(ResampledTrIndices(1:ResampleSize),:),1);
            AccLLRSpikeNullTrialAved(niters,:) = mean(AccLLRSpikeNull(ResampledTrIndices(1:ResampleSize),:),1);
            ResampledTrIndices = randperm(EventTotTrials);
            AccLLRLfpEventTrialAved(niters,:) = mean(AccLLRLfpEvent(ResampledTrIndices(1:ResampleSize),:),1);
            AccLLRSpikeEventTrialAved(niters,:) = mean(AccLLRSpikeEvent(ResampledTrIndices(1:ResampleSize),:),1);
        end
        
        Results.VarNoHist.TrialAv.Null.AccLLRSpike = AccLLRSpikeNullTrialAved;
        Results.VarNoHist.TrialAv.Null.AccLLRLfp = AccLLRLfpNullTrialAved;
        Results.VarNoHist.TrialAv.Event.AccLLRSpike = AccLLRSpikeEventTrialAved;
        Results.VarNoHist.TrialAv.Event.AccLLRLfp = AccLLRLfpEventTrialAved;

        Results.VarNoHist.TrialAv.SpikeParams = SpikeParams;
        Results.VarNoHist.TrialAv.LfpParams = LfpParams;
        Results.VarNoHist.TrialAv.OnsetParams = OnsetParams;
    end
end
    

Data(1).Event = Spikes1Event;
Data(1).Null = Spikes1Null;
Data(2).Event = Spikes2Event;
Data(2).Null = Spikes2Null;
Data(1).Trials.Event = EventTrials;
Data(2).Trials.Event = EventTrials;
Data(1).Trials.Null = NullTrials;
Data(2).Trials.Null = NullTrials;
Data(1).Type = 'Spike';
Data(2).Type = 'Spike';

