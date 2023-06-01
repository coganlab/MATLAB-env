function [ERP, Data, myTrials] = subjERP(Subject, CondParams, AnalParams)
%
%   [ERP,Data,NTrials] = subjERP(Subject, CondParams, AnalParams)
%
%   SUBJECT     =   Structure array.  Subject information
%   CONDPARAMS =   Data structure.  Parameter information condition
%   ANALPARAMS  =   Data structure.  Analysis parameter information.
%
%   CondParams.Field   =   String.  Alignment field.  
%                           Defaults to 'ResponseStart'
%   CondParams.bn      =   Alignment time.
%                           Defaults to [-2e3,1e3]
%   CondParams.cond    =   StartCode conds
%                           Defaults to []
%   CondParams.PropertyName() = 'Noisy' and/or 'NoResponse'
%   CondParams.PropertyValue() = 0 or 1;
%   CondParams.IntervalName = 'STRING';
%   CondParams.IntervalDuration = [min,max]
%                       IntervalDuration is either in ms or proportions
%                       if min and max are between 0 and 1 IntervalDuration
%                       is a proportion, otherwise a time duration in ms.
%                       For example
%                         IntervalDuration = [0,500] means time duration
%                         IntervalDuration = [0,0.5] means fastest 50% of
%                           intervals
%   CondParams.PropertyName = 'String'  'Noisy' or 'NoResponse'
%   CondParams.PropertyValue = Scalar. 1 or 0.
%
%   AnalParams.Channel =  String/Scalar.  Name/number of channel to study.
%   AnalParams.Reference = String.  Reference type.
%   {CHANNEL_NAME,'Grand average','Single-ended'}
%                           Defaults to 'Single-ended'.
%   AnalParams.TrialPooling =  Scalar.  Trial pooling flag.  0 = save each
%                            trial.  1 = pool trials.  Defaults to 0.
%   AnalParams.ArtifactThreshold = Scalar.  Threshold for artifact
%                           rejection.  Defaults to 6.
%
%

global experiment

% if ~isfield(CondParams,'PropertyName')
%     CondParams.PropertyName{1} = 'Noisy';
%     CondParams.PropertyValue(1) = 0;
%     CondParams.PropertyName{2} = 'NoResponse';
%     CondParams.PropertyValue(2) = 0;
% end

if ~isfield(CondParams,'Field') || isempty(CondParams.Field); 
    CondParams.Field = 'ResponseStart'; 
end
Field = CondParams.Field;

if ~isfield(CondParams,'bn') || isempty(CondParams.bn)
    CondParams.bn = [-2e3,1e3]; 
end
bn = CondParams.bn;

if ~isfield(CondParams,'conds') || isempty(CondParams.conds)
    CondParams.conds = []; 
end
conds = CondParams.conds;

if ~isfield(AnalParams,'Channel') || isempty(AnalParams.Channel)
    error('Need to specify which Channel to analyze')
end
if ~isfield(AnalParams,'Reference') || isempty(AnalParams.Reference)
    Reference = 'Single-Ended';
else
    Reference = AnalParams.Reference;
end
if ~isfield(AnalParams,'TrialPooling') || isempty(AnalParams.TrialPooling)
    flag = 0;
else
    flag = AnalParams.TrialPooling;
end
if ~isfield(AnalParams,'ArtifactThreshold') || isempty(AnalParams.ArtifactThreshold)
    thresh = 6;
else
    thresh = AnalParams.ArtifactThreshold;
end
if ~isfield(AnalParams,'ReferenceChannels') || isempty(AnalParams.ReferenceChannels)
    ReferenceChannels = 1:64;
else
    ReferenceChannels = AnalParams.ReferenceChannels;
end

% This handles Trials in Subject.Trials and same for experiment. 
if isfield(Subject, 'Trials')
    Trials = Subject.Trials;
else
    Trials = dbTrials(Subject.Name,Subject.Day);
end
if isfield(Subject, 'Experiment')
    experiment = Subject.Experiment;
else
    experiment = loadExperiment(Subject.Name);
end

Trials = Params2Trials(Trials,CondParams);

sampling = experiment.processing.ieeg.sample_rate;
channels = experiment.channels;
[Channel_names{1:length(channels)}] = deal(channels.name);
    
if ischar(AnalParams.Channel)
    [dum,Ch] = intersect(Channel_names,AnalParams.Channel);
elseif iscell(AnalParams.Channel)
    Ch = zeros(1,length(AnalParams.Channel));
    for iCh = 1:length(AnalParams.Channel)
     [dum,Ch(iCh)] = intersect(Channel_names,AnalParams.Channel{iCh});
    end
else
    Ch = AnalParams.Channel;
end

if ischar(ReferenceChannels)
    try
        [dum,ReferenceChannelNums] = intersect(Channel_names,ReferenceChannels);
    catch
        ReferenceChannelNums = 1:64;
    end
elseif iscell(ReferenceChannels)
    ReferenceChannelNums = zeros(1,length(ReferenceChannels));
    for iCh = 1:length(ReferenceChannels)
        try
            [dum,ReferenceChannelNums(iCh)] = intersect(Channel_names,ReferenceChannels{iCh});
        catch
            ReferenceChannelNums(iCh) = iCh; 
        end
    end
else
    ReferenceChannelNums = ReferenceChannels;
end

IEEG = trialIEEG(Trials, Ch, Field,bn);
ind = [];
for iCh =1:size(IEEG,2)
    tmp = sq(IEEG(:,iCh,:));
    th = thresh*std(tmp(:));
    e = max(abs(tmp'));
    ind = [ind find(e>th)]; %#ok<AGROW>
end
badtrials = unique(ind);
goodtrials = setdiff(1:length(Trials),badtrials);

switch Reference
    case 'Single-ended'
        if length(Ch) > 1
            ERP = cell(1,length(Ch));
            IEEG = IEEG(goodtrials,:,:);
            for iCh = 1:length(Ch)
                ERP{iCh} = sq(mean(IEEG(:,iCh,:)));
            end
        else
            IEEG = IEEG(goodtrials,:);
            ERP = mean(IEEG);
        end
        Data.IEEG = IEEG;
    case 'Grand average'
%         channels = experiment.channels;
%         [Channel_names{1:length(channels)}] = deal(channels.name);
%         for iCh = 1:length(ReferenceChannelNums)
%             try
%                 [dum, Grid_Channels(iCh)] = intersect(Channel_names,ReferenceChannels(iCh)); %#ok<AGROW>
%             catch me %#ok<NASGU>
%                 Grid_Channels(iCh) = ReferenceChannels(iCh); %#ok<AGROW>
%             end
%         end
        Trials = Trials(goodtrials); 
        GAR_IEEG = trialIEEG(Trials, ReferenceChannelNums, Field, ...
            bn);
        GAR_IEEG = sq(mean(GAR_IEEG,2));
        
        if length(Ch)>1
            ERP = cell(1,length(Ch));
            IEEG = IEEG(goodtrials,:,:);
            for iCh = 1:length(Ch)
                gIEEG = sq(IEEG(:,iCh,:)) - GAR_IEEG;
                %Data.IEEG(:,iCh,:) = gIEEG;
                ERP{iCh} = mean(gIEEG);
                Data.IEEG(iCh,:,:) = gIEEG;
            end
        else
            IEEG = IEEG(goodtrials,:);
            gIEEG = IEEG - GAR_IEEG;
            ERP = mean(gIEEG);
            Data.IEEG = gIEEG;
        end
end


myTrials = Trials;

