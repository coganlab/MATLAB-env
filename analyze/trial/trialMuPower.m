function [MuPower] = trialMuPower(Trials,sys,ch,field,bn,bnsmooth)
%
%  [MuPower] = trialMuPower(Trials,sys,ch,field,bn)
%

global MONKEYDIR;

    if nargin < 2; sys = Trials(1).MT1; end
    if nargin < 4; field = 'TargsOn'; end
    if nargin < 5; bn = [-500,1500]; end

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
    CH = Trials(1).Ch(sysnum(1));

    olddir = pwd;
    MuPower = zeros(ntr,length(ch),diff(bn)*FS/1e3./(30*bnsmooth),'single');

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
         if(CH == 1)
            MuPower_tmp = calcMuPower(Mu_tmp,bnsmooth*30);
             MuPower(tr,:) = MuPower_tmp;
         else
             for iCh = 1:length(ch)
               MuPower_tmp = calcMuPower(Mu_tmp(ch(iCh),:),bnsmooth*30);
               MuPower(tr,iCh,:) = MuPower_tmp;
             end
         end
    end

    if ntr || length(ch)==1
        MuPower = sq(MuPower);
    end
    
    cd(olddir);

    
