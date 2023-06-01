function [Raw] = trialRaw(Trials, sys, electrode, contact, field, bn)
%
%  [Raw] = trialRaw(Trials,sys,electrode,contact,field,bn)
%
%  Inputs:      TRIALS = Trials data structure
%               SYS =   Scalar/String.  Recording system.
%                   Defaults to 1.  Could also be 'LIP'
%               ELECTRODE      = Scalar/Vector.  Channel(s) to load data from.
%                   Defaults to all electrodes in recording
%               CONTACT - Scalar/vector.  Contacts to load data from.
%                   Defaults to all contacts in a recording
%               FIELD   = Scalar.  Event to align data to.
%                   Defaults to 'StartOn'
%               BN      = Vector.  Time to start and stop loading data.
%                   Defaults to [-500,1500].
%
%  Outputs:     RAW     = [TRIAL,NCH,TIME] or [TRIAL,TIME]. Raw data
%


global MONKEYDIR;

if nargin < 2; sys = Trials(1).MT(1); end
if nargin < 3; electrode = []; end
if nargin < 4; contact = []; end
if nargin < 5; field = 'StartOn'; end
if nargin < 6; bn = [-500,1500]; end

if iscell(contact); contact = contact{1}; end

Trials;
day = Trials(1).Day;
rec = Trials(1).Rec;
load([MONKEYDIR '/' day '/' rec '/rec' rec '.Rec.mat']);
sys;
FS = Trials(1).Fs; %  This needs to come from exp def file, no?

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
mtch = getChannelIndex(Trials(1), sys, electrode, contact);
if isfile([MONKEYDIR '/' day '/' rec '/rec' rec '.experiment.mat'])
    load([MONKEYDIR '/' day '/' rec '/rec' rec '.experiment.mat'])
    format = experiment.hardware.acquisition.data_format;
else
    format = 'short';
end

olddir = pwd;
Raw = zeros(ntr,length(mtch),diff(bn)*FS/1e3,'single');
if strcmp(field, 'PulseStarts')
    Raw = zeros(0,length(mtch),diff(bn)*FS/1e3, 'single');
end
oldrec = '';
for tr = 1:ntr
    %       disp(['Trial ' num2str(tr) ' out of ' num2str(ntr)]);
    day = Trials(tr).Day;
    rec = Trials(tr).Rec;
    subtrial = Trials(tr).Trial;
    if ~strcmp(rec,oldrec)
        EventsFile = [MONKEYDIR '/' day '/' rec '/rec' rec '.Events.mat'];
        MocapEventsFile = [MONKEYDIR '/' day '/' rec '/rec' rec '.MocapEvents.mat'];
        if exist(EventsFile,'file')
            load(EventsFile);
        elseif exist(MocapEventsFile,'file')
            load(MocapEventsFile);
            Events = MocapEvents;
        end
        cd([MONKEYDIR '/' day '/' rec]);
        fileprefix = ['rec' rec '.' sys];
    end
    oldrec = rec;
    
    Raw_tmp = loadraw(['rec' rec '.' sys],Events,subtrial,field,bn,CH,FS,format);
    if strcmp(field, 'PulseStarts')
        pulses = Events.PulseStarts{subtrial};
        if length(pulses) > 1
            if(CH == 1)
                for iPulse = 1:size(Raw_tmp,1)
                    Raw(end+1,:) = Raw_tmp(iPulse, :);
                end
            else
                for iPulse = 1:size(Raw_tmp,1)
                    Raw(end+1,:,:) = Raw_tmp(iPulse,mtch,:);
                end
            end
        else
            if(CH == 1)
                    Raw(end+1,:) = Raw_tmp(mtch, :);
            else
                    Raw(end+1,:,:) = Raw_tmp(mtch,:);
            end
        end
    else
        if(CH == 1)
            Raw(tr,:) = Raw_tmp;
        else
            Raw(tr,:,:) = Raw_tmp(mtch,:);
        end
    end
end

if ntr || length(mtch)==1
    Raw = sq(Raw);
end
cd(olddir);

