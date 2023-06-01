%
%Finds the locations of the circle in target coordinates

function locations = choiceFindCircleTargetPlacement(reward_config,hand_target,eye_target,task_code)
    
global ReachCode
global SaccadeCode
global ReachSaccadeCode

%reward_config = mod(reward_config, 2);
locations = zeros(1,length(reward_config));
for i = 1:length(reward_config)
    if(task_code(i) == ReachCode || task_code(i) == ReachSaccadeCode)
        target = hand_target(i);
    elseif(task_code(i) == SaccadeCode)
        target = eye_target(i);
    else
        target = nan;
        target2 = nan;
    end

    if(target == 1)
        target2 = 5;
    elseif(target == 2)
        target2 = 6;
    elseif(target == 3)
        target2 = 7;
    elseif(target == 4)
        target2 = 8;
    elseif(target == 5)
        target2 = 1;
    elseif(target == 6)
        target2 = 2;
    elseif(target == 7)
        target2 = 3;
    elseif(target == 8)
        target2 = 4;
    end

    if(reward_config(i) == 1 || reward_config(i) == 3)
        locations(i) = target;
    elseif(reward_config(i) == 2 || reward_config(i) == 4)
        locations(i) = target2;
    end

end

return
