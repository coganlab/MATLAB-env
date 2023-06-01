function [Results, Data , Model] = loocalcOnsetS(Session, InputParams1, InputParams2, AnalParams)
%
%  [Results, Data, Model] = loocalcOnsetS(Session, InputParams);
% Leave one out likelihood computation
%  Inputs:
%   Session              =   CellArray.  Spike Session information.
%   InputParams1 =   Data structure.  Parameter information for 1st condition
%   InputParams2 =   Data structure.  Parameter information for 2nd condition    
%  
%   InputParams.Task           = String.  Behavioral Task.
%                             Defaults to 'DelReachSaccade'
%   InputParams.Target
%	       .Field
%	       .bn
%   AnalParams.Hist = 0/1.  Calculate History results? (optional)
%                           Defaults to 1.  Calculate them
%   AnalParams.NoHist = 0/1. Calculate No History results? (optional)
%                           Defaults to 1.  Calculate them.
%   AnalParams.VarNoHist = 0/1. Calculate Variable Rate No History results? (optional)
%                           Defaults to 1.  Calculate them.
%
%   AnalParams.TrialAvgdDetect = 0/1 Calculate the detection times using
%                             resampled trial averaged accumulated  log-lik ratios
%                           Defaults to 1. Calculate them
%   AnalParams.TrialAvNumTrials = 
%


if ~isfield(AnalParams,'Hist')
    HistFlag = 1;
else
    HistFlag = AnalParams.Hist;
end
if ~isfield(AnalParams,'NoHist')
    NoHistFlag = 1;
else
    NoHistFlag = AnalParams.NoHist;
end
if ~isfield(AnalParams,'VarNoHist')
    VarNoHistFlag = 1;
else
    VarNoHistFlag = AnalParams.VarNoHist;
end
if ~isfield(AnalParams,'TrialAvgdDetect')
    TrialAvgdFlag = 1;
else
    TrialAvgdFlag = AnalParams.TrialAvgdDetect;
end
if ~isfield(AnalParams,'Smoothing')
    SpikeParams.Smoothing = 5;
else
    SpikeParams.Smoothing = AnalParams.Smoothing;
end
%SpikeParams.Static = InputParams2.Static;




SysS = Session{3}{1};
ChS = Session{4};
ClS = Session{5};

EventTrials = Params2Trials(Session, InputParams1);
NullTrials = Params2Trials(Session, InputParams2);

SpikesEvent = trialSpike(EventTrials, SysS, ChS, ClS, InputParams1.Field, InputParams1.bn);
SpikesNull = trialSpike(NullTrials, SysS, ChS, ClS, InputParams2.Field, InputParams2.bn);


%Baseline Correction
nTrEvent = length(SpikesEvent);
nTrNull = length(SpikesNull);
nTrMin = min([nTrEvent,nTrNull]);
if ~isfield(AnalParams,'TrialAvNumTrials')
   AnalParams.TrialAvNumTrials = [2,5:5:min([25,round(nTrMin./2)])];
end

if ~isfield(AnalParams,'TrialAvIterations')
    for iNumTrials = 1:length(AnalParams.TrialAvNumTrials)
        NumTrials = AnalParams.TrialAvNumTrials(iNumTrials);
        if nTrMin < 50
        AnalParams.TrialAvIterations(iNumTrials) = ...
            min([50,round(0.5*factorial(nTrMin)./(factorial(nTrMin-NumTrials).*factorial(NumTrials)))]);
        else
            AnalParams.TrialAvIterations(iNumTrials)=50;
        end
    end
end
    
% Some parameters  for spike - field  analysis
if isfield(AnalParams,'StartofAccumulationTime')
    StartofAccumulationTime = AnalParams.StartofAccumulationTime;
    OnsetParams.StartofAccumulationTime = StartofAccumulationTime;
else
    StartofAccumulationTime = 0;
    OnsetParams.StartofAccumulationTime = StartofAccumulationTime;
