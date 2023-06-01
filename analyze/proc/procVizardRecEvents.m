function procVizardRecEvents(day)
global MONKEYDIR
recs = dayrecs(day);
nRecs = length(recs);

for i=1:nRecs
    trial=dbSelectTrials(day,recs{i});
    
    
    
    
    
    
    % Events(trial_num).Depth{iTower} = ones(1,MocapTrials(trial_num).Ch(iTower)).*1e3;
    if isempty(trial)
        Events(1).Day = day;
        Events(1).Rec = NaN;
        Events(1).Trial = NaN;
        
        Events(1).StartPos = NaN;
        Events(1).TargetPos = NaN;
        Events(1).TargsOn = NaN; %same as delay timestamp?
        Events(1).ReachStart = NaN; %  Time reach started
        Events(1).ReachStop = NaN;  %  Time reach stopped
        
        Events(1).Reward = NaN;
        Events(1).TargAq = NaN;
        Events(1).Go = NaN;
        Events(1).StartOn = NaN;
        Events(1).Delay = NaN;
        Events(1).StartAq = NaN;
        Events(1).StartOn = NaN;
        Events(1).HitWindow = NaN;
        Events(1).FrameNum = NaN;
        Events(1).ThreeD = NaN;
        Events(1).TargSize = NaN;
        Events(1).TargRotErr = NaN;
        Events(1).TargRot = NaN;
        Events(1).Grasp = NaN;
        Events(1).ShoulderPos = NaN;
        Events(1).TargetOff = NaN;
        Events(1).TargetRet = NaN;
        Events(1).HandCode = NaN;  %  Hand?.  1 = right.  0 = left. 2 = bimanual.
        Events(1).StartHand = NaN;  %  Initial hand location code
        Events(1).Choice = NaN;
        Events(1).Reward = NaN;
        Events(1).RewardMag = NaN;
        Events(1).Reach = NaN;      %  Is Reach trial
        Events(1).SaccStart = NaN;  %  Time saccade started
        Events(1).SaccStop = NaN;   %  Time saccade finished
        Events(1).Saccade = NaN;
        Events(1).StartEye =  NaN;  %  Initial eye location code
        Events(1).Reward2T = NaN;
        Events(1).Joystick = NaN;   %  Joystick?  0 = Touch; 1 = Joystick
        Events(1).InstOn = NaN;
        Events(1).Success = 1;
        Events(1).Ch = NaN%[32 32 32 32 32];
        Events(1).End = NaN;
        Events(1).MT = NaN%{'L_PMv','L_PMd','R_PMd','R_PMv','L_PPC'};
        Events(1).Gain = NaN;
        Events(1).Fs = NaN;
        Events(1).Iso = NaN;
        Events(1).Depth = NaN;
        Events(1).Sacc2Start = NaN;
        Events(1).Sacc2Stop = NaN;
        Events(1).Sacc2Center = NaN;
        Events(1).Reach2Start = NaN;
        Events(1).Targ2On = NaN;
        Events(1).ReachGo = NaN;
        Events(1).ReachAq = NaN;
        Events(1).SaccadeGo = NaN;
        Events(1).SaccadeAq = NaN;
        Events(1).Reward2T = NaN;
        Events(1).RewardConfig = NaN;
        Events(1).RewardBlock = NaN;
        Events(1).HandRewardBlock = NaN;
        Events(1).ReachChoice = NaN;
        Events(1).EyeRewardBlock = NaN;
        Events(1).SaccadeChoice = NaN;
        Events(1).ReachCircleTarget = NaN;
        Events(1).SaccadeCircleTarget = NaN;
        Events(1).HighReward = NaN;
        Events(1).RewardTask = NaN;
        Events(1).EyeTarget = NaN;
        Events(1).EyeTargetLocation = NaN;
        Events(1).HandTargetLocation = NaN;
        Events(1).AdaptationFeedback = NaN;
        Events(1).AdaptationAction = NaN;
        Events(1).AdaptationPhase = NaN;
        Events(1).LEDBoard = NaN;
        Events(1).RewardDur = NaN;
        Events(1).RewardDist = NaN;
        Events(1).Reward4TNoise = NaN;
        Events(1).Targ2 = NaN;
        Events(1).Separable4T = NaN;
        Events(1).TargMove = NaN;
        Events(1).EffInstOn = NaN;
        Events(1).MinReachRT = NaN;
        Events(1).MaxReachRT = NaN;
        Events(1).MinReachAq = NaN;
        Events(1).MaxReachAq = NaN;
        Events(1).MinSaccadeRT = NaN;
        Events(1).MaxSaccadeRT = NaN;
        Events(1).MinSaccadeAq = NaN;
        Events(1).MaxSaccadeAq = NaN;
        Events(1).MinSaccade2RT = NaN;
        Events(1).MaxSaccade2RT = NaN;
        Events(1).Minsaccade2Aq = NaN;
        Events(1).MaxSaccade2Aq = NaN;
        Events(1).DoubleSTep = NaN;
        Events(1).BrightVals = NaN;
        Events(1).BrightDist = NaN;
        Events(1).T1T2Locations = NaN;
        Events(1).T1T2Delta = NaN;
        Events(1).TargetScale = NaN;
        Events(1).Target2Scale = NaN;
        Events(1).RewardSwitchPoint = NaN;
        Events(1).SaccadeChoiceContinuousLocation = NaN;
        Events(1).UnchosenTargetContinuousLocation = NaN;
        Events(1).UnchosenTarget = NaN;
        Events(1).RewardVolumeVals = NaN;
        Events(1).RewardVolumeDist = NaN;
        Events(1).TargetLuminanceVals = NaN;
        Events(1).EyeChoiceContinuousLocation = NaN;
        Events(1).RewardBlockTrial = NaN;
        
        cd([ MONKEYDIR '/' day '/' recs{i}])
        save([MONKEYDIR '/' day '/' recs{i} '/rec' recs{i} '.Events.mat'],'Events')
    else
        
        
        % Events.Rec = [Events.Rec];
        
        Events.Depth=[trial.Depth]';
        Events.MT=[trial.MT]';
        Events.StartPos = [trial.StartPos]';
        Events.TargetPos = [trial.TargetPos]';
        Events.TargsOn = [trial.TargsOn]'; %same as delay timestamp?
        Events.ReachStart = [trial.ReachStart]'; %  Time reach started
        Events.ReachStop = [trial.ReachStop]'; %  Time reach stopped
        
        Events.Reward = [trial.Reward]';
        Events.TargAq = [trial.TargAq]';
        
        Events.Go = [trial.Go]';
        %Events.Trial = [1:length(Events.Go)]';
        Events.Trial=[trial.Trial];
        Events.StartOn = [trial.StartOn]';
        
        Events.Delay = [trial.Delay]';
        Events.StartAq = [trial.StartAq]';
        Events.HitWindow = [trial.HitWindow]';
        Events.FrameNum = [trial.FrameNum]';
        Events.ThreeD = [trial.ThreeD]';
        Events.TargSize = [trial.TargSize]';
        Events.TargRotErr = [trial.TargRotErr]';
        Events.TargRot = [trial.TargRot]';
        Events.Grasp = [trial.Grasp]';
        Events.ShoulderPos = [trial.ShoulderPos]';
        Events.TargetOff = [trial.TargetOff]';
        Events.TargetRet = [trial.TargetRet]';
        Events.HandCode = [trial.HandCode]';  %  Hand?.  1 = right.  0 = left. 2 = bimanual.
        Events.StartHand = [trial.StartHand]';  %  Initial hand location code
        Events.Choice = [trial.Choice]';
        Events.Reward = [trial.Reward]';
        Events.RewardMag = [trial.RewardMag]';
        Events.Reach = [trial.Reach]';      %  Is Reach trial
        Events.SaccStart = [trial.SaccStart]';  %  Time saccade started
        Events.SaccStop = [trial.SaccStop]';   %  Time saccade finished
        Events.Saccade = [trial.Saccade]';
        Events.StartEye =  [trial.StartEye]';  %  Initial eye location code
        Events.Reward2T = [trial.Reward2T]';
        Events.Joystick = [trial.Joystick]';   %  Joystick?  0 = Touch; 1 = Joystick
        Events.InstOn = [trial.InstOn]';
        Events.Success = [trial.Success]';
        %Events.Ch = [32 32 32 32 32];
        Events.End = [trial.End]';
        %Events.MT = {'L_PMv','L_PMd','R_PMd','R_PMv','L_PPC'};
        %Events.Gain = [trial]';
        Events.Fs = [trial.Fs]';
        Events.Iso = [trial.Iso]';
        %Events.Depth = [trial]';
        Events.Sacc2Start = [trial.Sacc2Start]';
        Events.Sacc2Stop = [trial.Sacc2Stop]';
        Events.Sacc2Center = [trial.Sacc2Center]';
        Events.Reach2Start = [trial.Reach2Start]';
        Events.Targ2On = [trial.Targ2On]';
        Events.ReachGo = [trial.ReachGo]';
        Events.ReachAq = [trial.ReachAq]';
        Events.SaccadeGo = [trial.SaccadeGo]';
        Events.SaccadeAq = [trial.SaccadeAq]';
        Events.Reward2T = [trial.Reward2T]';
        Events.RewardConfig = [trial.RewardConfig]';
        Events.RewardBlock = [trial.RewardBlock]';
        Events.HandRewardBlock = [trial.HandRewardBlock]';
        Events.ReachChoice = [trial.ReachChoice]';
        Events.EyeRewardBlock = [trial.EyeRewardBlock]';
        Events.SaccadeChoice = [trial.SaccadeChoice]';
        Events.ReachCircleTarget = [trial.ReachCircleTarget]';
        Events.SaccadeCircleTarget = [trial.SaccadeCircleTarget]';
        Events.HighReward = [trial.HighReward]';
        Events.RewardTask = [trial.RewardTask]';
        Events.EyeTarget = [trial.EyeTarget]';
        Events.EyeTargetLocation = [trial.EyeTargetLocation]';
        Events.HandTargetLocation = [trial.HandTargetLocation]';
        Events.AdaptationFeedback = [trial.AdaptationFeedback]';
        Events.AdaptationAction = [trial.AdaptationAction]';
        Events.AdaptationPhase = [trial.AdaptationPhase]';
        Events.LEDBoard = [trial.LEDBoard]';
        Events.RewardDur = [trial.RewardDur]';
        Events.RewardDist = [trial.RewardDist]';
        Events.Reward4TNoise = [trial.Reward4TNoise]';
        Events.Targ2 = [trial.Targ2]';
        Events.Separable4T = [trial.Separable4T]';
        Events.TargMove = [trial.TargMove]';
        Events.EffInstOn = [trial.EffInstOn]';
        Events.MinReachRT = [trial.MinReachRT]';
        Events.MaxReachRT = [trial.MaxReachRT]';
        Events.MinReachAq = [trial.MinReachAq]';
        Events.MaxReachAq = [trial.MaxReachAq]';
        Events.MinSaccadeRT = [trial.MinSaccadeRT]';
        Events.MaxSaccadeRT = [trial.MaxSaccadeRT]';
        Events.MinSaccadeAq = [trial.MinSaccadeAq]';
        Events.MaxSaccadeAq = [trial.MaxSaccadeAq]';
        Events.MinSaccade2RT = [trial.MinSaccade2RT]';
        Events.MaxSaccade2RT = [trial.MaxSaccade2RT]';
        Events.Minsaccade2Aq = [trial.Minsaccade2Aq]';
        Events.MaxSaccade2Aq = [trial.MaxSaccade2Aq]';
        Events.DoubleSTep = [trial.DoubleSTep]';
        Events.BrightVals = [trial.BrightVals]';
        Events.BrightDist = [trial.BrightDist]';
        Events.T1T2Locations = [trial.T1T2Locations]';
        Events.T1T2Delta = [trial.T1T2Delta]';
        Events.TargetScale = [trial.TargetScale]';
        Events.Target2Scale = [trial.Target2Scale]';
        Events.RewardSwitchPoint = [trial.RewardSwitchPoint]';
        Events.SaccadeChoiceContinuousLocation = [trial.SaccadeChoiceContinuousLocation]';
        Events.UnchosenTargetContinuousLocation = [trial.UnchosenTargetContinuousLocation]';
        Events.UnchosenTarget = [trial.UnchosenTarget]';
        Events.RewardVolumeVals = [trial.RewardVolumeVals]';
        Events.RewardVolumeDist = [trial.RewardVolumeDist]';
        Events.TargetLuminanceVals = [trial.TargetLuminanceVals]';
        Events.EyeChoiceContinuousLocation = [trial.EyeChoiceContinuousLocation]';
        Events.RewardBlockTrial = [trial.RewardBlockTrial]';
        
        cd([ MONKEYDIR '/' day '/' recs{i}])
        save([MONKEYDIR '/' day '/' recs{i} '/rec' recs{i} '.Events.mat'],'Events')
    end
end
end