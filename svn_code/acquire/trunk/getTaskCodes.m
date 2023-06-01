function [TD,task] = getTaskCodes(evs,TD,Ind_StartOn,Task)
%
%   [TD,task] = getTaskCodes(evs,TD,Ind_StartOn,Task)
%

disp('Inside getTaskCodes')

switch Task
    case 'Task Control v1'

        disp('Assigning Target');
        TD.Target(TD.currentTrial) = evs(2,Ind_StartOn-1) - 30;

        disp('Assigning Start Hand');
        TD.StartHand(TD.currentTrial) = evs(2,Ind_StartOn-2) - 10;

        disp('Assigning Start Eye');
        TD.StartEye(TD.currentTrial) = evs(2,Ind_StartOn-3) - 30;

        disp('Assigning Hand Code');
        TD.HandCode(TD.currentTrial) = evs(2,Ind_StartOn-4) - 10;

        disp('Assigning Joystick Code');
        TD.JoystickCode(TD.currentTrial) = evs(2,Ind_StartOn-5) - 30;

        disp('Assigning Task Code');
        TD.TaskCode(TD.currentTrial) = evs(2,Ind_StartOn-6) - 10;

    case 'Task Control v2.1'

        disp('Assigning Target');
        TD.Target(TD.currentTrial) = evs(2,Ind_StartOn-1) - 30;

        disp('Assigning Start Hand');
        TD.StartHand(TD.currentTrial) = evs(2,Ind_StartOn-2) - 10;

        disp('Assigning Start Eye');
        TD.StartEye(TD.currentTrial) = evs(2,Ind_StartOn-3) - 30;

        disp('Assigning Hand Code');
        TD.HandCode(TD.currentTrial) = evs(2,Ind_StartOn-4) - 10;

        disp('Assigning Joystick Code');
        TD.JoystickCode(TD.currentTrial) = evs(2,Ind_StartOn-5) - 30;

        disp('Assigning Task Code');
        TD.TaskCode(TD.currentTrial) = evs(2,Ind_StartOn-6) - 10 + 1;

    case 'Task Control v2.2'

        disp('Assigning Target');
        TD.Target(TD.currentTrial) = evs(2,Ind_StartOn-1) - 30;

        disp('Assigning Start Hand');
        TD.StartHand(TD.currentTrial) = evs(2,Ind_StartOn-2) - 10;

        disp('Assigning Start Eye');
        TD.StartEye(TD.currentTrial) = evs(2,Ind_StartOn-3) - 30;

        disp('Assigning Hand Code');
        TD.HandCode(TD.currentTrial) = evs(2,Ind_StartOn-4) - 10;

        disp('Assigning Joystick Code');
        TD.JoystickCode(TD.currentTrial) = evs(2,Ind_StartOn-5) - 30;

        disp('Assigning Task Code');
        TD.TaskCode(TD.currentTrial) = evs(2,Ind_StartOn-6) - 10 + 1;

    case 'Task Control v2.3'

        disp('Assigning Target');
        TD.currentTrial;
        TD.Target(TD.currentTrial) = evs(2,Ind_StartOn-1) - 30;

        disp('Assigning Start Hand');
        TD.StartHand(TD.currentTrial) = evs(2,Ind_StartOn-2) - 10;

        disp('Assigning Start Eye');
        TD.StartEye(TD.currentTrial) = evs(2,Ind_StartOn-3) - 30;

        disp('Assigning Hand Code');
        TD.HandCode(TD.currentTrial) = evs(2,Ind_StartOn-4) - 10;

        disp('Assigning Joystick Code');
        TD.JoystickCode(TD.currentTrial) = evs(2,Ind_StartOn-5) - 30;

        disp('Assigning Task Code');
        TD.TaskCode(TD.currentTrial) = evs(2,Ind_StartOn-6) - 10 + 1;

    case 'Task Control v2.5'

        disp('Assigning Target');
        TD.currentTrial;
        TD.Target(TD.currentTrial) = evs(2,Ind_StartOn-1) - 30;

        disp('Assigning Start Hand');
        TD.StartHand(TD.currentTrial) = evs(2,Ind_StartOn-2) - 10;

        disp('Assigning Start Eye');
        TD.StartEye(TD.currentTrial) = evs(2,Ind_StartOn-3) - 30;

        disp('Assigning Hand Code');
        TD.HandCode(TD.currentTrial) = evs(2,Ind_StartOn-4) - 10;

        disp('Assigning Joystick Code');
        TD.JoystickCode(TD.currentTrial) = evs(2,Ind_StartOn-5) - 30;

        disp('Assigning Task Code');
        TD.TaskCode(TD.currentTrial) = evs(2,Ind_StartOn-6) - 10 + 1;

    case 'Task Control v2.6'

        disp('Assigning Target');
        TD.currentTrial;
        TD.Target(TD.currentTrial) = evs(2,Ind_StartOn-1) - 30;

        disp('Assigning Start Hand');
        TD.StartHand(TD.currentTrial) = evs(2,Ind_StartOn-2) - 10;

        disp('Assigning Start Eye');
        TD.StartEye(TD.currentTrial) = evs(2,Ind_StartOn-3) - 30;

        disp('Assigning Hand Code');
        TD.HandCode(TD.currentTrial) = evs(2,Ind_StartOn-4) - 10;

        disp('Assigning Joystick Code');
        TD.JoystickCode(TD.currentTrial) = evs(2,Ind_StartOn-5) - 30;

        disp('Assigning Task Code');
        TD.TaskCode(TD.currentTrial) = evs(2,Ind_StartOn-6) - 10 + 1;

    case 'Task Control v2.7'

        task = evs(2,Ind_StartOn-6) - 10 + 1;

        disp('Assigning Target');
        TD.currentTrial;
        TD.Target(TD.currentTrial) = evs(2,Ind_StartOn-1) - 30 + 1;

        disp('Assigning Start Hand');
        TD.StartHand(TD.currentTrial) = evs(2,Ind_StartOn-2) - 10;

        disp('Assigning Start Eye');
        TD.StartEye(TD.currentTrial) = evs(2,Ind_StartOn-3) - 30;

        disp('Assigning Hand Code');
        TD.HandCode(TD.currentTrial) = evs(2,Ind_StartOn-4) - 10;

        disp('Assigning Joystick Code');
        TD.JoystickCode(TD.currentTrial) = evs(2,Ind_StartOn-5) - 30;

        disp('Assigning Task Code');
        TD.TaskCode(TD.currentTrial)  = task;

    case 'Task Control v2.8'

        task = evs(2,Ind_StartOn-6) - 10 + 1;

        disp('Assigning Target');
        TD.currentTrial;
        TD.Target(TD.currentTrial) = evs(2,Ind_StartOn-1) - 30 + 1;

        disp('Assigning Start Hand');
        TD.StartHand(TD.currentTrial) = evs(2,Ind_StartOn-2) - 10;

        disp('Assigning Start Eye');
        TD.StartEye(TD.currentTrial) = evs(2,Ind_StartOn-3) - 30;

        disp('Assigning Hand Code');
        TD.HandCode(TD.currentTrial) = evs(2,Ind_StartOn-4) - 10;

        disp('Assigning Joystick Code');
        TD.JoystickCode(TD.currentTrial) = evs(2,Ind_StartOn-5) - 30;

        disp('Assigning Task Code');
        TD.TaskCode(TD.currentTrial)  = task;

    case 'Task Control v2.9'

        task = evs(2,Ind_StartOn-10) - 10 + 1;

        TD.Reward2T(TD.currentTrial) = evs(2,Ind_StartOn-1) - 30 + 1;
        TD.Choice(TD.currentTrial) = evs(2,Ind_StartOn-2) - 10 + 1;
        TD.RewardMag(TD.currentTrial) = evs(2,Ind_StartOn-3) - 30 + 1;
        TD.Reward(TD.currentTrial) = evs(2,Ind_StartOn-4) - 10 + 1;

        disp('Assigning Target');
        TD.currentTrial;
        TD.Target(TD.currentTrial) = evs(2,Ind_StartOn-5) - 30 + 1;

        disp('Assigning Start Hand');
        TD.StartHand(TD.currentTrial) = evs(2,Ind_StartOn-6) - 10;

        disp('Assigning Start Eye');
        TD.StartEye(TD.currentTrial) = evs(2,Ind_StartOn-7) - 30;

        disp('Assigning Hand Code');
        TD.HandCode(TD.currentTrial) = evs(2,Ind_StartOn-8) - 10;

        disp('Assigning Joystick Code');
        TD.JoystickCode(TD.currentTrial) = evs(2,Ind_StartOn-9) - 30;

        disp('Assigning Task Code');
        TD.TaskCode(TD.currentTrial)  = task;

    case 'Task Control v2.10'

        task = evs(2,Ind_StartOn-10) - 10 + 1;

        TD.Reward2T(TD.currentTrial) = evs(2,Ind_StartOn-1) - 30 + 1;
        TD.Choice(TD.currentTrial) = evs(2,Ind_StartOn-2) - 10 + 1;
        TD.RewardMag(TD.currentTrial) = evs(2,Ind_StartOn-3) - 30 + 1;
        TD.Reward(TD.currentTrial) = evs(2,Ind_StartOn-4) - 10 + 1;

        disp('Assigning Target');
        TD.currentTrial;
        TD.Target(TD.currentTrial) = evs(2,Ind_StartOn-5) - 30 + 1;

        disp('Assigning Start Hand');
        TD.StartHand(TD.currentTrial) = evs(2,Ind_StartOn-6) - 10;

        disp('Assigning Start Eye');
        TD.StartEye(TD.currentTrial) = evs(2,Ind_StartOn-7) - 30;

        disp('Assigning Hand Code');
        TD.HandCode(TD.currentTrial) = evs(2,Ind_StartOn-8) - 10;

        disp('Assigning Joystick Code');
        TD.JoystickCode(TD.currentTrial) = evs(2,Ind_StartOn-9) - 30;

        disp('Assigning Task Code');
        TD.TaskCode(TD.currentTrial)  = task;

 case 'Task Control v3.00'

        task = evs(2,Ind_StartOn-10) - 10 + 1;

        TD.Reward2T(TD.currentTrial) = evs(2,Ind_StartOn-1) - 30 + 1;
        TD.Choice(TD.currentTrial) = evs(2,Ind_StartOn-2) - 10 + 1;
        TD.RewardMag(TD.currentTrial) = evs(2,Ind_StartOn-3) - 30 + 1;
        TD.Reward(TD.currentTrial) = evs(2,Ind_StartOn-4) - 10 + 1;

        disp('Assigning Target');
        TD.currentTrial;
        TD.Target(TD.currentTrial) = evs(2,Ind_StartOn-5) - 30 + 1;

        disp('Assigning Start Hand');
        TD.StartHand(TD.currentTrial) = evs(2,Ind_StartOn-6) - 10;

        disp('Assigning Start Eye');
        TD.StartEye(TD.currentTrial) = evs(2,Ind_StartOn-7) - 30;

        disp('Assigning Hand Code');
        TD.HandCode(TD.currentTrial) = evs(2,Ind_StartOn-8) - 10;

        disp('Assigning Joystick Code');
        TD.JoystickCode(TD.currentTrial) = evs(2,Ind_StartOn-9) - 50;

        disp('Assigning Task Code');
        TD.TaskCode(TD.currentTrial)  = task;

 case {'Task Control v3.01','Task Control v3.03','Task Control v3.04','Task Control v3.05','Task Control v3.06','Task Control v3.07','Task Control v3.08','Task Control v3.09','Task Control v3.10','Task Control v3.11','Task Control v3.12'}

        task = evs(2,Ind_StartOn-10) - 10 + 1;

        TD.Reward2T(TD.currentTrial) = evs(2,Ind_StartOn-1) - 30 + 1;
        TD.Choice(TD.currentTrial) = evs(2,Ind_StartOn-2) - 10 + 1;
        TD.RewardMag(TD.currentTrial) = evs(2,Ind_StartOn-3) - 30 + 1;
        TD.Reward(TD.currentTrial) = evs(2,Ind_StartOn-4) - 10 + 1;

        disp('Assigning Target');
        TD.currentTrial;
        TD.Target(TD.currentTrial) = evs(2,Ind_StartOn-5) - 30 + 1;

        disp('Assigning Start Hand');
        TD.StartHand(TD.currentTrial) = evs(2,Ind_StartOn-6) - 10;

        disp('Assigning Start Eye');
        TD.StartEye(TD.currentTrial) = evs(2,Ind_StartOn-7) - 30;

        disp('Assigning Hand Code');
        TD.HandCode(TD.currentTrial) = evs(2,Ind_StartOn-8) - 10;

        disp('Assigning Joystick Code');
        TD.JoystickCode(TD.currentTrial) = evs(2,Ind_StartOn-9) - 50;

        disp('Assigning Task Code');
        TD.TaskCode(TD.currentTrial)  = task;


 case {'Task Control v3.13','Task Control v3.14','Task Control v3.15'}

        task = evs(2,Ind_StartOn-11) - 10 + 1;

        TD.Reward2T(TD.currentTrial) = evs(2,Ind_StartOn-2) - 30 + 1;
        TD.Choice(TD.currentTrial) = evs(2,Ind_StartOn-3) - 10 + 1;
        TD.RewardMag(TD.currentTrial) = evs(2,Ind_StartOn-4) - 30 + 1;
        TD.Reward(TD.currentTrial) = evs(2,Ind_StartOn-5) - 10 + 1;

        disp('Assigning Hand Target');
        TD.currentTrial;
        TD.Target(TD.currentTrial) = evs(2,Ind_StartOn-6) - 30 + 1;
        
        disp('Assigning Eye Target');
        TD.EyeTarget(TD.currentTrial) = evs(2,Ind_StartOn-1) - 10 + 1;

        disp('Assigning Start Hand');
        TD.StartHand(TD.currentTrial) = evs(2,Ind_StartOn-7) - 10;

        disp('Assigning Start Eye');
        TD.StartEye(TD.currentTrial) = evs(2,Ind_StartOn-8) - 30;

        disp('Assigning Hand Code');
        TD.HandCode(TD.currentTrial) = evs(2,Ind_StartOn-9) - 10;

        disp('Assigning Joystick Code');
        TD.JoystickCode(TD.currentTrial) = evs(2,Ind_StartOn-10) - 50;

        disp('Assigning Task Code');
        TD.TaskCode(TD.currentTrial)  = task;

