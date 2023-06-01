function [Trials] = dbLaserAwakeDatabase(Days)
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
cd(MONKEYDIR);

if ~iscell(Days)  Days = str2cell(Days);  end

disp('Making plexon database');

nd = length(Days);
ind = 0;
clear Trials
NumTrials = 0;
%experiment_structure = 0;
for d = 1:nd
    day = Days{d};
    disp(['Day: ' day]);
    if isdir([MONKEYDIR '/' day])
        
        cd([MONKEYDIR '/' day])
        % For some strange path reason this needs to be made explicit on z4
        if isfile([MONKEYDIR '/' day '/mat/Trials.mat'])
            disp('loading trials from mat file')
            Tmp = load([MONKEYDIR '/' day '/mat/Trials.mat']);
            disp('done loading')
            Trials(ind+1:ind+length(Tmp.Trials)) = Tmp.Trials;
            ind = ind+length(Tmp.Trials);
        else
            recs = dayrecs(day);
            nr = length(recs);
            disp([num2str(nr) ' recordings']);
            
            for r = 1:nr
                disp(['Recording: ' recs{r}]);
                cd([MONKEYDIR '/' day '/' recs{r}]);
                %            isfile(['rec' recs{r} '.Events.mat']);
                if isfile(['rec' recs{r} '.Events.mat'])
                    load(['rec' recs{r} '.Events.mat']);
                    if (~isfile(['rec' recs{r} '.experiment.mat']))
                        load(['rec' recs{r} '.Rec.mat']);
                    else
                        experiment_structure = 1;
                        load(['rec' recs{r} '.experiment.mat']);
                    end
                    
                    ntr = length(Events.StartOn);
                    trials = find(Events.StartOn);
                    
                    for t = 1:ntr
                        ind = ind+1;
                        Trials(ind).Day = day;
                        Trials(ind).Rec = recs{r};
                        Trials(ind).Trial = t;
                        for microdrives = 1:length(experiment.hardware.microdrive)
                            Trials(ind).MT{microdrives} = experiment.hardware.microdrive(microdrives).name;
                            Trials(ind).Ch(microdrives) = length(experiment.hardware.microdrive(microdrives).electrodes);
                            for electrodes = 1:length(experiment.hardware.microdrive(microdrives).electrodes)
                                Trials(ind).Gain{microdrives}{electrodes}  = experiment.hardware.microdrive(microdrives).electrodes(electrodes).gain;
                                %                                 Trials(ind).Gain = 1e4;
                            end
                        end
                        Trials(ind).Fs = experiment.hardware.acquisition(1).samplingrate;
                        
                        Trials(ind).StartOn = Events.StartOn(t);
                        Trials(ind).TargsOn = Events.TargsOn(t);
                        Trials(ind).PulseStarts = Events.PulseStarts(t);
                        Trials(ind).PulseDur = Events.PulseDur(t);
                        Trials(ind).PulseAmp = Events.PulseAmp(t);
                        Trials(ind).PulseFreq = Events.PulseFreq(t);
                        Trials(ind).Burst = Events.Burst(t);
                        
                        Trials(ind).End = Events.End(t) - Events.StartOn(t);
                        Trials(ind).TaskCode = 100;
                        Trials(ind).Joystick = 0;
                        Trials(ind).Choice = 0;
                        Trials(ind).Target = 1;
                        Trials(ind).Task = 'LaserStim';
                        %this is a temporary hack (2/21/13)
                        for microdrives = 1:length(experiment.hardware.microdrive)
                            nChan = Trials(ind).Ch(microdrives);
                            for c = 1:nChan
                                Trials(ind).Iso{microdrives,c} = 1;
                            end
                        end
                        %                         Trials(ind).Iso = [];
                        %pull in info from Rec file - height, etc.
                        if(experiment_structure)
                            try
                                for iTower = 1:length(experiment.hardware.microdrive)
                                    tower = experiment.hardware.microdrive(iTower).name;
                                    if isfile([MONKEYDIR '/' day '/' recs{r} '/rec' recs{r} '.' tower '.electrodelog.txt'])
                                        Log = load([MONKEYDIR '/' day '/' recs{r} '/rec' recs{r} '.' tower '.electrodelog.txt']);
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
                                    elseif (iTower == 1 && isfile([MONKEYDIR '/' day '/' recs{r} '/rec' recs{r} '.electrodelog.txt']))
                                        Log = load([MONKEYDIR '/' day '/' recs{r} '/rec' recs{r} '.electrodelog.txt']);
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
                        elseif isfile([MONKEYDIR '/' day '/' recs{r} '/rec' recs{r} '.electrodelog.txt'])
                            Log = load([MONKEYDIR '/' day '/' recs{r} '/rec' recs{r} '.electrodelog.txt']);
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
                        
                    end         %  Loop over trials
                    
                end
            end             %  if events
        end           %  Loop over recs
    end             %  if saved Trials.mat file
end             %  Loop over days

cd(olddir);

if ind==0
    Trials = [];
end
