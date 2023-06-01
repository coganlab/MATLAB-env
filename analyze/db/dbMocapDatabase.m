function [Trials] = dbMocapDatabase(Days,MonkeyDir)
%  DBMOCAPDATABASE contructs MocapTrials data structure across Days.
%
%  [MOCAPTRIALS] = DBMOCAPDATABASE(DAYS);
%
%  Inputs:  DAYS    =   Cell array.  Days to include.
%                           ie to {'020822',020823','020824'}
%
%  Outputs: MOCAPTRIALS =  Structure array. Trials data structure for each recording.
%                       Only successful trials are returned.

global MONKEYDIR
if nargin < 3 || isempty(MonkeyDir)
    MonkeyDir = MONKEYDIR;
end


if ~iscell(Days)  Days = str2cell(Days);  end

disp('Making Mocap database');

nd = length(Days);
trial_num = 1;
total_trial_num = 1;
clear Trials
START_STATE = 1;
REWARD_STATE = 8;
DEL_REACH = 2;
CHASE = 5;
ErrorTrials = [];
error_trial = 0;
trial_num = 1;
error_trial_num = 1;
total_trial_num = 1;
ind = 0;
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
            recs = dayrecs(day);
            nr = length(recs);
            r = 1;
            local_trial_num = 1;
            rec = recs{r};
            load([MONKEYDIR '/' day '/' rec '/rec' rec '.experiment.mat'])
        else
            recs = dayrecs(day);
            nr = length(recs);
            disp([num2str(nr) ' recordings']);
            for r = 1:nr
                local_trial_num = 1;
                rec = recs{r};
                cd([MONKEYDIR '/' day '/' rec])
                file_name = ['rec' rec '.Vizard.mat'];
                load([MONKEYDIR '/' day '/' rec '/rec' rec '.experiment.mat'])
                if(isfile(file_name))
                    %Vizard session
                    disp(['loading rec' rec])
                    load(['rec' rec '.Vizard.mat'])
                    
                    state_codes = ev(4,:);
                    times = ev(1,:);
                    frame_num = ev(2,:);
                    task = ev(3,:);
                    init_pos = ev(5:7,:);
                    target_pos = ev(10:12,:);
                    hit_window = ev(14:16,:);
                    three_d = ev(17,:);
                    try
                        target_size = ev(18:20,:);
                    catch
                        target_size = nan(3,size(ev,2));
                    end
                    try
                        target_rot_err = ev(21,:);
                    catch
                        target_rot_err = nan(1,size(ev,2));
                    end
                    try
                        target_rot = ev(22:24,:);
                    catch
                        target_rot = nan(3,size(ev,2));
                    end
                    try
                        grasp_trial = ev(25,:);
                    catch
                        grasp_trial = nan(1,size(ev,2));
                    end
                    try
                        shoulder_position = ev(26:28,:);
                    catch
                        shoulder_position = nan(3,size(ev,2));
                    end
                    correct_trials = sum(state_codes == REWARD_STATE);
                    total_trials = sum(state_codes == START_STATE);
                    
                    for iEvents = 9:length(state_codes)
                        if(state_codes(iEvents) == REWARD_STATE)
                            Trials(trial_num).TaskCode = task(iEvents);
                            Trials(trial_num).Day = day;
                            if(task(iEvents) == DEL_REACH) % Del Reach
                                Trials(trial_num).Rec = rec;
                                Trials(trial_num).Trial = local_trial_num;
                                Trials(trial_num).Reward = times(iEvents);
                                Trials(trial_num).TargAq = times(iEvents-2);
                                Trials(trial_num).Go = times(iEvents-3);
                                
                                Trials(trial_num).Delay = times(iEvents-4);
                                Trials(trial_num).StartAq = times(iEvents-6);
                                Trials(trial_num).Start = times(iEvents-7);
                                Trials(trial_num).StartPos = init_pos(:,iEvents);
                                Trials(trial_num).TargetPos = target_pos(:,iEvents);
                                Trials(trial_num).HitWin = hit_window(:,iEvents);
                                Trials(trial_num).FrameNum = frame_num(:,iEvents);
                                Trials(trial_num).ThreeD = three_d(:,iEvents);
                                Trials(trial_num).TargSize = target_size(:,iEvents);
                                Trials(trial_num).TargRotErr = target_rot_err(:,iEvents);
                                Trials(trial_num).TargRot = target_rot(:,iEvents);
                                Trials(trial_num).Grasp = grasp_trial(:,iEvents);
                                Trials(trial_num).ShoulderPos = shoulder_position(:,iEvents);
                                trial_num = trial_num+1;
                                local_trial_num = local_trial_num+1;
                                error_trial = 0;
                            elseif(task(iEvents) == CHASE)
                                Trials(trial_num).Rec = rec;
                                Trials(trial_num).Trial = local_trial_num;
                                Trials(trial_num).Reward = times(iEvents);
                                Trials(trial_num).TargAq = times(iEvents-2);
                                Trials(trial_num).Go = times(iEvents-3);
                                Trials(trial_num).Delay = NaN;
                                Trials(trial_num).StartAq = NaN;
                                Trials(trial_num).Start = times(iEvents-4);
                                Trials(trial_num).StartPos = init_pos(:,iEvents);
                                Trials(trial_num).TargetPos = target_pos(:,iEvents);
                                Trials(trial_num).HitWin = hit_window(:,iEvents);
                                Trials(trial_num).FrameNum = frame_num(:,iEvents);
                                Trials(trial_num).ThreeD = three_d(:,iEvents);
                                Trials(trial_num).TargSize = target_size(:,iEvents);
                                Trials(trial_num).TargRotErr = target_rot_err(:,iEvents);
                                Trials(trial_num).TargRot = target_rot(:,iEvents);
                                Trials(trial_num).Grasp = grasp_trial(:,iEvents);
                                Trials(trial_num).ShoulderPos = shoulder_position(:,iEvents);
                                trial_num = trial_num+1;
                                local_trial_num = local_trial_num+1;
                                error_trial = 0;
                            end
                            total_trial_num = total_trial_num+1;
                        elseif(state_codes(iEvents) == START_STATE)
                            if(error_trial == 1)
                                ErrorTrials(error_trial_num).TaskCode =  task(iEvents);
                                ErrorTrials(error_trial_num).Rec = rec;
                                ErrorTrials(error_trial_num).Trial = error_trial_num;
                                ErrorTrials(error_trial_num).Reward = NaN;
                                ErrorTrials(error_trial_num).TargAq = NaN;
                                ErrorTrials(error_trial_num).Go = NaN;
                                ErrorTrials(error_trial_num).Delay = NaN;
                                ErrorTrials(error_trial_num).StartAq = NaN;
                                ErrorTrials(error_trial_num).Start = NaN;
                                ErrorTrials(error_trial_num).StartPos = init_pos(:,iEvents);
                                ErrorTrials(error_trial_num).TargetPos = target_pos(:,iEvents);
                                ErrorTrials(error_trial_num).HitWin = hit_window(:,iEvents);
                                ErrorTrials(error_trial_num).FrameNum = frame_num(:,iEvents);
                                ErrorTrials(error_trial_num).ThreeD = three_d(:,iEvents);
                                ErrorTrials(error_trial_num).TargSize = target_size(:,iEvents);
                                ErrorTrials(error_trial_num).TargRotErr = target_rot_err(:,iEvents);
                                ErrorTrials(error_trial_num).TargRot = target_rot(:,iEvents);
                                ErrorTrials(error_trial_num).Grasp = grasp_trial(:,iEvents);
                                ErrorTrials(error_trial_num).ShoulderPos = shoulder_position(:,iEvents);
                                errorEvents = iEvents-last_start;
                                if(errorEvents > 0)
                                    for iErrorEvents = 0:(errorEvents-2);
                                        if(iErrorEvents == 1)
                                            ErrorTrials(error_trial_num).Start = times(last_start +iErrorEvents);
                                        elseif(iErrorEvents == 2)
                                            ErrorTrials(error_trial_num).StartAq =  times(last_start +iErrorEvents);
                                        elseif(iErrorEvents == 3)
                                            ErrorTrials(error_trial_num).Delay = times(last_start +iErrorEvents);
                                        elseif(iErrorEvents == 4)
                                            ErrorTrials(error_trial_num).Go = times(last_start +iErrorEvents);
                                        elseif(iErrorEvents == 5)
                                            ErrorTrials(error_trial_num).TargAq = times(last_start +iErrorEvents);
                                        elseif(iErrorEvents == 6)
                                            ErrorTrials(error_trial_num).Reward = times(last_start +iErrorEvents);
                                        end
                                    end
                                end
                                total_trial_num = total_trial_num+1;
                                error_trial_num = error_trial_num+1;
                            else
                                error_trial = 1;
                            end
                            last_start = iEvents;
                        end
                    end
                elseif(isfile(['rec' recs{r} '.GraspBehavior.mat']));
                    load(['rec' recs{r} '.GraspBehavior.mat'])
                    load(['rec' rec '.experiment.mat'])
                    reach_start = behavior.reachStart;
                    reach_stop = behavior.reachStop;
                    for itr = 1:min(length(reach_start),length(reach_stop))
                        Trials(trial_num).TaskCode = 9; %DelReach
                        Trials(trial_num).Day = day;
                        Trials(trial_num).Rec = rec;
                        Trials(trial_num).Trial = local_trial_num;
                        Trials(trial_num).TargAq = behavior.reachStop(itr);
                        Trials(trial_num).ReachStart = behavior.reachStart(itr);
                        
                        
                        Trials(trial_num).Go = NaN;
                        Trials(trial_num).Reward = NaN;
                        Trials(trial_num).Delay = NaN;
                        Trials(trial_num).StartAq = NaN;
                        Trials(trial_num).Start = NaN;
                        Trials(trial_num).StartPos = NaN;
                        Trials(trial_num).TargetPos = NaN;
                        Trials(trial_num).HitWin = NaN;
                        Trials(trial_num).FrameNum = NaN;
                        Trials(trial_num).ThreeD = NaN;
                        Trials(trial_num).TargSize = NaN;
                        Trials(trial_num).TargRotErr = NaN;
                        Trials(trial_num).TargRot = NaN;
                        Trials(trial_num).Grasp = NaN;
                        Trials(trial_num).ShoulderPos = NaN;
                        trial_num = trial_num+1;
                        total_trial_num = total_trial_num+1;
                        local_trial_num = local_trial_num+1;
                    end
                else
                    
                    
                    
                        tmp = r;
                        Trials(tmp).Joystick = 0;
                        for microdrives = 1:length(experiment.hardware.microdrive)
                            if isfield(experiment.hardware.microdrive(microdrives),'name')
                                Trials(tmp).MT{microdrives} = experiment.hardware.microdrive(microdrives).name;
                                Trials(tmp).Ch(microdrives) = length(experiment.hardware.microdrive(microdrives).electrodes);
                                for electrodes = 1:length(experiment.hardware.microdrive(microdrives).electrodes)
                                    Trials(tmp).Gain(microdrives).Electrode(electrodes) = experiment.hardware.microdrive(microdrives).electrodes(electrodes).gain;
                                    if isfield(experiment.hardware.microdrive(microdrives).electrodes(electrodes),'numContacts')
                                        Trials(tmp).NumContacts(microdrives).Electrode(electrodes) = experiment.hardware.microdrive(microdrives).electrodes(electrodes).numContacts;
                                    else
                                        Trials(tmp).NumContacts(microdrives).Electrode(electrodes) = 1;
                                    end
                                end
                            end
                            if ~isfield(experiment.acquire,'IsoWin')
                                IsoWin = 100e3;
                            else
                                IsoWin = experiment.acquire.IsoWin;
                            end
                            if isfield(experiment.hardware.microdrive(microdrives),'name')

                                    for c = 1:Trials(tmp).Ch
                                        Trials(tmp).Iso{microdrives,c} = 1;
                                    end
                            end
                        end
                        Trials(tmp).Fs = experiment.hardware.acquisition(1).samplingrate;
                        for iTower = 1:length(experiment.hardware.microdrive)
                            tower = experiment.hardware.microdrive(iTower).name;
                            if isfile([MonkeyDir '/' day '/' recs{r} '/rec' recs{r} '.' tower '.electrodelog.txt'])
                                Log = load([MonkeyDir '/' day '/' recs{r} '/rec' recs{r} '.' tower '.electrodelog.txt']);
                                if ~isempty(Log)
                                    Trials(tmp).Depth{iTower} = Log(1,2:end);
                                else
                                    Trials(tmp).Depth{iTower} = ones(1,Trials(tmp).Ch(iTower)).*1e3;
                                end
                            end
                        end
                        
                        
                        
                    
                end
            end
        end
    end
end