case {'Task Control v3.16'}

        task = evs(2,Ind_StartOn-12) - 10 + 1;

        TD.Reward2T(TD.currentTrial) = evs(2,Ind_StartOn-3) - 30 + 1;
        TD.Choice(TD.currentTrial) = evs(2,Ind_StartOn-4) - 10 + 1;
        TD.RewardMag(TD.currentTrial) = evs(2,Ind_StartOn-5) - 30 + 1;
        TD.Reward(TD.currentTrial) = evs(2,Ind_StartOn-6) - 10 + 1;

        disp('Assigning Hand Target');
        TD.currentTrial;
        TD.Target(TD.currentTrial) = evs(2,Ind_StartOn-7) - 30 + 1;
        
        disp('Assigning Eye Target');
        TD.EyeTarget(TD.currentTrial) = evs(2,Ind_StartOn-2) - 10 + 1;

        disp('Assigning Start Hand');
        TD.StartHand(TD.currentTrial) = evs(2,Ind_StartOn-8) - 10;

        disp('Assigning Start Eye');
        TD.StartEye(TD.currentTrial) = evs(2,Ind_StartOn-9) - 30;

        disp('Assigning Hand Code');
        TD.HandCode(TD.currentTrial) = evs(2,Ind_StartOn-10) - 10;

        disp('Assigning Joystick Code');
        TD.JoystickCode(TD.currentTrial) = evs(2,Ind_StartOn-11) - 50;

        disp('Assigning LED Board');
        TD.LEDBoard(TD.currentTrial) = evs(2,Ind_StartOn-1) - 30;

        disp('Assigning Task Code');
        TD.TaskCode(TD.currentTrial)  = task;

