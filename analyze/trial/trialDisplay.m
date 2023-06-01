function Display = trialDisplay(Trials,field,bn)
%  TRIALDISPLAY loads display sensor data for a trial
%
%  DISPLAY = TRIALDISPLAY(TRIALS, FIELD, BN)
%
%  Inputs:	TRIALS = Trials data structure
%            	FIELD   = Scalar.  Event to align data to.
%                   Defaults to 'TargOn'
%            	BN      = Vector.  Time to start and stop loading data.
%                   Defaults to [-500,1500].
%
%  Outputs:	DISPLAY	= [TRIAL,TIME]. Display sensor data
%

global MONKEYDIR Rec;

    ntr = length(Trials);

    olddir = pwd;
    oldrec = '';
    if isfile([MONKEYDIR '/' Trials(1).Day '/' Trials(1).Rec '/rec' Trials(1).Rec '.experiment.mat'])
      load([MONKEYDIR '/' Trials(1).Day '/' Trials(1).Rec '/rec' Trials(1).Rec '.experiment.mat'])
    else
            load([MONKEYDIR '/' Trials(1).Day '/' Trials(1).Rec '/rec' Trials(1).Rec '.Rec.mat'])
    end
    FS = Trials(1).Fs;
    Display = zeros(ntr,diff(bn).*FS./1e3);
    for tr = 1:ntr
        %       disp(['Trial ' num2str(tr) ' out of ' num2str(ntr)]);
        day = Trials(tr).Day;
        rec = Trials(tr).Rec;
        subtrial = Trials(tr).Trial;
        if ~strcmp(rec,oldrec)
            load([MONKEYDIR '/' day '/' rec '/rec' rec '.Events.mat']);
            cd([MONKEYDIR '/' day '/' rec]);
            fileprefix = ['rec' rec];
        end
        oldrec = rec;
        %fileprefix
        Display_tmp = loaddisplay(fileprefix,Events,subtrial,field,bn, [],FS);
        Display(tr,:) = Display_tmp;
    end

    if ntr ==1
        Display = sq(Display);
    end
    cd(olddir);

