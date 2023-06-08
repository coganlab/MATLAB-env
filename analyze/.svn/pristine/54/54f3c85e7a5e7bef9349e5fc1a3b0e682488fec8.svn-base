function [Mlfp] = trialMlfp(Trials,sys,ch,field,bn)
%  TRIALMLFP loads median filtered lfp data for a trial
%
%  [MLFP] = TRIALMLFP(TRIALS, SYS, CH, FIELD, BN)
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
%  Outputs:	MLFP	= [TRIAL,NCH,TIME] or [TRIAL,TIME]. Median filtered lfp data
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

day = Trials(1).Day;
rec = Trials(1).Rec;
if isfile([MONKEYDIR '/' day '/' rec '/rec' rec '.experiment.mat'])
    load([MONKEYDIR '/' day '/' rec '/rec' rec '.experiment.mat'])
    format = experiment.hardware.acquisition.data_format;
else
    format = 'short';
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
Mlfp = zeros(ntr,length(ch),diff(bn));
if strcmp(field, 'PulseStarts')
    Mlfp = zeros(0,length(ch),diff(bn));
end
oldrec = '';

for iRec = 1:length(RecList)
    clfp_flag = 0;
    dsplfp_flag = 0;
    rec = RecList{iRec};
    load([MONKEYDIR '/' day '/' rec '/rec' rec '.Events.mat']);
    cd([MONKEYDIR '/' day '/' rec]);
    fileprefix = ['rec' rec '.' sys];
    if exist([fileprefix '.dsplfp.dat'],'file');
        dsplfp_flag = 1; disp('Loading spike denoised data');
    elseif exist([fileprefix '.clfp.dat'],'file');
        clfp_flag = 1; disp('Loading cleaned data');
    end
    RecInd = find(strcmp(Recs,RecList{iRec}));
    
    for tr = RecInd
        %       disp(['Trial ' num2str(tr) ' out of ' num2str(ntr)]);
        subtrial = Trials(tr).Trial;
        %fileprefix
        if dsplfp_flag
            Mlfp_tmp = loaddsplfp(fileprefix,Events,subtrial,field,bn,CH);
        elseif clfp_flag
            Mlfp_tmp = loadclfp(fileprefix,Events,subtrial,field,bn,CH);
        else
            Mlfp_tmp = loadmlfp(fileprefix,Events,subtrial,field,bn,CH);
        end
        if strcmp(field, 'PulseStarts')
            if(CH == 1)
                for iPulse = 1:size(Mlfp_tmp,1)
                    Mlfp(end+1,:) = Mlfp_tmp(iPulse, :);
                end
            else
                for iPulse = 1:size(Mlfp_tmp,1)
                    Mlfp(end+1,:,:) = Mlfp_tmp(iPulse,ch,:);
                end
            end
        else
            if(CH == 1)
                Mlfp(tr,:,:) = Mlfp_tmp(:);
            else
                if size(Mlfp_tmp(1,ch,:),3) == diff(bn)
                    Mlfp(tr,:,:) = Mlfp_tmp(1,ch,:);
                else
                    Mlfp(tr,:,:) = nan(1,length(ch),diff(bn));
                end
            end            
        end
    end
end
    
    %Mlfp = Mlfp(~isnan(Mlfp(:,1,1)),:,:);
    if ntr || length(ch)==1
        Mlfp = sq(Mlfp);
    end
    cd(olddir);
    
