function [Results, Data , Model] = loocalcOnsetSF(Session, InputParams)
%
%  [Results, Data, Model] = loocalcOnsetSF(Session, InputParams);
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

Trials = sessTrials(Session, InputParams.Task);
SysS = Session{3}{1};
ChS = Session{4}(1);
ClS = Session{5}{1};
SysF = Session{3}{2};
ChF = Session{4}(2);

EventTrials = Trials([Trials.Target] == InputParams.Event.Target);
if isempty(InputParams.Null.Target)
  NullTrials = Trials([Trials.Target]>0);
else
  NullTrials = [];
  for iTarget = 1:length(InputParams.Null.Target)
    NullTrials = [NullTrials Trials([Trials.Target]==InputParams.Null.Target)];
  end
end

SpikesNull = trialSpike(NullTrials, SysS, ChS, ClS, InputParams.Null.Field, InputParams.Null.bn);
SpikesEvent = trialSpike(EventTrials, SysS, ChS, ClS, InputParams.Event.Field, InputParams.Event.bn);

LfpNull = trialMlfp(NullTrials, SysF, ChF, InputParams.Null.Field, InputParams.Null.bn);
LfpEvent = trialMlfp(EventTrials, SysF, ChF, InputParams.Event.Field, InputParams.Event.bn);

%Baseline Correction
Baseline = mean(LfpNull(:)); LfpNull = LfpNull - Baseline; LfpEvent = LfpEvent - Baseline;

nTrEvent = size(LfpEvent,1);
nTrNull = size(LfpNull,1);
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

% Some parameters  for spike - field  analysis
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
%*************************************************************************
% Parameters for Lfp Models
%************************************************************************
LfpParams.maxorder = Morder;            % maximum model order in ms
GoCue = 0;
LfpParams.compbound = GoCue:GoCue+compbound2;  % time points between latency needs to be tested
LfpParams.lags = -100:100;     % the limits of latency jitters for max likelihood computation
LfpParams.M = 5; % Total number of iterations made
LfpParams.errorchk = 0.01;

% ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
% Parameters for Spike Params
%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
SpikeParams.maxorder = Morder;            % maximum model order in ms
SpikeParams.compbound = GoCue:GoCue+compbound2;  % time points between latency needs to be tested
SpikeParams.lags = -50:100;     % the limits of latency jitters for max likelihood computation
SpikeParams.M = 5; % Total number of iterations made
SpikeParams.errorchk = 0.01; % if improvement in consecutive iterations doesn't improve by 1% or if it gets worse fitting stops
SpikeParams.MaxSmoothing = 30; % Checks for smoothing up to 50 ms
SpikeParams.Event.bn = [1, abs(diff(InputParams.Event.bn)), 1];  % binning of spike trains for event
SpikeParams.Null.bn = [1, abs(diff(InputParams.Null.bn)), 1];     % binning of spike trains for null


