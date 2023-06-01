function [Results, Data , Model] = loocalcDecisionOnsetM(Session, InputParams)
%
%  [Results, Data, Model] = loocalcDecisionOnsetM(Session, InputParams);
% Leave one out likelihood computation
%   Inputs:

%  Inputs:
%   Session              =   CellArray.  Spike Session information.   Can
%   include multiple sessions
%  InputParams.Task           = String.  Behavioral Task.
%                             Defaults to 'DelReachSaccade'
%  InputParams.Event.Target
%	       .Field
%	       .bn
%  InputParams.Null.Target
%         .Field
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
%                           Defaults to 0.  Do not calculate trial-averages 
%  InputParams.TrialAvNumTrials = 
%  InputParams.Monkey = cell array of monkey name strings one for each
%               sessions (if multiple sessions are inputted)
%
global MONKEYDIR MONKEYNAME

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
SpikeParams.Static = InputParams.Null.Static;



if ~iscell(InputParams.Task); InputParams.Task = {InputParams.Task}; end
if ~iscell(InputParams.Event.Task); InputParams.Event.Task = {InputParams.Event.Task}; end
if ~iscell(InputParams.Null.Task); InputParams.Null.Task = {InputParams.Null.Task}; end


if iscell(Session{1})
   tmp_targets = InputParams.Event.Target;
   tmp_null_targets = InputParams.Null.Target;
   number_of_sessions = length(Session);
    for iSess = 1:number_of_sessions
        
        MONKEYNAME = InputParams.Monkey{iSess}
        MONKEYDIR = ['/mnt/raid/' InputParams.Monkey{iSess}]
        %addpath(genpath(MONKEYDIR))
        iSess
        SysS = Session{iSess}{3}{1};
        ChS = Session{iSess}{4};
        ClS = Session{iSess}{5};
        InputParams.Event.Target = tmp_targets(iSess);
        if(length(tmp_null_targets) > 0)
            InputParams.Null.Target = tmp_null_targets(iSess);
        end
        [EventTrials{iSess}, NullTrials{iSess}] = calcDecisionOnsetTrials(Session{iSess}, InputParams);
        SpikesNull{iSess} = trialSpike(NullTrials{iSess}, SysS, ChS, ClS, InputParams.Null.Field, InputParams.Null.bn);
        SpikesEvent{iSess} = trialSpike(EventTrials{iSess}, SysS, ChS, ClS, InputParams.Event.Field, InputParams.Event.bn);
        nTrEvent(iSess) = length(SpikesEvent{iSess});
        nTrNull(iSess) = length(SpikesNull{iSess});
        nTrMin(iSess) = min([nTrEvent(iSess),nTrNull(iSess)]);
    end
else
    SysS = Session{3}{1};
    ChS = Session{4};
    ClS = Session{5};
    [EventTrials, NullTrials] = calcDecisionOnsetTrials(Session, InputParams);
    
    SpikesNull = trialSpike(NullTrials, SysS, ChS, ClS, InputParams.Null.Field, InputParams.Null.bn);
    SpikesEvent = trialSpike(EventTrials, SysS, ChS, ClS, InputParams.Event.Field, InputParams.Event.bn);
    
    nTrEvent = length(SpikesEvent);
    nTrNull = length(SpikesNull);
    nTrMin = min([nTrEvent,nTrNull]);
    %nTrMin = nTrEvent;
    number_of_sessions = 1;
end

if ~isfield(InputParams,'TrialAvNumTrials')
    for iTrMin = 1:length(nTrMin)
        tmp_nTrMin{iTrMin} = [2,5:5:min([25,round(nTrMin(iTrMin)./2)])];
        %tmp_nTrMin{iTrMin} = [2,4:2:min([30,round(nTrMin(iTrMin)./2)])];
    end
   InputParams.TrialAvNumTrials = tmp_nTrMin
end

