function [Results, Data , Model] = loocalcDecisionOnsetS(Session, InputParams)
%
%  [Results, Data, Model] = loocalcDecisionOnsetS(Session, InputParams);
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
   nSess = length(Session);
    for iSess = 1:nSess
        
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
    nSess = 1;
end

if ~isfield(InputParams,'TrialAvNumTrials')
    for iTrMin = 1:length(nTrMin)
        %tmp_nTrMin{iTrMin} = [2,5:5:min([25,round(nTrMin(iTrMin)./2)])];
        tmp_nTrMin{iTrMin} = [2,4:2:min([30,round(nTrMin(iTrMin)./2)])];
    end
   InputParams.TrialAvNumTrials = tmp_nTrMin;
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
    if(nSess == 1)
        min_num_trials = length(NullTrials);
    else
        min_num_trials = length(NullTrials{1});
    end
    for iSess = 2:nSess
        min_num_trials = min(min_num_trials,length(NullTrials{iSess}));
    end
    OnsetParams.ModelType = 'NoHist';
    OnsetParams.EndAcc = MaximumTimetoOnsetDetection*ones(1,min_num_trials);
    
    AccLLRSpikeNull = accLR(LRSpikeNoHistNull, ...
        OnsetParams.StartofAccumulationTime, OnsetParams.EndAcc);
    Results.NoHist.Null.AccLLR = AccLLRSpikeNull;
    if(nSess == 1)
        min_num_trials = length(EventTrials);
    else
        min_num_trials = length(EventTrials{1});
    end
    for iSess = 2:nSess
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

Data.Event = SpikesEvent;
Data.Null = SpikesNull;
Data.Trials.Null = NullTrials;
Data.Trials.Event = EventTrials;
Data.Type = 'Spike';

