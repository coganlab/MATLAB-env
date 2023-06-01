function State = trialState(Trials,field,bn)
%  TRIALSTATE loads analog state data for a trial
%
%  State = TRIALSTATE(TRIALS, FIELD, BN)
%
%  Inputs:	TRIALS = Trials data structure
%            	FIELD   = Scalar.  Event to align data to.
%                   Defaults to 'TargOn'
%            	BN      = Vector.  Time to start and stop loading data.
%                   Defaults to [-500,1500].
%
%  Outputs:	STATE	= [TRIAL,TIME]. Analog state data
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
    State = zeros(ntr,diff(bn).*FS./1e3);
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
        State_tmp = loadstate(fileprefix,Events,subtrial,field,bn, [],FS);
        State(tr,:) = State_tmp;
    end

    if ntr ==1
        State = sq(State);
    end
    cd(olddir);

