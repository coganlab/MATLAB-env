function [Mu] = trialMu(Trials,sys,electrode,contact,field,bn)
%
%  [Mu] = trialMu(Trials,sys,electrode,contact,field,bn)
%


global MONKEYDIR;

if nargin < 2; sys = Trials(1).MT1; end
if nargin < 3; electrode = []; end
if nargin < 4; contact = []; end

if nargin < 5; field = 'TargsOn'; end
if nargin < 6; bn = [-500,1500]; end

day = Trials(1).Day;
rec = Trials(1).Rec;
load([MONKEYDIR '/' day '/' rec '/rec' rec '.experiment.mat']);
sys;
FS = experiment.hardware.acquisition.samplingrate;

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


olddir = pwd;
Mu = zeros(ntr,length(mtch),diff(bn)*FS/1e3,'single');
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
    
    Mu_tmp = loadmu(['rec' rec '.' sys],Events,subtrial,field,bn,CH,FS);
    if strcmp(field, 'PulseStarts')
        if(CH == 1)
            for iPulse = 1:size(Mu_tmp,1)
                Mu(end+1,:) = Mu_tmp(iPulse, :);
            end
        else
            for iPulse = 1:size(Mu_tmp,1)
                Mu(end+1,:,:) = Mu_tmp(iPulse,mtch,:);
            end
        end
    else
        if(CH == 1)
            Mu(tr,:) = Mu_tmp;
        else
            Mu(tr,:,:) = Mu_tmp(mtch,:);
        end
    end
end

if ntr || length(mtch)==1
    Mu = sq(Mu);
end
cd(olddir);

