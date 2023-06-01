function  saveVizardTrials(day)



global MONKEYDIR
STROBE_THRESHOLD = 1e4;
START_STATE = 1;
REWARD_STATE = 8;
DEL_REACH = 2;%center out
CHASE = 5;
olddir = pwd;

recs = dayrecs(day);
nRecs = length(recs);

Trials = [];
ErrorTrials = [];
trial_num = 1;
error_trial_num = 1;
total_trial_num = 1;
error_trial = 0;
for iNum = 1:nRecs
    rec = recs{iNum};
    if exist([MONKEYDIR '/' day '/' rec],'dir')
        cd([ MONKEYDIR '/' day '/' rec])
        if isfile([MONKEYDIR '/' day '/' recs{iNum} '/rec' rec '.MocapEvents.mat'])
            load([MONKEYDIR '/' day '/' rec '/rec' rec '.MocapEvents.mat']);
        end
    else
        continue
    end
    
    
    %trials = find(MocapEvents.Success);
    %ntr = length(trials);
    
    if(isfile(['rec' rec '.Vizard.mat']))
        disp(['loading rec' rec])
        load(['rec' rec '.Vizard.mat'])
        load([MONKEYDIR '/' day '/' rec '/rec' rec '.experiment.mat'])
        
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
                if(task(iEvents) == DEL_REACH) % Del Reach
                    %Trials(trial_num).TaskCode=9;
                    %Trials(trial_num).JoyCode=0;
                    if(isfield(experiment.hardware,'microdrive'))
                        for microdrives = 1:length(experiment.hardware.microdrive)
                            if isfield(experiment.hardware.microdrive(microdrives),'name')
                                Trials(trial_num).MT{microdrives} = experiment.hardware.microdrive(microdrives).name;
                                Trials(trial_num).Ch(microdrives) = length(experiment.hardware.microdrive(microdrives).electrodes);
                                for electrodes = 1:length(experiment.hardware.microdrive(microdrives).electrodes)
                                    Trials(trial_num).Gain  = experiment.hardware.microdrive(microdrives).electrodes(electrodes).gain;
                                end
                            end
                        end
                    end
                    for iTower = 1:length(experiment.hardware.microdrive)
                        tower = experiment.hardware.microdrive(iTower).name;
                        if isfile([MONKEYDIR '/' day '/' rec '/rec' rec '.' tower '.electrodelog.txt'])
                            Log = load([MONKEYDIR '/' day '/' rec '/rec' rec '.' tower '.electrodelog.txt']);
                            if ~isempty(Log)
                                lind = find(Log(:,1).*1e3 < MocapEvents.StartOn(1), 1, 'last' );
                                if ~isempty(lind)
                                    Trials(trial_num).Depth{iTower} = Log(lind,2:end);
                                else
                                    Trials(trial_num).Depth{iTower} = Log(1,2:end);
                                end
                            else
                                Trials(trial_num).Depth{iTower} = ones(1,Trials(trial_num).Ch(iTower)).*1e3;
                                Trials(trial_num).Depth{iTower}=NaN;
                            end
                        else
                            Trials(trial_num).Depth{iTower} = ones(1,Trials(trial_num).Ch(iTower)).*1e3;
                            Trials(trial_num).Depth{iTower}=NaN;
                        end
                    end
                    %                         MocapTrials(ind).Trial = MocapEvents.Trial(trials(t));
                    %                         MocapTrials(ind).StartOn = MocapEvents.StartOn(trials(t));
                    %                         MocapTrials(ind).End = MocapEvents.End(trials(t)) - ...
                    %                             MocapEvents.StartOn(trials(t));
                    
                    
                    Trials(trial_num).Day = day;
                    Trials(trial_num).Rec = rec;
                    Trials(trial_num).Trial = total_trial_num;
                    
                    Trials(trial_num).StartPos = init_pos(:,iEvents);
                    Trials(trial_num).TargetPos = target_pos(:,iEvents);
                    
                    
                    if target_pos(1,iEvents)==init_pos(1,iEvents)%same x-position
                        if target_pos(2,iEvents)>init_pos(2,iEvents)%target y-coordinate is greater than start position
                            Trials(trial_num).Target = 3;
                        end
                    elseif target_pos(1,iEvents)==init_pos(1,iEvents)%same x-position
                        if target_pos(2,iEvents)<init_pos(2,iEvents)%target y-coordinate is less than start position
                            Trials(trial_num).Target = 7;
                        end
                    elseif target_pos(2,iEvents)==init_pos(2,iEvents) %y is same
                        if target_pos(1,iEvents)>init_pos(1,iEvents)%target x is greater than start pos.
                            Trials(trial_num).Target = 1;
                        end
                    elseif target_pos(2,iEvents)==init_pos(2,iEvents) %y is same
                        if target_pos(1,iEvents)<init_pos(1,iEvents)%target x is less than start pos.
                            Trials(trial_num).Target = 5;
                        end
                    elseif target_pos(1,iEvents)>init_pos(1,iEvents) %x is greater than start pos.
                        if target_pos(2,iEvents)>init_pos(2,iEvents)%target y is greater than start pos.
                            Trials(trial_num).Target = 2;
                        end
                    elseif target_pos(1,iEvents)>init_pos(1,iEvents) %x is greater than start pos.
                        if target_pos(2,iEvents)<init_pos(2,iEvents)%target y is less than start pos.
                            Trials(trial_num).Target = 8;
                        end
                    elseif target_pos(1,iEvents)<init_pos(1,iEvents) %x is less than start pos.
                        if target_pos(2,iEvents)>init_pos(2,iEvents)%target y is greater than start pos.
                            Trials(trial_num).Target = 4;
                        end
                    elseif target_pos(1,iEvents)<init_pos(1,iEvents) %x is less than start pos.
                        if target_pos(2,iEvents)<init_pos(2,iEvents)%target y is less than start pos.
                            Trials(trial_num).Target = 6;
                        end
                    end
                    
                    %Trials(trial_num).Target = NaN;	 %  Target location code
                    Trials(trial_num).TargsOn = NaN; %same as delay timestamp?
                    Trials(trial_num).ReachStart = NaN; %  Time reach started
                    Trials(trial_num).ReachStop = NaN;  %  Time reach stopped
                    
                    Trials(trial_num).Reward = times(iEvents);
                    Trials(trial_num).TargAq = times(iEvents-2);
                    Trials(trial_num).Go = times(iEvents-3);
                    Trials(trial_num).StartOn = times(iEvents-4);
                    Trials(trial_num).Delay = NaN;
                    Trials(trial_num).StartAq = NaN;
                    Trials(trial_num).HitWindow = hit_window(:,iEvents);
                    Trials(trial_num).FrameNum = frame_num(:,iEvents);
                    Trials(trial_num).ThreeD = three_d(:,iEvents);
                    Trials(trial_num).TargSize = target_size(:,iEvents);
                    Trials(trial_num).TargRotErr = target_rot_err(:,iEvents);
                    Trials(trial_num).TargRot = target_rot(:,iEvents);
                    Trials(trial_num).Grasp = grasp_trial(:,iEvents);
                    Trials(trial_num).ShoulderPos = shoulder_position(:,iEvents);
                    Trials(trial_num).TargetOff = NaN;
                    Trials(trial_num).TargetRet = NaN;
                    Trials(trial_num).HandCode = NaN;  %  Hand?.  1 = right.  0 = left. 2 = bimanual.
                    Trials(trial_num).StartHand = NaN;  %  Initial hand location code
                    Trials(trial_num).Choice = NaN;
                    Trials(trial_num).Reward = NaN;
                    Trials(trial_num).RewardMag = NaN;
                    Trials(trial_num).Reach = NaN;      %  Is Reach trial
                    Trials(trial_num).SaccStart = NaN;  %  Time saccade started
                    Trials(trial_num).SaccStop = NaN;   %  Time saccade finished
                    Trials(trial_num).Saccade = NaN;
                    Trials(trial_num).StartEye =  NaN;  %  Initial eye location code
                    Trials(trial_num).Reward2T = NaN;
                    Trials(trial_num).Joystick = NaN;   %  Joystick?  0 = Touch; 1 = Joystick
                    Trials(trial_num).InstOn = NaN;
                    Trials(trial_num).Success = 1;
                    %Trials(trial_num).Ch = [32 32 32 32 32];
                    Trials(trial_num).End = NaN;
                    %Trials(trial_num).MT = {'L_PMv','L_PMd','R_PMd','R_PMv','L_PPC'};
                    %Trials(trial_num).Gain = NaN;
                    Trials(trial_num).Fs = NaN;
                    Trials(trial_num).Iso = NaN;
                    %Trials(trial_num).Depth = NaN;
                    Trials(trial_num).Sacc2Start = NaN;
                    Trials(trial_num).Sacc2Stop = NaN;
                    Trials(trial_num).Sacc2Center = NaN;
                    Trials(trial_num).Reach2Start = NaN;
                    Trials(trial_num).Targ2On = NaN;
                    Trials(trial_num).ReachGo = NaN;
                    Trials(trial_num).ReachAq = NaN;
                    Trials(trial_num).SaccadeGo = NaN;
                    Trials(trial_num).SaccadeAq = NaN;
                    Trials(trial_num).Reward2T = NaN;
                    Trials(trial_num).RewardConfig = NaN;
                    Trials(trial_num).RewardBlock = NaN;
                    Trials(trial_num).HandRewardBlock = NaN;
                    Trials(trial_num).ReachChoice = NaN;
                    Trials(trial_num).EyeRewardBlock = NaN;
                    Trials(trial_num).SaccadeChoice = NaN;
                    Trials(trial_num).ReachCircleTarget = NaN;
                    Trials(trial_num).SaccadeCircleTarget = NaN;
                    Trials(trial_num).HighReward = NaN;
                    Trials(trial_num).RewardTask = NaN;
                    Trials(trial_num).EyeTarget = NaN;
                    Trials(trial_num).EyeTargetLocation = NaN;
                    Trials(trial_num).HandTargetLocation = NaN;
                    Trials(trial_num).AdaptationFeedback = NaN;
                    Trials(trial_num).AdaptationAction = NaN;
                    Trials(trial_num).AdaptationPhase = NaN;
                    Trials(trial_num).LEDBoard = NaN;
                    Trials(trial_num).RewardDur = NaN;
                    Trials(trial_num).RewardDist = NaN;
                    Trials(trial_num).Reward4TNoise = NaN;
                    Trials(trial_num).Targ2 = NaN;
                    Trials(trial_num).Separable4T = NaN;
                    Trials(trial_num).TargMove = NaN;
                    Trials(trial_num).EffInstOn = NaN;
                    Trials(trial_num).MinReachRT = NaN;
                    Trials(trial_num).MaxReachRT = NaN;
                    Trials(trial_num).MinReachAq = NaN;
                    Trials(trial_num).MaxReachAq = NaN;
                    Trials(trial_num).MinSaccadeRT = NaN;
                    Trials(trial_num).MaxSaccadeRT = NaN;
                    Trials(trial_num).MinSaccadeAq = NaN;
                    Trials(trial_num).MaxSaccadeAq = NaN;
                    Trials(trial_num).MinSaccade2RT = NaN;
                    Trials(trial_num).MaxSaccade2RT = NaN;
                    Trials(trial_num).Minsaccade2Aq = NaN;
                    Trials(trial_num).MaxSaccade2Aq = NaN;
                    Trials(trial_num).DoubleSTep = NaN;
                    Trials(trial_num).BrightVals = NaN;
                    Trials(trial_num).BrightDist = NaN;
                    Trials(trial_num).T1T2Locations = NaN;
                    Trials(trial_num).T1T2Delta = NaN;
                    Trials(trial_num).TargetScale = NaN;
                    Trials(trial_num).Target2Scale = NaN;
                    Trials(trial_num).RewardSwitchPoint = NaN;
                    Trials(trial_num).SaccadeChoiceContinuousLocation = NaN;
                    Trials(trial_num).UnchosenTargetContinuousLocation = NaN;
                    Trials(trial_num).UnchosenTarget = NaN;
                    Trials(trial_num).RewardVolumeVals = NaN;
                    Trials(trial_num).RewardVolumeDist = NaN;
                    Trials(trial_num).TargetLuminanceVals = NaN;
                    Trials(trial_num).EyeChoiceContinuousLocation = NaN;
                    Trials(trial_num).RewardBlockTrial = NaN;
                    
                    trial_num = trial_num+1;
                    error_trial = 0;
                elseif(task(iEvents) == CHASE)
                    %Trials(trial_num).TaskCode=1; %corresponds to touch
                    if(isfield(experiment.hardware,'microdrive'))
                        for microdrives = 1:length(experiment.hardware.microdrive)
                            if isfield(experiment.hardware.microdrive(microdrives),'name')
                                Trials(trial_num).MT{microdrives} = experiment.hardware.microdrive(microdrives).name;
                                Trials(trial_num).Ch(microdrives) = length(experiment.hardware.microdrive(microdrives).electrodes);
                                for electrodes = 1:length(experiment.hardware.microdrive(microdrives).electrodes)
                                    Trials(trial_num).Gain  = experiment.hardware.microdrive(microdrives).electrodes(electrodes).gain;
                                end
                            end
                        end
                    end
                    
                    for iTower = 1:length(experiment.hardware.microdrive)
                        tower = experiment.hardware.microdrive(iTower).name;
                        if isfile([MONKEYDIR '/' day '/' rec '/rec' rec '.' tower '.electrodelog.txt'])
                            Log = load([MONKEYDIR '/' day '/' rec '/rec' rec '.' tower '.electrodelog.txt']);
                            if ~isempty(Log)
                                lind = find(Log(:,1).*1e3 < MocapEvents.StartOn(1), 1, 'last' );
                                if ~isempty(lind)
                                    Trials(trial_num).Depth{iTower} = Log(lind,2:end);
                                else
                                    Trials(trial_num).Depth{iTower} = Log(1,2:end);
                                end
                            else
                                Trials(trial_num).Depth{iTower} = ones(1,Trials(trial_num).Ch(iTower)).*1e3;
                                Trials(trial_num).Depth{iTower}=NaN;
                            end
                        else
                            Trials(trial_num).Depth{iTower} = ones(1,Trials(trial_num).Ch(iTower)).*1e3;
                            Trials(trial_num).Depth{iTower}=NaN;
                        end
                    end
                    %                         MocapTrials(ind).Trial = MocapEvents.Trial(trials(t));
                    %                         MocapTrials(ind).StartOn = MocapEvents.StartOn(trials(t));
                    %                         MocapTrials(ind).End = MocapEvents.End(trials(t)) - ...
                    %                             MocapEvents.StartOn(trials(t));
                    
                    Trials(trial_num).Day = day;
                    Trials(trial_num).Rec = rec;
                    Trials(trial_num).Trial = total_trial_num;
                    
                    Trials(trial_num).StartPos = init_pos(:,iEvents);
                    Trials(trial_num).TargetPos = target_pos(:,iEvents);
                    
                    
                    if target_pos(1,iEvents)==init_pos(1,iEvents)%same x-position
                        if target_pos(2,iEvents)>init_pos(2,iEvents)%target y-coordinate is greater than start position
                            Trials(trial_num).Target = 3;
                        end
                    elseif target_pos(1,iEvents)==init_pos(1,iEvents)%same x-position
                        if target_pos(2,iEvents)<init_pos(2,iEvents)%target y-coordinate is less than start position
                            Trials(trial_num).Target = 7;
                        end
                    elseif target_pos(2,iEvents)==init_pos(2,iEvents) %y is same
                        if target_pos(1,iEvents)>init_pos(1,iEvents)%target x is greater than start pos.
                            Trials(trial_num).Target = 1;
                        end
                    elseif target_pos(2,iEvents)==init_pos(2,iEvents) %y is same
                        if target_pos(1,iEvents)<init_pos(1,iEvents)%target x is less than start pos.
                            Trials(trial_num).Target = 5;
                        end
                    elseif target_pos(1,iEvents)>init_pos(1,iEvents) %x is greater than start pos.
                        if target_pos(2,iEvents)>init_pos(2,iEvents)%target y is greater than start pos.
                            Trials(trial_num).Target = 2;
                        end
                    elseif target_pos(1,iEvents)>init_pos(1,iEvents) %x is greater than start pos.
                        if target_pos(2,iEvents)<init_pos(2,iEvents)%target y is less than start pos.
                            Trials(trial_num).Target = 8;
                        end
                    elseif target_pos(1,iEvents)<init_pos(1,iEvents) %x is less than start pos.
                        if target_pos(2,iEvents)>init_pos(2,iEvents)%target y is greater than start pos.
                            Trials(trial_num).Target = 4;
                        end
                    elseif target_pos(1,iEvents)<init_pos(1,iEvents) %x is less than start pos.
                        if target_pos(2,iEvents)<init_pos(2,iEvents)%target y is less than start pos.
                            Trials(trial_num).Target = 6;
                        end
                    end
                    
                    %Trials(trial_num).Target = NaN;	 %  Target location code
                    %Trials(trial_num).TargsOn = NaN; %same as delay timestamp?
                    Trials(trial_num).ReachStart = NaN; %  Time reach started
                    Trials(trial_num).ReachStop = NaN;  %  Time reach stopped
                    
                    Trials(trial_num).Reward = times(iEvents);
                    Trials(trial_num).TargAq = times(iEvents-2);
                    Trials(trial_num).Go = times(iEvents-3);
                    Trials(trial_num).Delay = times(iEvents-4);
                    Trials(trial_num).StartAq = times(iEvents-6);
                    Trials(trial_num).StartOn = times(iEvents-7);
                    Trials(trial_num).TargsOn = times(iEvents-7);
                    Trials(trial_num).HitWindow = hit_window(:,iEvents);
                    Trials(trial_num).FrameNum = frame_num(:,iEvents);
                    Trials(trial_num).ThreeD = three_d(:,iEvents);
                    Trials(trial_num).TargSize = target_size(:,iEvents);
                    Trials(trial_num).TargRotErr = target_rot_err(:,iEvents);
                    Trials(trial_num).TargRot = target_rot(:,iEvents);
                    Trials(trial_num).Grasp = grasp_trial(:,iEvents);
                    Trials(trial_num).ShoulderPos = shoulder_position(:,iEvents);
                    Trials(trial_num).TargetOff = NaN;
                    Trials(trial_num).TargetRet = NaN;
                    Trials(trial_num).HandCode = NaN;  %  Hand?.  1 = right.  0 = left. 2 = bimanual.
                    Trials(trial_num).StartHand = NaN;  %  Initial hand location code
                    Trials(trial_num).Choice = NaN;
                    Trials(trial_num).Reward = NaN;
                    Trials(trial_num).RewardMag = NaN;
                    Trials(trial_num).Reach = NaN;      %  Is Reach trial
                    Trials(trial_num).SaccStart = NaN;  %  Time saccade started
                    Trials(trial_num).SaccStop = NaN;   %  Time saccade finished
                    Trials(trial_num).Saccade = NaN;
                    Trials(trial_num).StartEye =  NaN;  %  Initial eye location code
                    Trials(trial_num).Reward2T = NaN;
                    Trials(trial_num).Joystick = NaN;   %  Joystick?  0 = Touch; 1 = Joystick
                    Trials(trial_num).InstOn = NaN;
                    Trials(trial_num).Success = 1;
                    %Trials(trial_num).Ch = [32 32 32 32 32];
                    Trials(trial_num).End = NaN;
                    %Trials(trial_num).MT = {'L_PMv','L_PMd','R_PMd','R_PMv','L_PPC'};
                    %Trials(trial_num).Gain = NaN;
                    Trials(trial_num).Fs = NaN;
                    Trials(trial_num).Iso = NaN;
                    %Trials(trial_num).Depth = NaN;
                    Trials(trial_num).Sacc2Start = NaN;
                    Trials(trial_num).Sacc2Stop = NaN;
                    Trials(trial_num).Sacc2Center = NaN;
                    Trials(trial_num).Reach2Start = NaN;
                    Trials(trial_num).Targ2On = NaN;
                    Trials(trial_num).ReachGo = NaN;
                    Trials(trial_num).ReachAq = NaN;
                    Trials(trial_num).SaccadeGo = NaN;
                    Trials(trial_num).SaccadeAq = NaN;
                    Trials(trial_num).Reward2T = NaN;
                    Trials(trial_num).RewardConfig = NaN;
                    Trials(trial_num).RewardBlock = NaN;
                    Trials(trial_num).HandRewardBlock = NaN;
                    Trials(trial_num).ReachChoice = NaN;
                    Trials(trial_num).EyeRewardBlock = NaN;
                    Trials(trial_num).SaccadeChoice = NaN;
                    Trials(trial_num).ReachCircleTarget = NaN;
                    Trials(trial_num).SaccadeCircleTarget = NaN;
                    Trials(trial_num).HighReward = NaN;
                    Trials(trial_num).RewardTask = NaN;
                    Trials(trial_num).EyeTarget = NaN;
                    Trials(trial_num).EyeTargetLocation = NaN;
                    Trials(trial_num).HandTargetLocation = NaN;
                    Trials(trial_num).AdaptationFeedback = NaN;
                    Trials(trial_num).AdaptationAction = NaN;
                    Trials(trial_num).AdaptationPhase = NaN;
                    Trials(trial_num).LEDBoard = NaN;
                    Trials(trial_num).RewardDur = NaN;
                    Trials(trial_num).RewardDist = NaN;
                    Trials(trial_num).Reward4TNoise = NaN;
                    Trials(trial_num).Targ2 = NaN;
                    Trials(trial_num).Separable4T = NaN;
                    Trials(trial_num).TargMove = NaN;
                    Trials(trial_num).EffInstOn = NaN;
                    Trials(trial_num).MinReachRT = NaN;
                    Trials(trial_num).MaxReachRT = NaN;
                    Trials(trial_num).MinReachAq = NaN;
                    Trials(trial_num).MaxReachAq = NaN;
                    Trials(trial_num).MinSaccadeRT = NaN;
                    Trials(trial_num).MaxSaccadeRT = NaN;
                    Trials(trial_num).MinSaccadeAq = NaN;
                    Trials(trial_num).MaxSaccadeAq = NaN;
                    Trials(trial_num).MinSaccade2RT = NaN;
                    Trials(trial_num).MaxSaccade2RT = NaN;
                    Trials(trial_num).Minsaccade2Aq = NaN;
                    Trials(trial_num).MaxSaccade2Aq = NaN;
                    Trials(trial_num).DoubleSTep = NaN;
                    Trials(trial_num).BrightVals = NaN;
                    Trials(trial_num).BrightDist = NaN;
                    Trials(trial_num).T1T2Locations = NaN;
                    Trials(trial_num).T1T2Delta = NaN;
                    Trials(trial_num).TargetScale = NaN;
                    Trials(trial_num).Target2Scale = NaN;
                    Trials(trial_num).RewardSwitchPoint = NaN;
                    Trials(trial_num).SaccadeChoiceContinuousLocation = NaN;
                    Trials(trial_num).UnchosenTargetContinuousLocation = NaN;
                    Trials(trial_num).UnchosenTarget = NaN;
                    Trials(trial_num).RewardVolumeVals = NaN;
                    Trials(trial_num).RewardVolumeDist = NaN;
                    Trials(trial_num).TargetLuminanceVals = NaN;
                    Trials(trial_num).EyeChoiceContinuousLocation = NaN;
                    Trials(trial_num).RewardBlockTrial = NaN;
                    trial_num = trial_num+1;
                    error_trial = 0;
                end
                total_trial_num = total_trial_num+1;
            elseif(state_codes(iEvents) == START_STATE)
                if(error_trial == 1)
                    
                    if(isfield(experiment.hardware,'microdrive'))
                        for microdrives = 1:length(experiment.hardware.microdrive)
                            if isfield(experiment.hardware.microdrive(microdrives),'name')
                                ErrorTrials(error_trial_num).MT{microdrives} = experiment.hardware.microdrive(microdrives).name;
                                ErrorTrials(error_trial_num).Ch(microdrives) = length(experiment.hardware.microdrive(microdrives).electrodes);
                                for electrodes = 1:length(experiment.hardware.microdrive(microdrives).electrodes)
                                    ErrorTrials(error_trial_num).Gain  = experiment.hardware.microdrive(microdrives).electrodes(electrodes).gain;
                                end
                            end
                        end
                    end
                    
                    
                    for iTower = 1:length(experiment.hardware.microdrive)
                        tower = experiment.hardware.microdrive(iTower).name;
                        if isfile([MONKEYDIR '/' day '/' rec '/rec' rec '.' tower '.electrodelog.txt'])
                            Log = load([MONKEYDIR '/' day '/' rec '/rec' rec '.' tower '.electrodelog.txt']);
                            if ~isempty(Log)
                                lind = find(Log(:,1).*1e3 < MocapEvents.StartOn(1), 1, 'last' );
                                if ~isempty(lind)
                                    ErrorTrials(error_trial_num).Depth{iTower} = Log(lind,2:end);
                                else
                                    ErrorTrials(error_trial_num).Depth{iTower} = Log(1,2:end);
                                end
                            else
                                ErrorTrials(error_trial_num).Depth{iTower} = ones(1,ErrorTrials(error_trial_num).Ch(iTower)).*1e3;
                                
                            end
                        else
                            ErrorTrials(error_trial_num).Depth{iTower} = ones(1,ErrorTrials(error_trial_num).Ch(iTower)).*1e3;
                            
                        end
                    end
                    %ErrorTrials(error_trial_num).Trial = MocapEvents.Trial(trials(t));
                    %ErrorTrials(error_trial_num).StartOn = MocapEvents.StartOn(trials(t));
                    %ErrorTrials(error_trial_num).End = MocapEvents.End(trials(t)) - ...
                    %MocapEvents.StartOn(trials(t));
                    
                    ErrorTrials(error_trial_num).Day = day;
                    ErrorTrials(error_trial_num).Rec = rec;
                    ErrorTrials(error_trial_num).Trial = total_trial_num;
                    
                    ErrorTrials(error_trial_num).StartPos = init_pos(:,iEvents);
                    ErrorTrials(error_trial_num).TargetPos = target_pos(:,iEvents);
                    
                    
                    if target_pos(1,iEvents)==init_pos(1,iEvents)%same x-position
                        if target_pos(2,iEvents)>init_pos(2,iEvents)%target y-coordinate is greater than start position
                            ErrorTrials(error_trial_num).Target = 3;
                        end
                    elseif target_pos(1,iEvents)==init_pos(1,iEvents)%same x-position
                        if target_pos(2,iEvents)<init_pos(2,iEvents)%target y-coordinate is less than start position
                            ErrorTrials(error_trial_num).Target = 7;
                        end
                    elseif target_pos(2,iEvents)==init_pos(2,iEvents) %y is same
                        if target_pos(1,iEvents)>init_pos(1,iEvents)%target x is greater than start pos.
                            ErrorTrials(error_trial_num).Target = 1;
                        end
                    elseif target_pos(2,iEvents)==init_pos(2,iEvents) %y is same
                        if target_pos(1,iEvents)<init_pos(1,iEvents)%target x is less than start pos.
                            ErrorTrials(error_trial_num).Target = 5;
                        end
                    elseif target_pos(1,iEvents)>init_pos(1,iEvents) %x is greater than start pos.
                        if target_pos(2,iEvents)>init_pos(2,iEvents)%target y is greater than start pos.
                            ErrorTrials(error_trial_num).Target = 2;
                        end
                    elseif target_pos(1,iEvents)>init_pos(1,iEvents) %x is greater than start pos.
                        if target_pos(2,iEvents)<init_pos(2,iEvents)%target y is less than start pos.
                            ErrorTrials(error_trial_num).Target = 8;
                        end
                    elseif target_pos(1,iEvents)<init_pos(1,iEvents) %x is less than start pos.
                        if target_pos(2,iEvents)>init_pos(2,iEvents)%target y is greater than start pos.
                            ErrorTrials(error_trial_num).Target = 4;
                        end
                    elseif target_pos(1,iEvents)<init_pos(1,iEvents) %x is less than start pos.
                        if target_pos(2,iEvents)<init_pos(2,iEvents)%target y is less than start pos.
                            ErrorTrials(error_trial_num).Target = 6;
                        end
                    end
                    
                    %ErrorTrials(error_trial_num).Target = NaN;	 %  Target location code
                    ErrorTrials(error_trial_num).TargsOn = NaN; %same as delay timestamp?
                    ErrorTrials(error_trial_num).ReachStart = NaN; %  Time reach started
                    ErrorTrials(error_trial_num).ReachStop = NaN;  %  Time reach stopped
                    
                    ErrorTrials(error_trial_num).Reward = times(iEvents);
                    ErrorTrials(error_trial_num).TargAq = times(iEvents-2);
                    ErrorTrials(error_trial_num).Go = times(iEvents-3);
                    ErrorTrials(error_trial_num).Delay = times(iEvents-4);
                    ErrorTrials(error_trial_num).StartAq = times(iEvents-6);
                    ErrorTrials(error_trial_num).StartOn = times(iEvents-7);
                    ErrorTrials(error_trial_num).HitWindow = hit_window(:,iEvents);
                    ErrorTrials(error_trial_num).FrameNum = frame_num(:,iEvents);
                    ErrorTrials(error_trial_num).ThreeD = three_d(:,iEvents);
                    ErrorTrials(error_trial_num).TargSize = target_size(:,iEvents);
                    ErrorTrials(error_trial_num).TargRotErr = target_rot_err(:,iEvents);
                    ErrorTrials(error_trial_num).TargRot = target_rot(:,iEvents);
                    ErrorTrials(error_trial_num).Grasp = grasp_trial(:,iEvents);
                    ErrorTrials(error_trial_num).ShoulderPos = shoulder_position(:,iEvents);
                    ErrorTrials(error_trial_num).TargetOff = NaN;
                    ErrorTrials(error_trial_num).TargetRet = NaN;
                    ErrorTrials(error_trial_num).HandCode = NaN;  %  Hand?.  1 = right.  0 = left. 2 = bimanual.
                    ErrorTrials(error_trial_num).StartHand = NaN;  %  Initial hand location code
                    ErrorTrials(error_trial_num).Choice = NaN;
                    ErrorTrials(error_trial_num).Reward = NaN;
                    ErrorTrials(error_trial_num).RewardMag = NaN;
                    ErrorTrials(error_trial_num).Reach = NaN;      %  Is Reach trial
                    ErrorTrials(error_trial_num).SaccStart = NaN;  %  Time saccade started
                    ErrorTrials(error_trial_num).SaccStop = NaN;   %  Time saccade finished
                    ErrorTrials(error_trial_num).Saccade = NaN;
                    ErrorTrials(error_trial_num).StartEye =  NaN;  %  Initial eye location code
                    ErrorTrials(error_trial_num).Reward2T = NaN;
                    ErrorTrials(error_trial_num).Joystick = NaN;   %  Joystick?  0 = Touch; 1 = Joystick
                    ErrorTrials(error_trial_num).InstOn = NaN;
                    ErrorTrials(error_trial_num).Success = 1;
                    %ErrorTrials(error_trial_num).Ch = [32 32 32 32 32];
                    ErrorTrials(error_trial_num).End = NaN;
                    %ErrorTrials(error_trial_num).MT = {'L_PMv','L_PMd','R_PMd','R_PMv','L_PPC'};
                    %ErrorTrials(error_trial_num).Gain = NaN;
                    ErrorTrials(error_trial_num).Fs = NaN;
                    ErrorTrials(error_trial_num).Iso = NaN;
                    %ErrorTrials(error_trial_num).Depth = NaN;
                    ErrorTrials(error_trial_num).Sacc2Start = NaN;
                    ErrorTrials(error_trial_num).Sacc2Stop = NaN;
                    ErrorTrials(error_trial_num).Sacc2Center = NaN;
                    ErrorTrials(error_trial_num).Reach2Start = NaN;
                    ErrorTrials(error_trial_num).Targ2On = NaN;
                    ErrorTrials(error_trial_num).ReachGo = NaN;
                    ErrorTrials(error_trial_num).ReachAq = NaN;
                    ErrorTrials(error_trial_num).SaccadeGo = NaN;
                    ErrorTrials(error_trial_num).SaccadeAq = NaN;
                    ErrorTrials(error_trial_num).Reward2T = NaN;
                    ErrorTrials(error_trial_num).RewardConfig = NaN;
                    ErrorTrials(error_trial_num).RewardBlock = NaN;
                    ErrorTrials(error_trial_num).HandRewardBlock = NaN;
                    ErrorTrials(error_trial_num).ReachChoice = NaN;
                    ErrorTrials(error_trial_num).EyeRewardBlock = NaN;
                    ErrorTrials(error_trial_num).SaccadeChoice = NaN;
                    ErrorTrials(error_trial_num).ReachCircleTarget = NaN;
                    ErrorTrials(error_trial_num).SaccadeCircleTarget = NaN;
                    ErrorTrials(error_trial_num).HighReward = NaN;
                    ErrorTrials(error_trial_num).RewardTask = NaN;
                    ErrorTrials(error_trial_num).EyeTarget = NaN;
                    ErrorTrials(error_trial_num).EyeTargetLocation = NaN;
                    ErrorTrials(error_trial_num).HandTargetLocation = NaN;
                    ErrorTrials(error_trial_num).AdaptationFeedback = NaN;
                    ErrorTrials(error_trial_num).AdaptationAction = NaN;
                    ErrorTrials(error_trial_num).AdaptationPhase = NaN;
                    ErrorTrials(error_trial_num).LEDBoard = NaN;
                    ErrorTrials(error_trial_num).RewardDur = NaN;
                    ErrorTrials(error_trial_num).RewardDist = NaN;
                    ErrorTrials(error_trial_num).Reward4TNoise = NaN;
                    ErrorTrials(error_trial_num).Targ2 = NaN;
                    ErrorTrials(error_trial_num).Separable4T = NaN;
                    ErrorTrials(error_trial_num).TargMove = NaN;
                    ErrorTrials(error_trial_num).EffInstOn = NaN;
                    ErrorTrials(error_trial_num).MinReachRT = NaN;
                    ErrorTrials(error_trial_num).MaxReachRT = NaN;
                    ErrorTrials(error_trial_num).MinReachAq = NaN;
                    ErrorTrials(error_trial_num).MaxReachAq = NaN;
                    ErrorTrials(error_trial_num).MinSaccadeRT = NaN;
                    ErrorTrials(error_trial_num).MaxSaccadeRT = NaN;
                    ErrorTrials(error_trial_num).MinSaccadeAq = NaN;
                    ErrorTrials(error_trial_num).MaxSaccadeAq = NaN;
                    ErrorTrials(error_trial_num).MinSaccade2RT = NaN;
                    ErrorTrials(error_trial_num).MaxSaccade2RT = NaN;
                    ErrorTrials(error_trial_num).Minsaccade2Aq = NaN;
                    ErrorTrials(error_trial_num).MaxSaccade2Aq = NaN;
                    ErrorTrials(error_trial_num).DoubleSTep = NaN;
                    ErrorTrials(error_trial_num).BrightVals = NaN;
                    ErrorTrials(error_trial_num).BrightDist = NaN;
                    ErrorTrials(error_trial_num).T1T2Locations = NaN;
                    ErrorTrials(error_trial_num).T1T2Delta = NaN;
                    ErrorTrials(error_trial_num).TargetScale = NaN;
                    ErrorTrials(error_trial_num).Target2Scale = NaN;
                    ErrorTrials(error_trial_num).RewardSwitchPoint = NaN;
                    ErrorTrials(error_trial_num).SaccadeChoiceContinuousLocation = NaN;
                    ErrorTrials(error_trial_num).UnchosenTargetContinuousLocation = NaN;
                    ErrorTrials(error_trial_num).UnchosenTarget = NaN;
                    ErrorTrials(error_trial_num).RewardVolumeVals = NaN;
                    ErrorTrials(error_trial_num).RewardVolumeDist = NaN;
                    ErrorTrials(error_trial_num).TargetLuminanceVals = NaN;
                    ErrorTrials(error_trial_num).EyeChoiceContinuousLocation = NaN;
                    ErrorTrials(error_trial_num).RewardBlockTrial = NaN;
                    
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
                    %                     state = state_codes(iEvents - 1);
                    %                     i = 1;
                    %                     while(state ~= START_STATE)
                    %                         i = i + 1;
                    %                         if(iEvents - i > 0)
                    %                             state = state_codes(iEvents - i);
                    %                         else
                    %                                 state = NaN;
                    %                         end
                    %                     end
                    total_trial_num = total_trial_num+1;
                    error_trial_num = error_trial_num+1;
                else
                    error_trial = 1;
                end
                last_start = iEvents;
            end
        end
    end
end

save([MONKEYDIR '/' day '/mat/Trials.mat'],'Trials')
save([MONKEYDIR '/' day '/mat/ErrorTrials.mat'],'ErrorTrials')
