case {'Task Control v3.17','Task Control v3.18','Task Control v3.19'}

        task = evs(2,Ind_StartOn-14) - 10 + 1;

        TD.Reward2T(TD.currentTrial) = evs(2,Ind_StartOn-5) - 30 + 1;
        TD.Choice(TD.currentTrial) = evs(2,Ind_StartOn-6) - 10 + 1;
        TD.RewardMag(TD.currentTrial) = evs(2,Ind_StartOn-7) - 30 + 1;
        TD.Reward(TD.currentTrial) = evs(2,Ind_StartOn-8) - 10 + 1;

        disp('Assigning Hand Target');
        TD.currentTrial;
        TD.Target(TD.currentTrial) = evs(2,Ind_StartOn-9) - 30 + 1;
        
        disp('Assigning Eye Target');
        TD.EyeTarget(TD.currentTrial) = evs(2,Ind_StartOn-4) - 10 + 1;

        disp('Assigning Start Hand');
        TD.StartHand(TD.currentTrial) = evs(2,Ind_StartOn-10) - 10;

        disp('Assigning Start Eye');
        TD.StartEye(TD.currentTrial) = evs(2,Ind_StartOn-11) - 30;

        disp('Assigning Hand Code');
        TD.HandCode(TD.currentTrial) = evs(2,Ind_StartOn-12) - 10;

        disp('Assigning Joystick Code');
        TD.JoystickCode(TD.currentTrial) = evs(2,Ind_StartOn-13) - 50;

        disp('Assigning LED Board');
        TD.LEDBoard(TD.currentTrial) = evs(2,Ind_StartOn-3) - 30;

        disp('Assigning Task Code');
        TD.TaskCode(TD.currentTrial)  = task;

