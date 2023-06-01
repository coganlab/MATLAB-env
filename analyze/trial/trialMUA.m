function [MUA FS] = trialMUA(Trials,sys,electrode,contact,field,bn,MonkeyDir)
%  TRIALMUA loads mua data for a trial
%
%  [MUA] = TRIALMUA(TRIALS, SYS, ELECTRODE, CONTACT, FIELD, BN, MONKEYDIR)
%
%  Inputs:	TRIALS = Trials data structure
%               SYS =   Scalar/String.  Recording system.
%                   Defaults to 1.  Could also be 'LIP'
%               ELECTRODE      = Scalar/Vector.  Channel(s) to load data from.
%                   Defaults to all electrodes in recording
%		CONTACT - Scalar/vector.  Contacts to load data from.
%		    Defaults to all contacts in a recording
%            	FIELD   = Scalar.  Event to align data to.
%                   Defaults to 'TargsOn'
%            	BN      = Vector.  Time to start and stop loading data.
%                   Defaults to [-500 1500].
%               MONKEYDIR = String.  Directory of project data
%                   Defaults to the global MONKEYDIR variable
%
%  Outputs:	MUA = [TRIAL,NCH,TIME] or [TRIAL,TIME]. MUA data
%           FS  = Raw file sampling rate

global MONKEYDIR;



if nargin < 3 || isempty(electrode); electrode = []; end
if nargin < 4 || isempty(contact); contact = 1; end
if nargin < 5 || isempty(field); field = 'TargsOn'; end
if nargin < 6 || isempty(bn); bn = [-500 1500]; end
if nargin < 7 || isempty(MonkeyDir); MonkeyDir = MONKEYDIR; end

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

DayList = unique(Days);
RecList = unique(Recs);
MUA = zeros(ntr,length(mtch),diff(bn));
if strcmp(field, 'PulseStarts')
    MUA = zeros(0,length(mtch),diff(bn));
end

day = Trials(1).Day;
for iRec = 1:length(RecList)
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
    if ~exist([fileprefix '.mua.dat'],'file');
        error('No mua file')
    end
    RecInd = find(strcmp(Recs,RecList{iRec}));
    for tr = RecInd

        subtrial = Trials(tr).Trial;
        
        MUA_tmp = loadmua(fileprefix,Events,subtrial,field,bn,CH);
        
        if strcmp(field, 'PulseStarts')
            if(CH == 1)
                for iPulse = 1:size(MUA_tmp,1)
                    MUA(end+1,:) = MUA_tmp(iPulse, :);
                end
            else
                for iPulse = 1:size(MUA_tmp,1)
                    MUA(end+1,:,:) = MUA_tmp(iPulse,mtch,:);
                end
            end
        else
            if(CH == 1)
                MUA(tr,:,:) = MUA_tmp(:);
            else
                if size(MUA_tmp(1,mtch,:),3) == diff(bn)
                    MUA(tr,:,:) = MUA_tmp(1,mtch,:);
                else
                    MUA(tr,:,:) = nan(1,length(mtch),diff(bn));
                end
            end            
        end
    end
end

if ntr || length(mtch)==1
    MUA = sq(MUA);
end

