function [Spec, Data, myTrials, goodtrials, Err] = subjSpectrum(Subject, CondParams, AnalParams, goodtrials)
%
%   [Spec,Data,NTrials, Err] = subjSpectrum(Subject, CondParams, AnalParams)
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
%   AnalParams.Tapers  =  [N,W] Spectral analysis parameters.
%                           Defaults to [.5,5]
%   AnalParams.fk      =  Vector.  Select frequency band to keep.
%                           Defaults to 200
%   AnalParams.Channel =  String/Scalar.  Name/number of channel to study.
%   AnalParams.pad     =  Scalar.
%                           Defaults to 2;
%   AnalParams.Reference = String.  Reference type.
%   {CHANNEL_NAME,'Grand average','Single-ended'}
%                           Defaults to 'Single-ended'.
%   AnalParams.TrialPooling =  Scalar.  Trial pooling flag.  0 = save each
%                            trial.  1 = pool trials.  Defaults to 0.
%   AnalParams.ArtifactThreshold = Scalar.  Threshold for artifact
%                           rejection.  Defaults to 6.
%
%   AnalParams.Errorbar.Type = String.  'Chi-squared' or 'Jacknife';
%                               Defaults to 'Chi-squared'
%   AnalParams.Errorbar.P_val = Scalar.  P-value for errorbar.
%                               Defaults to 0.05
%
%

global experiment

if ~isfield(CondParams,'PropertyName')
    CondParams.PropertyName{1} = 'Noisy';
    CondParams.PropertyValue{1} = 0;
   CondParams.PropertyName{2} = 'NoResponse';
   CondParams.PropertyValue{2} = [0,1];
 %   CondParams.PropertyValue{2} = 0;
end

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

if ~isfield(AnalParams,'Tapers') || isempty(AnalParams.Tapers)
    tapers = [.5,5];
else
    tapers = AnalParams.Tapers;
end
if ~isfield(AnalParams,'dn') || isempty(AnalParams.dn)
    dn = 0.05;
else
    dn = AnalParams.dn;
end
if ~isfield(AnalParams,'fk') || isempty(AnalParams.fk)
    fk = 200;
else
    fk = AnalParams.fk;
end
if ~isfield(AnalParams,'pad') || isempty(AnalParams.pad)
    pad = 2;
else
    pad = AnalParams.pad;
end
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
    ReferenceChannels = [1:64];
else
    ReferenceChannels = AnalParams.ReferenceChannels;
end
if ~isfield(AnalParams,'Errorbar') || isempty(AnalParams.Errorbar)
    errorbar_flag = 0;
else
    errorbar_flag = 1;
    Errorbar = AnalParams.Errorbar;
    if ~isfield(Errorbar,'Type') || isempty(Errorbar.Type)
        Errorbar.Type = 'Chi-squared';
    end
    if ~isfield(Errorbar,'P_val') || isempty(Errorbar.P_val)
        Errorbar.P_val = 0.05;
    end
end
% This handles Trials in Subject.Trials and same for experiment.
if isfield(Subject, 'Trials')
    Trials = Subject.Trials;
else
    Trials = dbTrials(Subject.Name,Subject.Day);
end
% UNCOMMENT THIS PART
% if isfield(Subject, 'Experiment')
%     experiment = Subject.Experiment;
% else
%     experiment = loadExperiment(Subject.Name);
% end

Trials = Params2Trials(Trials,CondParams);
whos Trials

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

% disp(['Calculating spectrum with N = ' ...
%     num2str(N) ' and W = ' num2str(W)]);
N = tapers(1);

IEEG = trialIEEG(Trials, Ch, Field, ...
    [bn(1)-N./2*1e3,bn(2)+N./2*1e3]);
