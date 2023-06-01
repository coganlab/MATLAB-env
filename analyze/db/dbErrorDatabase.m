function [ErrorTrials] = dbErrorDatabase(Days)
%  DBERRORDATABASE contructs ErrorTrials data structure across Days.
%
%  [ErrorTrials] = DBERRORDATABASE(DAYS);
%
%  Inputs:  DAYS    =   Cell array.  Days to include.
%                           ie to {'020822',020823','020824'}
%
%  Outputs: ErrorTrials =  Structure array. ErrorTrials data structure for each recording.
%                       Only error ErrorTrials are returned.


global MONKEYDIR

olddir = pwd;
cd(MONKEYDIR);

if ~iscell(Days)  Days = str2cell(Days);  end

disp('Making error trials database');

nd = length(Days);
ind = 0;
clear ErrorTrials
NumErrorTrials = 0;
% ErrorTrials = dbInitTrials(Days,'Error');

experiment_structure = 0;
for d = 1:nd
    day = Days{d};
    disp(['Day: ' day]);
    if isdir([MONKEYDIR '/' day])

        cd([MONKEYDIR '/' day])
        % For some strange path reason this needs to be made explicit on z4
        if isfile('mat/ErrorTrials.mat')
            disp('loading ErrorTrials from mat file')
            Tmp = load('mat/ErrorTrials.mat');
            disp('done loading')
            ErrorTrials(ind+1:ind+length(Tmp.ErrorTrials)) = Tmp.ErrorTrials;
            ind = ind+length(Tmp.ErrorTrials);
        else
            recs = dayrecs(day);
            nr = length(recs);
            disp([num2str(nr) ' recordings']);
            for r = 1:nr
                disp(['Recording: ' recs{r}]);
                cd([MONKEYDIR '/' day '/' recs{r}]);
                %            isfile(['rec' recs{r} '.Events.mat']);
                if isfile(['rec' recs{r} '.Events.mat'])
                   % disp(['loading Events for rec' recs{r}])
                    load(['rec' recs{r} '.Events.mat']);
                    if(~isfile(['rec' recs{r} '.experiment.mat']))
                        load(['rec' recs{r} '.Rec.mat']);
                    else
                        experiment_structure = 1;
                        load(['rec' recs{r} '.experiment.mat']);
                    end
                    trials = find(Events.Success == 0);
                    ntr = length(trials);
                    NumErrorTrials = NumErrorTrials + ntr;
                    if(experiment_structure)
                        if(isfield(experiment.hardware,'microdrive'))
                            clear isoMT
                            for microdrives = 1:length(experiment.hardware.microdrive)
                                if isfield(experiment.hardware.microdrive(microdrives),'name')
                                if isfile(['rec' recs{r} '.' experiment.hardware.microdrive(microdrives).name '.iso.mat'])
                                    isoMT(microdrives) = load(['rec' recs{r} '.' experiment.hardware.microdrive(microdrives).name '.iso.mat']);
                                end
                                end
                            end
                        end
                    else
                        if(isfield(Rec,'MT1'))
                            if isfile(['rec' recs{r} '.' Rec.MT1 '.iso.mat'])
                                isoMT(1) = load(['rec' recs{r} '.' Rec.MT1 '.iso.mat']);
                            end
                            if isfile(['rec' recs{r} '.' Rec.MT2 '.iso.mat'])
                                isoMT(2) = load(['rec' recs{r} '.' Rec.MT2 '.iso.mat']);
                            end
                            if ~isfile(['rec' recs{r} '.' Rec.MT1 '.iso.mat']) & ~isfile(['rec' recs{r} '.' Rec.MT2 '.iso.mat']) & isfile(['rec' recs{r} '.iso.mat'])
                                isodata = load(['rec' recs{r} '.iso.mat']);
                            end
                        end
                    end

                    for t = 1:ntr
                        ind = ind+1;
                        ErrorTrials(ind).Day = day;
                        
                        if(experiment_structure)
                            % Load information from the experiment
                            % definition file
                            if(isfield(experiment.hardware,'microdrive'))
                                for microdrives = 1:length(experiment.hardware.microdrive)
                                    if isfield(experiment.hardware.microdrive(microdrives),'name')
                                        ErrorTrials(ind).MT{microdrives} = experiment.hardware.microdrive(microdrives).name;
                                        ErrorTrials(ind).Ch(microdrives) = length(experiment.hardware.microdrive(microdrives).electrodes);
                                        for electrodes = 1:length(experiment.hardware.microdrive(microdrives).electrodes)
                                            ErrorTrials(ind).Gain(microdrives).Electrode(electrodes) = experiment.hardware.microdrive(microdrives).electrodes(electrodes).gain;
                                            if isfield(experiment.hardware.microdrive(microdrives).electrodes(electrodes),'numContacts') & ...
                                               ~isempty(experiment.hardware.microdrive(microdrives).electrodes(electrodes).numContacts)
                                                ErrorTrials(ind).NumContacts(microdrives).Electrode(electrodes) = experiment.hardware.microdrive(microdrives).electrodes(electrodes).numContacts;
                                            else
                                                ErrorTrials(ind).NumContacts(microdrives).Electrode(electrodes) = 1;
                                            end
                                        end
                                    end
                                end
                                ErrorTrials(ind).Fs = experiment.hardware.acquisition(1).samplingrate;
                                
                                if ~isfield(experiment.acquire,'IsoWin')
                                    IsoWin = 100e3;
                                else
                                    IsoWin = experiment.acquire.IsoWin;
                                end
                                for microdrives = 1:length(experiment.hardware.microdrive)
                                    if isfield(experiment.hardware.microdrive(microdrives),'name')
                                    if isfile(['rec' recs{r} '.' experiment.hardware.microdrive(microdrives).name '.iso.mat'])
                                        load(['rec' recs{r} '.' experiment.hardware.microdrive(microdrives).name  '.iso.mat']);
                                        jind_Start = floor(Events.StartOn(trials(t))./IsoWin)+1;
                                        jind_End = floor(Events.End(trials(t))./IsoWin)+1;
                                        for c = 1:ErrorTrials(ind).Ch(microdrives)
                                            if length(iso) >= c
                                                if ~isempty(iso{c})
                                                    ciso = iso{c};
                                                    %                                                     disp(['Microdrive:' num2str(microdrives) ' Channel:' num2str(c)]);
                                                    ErrorTrials(ind).Iso{microdrives,c} = ciso(jind_Start,:).*ciso(jind_End,:);
                                                else
                                                    ErrorTrials(ind).Iso{microdrives,c} = [];
                                                end
                                            else
                                                ErrorTrials(ind).Iso{microdrives,c} = [];
                                            end
                                        end
                                    else
                                        for c = 1:ErrorTrials(ind).Ch
                                            ErrorTrials(ind).Iso{microdrives,c} = [];
                                        end
                                    end
                                    end
                                end
                            else
                                ErrorTrials(ind).MT(1) = {'PRR'};
                                ErrorTrials(ind).MT(2) = {'LIP'};
                                ErrorTrials(ind).MT1 = 'PRR';
                                ErrorTrials(ind).MT2 = 'LIP';
                                ErrorTrials(ind).Ch = [2 2];
                                ErrorTrials(ind).Gain(1:4) = 2e4;
                                ErrorTrials(ind).Fs = 2e4;
                                for c = 1:ErrorTrials(ind).Ch
                                    ErrorTrials(ind).Iso{1,c} = [];
                                end
                                for c = 1:ErrorTrials(ind).Ch(2)
                                    ErrorTrials(ind).Iso{2,c} = [];
                                end
                            end

                        else
                            % For backwards compatibility
                            %disp('For backwards compatibility')
                            if(isfield(Rec,'MT1'))
                                ErrorTrials(ind).MT(1) = {Rec.MT1};
                            else
                                ErrorTrials(ind).MT(1) = {'PRR'};
                            end
                            if(isfield(Rec,'MT2'))
                                ErrorTrials(ind).MT(2) = {Rec.MT2};
                            else
                                ErrorTrials(ind).MT(2) = {'LIP'};
                            end
                            
                            % For backward compatibility with old
                            % ErrorTrials structure.
                            if isfield(Rec,'MT1')
                                ErrorTrials(ind).MT1 = Rec.MT1;
                            else
                                ErrorTrials(ind).MT1 = 'PRR';
                            end
                            if isfield(Rec,'MT2')
                                ErrorTrials(ind).MT2 = Rec.MT2;
                            else
                                ErrorTrials(ind).MT2 = 'LIP';
                            end
                        
                            if isfield(Rec,'Ch') 
                                if isnumeric(Rec.Ch)
                                    ErrorTrials(ind).Ch = Rec.Ch;
                                else
                                    ErrorTrials(ind).Ch = [2,2];
                                end
                            else
                                ErrorTrials(ind).Ch = [2 2];
                            end
                            %ErrorTrials(ind).Ch
                            if(isfield(Rec,'Fs'))
                                ErrorTrials(ind).Fs = Rec.Fs;
                            else
                                ErrorTrials(ind).Fs = 2e4;
                            end
                            
                            if isfield(Rec,'Gain')
                                if length(Rec.Gain)==8
                                    ErrorTrials(ind).Gain(1:8) = Rec.Gain(1:8);
                                elseif length(Rec.Gain)==4
                                    ErrorTrials(ind).Gain(1:4) = Rec.Gain(1:4);
                                else
                                    ErrorTrials(ind).Gain(1:4) = Rec.Gain(1);
                                end
                            else
                                ErrorTrials(ind).Gain(1:4) = 2e4;
                            end
                            if ~isfield(Rec,'IsoWin') || isempty(Rec.IsoWin)
                                IsoWin = 100e3;
                            else
                                IsoWin = Rec.IsoWin;
                            end

                            if(isfield(Rec, 'MT1'))
                                if isfile(['rec' recs{r} '.' Rec.MT1 '.iso.mat'])
                                    load(['rec' recs{r} '.' Rec.MT1  '.iso.mat']);
                                    jind_Start = floor(Events.StartOn(trials(t))./IsoWin)+1;
                                    jind_End = floor(Events.End(trials(t))./IsoWin)+1;
                                    for c = 1:ErrorTrials(ind).Ch(1)
                                        if length(iso) >= c
                                            if ~isempty(iso{c})
                                                ciso = iso{c};
                                                ErrorTrials(ind).Iso{1,c} = ciso(jind_Start,:).*ciso(jind_End,:);
                                            else
                                                ErrorTrials(ind).Iso{1,c} = [];
                                            end
                                        else
                                            ErrorTrials(ind).Iso{1,c} = [];
                                        end
                                    end
                                elseif isfile(['rec' recs{r}  '.iso.mat'])
                                    load(['rec' recs{r}  '.iso.mat']);
                                    jind_Start = floor(Events.StartOn(trials(t))./IsoWin)+1;
                                    jind_End = floor(Events.End(trials(t))./IsoWin)+1;
                                    for c = 1:ErrorTrials(ind).Ch(1)
                                        if length(iso) >= c
                                            if ~isempty(iso{c})
                                                ciso = iso{c};
                                                ErrorTrials(ind).Iso{1,c} = ciso(jind_Start,:).*ciso(jind_End,:);
                                            else
                                                ErrorTrials(ind).Iso{1,c} = [];
                                            end
                                        else
                                            ErrorTrials(ind).Iso{1,c} = [];
                                        end
                                    end
                                else
                                    for c = 1:ErrorTrials(ind).Ch(1)
                                        ErrorTrials(ind).Iso{1,c} = [];
                                    end
                                end
                            else
                                for c = 1:ErrorTrials(ind).Ch(1)
                                    ErrorTrials(ind).Iso{1,c} = [];
                                end

                            end
                            if(isfield(Rec, 'MT2'))
                                if isfile(['rec' recs{r} '.' Rec.MT2 '.iso.mat'])
                                    load(['rec' recs{r} '.' Rec.MT2 '.iso.mat']);
                                    jind_Start = floor(Events.StartOn(trials(t))./IsoWin)+1;
                                    jind_End = floor(Events.End(trials(t))./IsoWin)+1;
                                    for c = 1:ErrorTrials(ind).Ch(2)
                                        if ~isempty(iso{c})
                                            ciso = iso{c};
                                            if ~isempty(ciso)
                                                ErrorTrials(ind).Iso{2,c} = ciso(jind_Start,:).*ciso(jind_End,:);
                                            else
                                                ErrorTrials(ind).Iso{2,c} = [];
                                            end
                                        end
                                    end
                                elseif isfile(['rec' recs{r}  '.iso.mat'])
                                    load(['rec' recs{r}  '.iso.mat']);
                                    jind_Start = floor(Events.StartOn(trials(t))./IsoWin)+1;
                                    jind_End = floor(Events.End(trials(t))./IsoWin)+1;
                                    for c = 1:ErrorTrials(ind).Ch(2)
                                        if length(iso) >= c + ErrorTrials(ind).Ch(1)
                                            if ~isempty(iso{c + ErrorTrials(ind).Ch(1)})
                                                ciso = iso{c + ErrorTrials(ind).Ch(1)};
                                                ErrorTrials(ind).Iso{2,c} = ciso(jind_Start,:).*ciso(jind_End,:);
                                            else
                                                ErrorTrials(ind).Iso{2,c} = [];
                                            end
                                        else
                                            ErrorTrials(ind).Iso{2,c} = [];
                                        end
                                    end
                                else
                                    for c = 1:ErrorTrials(ind).Ch(2)
                                        ErrorTrials(ind).Iso{2,c} = [];
                                    end
                                end
                            else
                                for c = 1:ErrorTrials(ind).Ch(2)
                                    ErrorTrials(ind).Iso{2,c} = [];
                                end
                            end

                        end

                        ErrorTrials(ind).Rec = recs{r};
                        
                        if isfile(['rec' recs{r} '.electrodelog.txt'])
                            Log = load(['rec' recs{r} '.electrodelog.txt']);
                            if ~isempty(Log)
                                lind = find(Log(:,1).*1e3 < Events.StartOn(trials(t)), 1, 'last' );
                                if ~isempty(lind)
                                    ErrorTrials(ind).Depth{1} = Log(lind,2:end);
                                else
                                    ErrorTrials(ind).Depth{1} = Log(1,2:end);
                                end
                            else
                                ErrorTrials(ind).Depth{1} = ones(1,ErrorTrials(ind).Ch(1)).*1e3;
                            end
                        else
                            ErrorTrials(ind).Depth{1} = ones(1,ErrorTrials(ind).Ch(1)).*1e3;
                            ErrorTrials(ind).Depth{2} = ones(1,ErrorTrials(ind).Ch(2)).*1e3;
                        end

                        if isfield(Events,'AbortState')
                            ErrorTrials(ind).AbortState = Events.AbortState(trials(t));
                        else
                            ErrorTrials(ind).AbortState = nan;
                        end                        
                        
                        ErrorTrials(ind).Trial = Events.Trial(trials(t));
                        ErrorTrials(ind).StartOn = Events.StartOn(trials(t));
                        ErrorTrials(ind).StartAq = Events.StartAq(trials(t)) - ...
                            Events.StartOn(trials(t));
                        ErrorTrials(ind).End = Events.End(trials(t)) - ...
                            Events.StartOn(trials(t));
                        ErrorTrials(ind).TargsOn = Events.TargsOn(trials(t)) - ...
                            Events.StartOn(trials(t));
                        ErrorTrials(ind).Go = Events.Go(trials(t)) - ...
                            Events.StartOn(trials(t));
                        ErrorTrials(ind).TargAq = Events.TargAq(trials(t)) - ...
                            Events.StartOn(trials(t));
                        ErrorTrials(ind).ReachStart = Events.ReachStart(trials(t)) - ...
                            Events.StartOn(trials(t));
                        ErrorTrials(ind).ReachStop = Events.ReachStop(trials(t)) - ...
                            Events.StartOn(trials(t));
                        ErrorTrials(ind).SaccStart = Events.SaccStart(trials(t)) - ...
                            Events.StartOn(trials(t));
                        ErrorTrials(ind).SaccStop = Events.SaccStop(trials(t)) - ...
                            Events.StartOn(trials(t));
                        if isfield(Events,'Sacc2Start')
                            ErrorTrials(ind).Sacc2Start = Events.Sacc2Start(trials(t)) - ...
                                Events.StartOn(trials(t));
                        else
                            ErrorTrials(ind).Sacc2Start = nan;
                        end
                        if isfield(Events,'Sacc2Stop')
                            ErrorTrials(ind).Sacc2Stop = Events.Sacc2Stop(trials(t)) - ...
                                Events.StartOn(trials(t));
                        else
                            ErrorTrials(ind).Sacc2Stop = nan;
                        end
                        if isfield(Events,'Sacc2Center')
                            ErrorTrials(ind).Sacc2Center = Events.Sacc2Center(trials(t));
                        else
                            ErrorTrials(ind).Sacc2Center = nan;
                        end
                        if isfield(Events,'Reach2Start')
                            ErrorTrials(ind).Reach2Start = Events.Reach2Start(trials(t)) - ...
                                Events.StartOn(trials(t));
                        else
                            ErrorTrials(ind).Reach2Start = nan;
                        end
                        if isfield(Events,'TargetOff')
                            ErrorTrials(ind).TargetOff = Events.TargetOff(trials(t)) - ...
                                Events.StartOn(trials(t));
                        else
                            ErrorTrials(ind).TargetOff = nan;
                        end
                        if isfield(Events,'InstOn')
                            ErrorTrials(ind).InstOn = Events.InstOn(trials(t)) - ...
                                Events.StartOn(trials(t));
                        else
                            ErrorTrials(ind).InstOn = nan;
                        end
                        if isfield(Events,'Targ2On')
                            ErrorTrials(ind).Targ2On = Events.Targ2On(trials(t)) - ...
                                Events.StartOn(trials(t));
                        else
                            ErrorTrials(ind).Targ2On = nan;
                        end
                        if isfield(Events,'TargetRet')
                            ErrorTrials(ind).TargetRet = Events.TargetRet(trials(t)) - ...
                                Events.StartOn(trials(t));
                        else
                            ErrorTrials(ind).TargetRet = nan;
                        end

                        if isfield(Events,'ReachGo')
                            ErrorTrials(ind).ReachGo = Events.ReachGo(trials(t)) - ...
                                Events.StartOn(trials(t));
                        else
                            ErrorTrials(ind).ReachGo = nan;
                        end
                        if isfield(Events,'ReachAq')
                            ErrorTrials(ind).ReachAq = Events.ReachAq(trials(t)) - ...
                                Events.StartOn(trials(t));
                        else
                            ErrorTrials(ind).ReachAq = nan;
                        end

                        if isfield(Events,'SaccadeGo') && length(Events.SaccadeGo) > trials(t)-1
                            ErrorTrials(ind).SaccadeGo = Events.SaccadeGo(trials(t)) - ...
                                Events.StartOn(trials(t));
                        else
                            ErrorTrials(ind).SaccadeGo = nan;
                        end

                        if isfield(Events,'SaccadeAq')
                            ErrorTrials(ind).SaccadeAq = Events.SaccadeAq(trials(t)) - ...
                                Events.StartOn(trials(t));
                        else
                            ErrorTrials(ind).SaccadeAq = nan;
                        end

                        if isfield(Events,'Reward2T')
                            ErrorTrials(ind).Reward2T = Events.Reward2T(trials(t));
                        else
                            ErrorTrials(ind).Reward2T = nan;
                        end
                        if isfield(Events,'RewardConfig')
                            ErrorTrials(ind).RewardConfig = Events.RewardConfig(trials(t));
                        else
                            ErrorTrials(ind).RewardConfig = nan;
                        end
                        if isfield(Events,'Choice')
                            ErrorTrials(ind).Choice = Events.Choice(trials(t));
                        else
                            ErrorTrials(ind).Choice = nan;
                        end
                        if isfield(Events,'RewardMag')
                            ErrorTrials(ind).RewardMag = Events.RewardMag(trials(t));
                        else
                            ErrorTrials(ind).RewardMag = nan;
                        end
                        if isfield(Events,'RewardBlock')
                            ErrorTrials(ind).RewardBlock = Events.RewardBlock(trials(t));
                        else
                            ErrorTrials(ind).RewardBlock = nan;
                        end
                        if isfield(Events,'HandRewardBlock')
                            ErrorTrials(ind).HandRewardBlock = Events.HandRewardBlock(trials(t));
                        else
                            ErrorTrials(ind).HandRewardBlock = nan;
                        end
                        if isfield(Events,'EyeRewardBlock')
                            ErrorTrials(ind).EyeRewardBlock = Events.EyeRewardBlock(trials(t));
                        else
                            ErrorTrials(ind).EyeRewardBlock = nan;
                        end
                        if isfield(Events,'ReachChoice')
                            ErrorTrials(ind).ReachChoice = Events.ReachChoice(trials(t));
                        else
                            ErrorTrials(ind).ReachChoice = nan;
                        end
                        if isfield(Events,'SaccadeChoice')
                            ErrorTrials(ind).SaccadeChoice = Events.SaccadeChoice(trials(t));
                        else
                            ErrorTrials(ind).SaccadeChoice = nan;
                        end
                        if isfield(Events,'ReachCircleTarget')
                            ErrorTrials(ind).ReachCircleTarget = Events.ReachCircleTarget(trials(t));
                        else
                            ErrorTrials(ind).ReachCircleTarget = nan;
                        end
                        if isfield(Events,'SaccadeCircleTarget')
                            ErrorTrials(ind).SaccadeCircleTarget = Events.SaccadeCircleTarget(trials(t));
                        else
                            ErrorTrials(ind).SaccadeCircleTarget = nan;
                        end
                        if isfield(Events,'HighReward')
                            ErrorTrials(ind).HighReward = Events.HighReward(trials(t));
                        else
                            ErrorTrials(ind).HighReward = nan;
                        end
                        if isfield(Events,'Reward')
                            ErrorTrials(ind).Reward = Events.Reward(trials(t));
                        else
                            ErrorTrials(ind).Reward = nan;
                        end
                        if isfield(Events,'RewardTask')
                            ErrorTrials(ind).RewardTask = Events.RewardTask(trials(t));
                        else
                            ErrorTrials(ind).RewardTask = 0;
                        end
                        if isfield(Events,'EyeTarget')
                            ErrorTrials(ind).EyeTarget = Events.EyeTarget(trials(t));
                        else
                            ErrorTrials(ind).EyeTarget = Events.Target(trials(t));  % Defaults to eye-hand targets linked
                        end
                        if isfield(Events,'EyeTargetLocation')
                            ErrorTrials(ind).EyeTargetLocation = Events.EyeTargetLocation(trials(t),:);
                        else
                            ErrorTrials(ind).EyeTargetLocation = zeros(1,2);
                        end
                        if isfield(Events,'HandTargetLocation')
                            ErrorTrials(ind).HandTargetLocation = Events.HandTargetLocation(trials(t),:);
                        else
                            ErrorTrials(ind).HandTargetLocation = zeros(1,2);
                        end
                        if isfield(Events,'AdaptationFeedback')
                            ErrorTrials(ind).AdaptationFeedback = Events.AdaptationFeedback(trials(t));
                        else
                            ErrorTrials(ind).AdaptationFeedback = 0;
                        end
                        if isfield(Events,'AdaptationAction')
                            ErrorTrials(ind).AdaptationAction = Events.AdaptationAction(trials(t));
                        else
                            ErrorTrials(ind).AdaptationAction = 0;
                        end
                        if isfield(Events,'AdaptationPhase')
                            ErrorTrials(ind).AdaptationPhase = Events.AdaptationPhase(trials(t));
                        else
                            ErrorTrials(ind).AdaptationPhase = 9;
                        end
                        if isfield(Events,'LEDBoard')
                            ErrorTrials(ind).LEDBoard = Events.LEDBoard(trials(t));
                        else
                            ErrorTrials(ind).LEDBoard = 0;
                        end
                        if isfield(Events,'RewardDur')
                            ErrorTrials(ind).RewardDur = Events.RewardDur(trials(t),:);
                        else
                            ErrorTrials(ind).RewardDur = [0 0 0 0];
                        end
                        if isfield(Events,'RewardDist')
                            ErrorTrials(ind).RewardDist = Events.RewardDist(trials(t),:);
                        else
                            ErrorTrials(ind).RewardDist = [0 0 0 0];
                        end
                        if isfield(Events,'Reward4TNoise')
                            ErrorTrials(ind).Reward4TNoise = Events.Reward4TNoise(trials(t),:);
                        else
                            ErrorTrials(ind).Reward4TNoise = [0 0];
                        end
                        if isfield(Events,'Targ2')
                            ErrorTrials(ind).Targ2 = Events.Targ2(trials(t));
                        else
                            ErrorTrials(ind).Targ2 = 99;
                        end
                        if isfield(Events,'Separable4T')
                            ErrorTrials(ind).Separable4T = Events.Separable4T(trials(t));
                        else
                            ErrorTrials(ind).Separable4T = 9;
                        end
                        if isfield(Events,'TargMove')
                            ErrorTrials(ind).TargMove = Events.TargMove(trials(t)) - ...
                                Events.StartOn(trials(t));
                        else
                            ErrorTrials(ind).TargMove = 0;
                        end
                        if isfield(Events,'EffInstOn')
                            ErrorTrials(ind).EffInstOn = Events.EffInstOn(trials(t)) - ...
                                Events.StartOn(trials(t));
                        else
                            ErrorTrials(ind).EffInstOn = 0;
                        end
                        if isfield(Events,'MinReachRT')
                            ErrorTrials(ind).MinReachRT = Events.MinReachRT(trials(t));
                        else
                            ErrorTrials(ind).MinReachRT = nan;
                        end
                        if isfield(Events,'MaxReachRT')
                            ErrorTrials(ind).MaxReachRT = Events.MaxReachRT(trials(t));
                        else
                            ErrorTrials(ind).MaxReachRT = nan;
                        end
                        if isfield(Events,'MinReachAq')
                            ErrorTrials(ind).MinReachAq = Events.MinReachAq(trials(t));
                        else
                            ErrorTrials(ind).MinReachAq = nan;
                        end
                        if isfield(Events,'MaxReachAq')
                            ErrorTrials(ind).MaxReachAq = Events.MaxReachAq(trials(t));
                        else
                            ErrorTrials(ind).MaxReachAq = nan;
                        end
                        if isfield(Events,'MinSaccadeRT')
                            ErrorTrials(ind).MinSaccadeRT = Events.MinSaccadeRT(trials(t));
                        else
                            ErrorTrials(ind).MinSaccadeRT = nan;
                        end
                        if isfield(Events,'MaxSaccadeRT')
                            ErrorTrials(ind).MaxSaccadeRT = Events.MaxSaccadeRT(trials(t));
                        else
                            ErrorTrials(ind).MaxSaccadeRT = nan;
                        end
                        if isfield(Events,'MinSaccadeAq')
                            ErrorTrials(ind).MinSaccadeAq = Events.MinSaccadeAq(trials(t));
                        else
                            ErrorTrials(ind).MinSaccadeAq = nan;
                        end
                        if isfield(Events,'MaxSaccadeAq')
                            ErrorTrials(ind).MaxSaccadeAq = Events.MaxSaccadeAq(trials(t));
                        else
                            ErrorTrials(ind).MaxSaccadeAq = nan;
                        end
                        if isfield(Events,'MinSaccade2RT')
                            ErrorTrials(ind).MinSaccade2RT = Events.MinSaccade2RT(trials(t));
                        else
                            ErrorTrials(ind).MinSaccade2RT = nan;
                        end
                        if isfield(Events,'MaxSaccade2RT')
                            ErrorTrials(ind).MaxSaccade2RT = Events.MaxSaccade2RT(trials(t));
                        else
                            ErrorTrials(ind).MaxSaccade2RT = nan;
                        end
                        if isfield(Events,'MinSaccade2Aq')
                            ErrorTrials(ind).MinSaccade2Aq = Events.MinSaccade2Aq(trials(t));
                        else
                            ErrorTrials(ind).MinSaccade2Aq = nan;
                        end
                        if isfield(Events,'MaxSaccade2RT')
                            ErrorTrials(ind).MaxSaccade2RT = Events.MaxSaccade2RT(trials(t));
                        else
                            ErrorTrials(ind).MaxSaccade2RT = nan;
                        end
                        ErrorTrials(ind).HandCode = Events.HandCode(trials(t));
                        ErrorTrials(ind).TaskCode = Events.TaskCode(trials(t));
                        ErrorTrials(ind).Joystick = Events.Joystick(trials(t));
                        ErrorTrials(ind).Target = Events.Target(trials(t));
                        ErrorTrials(ind).StartHand = Events.StartHand(trials(t));
                        ErrorTrials(ind).StartEye = Events.StartEye(trials(t));
                        ErrorTrials(ind).Success = Events.Success(trials(t));
                        ErrorTrials(ind).Saccade = Events.Saccade(trials(t));
                        ErrorTrials(ind).Reach = Events.Reach(trials(t));
                        if isfield(Events,'DoubleStep')
                            ErrorTrials(ind).DoubleStep = Events.DoubleStep(trials(t));
                        else
                            ErrorTrials(ind).DoubleStep = 0;
                        end
                        
                        if isfield(Events,'BrightVals')
                            ErrorTrials(ind).BrightVals = Events.BrightVals(trials(t),:);
                        else
                            ErrorTrials(ind).BrightVals = nan;
                        end
                        
                        if isfield(Events,'BrightDist')
                            ErrorTrials(ind).BrightDist = Events.BrightDist(trials(t),:);
                        else
                            ErrorTrials(ind).BrightDist = nan;
                        end
                        
                        if isfield(Events,'T1T2Locations')
                            ErrorTrials(ind).T1T2Locations = squeeze(Events.T1T2Locations(trials(t),:,:));
                        else
                            ErrorTrials(ind).T1T2Locations = nan;
                        end
                        
                        if isfield(Events,'T1T2Delta')
                            ErrorTrials(ind).T1T2Delta = Events.T1T2Delta(trials(t));
                        else
                            ErrorTrials(ind).T1T2Delta = nan;
                        end
                        
                        if isfield(Events,'TargetScale')
                            ErrorTrials(ind).TargetScale = Events.TargetScale(trials(t));
                            ErrorTrials(ind).Target2Scale = Events.Target2Scale(trials(t));
                        else
                            ErrorTrials(ind).TargetScale = nan;
                            ErrorTrials(ind).Target2Scale = nan;
                        end
                        if isfield(Events,'RewardSwitchPoint')
                            ErrorTrials(ind).RewardSwitchPoint = Events.RewardSwitchPoint;
                        else
                            ErrorTrials(ind).RewardSwitchPoint = [nan,nan];
                        end 
%                         try
                        if isfield(Events,'SaccadeChoiceContinuousLocation')
                            ErrorTrials(ind).SaccadeChoiceContinuousLocation = Events.SaccadeChoiceContinuousLocation(trials(t),:);
                        else
                            ErrorTrials(ind).SaccadeChoiceContinuousLocation = nan;
                        end
%                         catch
%                           disp('Field "SaccadeChoiceContinuousLocation" not found: run procChoice to generate');
%                         end

                        if isfield(Events,'UnchosenTargetContinuousLocation')
                            ErrorTrials(ind).UnchosenTargetContinuousLocation = Events.UnchosenTargetContinuousLocation(trials(t),:);
                        else
                            ErrorTrials(ind).UnchosenTargetContinuousLocation = nan;
                        end
                        if isfield(Events,'UnchosenTarget')
                            ErrorTrials(ind).UnchosenTarget = Events.UnchosenTarget(trials(t));
                        else
                            ErrorTrials(ind).UnchosenTarget = nan;
                        end
                        
                        
                        
                        if isfield(Events,'RewardVolumeVals')
                           ErrorTrials(ind).RewardVolumeVals = Events.RewardVolumeVals(trials(t),:);
                           ErrorTrials(ind).RewardVolumeDist = Events.RewardVolumeDist(trials(t),:);
                           ErrorTrials(ind).TargetLuminanceVals = Events.TargetLuminanceVals(trials(t),:);
                           % ErrorTrials(ind).TargetLuminanceDist = Events.TargetLuminanceDist(trials(t),:);
                        else
                           ErrorTrials(ind).RewardVolumeVals = nan;
                           ErrorTrials(ind).RewardVolumeDist = nan;
                           ErrorTrials(ind).TargetLuminanceVals = nan;
                           % ErrorTrials(ind).TargetLuminanceDist = nan;
                        end

                        if isfield(Events,'BrightVals')
                            ErrorTrials(ind).BrightVals = Events.BrightVals(trials(t),:);
                        else
                            ErrorTrials(ind).BrightVals = nan;
                        end
                        
                        if isfield(Events,'BrightDist')
                            ErrorTrials(ind).BrightDist = Events.BrightDist(trials(t),:);
                        else
                            ErrorTrials(ind).BrightDist = nan;
                        end
                        
                        if isfield(Events,'T1T2Locations')
                            ErrorTrials(ind).T1T2Locations = squeeze(Events.T1T2Locations(trials(t),:,:));
                        else
                            ErrorTrials(ind).T1T2Locations = nan;
                        end
                        
                        if isfield(Events,'T1T2Delta')
                            ErrorTrials(ind).T1T2Delta = Events.T1T2Delta(trials(t));
                        else
                            ErrorTrials(ind).T1T2Delta = nan;
                        end
                        
                        if isfield(Events,'TargetScale')
                            ErrorTrials(ind).TargetScale = Events.TargetScale(trials(t));
                            ErrorTrials(ind).Target2Scale = Events.Target2Scale(trials(t));
                        else
                            ErrorTrials(ind).TargetScale = nan;
                            ErrorTrials(ind).Target2Scale = nan;
                        end
                        
                        try
                        if isfield(Events,'EyeChoiceContinuousLocation')
                            ErrorTrials(ind).EyeChoiceContinuousLocation = Events.EyeChoiceContinuousLocation(trials(t),:);
                        else
                            ErrorTrials(ind).EyeChoiceContinuousLocation = nan;
                        end
                        catch
                          disp('Field "EyeChoiceContinuousLocation" not found: run procChoice to generate');
                        end
                        
                        if isfield(Events,'RewardBlockTrial')
                            ErrorTrials(ind).RewardBlockTrial = Events.RewardBlockTrial(trials(t));
                        else
                            ErrorTrials(ind).RewardBlockTrial = nan;
                        end
                        
                    end         %  Loop over trials

                end
            end           %  if events  
        end           %  Loop over recs
    end             %  if saved ErrorTrials.mat file
end             %  Loop over days

cd(olddir);

if ind==0
    ErrorTrials = [];
end

