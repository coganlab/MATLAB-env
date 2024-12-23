function [Coh, Spec1, Spec2, Data, myTrials] = subjCoherency3B(Subject, CondParams, AnalParams)
%
%   [Coh,Spec1, Spec2,Data,NTrials] = subjCoherency(Subject, CondParams, AnalParams)
%
% Computers local reference channels (3 neighbors non overlapping)

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
%   AnalParams.Channel =  String/Scalar.  Name/number of channels to study.
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
%nyumc;
global experiment



if ~isfield(CondParams,'PropertyName')
    CondParams.PropertyName{1} = 'Noisy';
    CondParams.PropertyValue{1} = 0;
    CondParams.PropertyName{2} = 'NoResponse';
    CondParams.PropertyValue{2} = [0,1];
end

if ~isfield(CondParams,'Field') || isempty(CondParams.Field); 
    CondParams.Field = 'ResponseStart'; 
end
Field = CondParams.Field;

if ~isfield(CondParams,'bn') || isempty(CondParams.bn)
    CondParams.bn = [-2e3,1e3]; 
end
bn = CondParams.bn;

if ~isfield(CondParams,'Conds') || isempty(CondParams.Conds)
    CondParams.Conds = []; 
end
conds = CondParams.Conds;

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
    error('Need to specify which Channels to analyze')
end
if ~isfield(AnalParams,'Reference') || isempty(AnalParams.Reference)
    Reference = 'Single-ended';
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
    Ch = AnalParams.Channel';
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

UniqueCh = unique(Ch(:));
IEEG = trialIEEG(Trials, UniqueCh, Field, ...
    [bn(1)-N./2*1e3,bn(2)+N./2*1e3]);
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
        
%         IEEG = IEEG(goodtrials,:,:);
%         if length(Ch) > 2
%             Spec = cell(1,length(Ch));
%             
%         else
%             Data.IEEG1 = sq(IEEG(:,1,:));
%             Data.IEEG2 = sq(IEEG(:,2,:));
%             [Coh, f, Spec1, Spec2] = tfcoh(sq(IEEG(:,1,:)),sq(IEEG(:,2,:)),tapers,sampling,dn,fk,pad,[],flag);
%             display('single')
%         end
%         Data.IEEG = IEEG;
 IEEG = IEEG(goodtrials,:,:);
        Trials = Trials(goodtrials); 
       % GAR_IEEG = trialIEEG(Trials, ReferenceChannelNums, Field, ...
        %    [bn(1)-N./2*1e3,bn(2)+N./2*1e3]);
        %GAR_IEEG = sq(mean(GAR_IEEG,2));
        
        if size(Ch,1)>1
            Coh = cell(1,size(Ch,1));
            for iChPair = 1:size(Ch,1)
               
                for iChPair2=(iChPair+1):size(Ch,1);
                %tic
                %disp(num2str(iChPair));
                %Chs1 = find(UniqueCh == Ch(iChPair,1));
                %Chs2 = find(UniqueCh == Ch(iChPair,2));
                Chs1=iChPair;
                Chs2=iChPair2;
                gIEEG1 = sq(IEEG(:,Chs1,:));
                gIEEG2 = sq(IEEG(:,Chs2,:));
                [Coh{iChPair}{iChPair2}, f, Spec1, Spec2] = tfcoh(gIEEG1,gIEEG2,tapers,sampling,dn,fk,pad,[],flag);
                display('Right')
                %toc
                end
            end
            Data = [];
        else
            gIEEG1 = sq(IEEG(:,1,:));
            gIEEG2 = sq(IEEG(:,2,:));
            if errorbar_flag
                [Coh, f, Spec1, Spec2] = tfcoh(gIEEG1,gIEEG2,tapers,sampling,dn,fk,pad,[],flag);
            else
                [Coh, f, Spec1, Spec2] = tfcoh(gIEEG1,gIEEG2,tapers,sampling,dn,fk,pad,[],flag);
            end
            Data.IEEG1 = gIEEG1;
            Data.IEEG2 = gIEEG2;
            display('wrong')
        end

    case 'Grand average'
        IEEG = IEEG(goodtrials,:,:);
        Trials = Trials(goodtrials); 
        GAR_IEEG = trialIEEG(Trials, ReferenceChannelNums, Field, ...
            [bn(1)-N./2*1e3,bn(2)+N./2*1e3]);
        GAR_IEEG = sq(mean(GAR_IEEG,2));
        
        if size(Ch,1)>1
            Coh = cell(1,size(Ch,1));
            for iChPair = 1:size(Ch,1)
               
                for iChPair2=(iChPair+1):size(Ch,1);
                %tic
                %disp(num2str(iChPair));
                %Chs1 = find(UniqueCh == Ch(iChPair,1));
                %Chs2 = find(UniqueCh == Ch(iChPair,2));
                Chs1=iChPair;
                Chs2=iChPair2;
                gIEEG1 = sq(IEEG(:,Chs1,:)) - GAR_IEEG;
                gIEEG2 = sq(IEEG(:,Chs2,:)) - GAR_IEEG;
                [Coh{iChPair}{iChPair2}, f, Spec1, Spec2] = tfcoh(gIEEG1,gIEEG2,tapers,sampling,dn,fk,pad,[],flag);
                display('Right')
                %toc
                end
            end
            Data = [];
        else
            gIEEG1 = sq(IEEG(:,1,:)) - GAR_IEEG;
            gIEEG2 = sq(IEEG(:,2,:)) - GAR_IEEG;
            if errorbar_flag
                [Coh, f, Spec1, Spec2] = tfcoh(gIEEG1,gIEEG2,tapers,sampling,dn,fk,pad,[],flag);
            else
                [Coh, f, Spec1, Spec2] = tfcoh(gIEEG1,gIEEG2,tapers,sampling,dn,fk,pad,[],flag);
            end
            Data.IEEG1 = gIEEG1;
            Data.IEEG2 = gIEEG2;
            display('wrong')
        end
  case 'Local average'
      testmatrix=1:64;
    testmatrix=reshape(testmatrix,8,8);
    testmatrix=testmatrix';

    nextvals=zeros(64,3);