ind = [];
ind2 = [];
for iCh =1:size(IEEG,2)
    tmp = sq(IEEG(:,iCh,:));
    th = thresh*std(tmp(:));
    e = max(abs(tmp')); % Finds the maximum SINGLE point
    ind = [ind find(e>th)];%#ok<AGROW>
    ind2 = [ind2 find(e==0)];
end
badtrials = unique(ind);
bd2=unique(ind2);
badtrials=[badtrials bd2];
if ~exist('goodtrials', 'var')
    goodtrials = setdiff(1:length(Trials),badtrials);
end

switch Reference
    case 'Single-ended'
        Trials = Trials(goodtrials);
     
        
        if length(Ch)>1
            IEEG = IEEG(goodtrials,:,:);
            Spec = cell(1,length(Ch));
            if errorbar_flag
                Err = cell(1,length(Ch));
                for iCh = 1:length(Ch)
                    if length(goodtrials) > 1
                        gIEEG = sq(IEEG(:,iCh,:));
                        
                        %gIEEG = sq(IEEG(:,iCh,:))-sq(mean(GAR_IEEG(:,iCh,:),2));
%                         % add in mean subtract
%                         for iTrial=1:size(gIEEG,1)
%                             gIEEG(iTrial,:,:)=sq(gIEEG(iTrial,:,:))-mean(gIEEG(iTrial,:,:),3);
%                         end
%                                   
                    else
                        gIEEG = sq(IEEG(:,iCh,:))';
                        
                    end
                    [Spec{iCh}, dum, Err{iCh}] = tfspec(gIEEG,tapers,sampling,dn,fk,pad,Errorbar.P_val,flag,[],Errorbar);
                end
            else
                for iCh = 1:length(Ch)
                    if length(goodtrials) > 1
                        gIEEG = sq(IEEG(:,iCh,:));
                         Spec{iCh} = tfspec(gIEEG,tapers,sampling,dn,fk,pad,[],flag);
                    elseif length(goodtrials) == 1
                        gIEEG = sq(IEEG(:,iCh,:))';
                         Spec{iCh} = tfspec(gIEEG,tapers,sampling,dn,fk,pad,[],flag);
                    else
                        gIEEG = [];
                    end
                    %Spec{iCh} = tfspec(gIEEG,tapers,sampling,dn,fk,pad,[],flag);
                end
            end
            Data.IEEG = gIEEG;
        else
            IEEG = IEEG(goodtrials,:);
            gIEEG = IEEG;
            if errorbar_flag
                [Spec,dum,Err] = tfspec(gIEEG,tapers,sampling,dn,fk,pad,Errorbar.P_val,flag,[],Errorbar);
            else
                Spec = tfspec(gIEEG,tapers,sampling,dn,fk,pad,[],flag);
            end
            Data.IEEG = gIEEG;
        end
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
            [bn(1)-N./2*1e3,bn(2)+N./2*1e3]);
        if length(goodtrials)> 1
            GAR_IEEG = sq(mean(GAR_IEEG,2));
        else
            GAR_IEEG = sq(mean(GAR_IEEG,1));
        end
        
        if length(Ch)>1
            IEEG = IEEG(goodtrials,:,:);
            Spec = cell(1,length(Ch));
            if errorbar_flag
                Err = cell(1,length(Ch));
                for iCh = 1:length(Ch)
                    if length(goodtrials) > 1
                        gIEEG = sq(IEEG(:,iCh,:)) - GAR_IEEG;
                        
                        %gIEEG = sq(IEEG(:,iCh,:))-sq(mean(GAR_IEEG(:,iCh,:),2));
%                         % add in mean subtract
%                         for iTrial=1:size(gIEEG,1)
%                             gIEEG(iTrial,:,:)=sq(gIEEG(iTrial,:,:))-mean(gIEEG(iTrial,:,:),3);
%                         end
%                                   
                    else
                        gIEEG = sq(IEEG(:,iCh,:))' - GAR_IEEG;
                        
                    end
                    [Spec{iCh}, dum, Err{iCh}] = tfspec(gIEEG,tapers,sampling,dn,fk,pad,Errorbar.P_val,flag,[],Errorbar);
                end
            else
                for iCh = 1:length(Ch)
                    if length(goodtrials) > 1
                        gIEEG = sq(IEEG(:,iCh,:)) - GAR_IEEG;
                         Spec{iCh} = tfspec(gIEEG,tapers,sampling,dn,fk,pad,[],flag);
                    elseif length(goodtrials) == 1
                        gIEEG = sq(IEEG(:,iCh,:))' - GAR_IEEG;
                         Spec{iCh} = tfspec(gIEEG,tapers,sampling,dn,fk,pad,[],flag);
                    else
                        gIEEG = [];
                    end
                    %Spec{iCh} = tfspec(gIEEG,tapers,sampling,dn,fk,pad,[],flag);
                end
            end
            Data.IEEG = gIEEG;
        else
            IEEG = IEEG(goodtrials,:);
            gIEEG = IEEG - GAR_IEEG;
            if errorbar_flag
                [Spec,dum,Err] = tfspec(gIEEG,tapers,sampling,dn,fk,pad,Errorbar.P_val,flag,[],Errorbar);
            else
                Spec = tfspec(gIEEG,tapers,sampling,dn,fk,pad,[],flag);
            end
            Data.IEEG = gIEEG;
        end
end

myTrials = Trials;

