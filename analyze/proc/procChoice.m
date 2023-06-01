function procChoice(day, rec)
%  PROCCHOICE deterines actual reach and saccade movement directions,
%   the location for the high reward target for choice tasks and the
%   location of the circle target. These fields are added to the Events
%   structure.
%
%  PROCCHOICE(DAY, REC)
%
%  Inputs:  DAY    = String '030603'
%           REC    = String '001', or num [1,2]


% choiceSaccadeLocs = [];
% counter = 1;

global MONKEYDIR
global ReachCode
global SaccadeCode
global ReachSaccadeCode
global DelSaccadeCode

olddir = pwd;

recs = dayrecs(day);
nRecs = length(recs);

StartField = 'StartAq';
Field = 'TargAq';
bn = [5,50];
number = 1;
THRESHOLD = 5;
ReachCode = 10;
DelSaccadeCode = 11;
SaccadeCode = 12;
ReachSaccadeCode = 13;

if nargin < 2
    num = [1,nRecs];
elseif ischar(rec)
    num = [find(strcmp(recs,rec)),find(strcmp(recs,rec))];
elseif length(rec)==1
    num = [rec,rec];
elseif length(rec)==2
    num = rec;
end

load([MONKEYDIR '/' day '/' recs{num(1)} '/rec' recs{num(1)} '.experiment.mat']);

if isfield(experiment,'hardware')
    format = getFileFormat('Broker');
elseif isfile(['rec' rec '.experiment.mat'])
    load(['rec' rec '.experiment.mat'])
    format = getFileFormat('Broker');
end