if ~isfield(InputParams,'TrialAvIterations')
    for iTrMin = 1:length(nTrMin)
        tmp_AvTrials = InputParams.TrialAvNumTrials{iTrMin};
        for iNumTrials = 1:length(tmp_AvTrials)
            NumTrials = tmp_AvTrials(iNumTrials);
            if nTrMin < 50
                InputParams.TrialAvIterations(iTrMin,iNumTrials) = ...
                    min([50,round(0.5*factorial(nTrMin(iTrMin))./(factorial(nTrMin(iTrMin)-NumTrials).*factorial(NumTrials)))]);
            else
                InputParams.TrialAvIterations(iTrMin,iNumTrials)=50;
            end
        end
    end
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
SpikeParams.maxorder = Morder;            % maximum model order in ms
SpikeParams.compbound = 0:compbound2;  % time points between latency needs to be tested
SpikeParams.lags = -50:100;     % the limits of latency jitters for max likelihood computation
SpikeParams.M = 5; % Total number of iterations made
SpikeParams.errorchk = 0.01; % if improvement in consecutive iterations doesn't improve by 1% or if it gets worse fitting stops
SpikeParams.Event.bn = [1, abs(diff(InputParams.Event.bn)), 1];  % binning of spike trains for event
SpikeParams.Null.bn = [1, abs(diff(InputParams.Null.bn)), 1];     % binning of spike trains for null


if NoHistFlag
    %  Processing the Spike and LFP No History models
    disp('Processing NoHist models')
    disp('... Processing Spike single trials');
    [LRSpikeNoHistEvent, LRSpikeNoHistNull, SpikeNoHistEventModel, SpikeNoHistNullModel] = ...
        likSpikeNoHistModel(SpikesEvent, SpikesNull, SpikeParams);
    Results.NoHist.Null.LR = LRSpikeNoHistNull;
    Results.NoHist.Event.LR = LRSpikeNoHistEvent;

    Model.NoHist.Event = SpikeNoHistEventModel;
    Model.NoHist.Null = SpikeNoHistNullModel;
    Model.Type = 'Spike';
    if(number_of_sessions == 1)
        min_num_trials = length(NullTrials);
    else
        min_num_trials = length(NullTrials{1});
    end
    for iSess = 2:number_of_sessions
        min_num_trials = min(min_num_trials,length(NullTrials{iSess}));
    end
    OnsetParams.ModelType = 'NoHist';
    OnsetParams.EndAcc = MaximumTimetoOnsetDetection*ones(1,min_num_trials);
    
    AccLLRSpikeNull = accLR(LRSpikeNoHistNull, ...
        OnsetParams.StartofAccumulationTime, OnsetParams.EndAcc);
    Results.NoHist.Null.AccLLR = AccLLRSpikeNull;
    
    if(number_of_sessions == 1)
        min_num_trials = length(EventTrials);
    else
        min_num_trials = length(EventTrials{1});
    end
    for iSess = 2:number_of_sessions
        min_num_trials = min(min_num_trials,length(EventTrials{iSess}));
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
        disp('... Processing Trial average');
        
        maxAverage = InputParams.TrialAvNumTrials(end);
        %disp(['... Processing up to ' num2str(maxAverage) ' Trial Averages']);
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
        NullTotTrials = size(AccLLRSpikeNull, 1); 
        EventTotTrials = size(AccLLRSpikeEvent, 1);
        OnsetParams.Iterations = Iterations;
        OnsetParams.ResampleSize = ResampleSize;

        AccLLRSpikeNullTrialAved = zeros(Iterations,size(AccLLRSpikeNull,2));
        AccLLRSpikeEventTrialAved = zeros(Iterations,size(AccLLRSpikeEvent,2));
        for niters = 1:Iterations;
            ResampledTrIndices = randperm(NullTotTrials);
            AccLLRSpikeNullTrialAved(niters,:) = mean(AccLLRSpikeNull(ResampledTrIndices(1:ResampleSize),:),1);
            ResampledTrIndices = randperm(EventTotTrials);
            AccLLRSpikeEventTrialAved(niters,:) = mean(AccLLRSpikeEvent(ResampledTrIndices(1:ResampleSize),:),1);
        end
        Results.Hist.TrialAv.Null.AccLLRSpike = AccLLRSpikeNullTrialAved;
        Results.Hist.TrialAv.Event.AccLLRSpike = AccLLRSpikeEventTrialAved;
        
        Results.Hist.TrialAv.SpikeParams = SpikeParams;
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
    

Data.Event = SpikesEvent;
Data.Null = SpikesNull;
Data.Trials.Null = NullTrials;
Data.Trials.Event = EventTrials;
Data.Type = 'Spike';