case {'Task Control v4.00'}
        disp('Task Control v4.00')
        task = evs(2,Ind_StartOn-15) - 10 + 1;

        TD.Reward2T(TD.currentTrial) = evs(2,Ind_StartOn-6) - 30 + 1;
        TD.Choice(TD.currentTrial) = evs(2,Ind_StartOn-7) - 10 + 1;
        TD.RewardMag(TD.currentTrial) = evs(2,Ind_StartOn-8) - 30 + 1;
        TD.Reward(TD.currentTrial) = evs(2,Ind_StartOn-9) - 10 + 1;

        disp('Assigning Hand Target');
        TD.currentTrial;
        TD.Target(TD.currentTrial) = evs(2,Ind_StartOn-10) - 30 + 1;
        
        disp('Assigning Eye Target');
        TD.EyeTarget(TD.currentTrial) = evs(2,Ind_StartOn-5) - 10 + 1;

        disp('Assigning Start Hand');
        TD.StartHand(TD.currentTrial) = evs(2,Ind_StartOn-11) - 10;

        disp('Assigning Start Eye');
        TD.StartEye(TD.currentTrial) = evs(2,Ind_StartOn-12) - 30;

        disp('Assigning Hand Code');
        TD.HandCode(TD.currentTrial) = evs(2,Ind_StartOn-13) - 10;

        disp('Assigning Joystick Code');
        TD.JoystickCode(TD.currentTrial) = evs(2,Ind_StartOn-14) - 50;

        disp('Assigning LED Board');
        TD.LEDBoard(TD.currentTrial) = evs(2,Ind_StartOn-4) - 30;

        disp('Assigning Task Code');
        TD.TaskCode(TD.currentTrial)  = task;