trc=0;
for iNum = num(1):num(2)
    close all
    disp(['Loading' MONKEYDIR '/' day '/' recs{iNum} '/rec' recs{iNum} '.Events.mat']);
    load([MONKEYDIR '/' day '/' recs{iNum} '/rec' recs{iNum} '.Events.mat']);
    
    disp('Loading hand/eye data');
    load([MONKEYDIR '/' day '/' recs{iNum} '/rec' recs{iNum} '.HandScale.mat']);
    load([MONKEYDIR '/' day '/' recs{iNum} '/rec' recs{iNum} '.EyeScale.mat']);

    %% Targets on Grid
    Events.ReachCircleTarget = nan(1,length(Events.Trial) );
    Events.SaccadeCircleTarget = nan(1,length(Events.Trial));
    for Tr = 1:length(Events.Trial)
        hand_data = loadhnd([MONKEYDIR '/' day '/' recs{iNum} '/rec' recs{iNum}], Events, Tr, Field, bn, number, HandScale, format);
        eye_data = loadeye([MONKEYDIR '/' day '/' recs{iNum} '/rec' recs{iNum}], Events, Tr, Field, bn, number, EyeScale, format);
        handlocx = choiceThresholdMovements(mean(hand_data(1,:)),THRESHOLD);
        handlocy = choiceThresholdMovements(mean(hand_data(2,:)),THRESHOLD);
        eyelocx = choiceThresholdMovements(mean(eye_data(1,:)),THRESHOLD);
        eyelocy = choiceThresholdMovements(mean(eye_data(2,:)),THRESHOLD);
        eyechoice = choiceFindMovementLocation(eyelocx,eyelocy);
        handchoice = choiceFindMovementLocation(handlocx,handlocy);
        
        Events.ReachChoice(Tr) = handchoice;
        Events.SaccadeChoice(Tr) = eyechoice;
        
        % Find the location of the circle
        hand_target = Events.Target(Tr);
        eye_target = Events.EyeTarget(Tr);
        task_code = Events.TaskCode(Tr);
        
        rewardConfig = Events.RewardConfig(Tr);
        circle_Target_Placement = choiceFindCircleTargetPlacement(rewardConfig,hand_target,eye_target,task_code);
        if(task_code == ReachCode) % Reach Trial
            Events.ReachCircleTarget(Tr) = circle_Target_Placement;
        elseif(task_code == SaccadeCode) % Saccade Trial
            Events.SaccadeCircleTarget(Tr) = circle_Target_Placement;
        elseif(task_code == ReachSaccadeCode) % Reach + Saccade Trial
            if(Events.RewardTask(Tr) == 6) % 4T Reward mag 1,2 circle is left
                tmp = mod(rewardConfig-1,4);
                saccade_config = (tmp == 0) + (tmp == 3);
                if(~saccade_config)
                    saccade_config = 2;
                end
                circle_Target_Placement = choiceFindCircleTargetPlacement(saccade_config,eye_target,eye_target,task_code);
                Events.SaccadeCircleTarget(Tr) = circle_Target_Placement;
                tmp = floor((rewardConfig-1)/4);
                reach_config = (tmp == 0) + (tmp == 3);
                if(~reach_config)
                    reach_config = 2;
                end
                circle_Target_Placement = choiceFindCircleTargetPlacement(reach_config,hand_target,hand_target,task_code);
                Events.ReachCircleTarget(Tr) = circle_Target_Placement;
            else
                Events.SaccadeCircleTarget(Tr) = circle_Target_Placement;
                Events.ReachCircleTarget(Tr) = circle_Target_Placement;
            end
        end
        
        % Error check on whether the decoded eye and hand position is sensible
        
        anti_direction = mod(hand_target+4,8);
        if anti_direction == 0 anti_direction = 8; end
        if(handchoice ~= hand_target && handchoice ~= anti_direction)
            targ_dist = abs(handchoice - hand_target);
            anti_targ_dist = abs(handchoice - anti_direction);
            if(targ_dist >5)
                handchoice = hand_target;
            elseif(anti_targ_dist >5)
                handchoice = anti_direction;
            else
                if(targ_dist > anti_targ_dist)
                    handchoice = anti_direction;
                else
                    handchoice = hand_target;
                end
            end
            Events.ReachChoice(Tr) = handchoice;
        end
        
        anti_direction = mod(eye_target+4,8);
        if anti_direction == 0 anti_direction = 8; end
        if(eyechoice ~= eye_target && eyechoice ~= anti_direction)
            targ_dist = abs(eyechoice - eye_target);
            anti_targ_dist = abs(eyechoice - anti_direction);
            if(targ_dist >5)
                eyechoice = eye_target;
            elseif(anti_targ_dist >5)
                eyechoice = anti_direction;
            else
                if(targ_dist > anti_targ_dist)
                    eyechoice = anti_direction;
                else
                    eyechoice = eye_target;
                end
            end
            Events.SaccadeChoice(Tr) = eyechoice;
        end
        
        
        %% Continuous Targets       
        tc = Events.TaskCode(Tr);
        eye_x = mean(eye_data(1,:));
        eye_y = mean(eye_data(2,:)); 
        hand_x = mean(hand_data(1,:));
        hand_y = mean(hand_data(2,:));
        
        trc=trc+1;
        e(trc,1) = eye_x;e(Tr,2) = eye_y;
        h(trc,1) = hand_x;h(Tr,2) = hand_y;
        tmp = squeeze(Events.T1T2Locations(Tr,:,:));
        t(trc,:) = [tmp(1,:) tmp(2,:)];
        try
            T1T2 = squeeze(Events.T1T2Locations(Tr,:,:));
            T1_x = T1T2(1,1); T1_y = T1T2(1,2); T2_x = T1T2(2,1); T2_y = T1T2(2,2);
            
            % initialize saccade and reach choice as nan
            Events.SaccadeChoiceContinuousLocation(Tr,1:2) = nan;
            Events.SaccadeChoice(Tr) = nan;
            Events.ReachChoiceContinuousLocation(Tr,1:2) = nan;
            Events.UnchosenTargetContinuousLocation(Tr,1:2) = nan;
            Events.UnchosenTarget(Tr) = nan;
            
            % Saccade Choice
            if any(tc == [11 12 13]) % DelSaccade, DelSaccade and Touch, DelReach and Saccade
                T1_dist = sqrt((T1_x-eye_x).^2 + (T1_y-eye_y).^2);
                T2_dist = sqrt((T2_x-eye_x).^2 + (T2_y-eye_y).^2);
                if(T1_dist < T2_dist)
                    Events.SaccadeChoiceContinuousLocation(Tr,:) = [T1_x, T1_y];
                    Events.UnchosenTargetContinuousLocation(Tr,:) = [T2_x, T2_y];
                else
                    Events.SaccadeChoiceContinuousLocation(Tr,:) = [T2_x, T2_y];
                    Events.UnchosenTargetContinuousLocation(Tr,:) = [T1_x, T1_y];
                end
                if Events.RewardTask(Tr)==9 % 2TRMB continuous choice task
                    Events.SaccadeChoice(Tr) = ContinuousTarget2DiscreteTarget(Events.SaccadeChoiceContinuousLocation(Tr,:));
                    Events.UnchosenTarget(Tr) = ContinuousTarget2DiscreteTarget(Events.UnchosenTargetContinuousLocation(Tr,:));
                    Events.Target(Tr) = Events.SaccadeChoice(Tr);
                end
                % Reach Choice
            elseif any(tc == [9 10 13]) % DelReach, DelReach and Fixate, DelReach and Saccade
                T1_dist = sqrt((T1_x-hand_x).^2 + (T1_y-hand_y).^2);
                T2_dist = sqrt((T2_x-hand_x).^2 + (T2_y-hand_y).^2);
                if(T1_dist < T2_dist)
                    Events.ReachChoiceContinuousLocation(Tr,:) = [T1_x, T1_y];
                    Events.UnchosenTargetContinuousLocation(Tr,:) = [T2_x, T2_y];
                else
                    Events.ReachChoiceContinuousLocation(Tr,:) = [T2_x, T2_y];
                    Events.UnchosenTargetContinuousLocation(Tr,:) = [T1_x, T1_y];
                end
            end
            
        catch
            disp('Unable to assign T1T2Locations');
            if(isfield(Events,'SaccadeChoiceContinuousLocation'))
                Events.SaccadeChoiceContinuousLocation(Tr,1:2) = nan;
                Events.SaccadeChoice(Tr) = nan;
                Events.UnchosenTargetContinuousLocation(Tr,1:2) = nan;
                Events.UnchosenTarget(Tr) = nan;
            end
        end

    end
    save([MONKEYDIR '/' day '/' recs{iNum} '/rec' recs{iNum} '.Events.mat'],'Events');
    disp(['Saving ' MONKEYDIR '/' day '/' recs{iNum} '/rec' recs{iNum} '.Events.mat']);
end

saveTrials(day);

cd(olddir);

keyboard
