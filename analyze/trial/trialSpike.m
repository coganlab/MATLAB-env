function [Spike] = trialSpike(Trials,sys,ch,contact,cl,field,bn,MonkeyDir)
%  TRIALSPIKE loads spike data from a channel for a trial
%
%  [SPIKE] = TRIALSPIKE(TRIALS, SYS, CH, CONTACT, CL, FIELD, BN, MONKEYDIR)
%
%  Inputs:	TRIALS = Trials data structure
%           SYS = Scalar/String.  System/Chamber to load data for
%		    CH	= Scalar.  Channel to load data for.
%                       Defaults to 1
%           CONTACT
%           CL  = Scalar.  Cell to load data for.
%                       Defaults to 1
%               = or Floating point number in which spikes will be loaded
%               depending on peak value
%          	FIELD   = Scalar.  Event to align data to.
%                       Defaults to 'ReachAq'
%         	BN      = Vector.  Time to start and stop loading data.
%                       Defaults to [-500,500];
%           MONKEYDIR = String.  Directory of project data
%                   Defaults to the global MONKEYDIR variable
%
%  Outputs:	SPIKE	= {TRIAL}. Spike data for cell events on electrode.
%
%   Note:  Assumes system <-> chamber assignment is the same for all trials
%
global MONKEYDIR

if nargin < 2 || isempty(sys); sys = Trials(1).MT(1); end
if nargin < 3 || isempty(ch); ch = 1; end
if nargin < 4 || isempty(contact); contact = 1; end
if nargin < 5 || isempty(cl); cl = ones(1,length(ch)); end
if nargin < 6 || isempty(field); field = 'TargsOn'; end
if nargin < 7 || isempty(bn); bn = [-500,500]; end
if nargin < 8 || isempty(MonkeyDir); MonkeyDir = MONKEYDIR; end


if ischar(sys)
    sysnum = findSys(Trials,sys);
end

if(iscell(contact))
    contact = contact{1};
end

% mtch must take into account the contact.  If this is not done then 
% the laminar data will not be loaded correctly.  Let bijan know if
% expChannelIndex is not working on your data.
mtch = getChannelIndex(Trials(1),sys,ch,contact);

ntr = length(Trials);

number = 1;
if length(number)==1
    number = repmat(number,ntr,1);
end

if strcmp(field, 'PulseStarts')
    Spike = {};
else
    Spike = cell(1,ntr);
end
Recs = getRec(Trials);
day = Trials(1).Day;
recs = dayrecs(day, MonkeyDir);
nRecs = length(recs);

% Modifications to support multiunit spike loading

if ~ischar(field); error('FIELD needs to be a string'); end

if(iscell(sys))
    sys = sys{1};
end

if(iscell(cl)); cl = cl{1}; end
if(iscell(cl)); cl = cl{1}; end

load_peaks = 0;
if(length(cl) == 3)
    load_peaks = 1;
    cl = cl(3);
elseif(mod(cl,1) ~= 0)
   load_peaks = 1;    
end


for iRecs = 1:nRecs
    rec = recs{iRecs};
    RecTrials = find(strcmp(Recs,rec));
    nTr = length(RecTrials);
    if nTr
        disp(['Loading up ' num2str(nTr) ' trials'])
        disp(['Loading from ' day ' recording ' rec]);
        EventsFile = [MonkeyDir '/' day '/' rec '/rec' rec '.Events.mat'];
        %pause
        MocapEventsFile = [MonkeyDir '/' day '/' rec '/rec' rec '.MocapEvents.mat'];
        if exist(EventsFile,'file')
            load(EventsFile);
            % Some Events files have MONKEYDIR set. So when you load
            % EventsFile, it silently resets the global MONKEYDIR value,
            % which will break *any* code that relies on MONKEYDIR if your
            % data has ever been moved, since MONKEYDIR is usually a global
            % variable. So, reset MONKEYDIR to the original value:
            MONKEYDIR = MonkeyDir;
            disp('loading event file')
            
        elseif exist(MocapEventsFile,'file')
            disp('loading mocap file')
            load(MocapEventsFile);
            Events = MocapEvents;
        end
        if(load_peaks)
            disp('Loading peak file')
            %[MONKEYDIR '/' day '/' rec '/rec' rec '.' sys '.pk.mat']
            load([MonkeyDir '/' day '/' rec '/rec' rec '.' sys '.pk.mat']);
            if exist([MonkeyDir '/' day '/' rec '/rec' rec '.' sys '.clu.mat'],'file')
                load([MonkeyDir '/' day '/' rec '/rec' rec '.' sys '.clu.mat']); 
            else
                for iElec = 1:length(pk)
                    clear tmp
                    if isempty(pk{iElec})
                        tmp = [];
                    else
                        tmp(:,1) = pk{iElec}(:,1);
                        tmp(:,2) = 1;
                    end
                    clu{iElec} = tmp;
                end
            end
        elseif exist([MonkeyDir '/' day '/' rec '/rec' rec '.' sys '.clu.mat'],'file')
            [MonkeyDir '/' day '/' rec '/rec' rec '.' sys '.clu.mat'];
            load([MonkeyDir '/' day '/' rec '/rec' rec '.' sys '.clu.mat']);
        end
        for iTr = 1:nTr
            tr = RecTrials(iTr);
            subtrial = Trials(tr).Trial;
            num = number(tr);
            %  disp(['Trial ' num2str(tr) ' out of ' num2str(nTr)]);
            if(load_peaks)
                Spike_tmp = loadpeak(pk,clu,Events,subtrial,field,bn,num,mtch);
                tmp = Spike_tmp{1};
                if ~isempty(tmp)  % Check if there is data
                    % What do we do with positive going spikes
                    if(cl<0) % Negative going threshold
                        ind = find(tmp(:,2) < cl);
                    else
                        ind = find(tmp(:,2) > cl);
                    end
                    if ind
                        Spike{tr} = tmp(ind,1);
                    end
                end
            else
                if strcmp(field,'PulseStarts')
                    Spike_tmp = loadspike(clu,Events,subtrial,field,bn,num,mtch);
                    nPulses = size(Spike_tmp,1);

                    for iPulse = 1:nPulses
                        tmp = Spike_tmp{iPulse};
                        if ~isempty(tmp)
                            ind = find(tmp(:,2)==cl);
                            if ind
                                Spike{end+1} = tmp(ind,1);
                            end
                        end
                    end
                else
                    Spike_tmp = loadspike(clu,Events,subtrial,field,bn,num,mtch);
                    tmp = Spike_tmp{1};
                    if ~isempty(tmp)
                        ind = find(tmp(:,2)==cl);
                        if ind
                            Spike{tr} = tmp(ind,1);
                        end
                    end
                end
            end
        end
    end
end

