function [Trials] = dbAOdatabase(Days,MonkeyDir)
%  DBDATABASE contructs Trials data structure across Days.
%
%  [TRIALS] = DBDATABASE(DAYS);
%
%  Inputs:  DAYS    =   Cell array.  Days to include.
%                           ie to {'020822',020823','020824'}
%
%  Outputs: TRIALS =  Structure array. Trials data structure for each recording.
%                       Only successful trials are returned.

global MONKEYDIR

olddir = pwd;
if nargin < 2 || isempty(MonkeyDir)
    MonkeyDir = MONKEYDIR;
end
if ~iscell(Days)  Days = str2cell(Days);  end

%disp('Making database');

nd = length(Days);
ind = 0;
clear Trials
NumTrials = 0;
experiment_structure = 0;
for d = 1:nd
    day = Days{d};
    disp(['Day: ' day]);
    if isdir([MonkeyDir '/' day])
        
        % For some strange path reason this needs to be made explicit on z4
        if isfile([MonkeyDir '/' day '/mat/Trials.mat'])
            disp('loading trials from mat file')
            Tmp = load([MonkeyDir '/' day '/mat/Trials.mat']);
            disp('done loading')
            Trials(ind+1:ind+length(Tmp.Trials)) = Tmp.Trials;
            ind = ind+length(Tmp.Trials);
                   
        else
            recs = dayrecs(day);
            nr = length(recs);
            disp([num2str(nr) ' recordings']);
            for r = 1:nr
                disp(['Recording: ' recs{r}]);
                %cd([MonkeyDir '/' day '/' recs{r}]);
                %            isfile(['rec' recs{r} '.Events.mat']);
                if isfile([MonkeyDir '/' day '/' recs{r} '/rec' recs{r} '.Events.mat'])
                    % disp(['loading Events for rec' recs{r}])
                    load([MonkeyDir '/' day '/' recs{r} '/rec' recs{r} '.Events.mat']);
                    if(~isfile([MonkeyDir '/' day '/' recs{r} '/rec' recs{r} '.experiment.mat']))
                        load([MonkeyDir '/' day '/' recs{r} '/rec' recs{r} '.Rec.mat']);
                    else
                        experiment_structure = 1;
                        load([MonkeyDir '/' day '/' recs{r} '/rec' recs{r} '.experiment.mat']);
                    end
                    trials = find(Events.Success);
                    ntr = length(trials);
                    NumTrials = NumTrials + ntr;
                    if(experiment_structure)
                        if(isfield(experiment.hardware,'microdrive'))
                            clear isoMT
                            for microdrives = 1:length(experiment.hardware.microdrive)
                                if isfield(experiment.hardware.microdrive(microdrives),'name')
                                    if isfile([MonkeyDir '/' day '/' recs{r} '/rec' recs{r} '.' experiment.hardware.microdrive(microdrives).name '.iso.mat'])
                                        isoMT(microdrives) = load([MonkeyDir '/' day '/' recs{r} '/rec' recs{r} '.' experiment.hardware.microdrive(microdrives).name '.iso.mat']);
                                    end
                                end
                            end
                        end
                    else
                        if(isfield(Rec,'MT1'))
                            if isfile([MonkeyDir '/' day '/' recs{r} '/rec' recs{r} '.' Rec.MT1 '.iso.mat'])
                                isoMT(1) = load([MonkeyDir '/' day '/' recs{r} '/rec' recs{r} '.' Rec.MT1 '.iso.mat']);
                            end
                            if isfile([MonkeyDir '/' day '/' recs{r} '/rec' recs{r} '.' Rec.MT2 '.iso.mat'])
                                isoMT(2) = load([MonkeyDir '/' day '/' recs{r} '/rec' recs{r} '.' Rec.MT2 '.iso.mat']);
                            end
                            if ~isfile([MonkeyDir '/' day '/' recs{r} '/rec' recs{r} '.' Rec.MT1 '.iso.mat']) && ~isfile([MonkeyDir '/' day '/' recs{r} '/rec' recs{r} '.' Rec.MT2 '.iso.mat']) & isfile(['rec' recs{r} '.iso.mat'])
                                isodata = load([MonkeyDir '/' day '/' recs{r} '/rec' recs{r} '.iso.mat']);
                            end
                        end
                    end
                    
                    for t = 1:ntr
                        ind = ind+1;
                        Trials(ind).Day = day;
                        
                        if(experiment_structure)
                            % Load information from the experiment
                            % definition file
                            if(isfield(experiment.hardware,'microdrive'))
                                for microdrives = 1:length(experiment.hardware.microdrive)
                                    if isfield(experiment.hardware.microdrive(microdrives),'name')
                                        Trials(ind).MT{microdrives} = experiment.hardware.microdrive(microdrives).name;
                                        Trials(ind).Ch(microdrives) = length(experiment.hardware.microdrive(microdrives).electrodes);
                                        for electrodes = 1:length(experiment.hardware.microdrive(microdrives).electrodes)
                                            Trials(ind).Gain(microdrives).Electrode(electrodes) = experiment.hardware.microdrive(microdrives).electrodes(electrodes).gain;
                                            if isfield(experiment.hardware.microdrive(microdrives).electrodes(electrodes),'numContacts')
                                                Trials(ind).NumContacts(microdrives).Electrode(electrodes) = experiment.hardware.microdrive(microdrives).electrodes(electrodes).numContacts;
                                            else
                                                Trials(ind).NumContacts(microdrives).Electrode(electrodes) = 1;
                                            end
                                        end
                                    end
                                end
                                Trials(ind).Fs = experiment.hardware.acquisition(1).samplingrate;
                                
                                if ~isfield(experiment.acquire,'IsoWin')
                                    IsoWin = 100e3;
                                else
                                    IsoWin = experiment.acquire.IsoWin;
                                end
                                for microdrives = 1:length(experiment.hardware.microdrive)

                                    if isfield(experiment.hardware.microdrive(microdrives),'name')
                                        if isfile([MonkeyDir '/' day '/' recs{r} '/rec' recs{r} '.' experiment.hardware.microdrive(microdrives).name '.iso.mat'])
                                            load([MonkeyDir '/' day '/' recs{r} '/rec' recs{r} '.' experiment.hardware.microdrive(microdrives).name  '.iso.mat']);
                                            jind_Start = floor(Events.StartOn(trials(t))./IsoWin)+1;
                                            jind_End = floor(Events.End(trials(t))./IsoWin)+1;
                                            
                                            for c = 1:Trials(ind).Ch(microdrives)
                                                if length(iso) >= c
                                                    if ~isempty(iso{c})
                                                        ciso = iso{c};
                                                        if size(ciso,1) < jind_End
                                                            di = jind_End-size(ciso,1);
                                                            ciso = [ciso; zeros(di,size(ciso,2))];
                                                            iso{c} = ciso;
                                                            save([MonkeyDir '/' day '/' recs{r} '/rec' recs{r} '.' experiment.hardware.microdrive(microdrives).name  '.iso.mat'],'iso');
                                                        end
                                                        %      disp(['Microdrive:' num2str(microdrives) ' Channel:' num2str(c)]);
                                                        Trials(ind).Iso{microdrives,c} = ciso(jind_Start,:).*ciso(jind_End,:);
                                                    else
                                                        Trials(ind).Iso{microdrives,c} = [];
                                                    end
                                                else
                                                    Trials(ind).Iso{microdrives,c} = [];
                                                end
                                            end
                                        else
                                            for c = 1:Trials(ind).Ch
                                                Trials(ind).Iso{microdrives,c} = [];
                                            end
                                        end
                                    end
                                end
                            else
                                Trials(ind).MT(1) = {'PRR'};
                                Trials(ind).MT(2) = {'LIP'};
                                Trials(ind).Ch = [2 2];
                                Trials(ind).Gain(1:4) = 2e4;
                                Trials(ind).Fs = 2e4;
                                for c = 1:Trials(ind).Ch
                                    Trials(ind).Iso{1,c} = [];
                                end
                                for c = 1:Trials(ind).Ch(2)
                                    Trials(ind).Iso{2,c} = [];
                                end
                            end
                            
                        else
                            % For backwards compatibility
                            %disp('For backwards compatibility')
                            if(isfield(Rec,'MT1'))
                                Trials(ind).MT(1) = {Rec.MT1};
                            else
                                Trials(ind).MT(1) = {'PRR'};
                            end
                            if(isfield(Rec,'MT2'))
                                Trials(ind).MT(2) = {Rec.MT2};
                            else
                                Trials(ind).MT(2) = {'LIP'};
                            end
                            if isfield(Rec,'Ch')
                                if isnumeric(Rec.Ch)
                                    Trials(ind).Ch = Rec.Ch;
                                else
                                    Trials(ind).Ch = [2,2];
                                end
                            else
                                Trials(ind).Ch = [2 2];
                            end
                            %Trials(ind).Ch
                            if(isfield(Rec,'Fs'))
                                Trials(ind).Fs = Rec.Fs;
                            else
                                Trials(ind).Fs = 2e4;
                            end
                            if isfield(Rec,'Gain')
                                if length(Rec.Gain)==8
                                    Trials(ind).Gain(1:8) = Rec.Gain(1:8);
                                elseif length(Rec.Gain)==4
                                    Trials(ind).Gain(1:4) = Rec.Gain(1:4);
                                else
                                    Trials(ind).Gain(1:4) = Rec.Gain(1);
                                end
                            else
                                Trials(ind).Gain(1:4) = 2e4;
                            end
                            if ~isfield(Rec,'IsoWin') || isempty(Rec.IsoWin)
                                IsoWin = 100e3;
                            else
                                IsoWin = Rec.IsoWin;
                            end
                            
                            if(isfield(Rec, 'MT1'))
                                if isfile([MonkeyDir '/' day '/' recs{r} '/rec' recs{r} '.' Rec.MT1 '.iso.mat'])
                                    load([MonkeyDir '/' day '/' recs{r} '/rec' recs{r} '.' Rec.MT1  '.iso.mat']);
                                    jind_Start = floor(Events.StartOn(trials(t))./IsoWin)+1;
                                    jind_End = floor(Events.End(trials(t))./IsoWin)+1;
                                    for c = 1:Trials(ind).Ch(1)
                                        if length(iso) >= c
                                            if ~isempty(iso{c})
                                                ciso = iso{c};
                                                Trials(ind).Iso{1,c} = ciso(jind_Start,:).*ciso(jind_End,:);
                                            else
                                                Trials(ind).Iso{1,c} = [];
                                            end
                                        else
                                            Trials(ind).Iso{1,c} = [];
                                        end
                                    end
                                elseif isfile([MonkeyDir '/' day '/' recs{r} '/rec' recs{r}  '.iso.mat'])
                                    load([MonkeyDir '/' day '/' recs{r} '/rec' recs{r}  '.iso.mat']);
                                    jind_Start = floor(Events.StartOn(trials(t))./IsoWin)+1;
                                    jind_End = floor(Events.End(trials(t))./IsoWin)+1;
                                    for c = 1:Trials(ind).Ch(1)
                                        if length(iso) >= c
                                            if ~isempty(iso{c})
                                                ciso = iso{c};
                                                Trials(ind).Iso{1,c} = ciso(jind_Start,:).*ciso(jind_End,:);
                                            else
                                                Trials(ind).Iso{1,c} = [];
                                            end
                                        else
                                            Trials(ind).Iso{1,c} = [];
                                        end
                                    end
                                else
                                    for c = 1:Trials(ind).Ch(1)
                                        Trials(ind).Iso{1,c} = [];
                                    end
                                end
                            else
                                for c = 1:Trials(ind).Ch(1)
                                    Trials(ind).Iso{1,c} = [];
                                end
                                
                            end
                            if(isfield(Rec, 'MT2'))
                                if isfile([MonkeyDir '/' day '/' recs{r} '/rec' recs{r} '.' Rec.MT2 '.iso.mat'])
                                    load([MonkeyDir '/' day '/' recs{r} '/rec' recs{r} '.' Rec.MT2 '.iso.mat']);
                                    jind_Start = floor(Events.StartOn(trials(t))./IsoWin)+1;
                                    jind_End = floor(Events.End(trials(t))./IsoWin)+1;
                                    for c = 1:Trials(ind).Ch(2)
                                        if ~isempty(iso{c})
                                            ciso = iso{c};
                                            if ~isempty(ciso)
                                                Trials(ind).Iso{2,c} = ciso(jind_Start,:).*ciso(jind_End,:);
                                            else
                                                Trials(ind).Iso{2,c} = [];
                                            end
                                        end
                                    end
                                elseif isfile([MonkeyDir '/' day '/' recs{r} '/rec' recs{r}  '.iso.mat'])
                                    load([MonkeyDir '/' day '/' recs{r} '/rec' recs{r}  '.iso.mat']);
                                    jind_Start = floor(Events.StartOn(trials(t))./IsoWin)+1;
                                    jind_End = floor(Events.End(trials(t))./IsoWin)+1;
                                    for c = 1:Trials(ind).Ch(2)
                                        if length(iso) >= c + Trials(ind).Ch(1)
                                            if ~isempty(iso{c + Trials(ind).Ch(1)})
                                                ciso = iso{c + Trials(ind).Ch(1)};
                                                Trials(ind).Iso{2,c} = ciso(jind_Start,:).*ciso(jind_End,:);
                                            else
                                                Trials(ind).Iso{2,c} = [];
                                            end
                                        else
                                            Trials(ind).Iso{2,c} = [];
                                        end
                                    end
                                else
                                    for c = 1:Trials(ind).Ch(2)
                                        Trials(ind).Iso{2,c} = [];
                                    end
                                end
                            else
                                for c = 1:Trials(ind).Ch(2)
                                    Trials(ind).Iso{2,c} = [];
                                end
                            end
                            
                        end
                        Trials(ind).Rec = recs{r};
                        
                        if(experiment_structure)
                            try
                                for iTower = 1:length(experiment.hardware.microdrive)
                                    tower = experiment.hardware.microdrive(iTower).name;
                                    if isfile([MonkeyDir '/' day '/' recs{r} '/rec' recs{r} '.' tower '.electrodelog.txt'])
                                        Log = load([MonkeyDir '/' day '/' recs{r} '/rec' recs{r} '.' tower '.electrodelog.txt']);
                                        if ~isempty(Log)
                                            lind = find(Log(:,1).*1e3 < Events.StartOn(trials(t)), 1, 'last' );
                                            if ~isempty(lind)
                                                Trials(ind).Depth{iTower} = Log(lind,2:end);
                                            else
                                                Trials(ind).Depth{iTower} = Log(1,2:end);
                                            end
                                        else
                                            Trials(ind).Depth{iTower} = ones(1,Trials(ind).Ch(iTower)).*1e3;
                                        end
                                    elseif (iTower == 1 && isfile([MonkeyDir '/' day '/' recs{r} '/rec' recs{r} '.electrodelog.txt']))
                                        Log = load([MonkeyDir '/' day '/' recs{r} '/rec' recs{r} '.electrodelog.txt']);
                                        if ~isempty(Log)
                                            lind = find(Log(:,1).*1e3 < Events.StartOn(trials(t)), 1, 'last' );
                                            if ~isempty(lind)
                                                Trials(ind).Depth{1} = Log(lind,2:end);
                                            else
                                                Trials(ind).Depth{1} = Log(1,2:end);
                                            end
                                        else
                                            Trials(ind).Depth{1} = ones(1,Trials(ind).Ch(1)).*1e3;
                                        end
                                    else
                                        if ~strcmp(tower,'MT2')
                                        Trials(ind).Depth{iTower} = ones(1,Trials(ind).Ch(iTower)).*1e3;
                                        end
                                    end
                                end
                            catch
                            end
                        elseif isfile([MonkeyDir '/' day '/' recs{r} '/rec' recs{r} '.electrodelog.txt'])
                            Log = load([MonkeyDir '/' day '/' recs{r} '/rec' recs{r} '.electrodelog.txt']);
                            if ~isempty(Log)
                                lind = find(Log(:,1).*1e3 < Events.StartOn(trials(t)), 1, 'last' );
                                if ~isempty(lind)
                                    Trials(ind).Depth{1} = Log(lind,2:end);
                                else
                                    Trials(ind).Depth{1} = Log(1,2:end);
                                end
                            else
                                Trials(ind).Depth{1} = ones(1,Trials(ind).Ch(1)).*1e3;
                            end
                        else
                            Trials(ind).Depth{1} = ones(1,Trials(ind).Ch(1)).*1e3;
                            Trials(ind).Depth{2} = ones(1,Trials(ind).Ch(2)).*1e3;
                        end
                        Trials(ind).Trial = Events.Trial(trials(t));
                        Trials(ind).StartOn = Events.StartOn(trials(t));                        
                        Trials(ind).Event = Events.Event(trials(t));
                        Trials(ind).Timestamp = Events.Timestamp(trials(t));
                        Trials(ind).End = Events.End(trials(t));
                        
                        Trials(ind).StartAq = Events.StartAq(trials(t)) - ...
                            Events.StartOn(trials(t));
                        Trials(ind).End = Events.End(trials(t)) - ...
                            Events.StartOn(trials(t));
                        Trials(ind).TargsOn = Events.TargsOn(trials(t)) - ...
                            Events.StartOn(trials(t));
                        Trials(ind).Go = Events.Go(trials(t)) - ...
                            Events.StartOn(trials(t));
                        Trials(ind).TargAq = Events.TargAq(trials(t)) - ...
                            Events.StartOn(trials(t));
                        Trials(ind).ReachStart = Events.ReachStart(trials(t)) - ...
                            Events.StartOn(trials(t));
                        Trials(ind).ReachStop = Events.ReachStop(trials(t)) - ...
                            Events.StartOn(trials(t));
                        Trials(ind).SaccStart = Events.SaccStart(trials(t)) - ...
                            Events.StartOn(trials(t));
                        Trials(ind).SaccStop = Events.SaccStop(trials(t)) - ...
                            Events.StartOn(trials(t));
                        if isfield(Events,'Sacc2Start')
                            Trials(ind).Sacc2Start = Events.Sacc2Start(trials(t)) - ...
                                Events.StartOn(trials(t));
                        else
                            Trials(ind).Sacc2Start = nan;
                        end
                        if isfield(Events,'Sacc2Stop')
                            Trials(ind).Sacc2Stop = Events.Sacc2Stop(trials(t)) - ...
                                Events.StartOn(trials(t));
                        else
                            Trials(ind).Sacc2Stop = nan;
                        end
                        if isfield(Events,'Sacc2Center')
                            Trials(ind).Sacc2Center = Events.Sacc2Center(trials(t));
                        else
                            Trials(ind).Sacc2Center = nan;
                        end
                        if isfield(Events,'Reach2Start')
                            Trials(ind).Reach2Start = Events.Reach2Start(trials(t)) - ...
                                Events.StartOn(trials(t));
                        else
                            Trials(ind).Reach2Start = nan;
                        end
                        if isfield(Events,'TargetOff')
                            Trials(ind).TargetOff = Events.TargetOff(trials(t)) - ...
                                Events.StartOn(trials(t));
                        else
                            Trials(ind).TargetOff = nan;
                        end
                        if isfield(Events,'InstOn')
                            Trials(ind).InstOn = Events.InstOn(trials(t)) - ...
                                Events.StartOn(trials(t));
                        else
                            Trials(ind).InstOn = nan;
                        end
                        if isfield(Events,'Targ2On')
                            Trials(ind).Targ2On = Events.Targ2On(trials(t)) - ...
                                Events.StartOn(trials(t));
                        else
                            Trials(ind).Targ2On = nan;
                        end
                        if isfield(Events,'TargetRet')
                            Trials(ind).TargetRet = Events.TargetRet(trials(t)) - ...
                                Events.StartOn(trials(t));
                        else
                            Trials(ind).TargetRet = nan;
                        end
                        
                        if isfield(Events,'ReachGo')
                            Trials(ind).ReachGo = Events.ReachGo(trials(t)) - ...
                                Events.StartOn(trials(t));
                        else
                            Trials(ind).ReachGo = nan;
                        end
                        if isfield(Events,'ReachAq')
                            Trials(ind).ReachAq = Events.ReachAq(trials(t)) - ...
                                Events.StartOn(trials(t));
                        else
                            Trials(ind).ReachAq = nan;
                        end
                        
                        if isfield(Events,'SaccadeGo') && length(Events.SaccadeGo) > trials(t)-1
                            Trials(ind).SaccadeGo = Events.SaccadeGo(trials(t)) - ...
                                Events.StartOn(trials(t));
                        else
                            Trials(ind).SaccadeGo = nan;
                        end
                        
                        if isfield(Events,'SaccadeAq')
                            Trials(ind).SaccadeAq = Events.SaccadeAq(trials(t)) - ...
                                Events.StartOn(trials(t));
                        else
                            Trials(ind).SaccadeAq = nan;
                        end
                        
                        if isfield(Events,'Reward2T')
                            Trials(ind).Reward2T = Events.Reward2T(trials(t));
                        else
                            Trials(ind).Reward2T = nan;
                        end
                        if isfield(Events,'RewardConfig')
                            Trials(ind).RewardConfig = Events.RewardConfig(trials(t));
                        else
                            Trials(ind).RewardConfig = nan;
                        end
                        if isfield(Events,'Choice')
                            Trials(ind).Choice = Events.Choice(trials(t));
                        else
                            Trials(ind).Choice = nan;
                        end
                        if isfield(Events,'RewardMag')
                            Trials(ind).RewardMag = Events.RewardMag(trials(t));
                        else
                            Trials(ind).RewardMag = nan;
                        end
                        if isfield(Events,'RewardBlock')
                            Trials(ind).RewardBlock = Events.RewardBlock(trials(t));
                        else
                            Trials(ind).RewardBlock = nan;
                        end
                        if isfield(Events,'HandRewardBlock')
                            Trials(ind).HandRewardBlock = Events.HandRewardBlock(trials(t));
                        else
                            Trials(ind).HandRewardBlock = nan;
                        end
                        if isfield(Events,'EyeRewardBlock')
                            Trials(ind).EyeRewardBlock = Events.EyeRewardBlock(trials(t));
                        else
                            Trials(ind).EyeRewardBlock = nan;
                        end
                        if isfield(Events,'ReachChoice')
                            Trials(ind).ReachChoice = Events.ReachChoice(trials(t));
                        else
                            Trials(ind).ReachChoice = nan;
                        end
                        if isfield(Events,'SaccadeChoice')
                            Trials(ind).SaccadeChoice = Events.SaccadeChoice(trials(t));
                        else
                            Trials(ind).SaccadeChoice = nan;
                        end
                        if isfield(Events,'ReachCircleTarget')
                            Trials(ind).ReachCircleTarget = Events.ReachCircleTarget(trials(t));
                        else
                            Trials(ind).ReachCircleTarget = nan;
                        end
                        if isfield(Events,'SaccadeCircleTarget')
                            Trials(ind).SaccadeCircleTarget = Events.SaccadeCircleTarget(trials(t));
                        else
                            Trials(ind).SaccadeCircleTarget = nan;
                        end
                        if isfield(Events,'HighReward')
                            Trials(ind).HighReward = Events.HighReward(trials(t));
                        else
                            Trials(ind).HighReward = nan;
                        end
                        if isfield(Events,'Reward')
                            Trials(ind).Reward = Events.Reward(trials(t));
                        else
                            Trials(ind).Reward = nan;
                        end
                        if isfield(Events,'RewardTask')
                            Trials(ind).RewardTask = Events.RewardTask(trials(t));
                        else
                            Trials(ind).RewardTask = 0;
                        end
                        if isfield(Events,'EyeTarget')
                            Trials(ind).EyeTarget = Events.EyeTarget(trials(t));
                        else
                            Trials(ind).EyeTarget = Events.Target(trials(t));  % Defaults to eye-hand targets linked
                        end

                        Trials(ind).Target = Events.Target(trials(t));

                        if ~isnan(Events.EyeTargetLocation)
                            Trials(ind).EyeTargetLocation = Events.EyeTargetLocation(trials(t),:);
			    Trials(ind).EyeTarget = ContinuousTarget2DiscreteTarget(Events.EyeTargetLocation(trials(t),:));
                        else
                            Trials(ind).EyeTargetLocation = zeros(1,2);
                        end
                        if ~isnan(Events.HandTargetLocation)
                            Trials(ind).HandTargetLocation = Events.HandTargetLocation(trials(t),:);
			    Trials(ind).Target = ContinuousTarget2DiscreteTarget(Events.HandTargetLocation(trials(t),:));
                        else
                            Trials(ind).HandTargetLocation = zeros(1,2);
                        end
                        if isfield(Events,'AdaptationFeedback')
                            Trials(ind).AdaptationFeedback = Events.AdaptationFeedback(trials(t));
                        else
                            Trials(ind).AdaptationFeedback = 0;
                        end
                        if isfield(Events,'AdaptationAction')
                            Trials(ind).AdaptationAction = Events.AdaptationAction(trials(t));
                        else
                            Trials(ind).AdaptationAction = 0;
                        end
                        if isfield(Events,'AdaptationPhase')
                            Trials(ind).AdaptationPhase = Events.AdaptationPhase(trials(t));
                        else
                            Trials(ind).AdaptationPhase = 9;
                        end
                        if isfield(Events,'LEDBoard')
                            Trials(ind).LEDBoard = Events.LEDBoard(trials(t));
                        else
                            Trials(ind).LEDBoard = 0;
                        end
                        if isfield(Events,'RewardDur')
                            Trials(ind).RewardDur = Events.RewardDur(trials(t),:);
                        else
                            Trials(ind).RewardDur = [0 0 0 0];
                        end
                        if isfield(Events,'RewardDist')
                            Trials(ind).RewardDist = Events.RewardDist(trials(t),:);
                        else
                            Trials(ind).RewardDist = [0 0 0 0];
                        end
                        if isfield(Events,'Reward4TNoise')
                            Trials(ind).Reward4TNoise = Events.Reward4TNoise(trials(t),:);
                        else
                            Trials(ind).Reward4TNoise = [0 0];
                        end
                        if isfield(Events,'Targ2')
                            Trials(ind).Targ2 = Events.Targ2(trials(t));
                        else
                            Trials(ind).Targ2 = 99;
                        end
                        if isfield(Events,'Separable4T')
                            Trials(ind).Separable4T = Events.Separable4T(trials(t));
                        else
                            Trials(ind).Separable4T = 9;
                        end
                        if isfield(Events,'TargMove')
                            Trials(ind).TargMove = Events.TargMove(trials(t)) - ...
                                Events.StartOn(trials(t));
                        else
                            Trials(ind).TargMove = 0;
                        end
                        if isfield(Events,'EffInstOn')
                            Trials(ind).EffInstOn = Events.EffInstOn(trials(t)) - ...
                                Events.StartOn(trials(t));
                        else
                            Trials(ind).EffInstOn = 0;
                        end
                        if isfield(Events,'MinReachRT')
                            Trials(ind).MinReachRT = Events.MinReachRT(trials(t));
                        else
                            Trials(ind).MinReachRT = nan;
                        end
                        if isfield(Events,'MaxReachRT')
                            Trials(ind).MaxReachRT = Events.MaxReachRT(trials(t));
                        else
                            Trials(ind).MaxReachRT = nan;
                        end
                        if isfield(Events,'MinReachAq')
                            Trials(ind).MinReachAq = Events.MinReachAq(trials(t));
                        else
                            Trials(ind).MinReachAq = nan;
                        end
                        if isfield(Events,'MaxReachAq')
                            Trials(ind).MaxReachAq = Events.MaxReachAq(trials(t));
                        else
                            Trials(ind).MaxReachAq = nan;
                        end
                        if isfield(Events,'MinSaccadeRT')
                            Trials(ind).MinSaccadeRT = Events.MinSaccadeRT(trials(t));
                        else
                            Trials(ind).MinSaccadeRT = nan;
                        end
                        if isfield(Events,'MaxSaccadeRT')
                            Trials(ind).MaxSaccadeRT = Events.MaxSaccadeRT(trials(t));
                        else
                            Trials(ind).MaxSaccadeRT = nan;
                        end
                        if isfield(Events,'MinSaccadeAq')
                            Trials(ind).MinSaccadeAq = Events.MinSaccadeAq(trials(t));
                        else
                            Trials(ind).MinSaccadeAq = nan;
                        end
                        if isfield(Events,'MaxSaccadeAq')
                            Trials(ind).MaxSaccadeAq = Events.MaxSaccadeAq(trials(t));
                        else
                            Trials(ind).MaxSaccadeAq = nan;
                        end
                        if isfield(Events,'MinSaccade2RT')
                            Trials(ind).MinSaccade2RT = Events.MinSaccade2RT(trials(t));
                        else
                            Trials(ind).MinSaccade2RT = nan;
                        end
                        if isfield(Events,'MaxSaccade2RT')
                            Trials(ind).MaxSaccade2RT = Events.MaxSaccade2RT(trials(t));
                        else
                            Trials(ind).MaxSaccade2RT = nan;
                        end
                        if isfield(Events,'MinSaccade2Aq')
                            Trials(ind).MinSaccade2Aq = Events.MinSaccade2Aq(trials(t));
                        else
                            Trials(ind).MinSaccade2Aq = nan;
                        end
                        if isfield(Events,'MaxSaccade2RT')
                            Trials(ind).MaxSaccade2RT = Events.MaxSaccade2RT(trials(t));
                        else
                            Trials(ind).MaxSaccade2RT = nan;
                        end
                        Trials(ind).HandCode = Events.HandCode(trials(t));
                        Trials(ind).TaskCode = Events.TaskCode(trials(t));
                        Trials(ind).Joystick = Events.Joystick(trials(t));
                        Trials(ind).StartHand = Events.StartHand(trials(t));
                        Trials(ind).StartEye = Events.StartEye(trials(t));
                        Trials(ind).Success = Events.Success(trials(t));
                        Trials(ind).Saccade = Events.Saccade(trials(t));
                        Trials(ind).Reach = Events.Reach(trials(t));
                        if isfield(Events,'DoubleStep')
                            Trials(ind).DoubleStep = Events.DoubleStep(trials(t));
                        else
                            Trials(ind).DoubleStep = 0;
                        end
                        
                        if isfield(Events,'BrightVals')
                            Trials(ind).BrightVals = Events.BrightVals(trials(t),:);
                        else
                            Trials(ind).BrightVals = nan;
                        end
                        
                        if isfield(Events,'BrightDist')
                            Trials(ind).BrightDist = Events.BrightDist(trials(t),:);
                        else
                            Trials(ind).BrightDist = nan;
                        end
                        
                        if isfield(Events,'T1T2Locations')
                            Trials(ind).T1T2Locations = squeeze(Events.T1T2Locations(trials(t),:,:));
                        else
                            Trials(ind).T1T2Locations = nan;
                        end
                        
                        if isfield(Events,'T1T2Delta')
                            Trials(ind).T1T2Delta = Events.T1T2Delta(trials(t));
                        else
                            Trials(ind).T1T2Delta = nan;
                        end
                        
                        if isfield(Events,'TargetScale')
                            Trials(ind).TargetScale = Events.TargetScale(trials(t));
                            Trials(ind).Target2Scale = Events.Target2Scale(trials(t));
                        else
                            Trials(ind).TargetScale = nan;
                            Trials(ind).Target2Scale = nan;
                        end
                        if isfield(Events,'RewardSwitchPoint')
                            Trials(ind).RewardSwitchPoint = Events.RewardSwitchPoint;
                        else
                            Trials(ind).RewardSwitchPoint = [nan,nan];
                        end
                        %                         try
                        if isfield(Events,'SaccadeChoiceContinuousLocation')
                            Trials(ind).SaccadeChoiceContinuousLocation = Events.SaccadeChoiceContinuousLocation(trials(t),:);
                        else
                            Trials(ind).SaccadeChoiceContinuousLocation = nan;
                        end
                        %                         catch
                        %                           disp('Field "SaccadeChoiceContinuousLocation" not found: run procChoice to generate');
                        %                         end
                        
                        if isfield(Events,'UnchosenTargetContinuousLocation')
                            Trials(ind).UnchosenTargetContinuousLocation = Events.UnchosenTargetContinuousLocation(trials(t),:);
                        else
                            Trials(ind).UnchosenTargetContinuousLocation = nan;
                        end
                        if isfield(Events,'UnchosenTarget')
                            Trials(ind).UnchosenTarget = Events.UnchosenTarget(trials(t));
                        else
                            Trials(ind).UnchosenTarget = nan;
                        end
                        
                        if isfield(Events,'RewardVolumeVals')
                            Trials(ind).RewardVolumeVals = Events.RewardVolumeVals(trials(t),:);
                            Trials(ind).RewardVolumeDist = Events.RewardVolumeDist(trials(t),:);
                            Trials(ind).TargetLuminanceVals = Events.TargetLuminanceVals(trials(t),:);
                            % Trials(ind).TargetLuminanceDist = Events.TargetLuminanceDist(trials(t),:);
                        else
                            Trials(ind).RewardVolumeVals = nan;
                            Trials(ind).RewardVolumeDist = nan;
                            Trials(ind).TargetLuminanceVals = nan;
                            % Trials(ind).TargetLuminanceDist = nan;
                        end
                        
                        if isfield(Events,'BrightVals')
                            Trials(ind).BrightVals = Events.BrightVals(trials(t),:);
                        else
                            Trials(ind).BrightVals = nan;
                        end
                        
                        if isfield(Events,'BrightDist')
                            Trials(ind).BrightDist = Events.BrightDist(trials(t),:);
                        else
                            Trials(ind).BrightDist = nan;
                        end
                        
                        if isfield(Events,'T1T2Locations')
                            Trials(ind).T1T2Locations = squeeze(Events.T1T2Locations(trials(t),:,:));
                        else
                            Trials(ind).T1T2Locations = nan;
                        end
                        
                        if isfield(Events,'T1T2Delta')
                            Trials(ind).T1T2Delta = Events.T1T2Delta(trials(t));
                        else
                            Trials(ind).T1T2Delta = nan;
                        end
                        
                        if isfield(Events,'TargetScale')
                            Trials(ind).TargetScale = Events.TargetScale(trials(t));
                            Trials(ind).Target2Scale = Events.Target2Scale(trials(t));
                        else
                            Trials(ind).TargetScale = nan;
                            Trials(ind).Target2Scale = nan;
                        end
                        
                        try
                            if isfield(Events,'EyeChoiceContinuousLocation')
                                Trials(ind).EyeChoiceContinuousLocation = Events.EyeChoiceContinuousLocation(trials(t),:);
                            else
                                Trials(ind).EyeChoiceContinuousLocation = nan;
                            end
                        catch
                            disp('Field "EyeChoiceContinuousLocation" not found: run procChoice to generate');
                        end
                        
                        if isfield(Events,'RewardBlockTrial')
                            Trials(ind).RewardBlockTrial = Events.RewardBlockTrial(trials(t));
                        else
                            Trials(ind).RewardBlockTrial = nan;
                        end
                        
                    end         %  Loop over trials
                    
                end
            end           %  if events
        end           %  Loop over recs
    end             %  if saved Trials.mat file
end             %  Loop over days

cd(olddir);

if ind==0
    Trials = [];
end
