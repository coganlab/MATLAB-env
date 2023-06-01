function [Elfp] = trialElfp(Trials,sys,ch,field,bn)
%  TRIALELFP loads median filtered lfp data for a trial
%
%  [ELFP] = TRIALELFP(TRIALS, SYS, CH, FIELD, BN)
%
%  Inputs:	TRIALS = Trials data structure
%               SYS =   Scalar/String.  Recording system.
%                   Defaults to 1.  Could also be 'LIP'
%               CH      = Scalar/Vector.  Channel(s) to load data from.
%                   Defaults to all channels in recording
%            	FIELD   = Scalar.  Event to align data to.
%                   Defaults to 'TargOn'
%            	BN      = Vector.  Time to start and stop loading data.
%                   Defaults to [-500,1500].
%
%  Outputs:	ELFP	= [TRIAL,NCH,TIME] or [TRIAL,TIME]. Median filtered lfp data
%

global MONKEYDIR;


if nargin < 4; field = 'TargsOn'; end
if nargin < 5; bn = [-500,1500]; end
%load([MONKEYDIR '/' Trials(1).Day '/' Trials(1).Rec '/rec' Trials(1).Rec '.experiment.mat'])

%Is this what works for Nan drive?
if ischar(sys) || iscell(sys)
    sysnum = findSys(Trials,sys);
else
    sysnum = sys;
end
if(iscell(sys))
    sys = sys{1};
end
%     %This code will work for DoubleMT. What about Nan drive?
%     for i = 1:length(experiment.hardware.microdrive)
%         if strcmp(experiment.hardware.microdrive(i).name(1),sys)
%             SysNum = i;
%         end
%     end

ntr = length(Trials);
CH = Trials(1).Ch(sysnum(1));
%     if nargin < 3; ch = 1:Trials(1).Ch(sysnum(1)); end

olddir = pwd;

Days = {Trials.Day};
Recs = {Trials.Rec};

DayList = unique(Days);
RecList = unique(Recs);
Elfp = zeros(ntr,length(ch),5*diff(bn));
oldrec = '';
clfp_flag = 0;    

day = Trials(1).Day;
for iRec = 1:length(RecList)
    rec = RecList{iRec};
    load([MONKEYDIR '/' day '/' rec '/rec' rec '.Events.mat']);
    cd([MONKEYDIR '/' day '/' rec]);
    fileprefix = ['rec' rec '.' sys];
    if exist([fileprefix '.celfp.dat'],'file'); clfp_flag = 1; disp('Loading cleaned data'); end
    RecInd = find(strcmp(Recs,RecList{iRec}));
    
    for tr = RecInd
        %       disp(['Trial ' num2str(tr) ' out of ' num2str(ntr)]);
        subtrial = Trials(tr).Trial;
        %fileprefix
        if clfp_flag
            Elfp_tmp = loadcelfp(fileprefix,Events,subtrial,field,bn,CH);
        else
            Elfp_tmp = loadelfp(fileprefix,Events,subtrial,field,bn,CH);
        end
        if(CH == 1)
            Elfp(tr,:,:) = Elfp_tmp(:);
        else
            Elfp(tr,:,:) = Elfp_tmp(1,ch,:);
        end
    end
end

if ntr || length(ch)==1
    Elfp = sq(Elfp);
end
cd(olddir);