if NoHistFlag
    %  Processing the Spike and LFP No History models
    disp('Processing NoHist models')
    disp('... Processing Lfp single trials')
    [LRLfpNoHistEvent, LRLfpNoHistNull, LfpNoHistEventModel, LfpNoHistNullModel] = ...
        likLfpNoHistModel(LfpEvent, LfpNull, LfpParams);
    disp('... Processing Spike single trials');
    [LRSpikeNoHistEvent, LRSpikeNoHistNull, SpikeNoHistEventModel, SpikeNoHistNullModel] = ...
        likSpikeNoHistModel(SpikesEvent, SpikesNull, SpikeParams);
    Results(1).NoHist.Null.LR = LRSpikeNoHistNull;
    Results(1).NoHist.Event.LR = LRSpikeNoHistEvent;
    Results(2).NoHist.Null.LR = LRLfpNoHistNull;
    Results(2).NoHist.Event.LR = LRLfpNoHistEvent;
    Results(1).Type = 'Spike';
    Results(2).Type = 'Field';

    Model(1).NoHist.Event = SpikeNoHistEventModel;
    Model(1).NoHist.Null = SpikeNoHistNullModel;
    Model(2).NoHist.Event = LfpNoHistEventModel;
    Model(2).NoHist.Null = LfpNoHistNullModel;
    Model(1).Type = 'Spike';
    Model(2).Type = 'Field';

    OnsetParams.ModelType = 'NoHist';
    OnsetParams.EndAcc = MaximumTimetoOnsetDetection*ones(1,length(NullTrials));
    AccLLRLfpNull = accLR(LRLfpNoHistNull, ...
        OnsetParams.StartofAccumulationTime, OnsetParams.EndAcc);
    AccLLRSpikeNull = accLR(LRSpikeNoHistNull, ...
        OnsetParams.StartofAccumulationTime, OnsetParams.EndAcc);
    Results(1).NoHist.Null.AccLLR = AccLLRSpikeNull;
    Results(2).NoHist.Null.AccLLR = AccLLRLfpNull;
    
    OnsetParams.EndAcc = MaximumTimetoOnsetDetection*ones(1,length(EventTrials));
    AccLLRLfpEvent = accLR(LRLfpNoHistEvent, ...
        OnsetParams.StartofAccumulationTime, OnsetParams.EndAcc);
    AccLLRSpikeEvent = accLR(LRSpikeNoHistEvent, ...
        OnsetParams.StartofAccumulationTime, OnsetParams.EndAcc);
    Results(1).NoHist.Event.AccLLR = AccLLRSpikeEvent;
    Results(2).NoHist.Event.AccLLR = AccLLRLfpEvent;

    Results(1).NoHist.DataParams = SpikeParams;
    Results(2).NoHist.DataParams = LfpParams;
    Results(1).NoHist.OnsetParams = OnsetParams;
    Results(1).NoHist.InputParams = InputParams;
    Results(2).NoHist.OnsetParams = OnsetParams;
    Results(2).NoHist.InputParams = InputParams;

    if TrialAvgdFlag
        disp(['... Processing up to ' num2str(InputParams.TrialAvNumTrials(end)) ' Trial Averages']);
 
        Lfp_TrialAv = likTrialAvLfpNoHistModel(LfpEvent, LfpNull, ...
            InputParams);
        Spike_TrialAv = likTrialAvSpikeNoHistModel(SpikesEvent, SpikesNull, ...
            InputParams, SpikeParams);
        
        for iNumTrials = 1:length(InputParams.TrialAvNumTrials)
            fprintf(1,'%d ',InputParams.TrialAvNumTrials(iNumTrials));

            EndAcc = MaximumTimetoOnsetDetection*ones(1,InputParams.TrialAvIterations(iNumTrials));
            
            AccLLRLfpEvent = accLR(Lfp_TrialAv.LREvent{iNumTrials},  ...
                OnsetParams.StartofAccumulationTime, EndAcc);
            
            AccLLRLfpNull = accLR(Lfp_TrialAv.LRNull{iNumTrials},  ...
                OnsetParams.StartofAccumulationTime, EndAcc);
            
            AccLLRSpikeEvent = accLR(Spike_TrialAv.LREvent{iNumTrials}, ...
                OnsetParams.StartofAccumulationTime, EndAcc);
            
            AccLLRSpikeNull = accLR(Spike_TrialAv.LRNull{iNumTrials}, ...
                OnsetParams.StartofAccumulationTime, EndAcc);
            
            [Spike_p, Spike_ST, Spike_Levels] = performance_levels(AccLLRSpikeEvent, ...
                AccLLRSpikeNull);
            [Lfp_p, Lfp_ST, Lfp_Levels] = performance_levels(AccLLRLfpEvent, AccLLRLfpNull);

            Lfp_TrialAv.AccLLREvent{iNumTrials} = AccLLRLfpEvent;
            Lfp_TrialAv.AccLLRNull{iNumTrials} = AccLLRLfpNull;
            Spike_TrialAv.AccLLREvent{iNumTrials} = AccLLRSpikeEvent;
            Spike_TrialAv.AccLLRNull{iNumTrials} = AccLLRSpikeNull;
            Lfp_TrialAv.p{iNumTrials} = Lfp_p;
            Lfp_TrialAv.ST{iNumTrials} = Lfp_ST;
            Lfp_TrialAv.Levels{iNumTrials} = Lfp_Levels;
            Spike_TrialAv.p{iNumTrials} = Spike_p;
            Spike_TrialAv.ST{iNumTrials} = Spike_ST;
            Spike_TrialAv.Levels{iNumTrials} = Spike_Levels;
        end
        fprintf(1,'\n');
        Results(1).NoHist.TrialAv = Spike_TrialAv;
        Results(2).NoHist.TrialAv = Lfp_TrialAv;
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
    

Data(1).Event = SpikesEvent;
Data(1).Null = SpikesNull;
Data(2).Event = LfpEvent;
Data(2).Null = LfpNull;
Data(1).Trials.Null = NullTrials;
Data(1).Trials.Event = EventTrials;
Data(2).Trials.Null = NullTrials;
Data(2).Trials.Event = EventTrials;
Data(1).Type = 'Spike';
Data(2).Type = 'Field';

