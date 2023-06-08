function [Results, Model] = loocalcField(LfpEvent, LfpNull, InputParams, LfpParams)
%
%  [Results, Model] = loocalcField(LfpEvent, LfpNull, InputParams, LfpParams)
%
%
%   InputParams.(MODELTYPE) where MODELTYPE = 'NoHist','Spectral'
%   InputParams.TrialAvgdDetect
%   InputParams.SessionCount
%   InputParams.TrialAvIterations
%   InputParams.StartofAccumulationTime
%   InputParams.MaximumTimetoOnsetDetection
%
%   LfpParams (only needed for 'Spectral');

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
if ~isfield(InputParams,'Spectral')
    SpectralFlag = 0;
else
    SpectralFlag = InputParams.Spectral;
end

if isfield(InputParams, 'SessionCount');
    nSess = InputParams.SessionCount;
else
    nSess = 1;
end

if nSess > 1
    nTrEvent = zeros(1,nSess); nTrNull = zeros(1,nSess);
    nTrMin = zeros(1,nSess);
    for iSess = 1:nSess
        nTrEvent(iSess) = size(LfpEvent{iSess},1);
        nTrNull(iSess) = size(LfpNull{iSess},1);
        nTrMin(iSess) = min([nTrEvent(iSess),nTrNull(iSess)]);
    end
else
    nTrEvent = size(LfpEvent,1);
    nTrNull = size(LfpNull,1);
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
        TrialAvIterations(iNumTrials) = min(tmp(tmp>0));
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

if NoHistFlag
    %  Processing the LFP No History model
    disp('Processing NoHist model')
    disp('... Processing Lfp single trials')
    OnsetParams.ModelType = 'NoHist';
    [LRLfpNoHistEvent, LRLfpNoHistNull, LfpNoHistEventModel, LfpNoHistNullModel] = ...
        likLfpNoHistModel(LfpEvent, LfpNull, LfpParams);
    Results.NoHist.Null.LR = LRLfpNoHistNull;
    Results.NoHist.Event.LR = LRLfpNoHistEvent;
    
    Model.NoHist.Event = LfpNoHistEventModel;
    Model.NoHist.Null = LfpNoHistNullModel;
    Model.Type = 'Field';
    
    if(nSess == 1)
        min_num_trials = size(LfpNull,1);
    else
        min_num_trials = size(LfpNull{1},1);
        for iSess = 2:nSess
            min_num_trials = min(min_num_trials,size(LfpNull{iSess},1));
        end
    end
    OnsetParams.EndAcc = MaximumTimetoOnsetDetection*ones(1,min_num_trials);
    AccLLRLfpNull = accLR(LRLfpNoHistNull,  ...
        OnsetParams.StartofAccumulationTime, OnsetParams.EndAcc);
    Results.NoHist.Null.AccLLR = AccLLRLfpNull;
    
    if(nSess == 1)
        min_num_trials = size(LfpEvent,1);
    else
        min_num_trials = size(LfpEvent{1},1);
        for iSess = 2:nSess
            min_num_trials = min(min_num_trials,size(LfpEvent{iSess},1));
        end
    end
    OnsetParams.EndAcc = MaximumTimetoOnsetDetection*ones(1,min_num_trials);
    AccLLRLfpEvent = accLR(LRLfpNoHistEvent, ...
        OnsetParams.StartofAccumulationTime, OnsetParams.EndAcc);
    Results.NoHist.Event.AccLLR = AccLLRLfpEvent;
    
    Results.NoHist.DataParams = LfpParams;
    Results.NoHist.OnsetParams = OnsetParams;
    Results.NoHist.InputParams = InputParams;
    Results.Type = 'Field';
    
    if TrialAvgdFlag
        maxAverage = max(InputParams.TrialAvNumTrials{end});
        disp(['... Processing up to ' num2str(maxAverage) ' Trial Averages']);
        
        Lfp_TrialAv = likTrialAvLfpNoHistModel(LfpEvent, LfpNull, ...
            InputParams);
        minNumTrials = length(InputParams.TrialAvNumTrials{1});
        for i = 2:length(InputParams.TrialAvNumTrials)
            minNumTrials = min(minNumTrials,length(InputParams.TrialAvNumTrials{i}));
        end
        
        for iNumTrials = 1:minNumTrials
            EndAcc = MaximumTimetoOnsetDetection*ones(1,InputParams.TrialAvIterations(iNumTrials));
            
            AccLLRLfpEvent = accLR(Lfp_TrialAv.LREvent{iNumTrials},  ...
                OnsetParams.StartofAccumulationTime, EndAcc);
            AccLLRLfpNull = accLR(Lfp_TrialAv.LRNull{iNumTrials},  ...
                OnsetParams.StartofAccumulationTime, EndAcc);
            
            [Lfp_p, Lfp_ST, Lfp_Levels] = performance_levels(AccLLRLfpEvent, AccLLRLfpNull);
            Lfp_TrialAv.AccLLREvent{iNumTrials} = AccLLRLfpEvent;
            Lfp_TrialAv.AccLLRNull{iNumTrials} = AccLLRLfpNull;
            Lfp_TrialAv.p{iNumTrials} = Lfp_p;
            Lfp_TrialAv.ST{iNumTrials} = Lfp_ST;
            Lfp_TrialAv.Levels{iNumTrials} = Lfp_Levels;
        end
        fprintf(1,'\n');
        Results.NoHist.TrialAv = Lfp_TrialAv;
    end