%bordervals1=[1,9,17,25,33,41,49];
    bordervals2=[8,16,24,32,40,48,56];
    bordervals3=[57:63];

    for iChan=1:64;
    nextvals(iChan,1)=iChan+1;
    nextvals(iChan,2)=iChan+8;
    nextvals(iChan,3)=iChan+9;
    end

    for iB2=1:length(bordervals2);
    nextvals(bordervals2(iB2),1)=bordervals2(iB2)-1;
    nextvals(bordervals2(iB2),3)=bordervals2(iB2)+7;
    end
    for iB3=1:length(bordervals3)
    nextvals(bordervals3(iB3),2)=bordervals3(iB3)-8;
    nextvals(bordervals3(iB3),3)=bordervals3(iB3)-7;
    end

    nextvals(64,1)=63;
    nextvals(64,2)=56;
    nextvals(64,3)=55;
      
        IEEG = IEEG(goodtrials,:,:);
        Trials = Trials(goodtrials); 
        GAR_IEEG = trialIEEG(Trials, ReferenceChannelNums, Field, ...
            [bn(1)-N./2*1e3,bn(2)+N./2*1e3]);
        %GAR_IEEG = sq(mean(GAR_IEEG,2));
  
        if size(Ch,1)>1
            Coh = cell(1,size(Ch,1));
            for iChPair = 1:size(Ch,1)
               
                for iChPair2=(iChPair+1):size(Ch,1);
                %tic
                %disp(num2str(iChPair));
                %Chs1 = find(UniqueCh == Ch(iChPair,1));
                %Chs2 = find(UniqueCh == Ch(iChPair,2));
                Chs1=iChPair;
                Chs2=iChPair2;
                GAR_IEEG2A=sq(mean(GAR_IEEG(:,nextvals(Chs1,:),:),2));
                GAR_IEEG2B=sq(mean(GAR_IEEG(:,nextvals(Chs2,:),:),2));
                gIEEG1 = sq(IEEG(:,Chs1,:)) - GAR_IEEG2A;
                gIEEG2 = sq(IEEG(:,Chs2,:)) - GAR_IEEG2B;
                [Coh{iChPair}{iChPair2}, f, Spec1, Spec2] = tfcoh(gIEEG1,gIEEG2,tapers,sampling,dn,fk,pad,[],flag);
                display('Right Yes')
                %toc
                end
            end
            Data = [];
        else
            gIEEG1 = sq(IEEG(:,1,:)) - GAR_IEEG;
            gIEEG2 = sq(IEEG(:,2,:)) - GAR_IEEG;
            if errorbar_flag
                [Coh, f, Spec1, Spec2] = tfcoh(gIEEG1,gIEEG2,tapers,sampling,dn,fk,pad,[],flag);
            else
                [Coh, f, Spec1, Spec2] = tfcoh(gIEEG1,gIEEG2,tapers,sampling,dn,fk,pad,[],flag);
            end
            Data.IEEG1 = gIEEG1;
            Data.IEEG2 = gIEEG2;
            display('wrong')
        end   
  case 'Bipolar'
        IEEG = IEEG(goodtrials,:,:);
        Trials = Trials(goodtrials); 
        oddindex=1:2:64;
        evenindex=2:2:64;
        IEEG=IEEG(:,evenindex,:)-IEEG(:,oddindex,:);
        %GAR_IEEG = trialIEEG(Trials, ReferenceChannelNums, Field, ...
         %   [bn(1)-N./2*1e3,bn(2)+N./2*1e3]);
        %GAR_IEEG = sq(mean(GAR_IEEG,2));
        Ch=1:32;
        Ch=Ch';
        if size(Ch,1)>1
            Coh = cell(1,size(Ch,1));
            for iChPair = 1:size(Ch,1)
               
                for iChPair2=(iChPair+1):size(Ch,1);
                %tic
                %disp(num2str(iChPair));
                %Chs1 = find(UniqueCh == Ch(iChPair,1));
                %Chs2 = find(UniqueCh == Ch(iChPair,2));
                Chs1=iChPair;
                Chs2=iChPair2;
                gIEEG1 = sq(IEEG(:,Chs1,:));
                gIEEG2 = sq(IEEG(:,Chs2,:));
                [Coh{iChPair}{iChPair2}, f, Spec1, Spec2] = tfcoh(gIEEG1,gIEEG2,tapers,sampling,dn,fk,pad,[],flag);
                display('Right Yes')
                %toc
                end
            end
            Data = [];
        else
            gIEEG1 = sq(IEEG(:,1,:)) - GAR_IEEG;
            gIEEG2 = sq(IEEG(:,2,:)) - GAR_IEEG;
            if errorbar_flag
                [Coh, f, Spec1, Spec2] = tfcoh(gIEEG1,gIEEG2,tapers,sampling,dn,fk,pad,[],flag);
            else
                [Coh, f, Spec1, Spec2] = tfcoh(gIEEG1,gIEEG2,tapers,sampling,dn,fk,pad,[],flag);
            end
            Data.IEEG1 = gIEEG1;
            Data.IEEG2 = gIEEG2;
            display('wrong')
        end
        
        
end

myTrials = Trials;