case {'Task Control v4.01'}
        disp('Task Control v4.01')
        task = evs(2,Ind_StartOn-17) - 10 + 1;

        TD.Reward2T(TD.currentTrial) = evs(2,Ind_StartOn-5) - 10 + 1;
        TD.Choice(TD.currentTrial) = evs(2,Ind_StartOn-6) - 30 + 1;
        TD.RewardMag(TD.currentTrial) = evs(2,Ind_StartOn-7) - 10 + 1;
        TD.Reward(TD.currentTrial) = evs(2,Ind_StartOn-8) - 30 + 1;

        disp('Assigning Hand Target');
        TD.currentTrial;
        handtarget = (evs(2,Ind_StartOn-12) - 30) * 10 + evs(2,Ind_StartOn-11) - 10 + 1;
        TD.Target(TD.currentTrial) = handtarget;
        
        disp('Assigning Eye Target');
        eyetarget = (evs(2,Ind_StartOn-10) - 30) * 10 + evs(2,Ind_StartOn-9) - 10 + 1;
        TD.EyeTarget(TD.currentTrial) = eyetarget;

        disp('Assigning Start Hand');
        TD.StartHand(TD.currentTrial) = evs(2,Ind_StartOn-13) - 10;

        disp('Assigning Start Eye');
        TD.StartEye(TD.currentTrial) = evs(2,Ind_StartOn-14) - 30;

        disp('Assigning Hand Code');
        TD.HandCode(TD.currentTrial) = evs(2,Ind_StartOn-15) - 10;

        disp('Assigning Joystick Code');
        TD.JoystickCode(TD.currentTrial) = evs(2,Ind_StartOn-16) - 50;

        disp('Assigning LED Board');
        TD.LEDBoard(TD.currentTrial) = evs(2,Ind_StartOn-4) - 30;

        disp('Assigning Task Code');
        TD.TaskCode(TD.currentTrial)  = task;