end

if SpectralFlag
    %  Processing the LFP Spectral models
    disp('Processing Spectral models')
    disp('... Processing Lfp single trials')
    OnsetParams.ModelType = 'Spectral';
    
    [LRLfpSpectralEvent, LRLfpSpectralNull, LfpSpectralEventModel, LfpSpectralNullModel] = ...
        likLfpSpectralModel(LfpEvent, LfpNull, LfpParams);
    Results.Spectral.Null.LR = LRLfpSpectralNull;
    Results.Spectral.Event.LR = LRLfpSpectralEvent;
    
    Model.Spectral.Event = LfpSpectralEventModel;
    Model.Spectral.Null = LfpSpectralNullModel;
    Model.Type = 'Field';
    
    Dn = LfpParams.Dn; N = LfpParams.Tapers(1);
    if(nSess == 1)
        min_num_trials = size(LfpNull,1);
    else
        min_num_trials = size(LfpNull{1},1);
        for iSess = 2:nSess
            min_num_trials = min(min_num_trials,size(LfpNull{iSess},1));
        end
    end
    OnsetParams.EndAcc = (MaximumTimetoOnsetDetection-N*1e3./2)./(Dn*1e3)*ones(1,min_num_trials);
    AccLLRLfpNull = accLR(LRLfpSpectralNull,  ...
        (OnsetParams.StartofAccumulationTime-N*1e3./2)./(Dn*1e3), OnsetParams.EndAcc);
    Results.Spectral.Null.AccLLR = AccLLRLfpNull;
    
    if(nSess == 1)
        min_num_trials = size(LfpEvent,1);
    else
        min_num_trials = size(LfpEvent{1},1);
        for iSess = 2:nSess
            min_num_trials = min(min_num_trials,size(LfpEvent{iSess},1));
        end
    end
    OnsetParams.EndAcc = (MaximumTimetoOnsetDetection-N*1e3./2)./(Dn*1e3)*ones(1,min_num_trials);
    AccLLRLfpEvent = accLR(LRLfpSpectralEvent, ...
        (OnsetParams.StartofAccumulationTime-N*1e3./2)./(Dn*1e3), OnsetParams.EndAcc);
    Results.Spectral.Event.AccLLR = AccLLRLfpEvent;
    
    Results.Spectral.DataParams = LfpParams;
    Results.Spectral.OnsetParams = OnsetParams;
    Results.Spectral.InputParams = InputParams;
    Results.Type = 'Field';
    if TrialAvgdFlag
        maxAverage = max(InputParams.TrialAvNumTrials{end});
        disp(['... Processing up to ' num2str(maxAverage) ' Trial Averages']);
        
        Lfp_TrialAv = likTrialAvLfpSpectralModel(LfpEvent, LfpNull, ...
            InputParams, LfpParams);
        minNumTrials = length(InputParams.TrialAvNumTrials{1});
        for i = 2:length(InputParams.TrialAvNumTrials)
            minNumTrials = min(minNumTrials,length(InputParams.TrialAvNumTrials{i}));
        end
        for iNumTrials = 1:minNumTrials
            EndAcc = (MaximumTimetoOnsetDetection-N*1e3./2)./(Dn*1e3)*ones(1,InputParams.TrialAvIterations(iNumTrials));
            
            AccLLRLfpEvent = accLR(Lfp_TrialAv.LREvent{iNumTrials},  ...
                (OnsetParams.StartofAccumulationTime-N*1e3./2)./(Dn*1e3), EndAcc);
            AccLLRLfpNull = accLR(Lfp_TrialAv.LRNull{iNumTrials},  ...
                (OnsetParams.StartofAccumulationTime-N*1e3./2)./(Dn*1e3), EndAcc);
            
            [Lfp_p, Lfp_ST, Lfp_Levels] = performance_levels(AccLLRLfpEvent, AccLLRLfpNull);
            Lfp_TrialAv.AccLLREvent{iNumTrials} = AccLLRLfpEvent;
            Lfp_TrialAv.AccLLRNull{iNumTrials} = AccLLRLfpNull;
            Lfp_TrialAv.p{iNumTrials} = Lfp_p;
            Lfp_TrialAv.ST{iNumTrials} = Lfp_ST;
            Lfp_TrialAv.Levels{iNumTrials} = Lfp_Levels;
        end
        Results.Spectral.TrialAv = Lfp_TrialAv;
    end
end

if TrialAvgdFlag
    if NoHistFlag
        Results.NoHist.InputParams.TrialAvNumTrials = InputParams.TrialAvNumTrials{1}(1:minNumTrials);
    end
    if SpectralFlag
        Results.Spectral.InputParams.TrialAvNumTrials = InputParams.TrialAvNumTrials{1}(1:minNumTrials);
    end
end