end
if isfield(AnalParams,'MaximumTimetoOnsetDetection')
    MaximumTimetoOnsetDetection = AnalParams.MaximumTimetoOnsetDetection;
    OnsetParams.MaximumTimetoOnsetDetection = MaximumTimetoOnsetDetection;
else
    MaximumTimetoOnsetDetection = 200;
    OnsetParams.MaximumTimetoOnsetDetection = MaximumTimetoOnsetDetection;
end
if isfield(AnalParams,'compbound2')
    compbound2 = AnalParams.compbound2;
else
    compbound2 = 200;
end
if isfield(AnalParams,'MaxGLMOrder')
    Morder = AnalParams.MaxGLMOrder;
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
SpikeParams.Event.bn = [1, abs(diff(InputParams1.bn)), 1];  % binning of spike trains for event
SpikeParams.Null.bn = [1, abs(diff(InputParams2.bn)), 1];     % binning of spike trains for null
SpikeParams.Static = 0;


if NoHistFlag
    %  Processing the Spike and LFP No History models
    disp('Processing NoHist models')
    disp('... Processing Spike single trials');
    [LRSpikeNoHistEvent, LRSpikeNoHistNull, SpikeNoHistEventModel, SpikeNoHistNullModel] = ...
        likSpikeNoHistModel(SpikesEvent, SpikesNull, SpikeParams);
    Results.NoHist.Null.LRSpike = LRSpikeNoHistNull;
    Results.NoHist.Event.LRSpike = LRSpikeNoHistEvent;

    Model.NoHist.Event = SpikeNoHistEventModel;
    Model.NoHist.Null = SpikeNoHistNullModel;
    Model.Type = 'Spike';

    OnsetParams.ModelType = 'NoHist';
    OnsetParams.EndAcc = MaximumTimetoOnsetDetection*ones(1,length(NullTrials));
    AccLLRSpikeNull = accLR(LRSpikeNoHistNull,  ...
        OnsetParams.StartofAccumulationTime, OnsetParams.EndAcc);
    Results.NoHist.Null.AccLLR = AccLLRSpikeNull;
    
    OnsetParams.EndAcc = MaximumTimetoOnsetDetection*ones(1,length(EventTrials));
    AccLLRSpikeEvent = accLR(LRSpikeNoHistEvent,  ...
        OnsetParams.StartofAccumulationTime, OnsetParams.EndAcc);
    Results.NoHist.Event.AccLLR = AccLLRSpikeEvent;

    Results.NoHist.DataParams = SpikeParams;
    Results.NoHist.OnsetParams = OnsetParams;
    Results.NoHist.InputParams = InputParams;
    Results.Type = 'Spike';
    
    if TrialAvgdFlag
        disp(['... Processing up to ' num2str(AnalParams.TrialAvNumTrials(end)) ' Trial Averages']);
        Spike_TrialAv = likTrialAvSpikeNoHistModel(SpikesEvent, SpikesNull, ...
            AnalParams, SpikeParams);
        
        for iNumTrials = 1:length(InputParams.TrialAvNumTrials)
            fprintf(1,'%d ',AnalParams.TrialAvNumTrials(iNumTrials));
            EndAcc = MaximumTimetoOnsetDetection*ones(1,AnalParams.TrialAvIterations(iNumTrials));
            
            AccLLRSpikeEvent = accLR(Spike_TrialAv.LREvent{iNumTrials}, ...
                OnsetParams.StartofAccumulationTime, EndAcc);
            AccLLRSpikeNull = accLR(Spike_TrialAv.LRNull{iNumTrials}, ...
                OnsetParams.StartofAccumulationTime, EndAcc);
            
            [Spike_p, Spike_ST, Spike_Levels] = performance_levels(AccLLRSpikeEvent, ...
                AccLLRSpikeNull);
            Spike_TrialAv.AccLLREvent{iNumTrials} = AccLLRSpikeEvent;
            Spike_TrialAv.AccLLRNull{iNumTrials} = AccLLRSpikeNull;
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