case {'Task Control v4.02','Task Control v4.03','Task Control v4.04','Task Control v4.05','Task Control v4.06','Task Control v4.07'}
        disp('Task Control v4.02-4.07')
        Ind_StartOn
        task = evs(2,Ind_StartOn-18) - 10 + 1;

        TD.Reward2T(TD.currentTrial) = evs(2,Ind_StartOn-5) - 30 + 1;
        TD.Choice(TD.currentTrial) = evs(2,Ind_StartOn-6) - 10 + 1;
        
        TD.EyeRewardMag(TD.currentTrial) = evs(2,Ind_StartOn-7) - 30 + 1;
        TD.RewardMag(TD.currentTrial) = evs(2,Ind_StartOn-8) - 10 + 1;
        TD.Reward(TD.currentTrial) = evs(2,Ind_StartOn-9) - 30 + 1;

        disp('Assigning Hand Target');
        TD.currentTrial;
        handtarget = (evs(2,Ind_StartOn-13) - 30) * 10 + evs(2,Ind_StartOn-12) - 10 + 1;
        TD.Target(TD.currentTrial) = handtarget;
        
        disp('Assigning Eye Target');
        eyetarget = (evs(2,Ind_StartOn-11) - 30) * 10 + evs(2,Ind_StartOn-10) - 10 + 1;
        TD.EyeTarget(TD.currentTrial) = eyetarget;

        disp('Assigning Start Hand');
        TD.StartHand(TD.currentTrial) = evs(2,Ind_StartOn-14) - 10;

        disp('Assigning Start Eye');
        TD.StartEye(TD.currentTrial) = evs(2,Ind_StartOn-15) - 30;

        disp('Assigning Hand Code');
        TD.HandCode(TD.currentTrial) = evs(2,Ind_StartOn-16) - 10;

        disp('Assigning Joystick Code');
        TD.JoystickCode(TD.currentTrial) = evs(2,Ind_StartOn-17) - 50;

        disp('Assigning LED Board');
        TD.LEDBoard(TD.currentTrial) = evs(2,Ind_StartOn-4) - 10;

        disp('Assigning Adaptation Phase');
        TD.AdaptPhase(TD.currentTrial) = evs(2,Ind_StartOn-3) - 30;

        disp('Assigning Adaptation Action');
        TD.AdaptAction(TD.currentTrial) = evs(2,Ind_StartOn-2) - 10;

        disp('Assigning 4T Reward Combo Number');
        TD.FourTComboNum(TD.currentTrial) = evs(2,Ind_StartOn-1) - 30;

        disp('Assigning Task Code');
        TD.TaskCode(TD.currentTrial)  = task;

