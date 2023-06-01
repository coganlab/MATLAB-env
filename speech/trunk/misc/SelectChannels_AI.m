function [NumTrials, commonind, OkTrials] = SelectChannels(Trials, CondParams, AnalParams)
%
%  SelectedChannels = SelectChannels(Trials, CondParams, AnalParams)
%

global experiment

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

if ~isfield(CondParams,'PropertyName')
    CondParams.PropertyName{1} = 'Noisy';
    CondParams.PropertyValue{1} = 0;
    CondParams.PropertyName{2} = 'NoResponse';
    CondParams.PropertyValue{2} = 0;
end

if ~isfield(AnalParams,'Tapers') || isempty(AnalParams.Tapers)
    tapers = [.5,5]; 
else
    tapers = AnalParams.Tapers;
end
if ~isfield(AnalParams,'Channel') || isempty(AnalParams.Channel)
    error('Need to specify which Channel to analyze')
end
if ~isfield(AnalParams,'ArtifactThreshold') || isempty(AnalParams.ArtifactThreshold)
    thresh = 6;
else
    thresh = AnalParams.ArtifactThreshold;
end

Trials = Params2Trials(Trials,CondParams);

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
N = tapers(1);
disp('Loading IEEG')
IEEG = trialIEEG(Trials, Ch, Field, [bn(1)-N./2*1e3,bn(2)+N./2*1e3]);

NumTrials = zeros(1,length(Ch));
ind=[];
commonind=[];
for iCh = 1:length(Ch)
    tmp = sq(IEEG(:,iCh,:));
    sd = std(tmp(:));
    e = max(abs(tmp'));
    if thresh < 100   % ArtifactTheshold is in terms of SD
        th = thresh.*sd; 
    else
        th = 10*thresh;  % ArtifactTheshold is in terms of uV, account for preamp gain
    end
    NumTrials(iCh) = length(find(e<th));
    ind=find(e<th);
    if iCh==1
        commonind=ind;
    else
        commonind=intersect(ind,commonind);
    end
    OkTrials{iCh}=ind;
end
