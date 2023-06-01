function [Lfp] = trialLfp(Trials,sys,electrode,contact,field,bn,MonkeyDir)
%  TRIALLFP loads lfp data for a trial
%
%  [LFP] = TRIALLFP(TRIALS, SYS, ELECTRODE, CONTACT, FIELD, BN, MONKEYDIR)
%
%  Inputs:	TRIALS = Trials data structure
%               SYS =   Scalar/String.  Recording system.
%                   Defaults to 1.  Could also be 'LIP'
%               ELECTRODE      = Scalar/Vector.  Channel(s) to load data from.
%                   Defaults to all electrodes in recording
%		CONTACT - Scalar/vector.  Contacts to load data from.
%		    Defaults to all contacts in a recording
%            	FIELD   = Scalar.  Event to align data to.
%                   Defaults to 'StartOn'
%            	BN      = Vector.  Time to start and stop loading data.
%                   Defaults to [-500,1500].
%               MONKEYDIR = String.  Directory of project data
%                   Defaults to the global MONKEYDIR variable
%
%  Outputs:	LFP	= [TRIAL,NCH,TIME] or [TRIAL,TIME]. Lfp data
%

global MONKEYDIR;


if nargin < 2 || isempty(sys); sys = Trials(1).MT(1); end
if nargin < 3 || isempty(electrode); electrode = []; end
if nargin < 4 || isempty(contact); contact = 1; end
if nargin < 5 || isempty(field); field = 'StartOn'; end
if nargin < 6 || isempty(bn); bn = [-500,1500]; end
if nargin < 7 || isempty(MonkeyDir); MonkeyDir = MONKEYDIR; end
%load([MONKEYDIR '/' Trials(1).Day '/' Trials(1).Rec '/rec' Trials(1).Rec '.experiment.mat'])

if iscell(contact); contact = contact{1}; end

%Is this what works for Nan drive?
if ischar(sys) || iscell(sys)
    sysnum = findSys(Trials,sys);
else
    sysnum = sys;
end
if(iscell(sys))
    sys = sys{1};
end

ntr = length(Trials);

CH = length(getChannelIndex(Trials(1), sys)); % if you do not input electrode, returns total number of channels in system
mtch = getChannelIndex(Trials(1),sys,electrode,contact);

Days = {Trials.Day};
Recs = {Trials.Rec};
day = Trials(1).Day;
rec = Trials(1).Rec;
if isfile([MONKEYDIR '/' day '/' rec '/rec' rec '.experiment.mat'])
    load([MONKEYDIR '/' day '/' rec '/rec' rec '.experiment.mat'])
    format = experiment.hardware.acquisition.data_format;
else
    format = 'short';
end

dsplfp_flag = 0;
mlfp_flag = 0;
clfp_flag = 0;

DayList = unique(Days);
RecList = unique(Recs);
Lfp = zeros(ntr,length(mtch),diff(bn));
if strcmp(field, 'PulseStarts')
    Lfp = zeros(0,length(mtch),diff(bn));
end

day = Trials(1).Day;
for iRec = 1:length(RecList)
    clfp_flag = 0;
    dsplfp_flag = 0;
    rec = RecList{iRec};
    EventsFile = [MonkeyDir '/' day '/' rec '/rec' rec '.Events.mat'];
    MocapEventsFile = [MonkeyDir '/' day '/' rec '/rec' rec '.MocapEvents.mat'];
    if exist(EventsFile,'file')
        load(EventsFile);
    elseif exist(MocapEventsFile,'file')
        load(MocapEventsFile);
        Events = MocapEvents;
    else
        EventsFile
        error('No events file')
    end

    fileprefix = [MonkeyDir '/' day '/' rec '/rec' rec '.' sys];
    if exist([fileprefix '.dsplfp.dat'],'file');
        dsplfp_flag = 1; %disp('Loading spike denoised data');
    elseif exist([fileprefix '.clfp.dat'],'file');
        clfp_flag = 1; %disp('Loading cleaned data');
    elseif exist([fileprefix '.mlfp.dat'],'file');
        mlfp_flag = 1; %disp('Loading median filtered data');
    end
    RecInd = find(strcmp(Recs,RecList{iRec}));
    
    for tr = RecInd
          %    disp(['Trial ' num2str(tr) ' out of ' num2str(ntr)]);
        subtrial = Trials(tr).Trial;
        %fileprefix

        if dsplfp_flag
            Lfp_tmp = loaddsplfp(fileprefix,Events,subtrial,field,bn,CH);
        elseif clfp_flag
            Lfp_tmp = loadclfp(fileprefix,Events,subtrial,field,bn,CH);
        elseif mlfp_flag
            Lfp_tmp = loadmlfp(fileprefix,Events,subtrial,field,bn,CH);
        else
            Lfp_tmp = loadlfp(fileprefix,Events,subtrial,field,bn,CH);
        end
        if strcmp(field, 'PulseStarts')
            if(CH == 1)
                for iPulse = 1:size(Lfp_tmp,1)
                    Lfp(end+1,:) = Lfp_tmp(iPulse, :);
                end
            else
                for iPulse = 1:size(Lfp_tmp,1)
                    Lfp(end+1,:,:) = Lfp_tmp(iPulse,mtch,:);
                end
            end
        else
            if(CH == 1)
                Lfp(tr,:,:) = Lfp_tmp(:);
            else
                if size(Lfp_tmp(1,mtch,:),3) == diff(bn)
                    Lfp(tr,:,:) = Lfp_tmp(1,mtch,:);
                else
                    Lfp(tr,:,:) = nan(1,length(mtch),diff(bn));
                end
            end            
        end
    end
end

if ntr || length(mtch)==1
    Lfp = sq(Lfp);
end