case {'Task Control v4.08','Task Control v4.09','Task Control v4.10','Task Control v4.11','Task Control v5.00','Task Control v5.01'}
        disp('Task Control v4.08-4.11 and 5.00-5.01')
        Ind_StartOn
        n = 19;  %number of initial states sent
        task = evs(2,Ind_StartOn-n) - 10 + 1;

        TD.Reward2T(TD.currentTrial) = evs(2,Ind_StartOn-n+13) - 30 + 1;
        TD.Choice(TD.currentTrial) = evs(2,Ind_StartOn-n+12) - 10 + 1;
        
        TD.EyeRewardMag(TD.currentTrial) = evs(2,Ind_StartOn-n+11) - 30 + 1;
        TD.RewardMag(TD.currentTrial) = evs(2,Ind_StartOn-n+10) - 10 + 1;
        TD.Reward(TD.currentTrial) = evs(2,Ind_StartOn-n+9) - 30 + 1;

        disp('Assigning Hand Target');
        TD.currentTrial;
        handtarget = (evs(2,Ind_StartOn-n+5) - 30) * 10 + evs(2,Ind_StartOn-n+6) - 10 + 1;
        TD.Target(TD.currentTrial) = handtarget;
        
        disp('Assigning Eye Target');
        eyetarget = (evs(2,Ind_StartOn-n+7) - 30) * 10 + evs(2,Ind_StartOn-n+8) - 10 + 1;
        TD.EyeTarget(TD.currentTrial) = eyetarget;

        disp('Assigning Start Hand');
        TD.StartHand(TD.currentTrial) = evs(2,Ind_StartOn-n+4) - 10;

        disp('Assigning Start Eye');
        TD.StartEye(TD.currentTrial) = evs(2,Ind_StartOn-n+3) - 30;

        disp('Assigning Hand Code');
        TD.HandCode(TD.currentTrial) = evs(2,Ind_StartOn-+2) - 10;

        disp('Assigning Joystick Code');
        TD.JoystickCode(TD.currentTrial) = evs(2,Ind_StartOn-n+1) - 50;

        disp('Assigning LED Board');
        TD.LEDBoard(TD.currentTrial) = evs(2,Ind_StartOn-n+12) - 10;

        disp('Assigning Adaptation Phase');
        TD.AdaptPhase(TD.currentTrial) = evs(2,Ind_StartOn-n+15) - 30;

        disp('Assigning Adaptation Action');
        TD.AdaptAction(TD.currentTrial) = evs(2,Ind_StartOn-n+16) - 10;

        disp('Assigning 4T Reward Combo Number');
        TD.FourTComboNum(TD.currentTrial) = evs(2,Ind_StartOn-n+17) - 30;

        disp('Assigning Target2');
        TD.Target2(TD.currentTrial) = evs(2,Ind_StartOn-n+18) - 30;

        disp('Assigning Task Code');
        TD.TaskCode(TD.currentTrial)  = task;

end

disp('Leaving getTaskCodes')

