function Scale = procCalibrateEye(day,num)
%  procCALIBRATEEYE determines scale for Eye position
%
%  Inputs:  DAY        =   String. Day to calibrate.
%           NUM        =   Cell. Recording number to calibrate
%                               Defaults to {'001'}
%
%  Outputs: SCALE   =   Structure.  Scaling for eye position.
%
%   Note:   This program assumes rec001.eye.dat and rec001.Events.mat
%               are in the current directory.
%
%               It works by taking eye position at acquisition of first reach.
%
%               To get calibrated eye position from raw data;
%                   scaled = (raw-Scale.Y(1))./Scale.Y(2)
%
%
%  This script is designed to be gone through by hand.
%
%   The steps are:
%       0.  Plot data
%       1.  Set zero using mouse and replot until happy
%       2.  Choose rotation and scale parameters and replot until happy
%       3   Set flag and replot until happy

global MONKEYDIR MONKEYNAME experiment

olddir = pwd;

if nargin < 2
    num = dayrecs(day);
end
figure;
% Load data for recordings
Trials = dbSelectTrials(day);
ntr = length(Trials);
clear Rec
[Rec{1:ntr}] = deal(Trials.Rec);
dum = zeros(1,ntr);
nNum = length(num);
for iNum = 1:nNum
    for i = 1:ntr
        RecTmp(i,:) = num2str(cell2num(Rec(i)));
        if RecTmp(i,:) == num{iNum}
            dum(i) = 1;
        end
    end
end
Trials = Trials(find(dum));

Saccade = [Trials.Saccade];
Target = [Trials.Target];
Reward = [Trials.Reward];
RewardTask = [Trials.RewardTask];
EyeTarget = [Trials.EyeTarget];
Continuous = calcContinuous(Trials);
if isfield(Trials,'AdaptationPhase')
    Adaptation = [Trials.AdaptationPhase];
else
    Adaptation = 9*ones(1,length(Trials));
end

%
% %  Determine offset
% at = 'StartAq'; bn = [0,10];
% [E] = EyeHandTrial(Trials,at,bn,1);
% e1 = sq(mean(E,3));
% % hold off; plot(e(:,1),e(:,2),'.'); hold on;
% %
%  Load up target data
at = 'TargAq'; bn = [20,30];
if ~isempty(find(Continuous==0 & Saccade>0 & Target>0 & (Reward==1 | RewardTask==1) & Target==EyeTarget, 1))
    Trials = Trials(find(Continuous == 0 & Saccade>0 & Target>0 & Adaptation>8 & (Reward==1 | RewardTask==1) & Target==EyeTarget));
    Target = [Trials.Target];
    E = trialEyeHand(Trials,at,bn,1);
    e = [sq(mean(E,3))];
    plot(e(:,1),e(:,2),'r.')
    if Adaptation == 10  %mapping targets used
        Pos = [[10,0];[10,10];[0,10];[-10,10];[-10,0];...
            [-10,-10];[0,-10];[10,-10];[20,0];[-20,0];...
            [0,0];[0,0];[24,0];[16,0];[25,15];...
            [25,5];[25,0];[25,-5];[25,-15];[20,-10];...
            [20,-5];[20,5];[20,10];[15,15];[15,5];...
            [15,0];[15,-5];[15,-15];[10,-5];[10,5];...
            [5,15];[5,5];[5,0];[5,-5];[5,-15];...
            [0,-5];[-5,-15];[-10,-15];[-10,-5];[-10,5];...
            [-15,15];[-15,5];[-15,0];[-15,-5];[-15,-10];...
            [-15,-15];[-20,-15];[-20,-10];[-20,-5];[-20,5];...
            [-20,10];[-25,15];[-25,5];[-25,0];[-25,-5];...
            [-25,-10];[-25,-15];[0,0];[-24,0];[-16,0];...
            [-5,15];[0,5];[-5,5];[-5,0];[-5,-5];...
            [-5,-10]];
    else
        Pos = [[10,0];[10,10];[0,10];[-10,10];[-10,0];...
            [-10,-10];[0,-10];[10,-10];[20,0];[-20,0];...
            [20,10];[-20,10];[20,-10];[-20,-10];[0,0];...
            [25,5];[25,0];[25,-5];[25,-15];[20,-10];...
            [20,-5];[20,5];[20,10];[15,15];[15,5];...
            [15,0];[15,-5];[15,-15];[10,-5];[10,5];...
            [5,15];[5,5];[5,0];[5,-5];[5,-15];...
            [0,-5];[-5,-15];[-10,-15];[-10,-5];[-10,5];...
            [-15,15];[-15,5];[-15,0];[-15,-5];[-15,-10];...
            [-15,-15];[-20,-15];[-20,-10];[-20,-5];[-20,5];...
            [-20,10];[-25,15];[-25,5];[-25,0];[-25,-5];...
            [-25,-10];[-25,-15];[0,0];[-24,0];[-16,0];...
            [-5,15];[0,5];[-5,5];[-5,0];[-5,-5];...
            [-5,-10]];
    end

    for i = 1:15
        ind = find(Target==i);
        E_sub = mean(E(ind,:,:),3);
        if size(E_sub,1) > 2
            E_sub_std = std(E_sub);
            myind = find(abs(E_sub(:,1)-mean(E_sub(:,1)))>3*E_sub_std(1) | abs(E_sub(:,2)-mean(E_sub(:,2)))>3*E_sub_std(2));
            if ~isempty(myind)
                Target(ind(myind)) = [];
                E(ind(myind),:,:) = [];
                e(ind(myind),:) = [];
            end
            % Do a quick check and get rid of the entire point of it's too variable
            %         ind = find(Target==i);
            %         E_sub = mean(E(ind,:,:),3);
            %         E_sub_std = std(E_sub);
            %         if E_sub_std(1) > 100 || E_sub_std(2) > 30
            %             Target(ind) = [];
            %             E(ind,:,:) = [];
            %             e(ind,:) = [];
            %         end
        end
    end
    %hold on;
    %plot(e(:,1),e(:,2),'g.');
    %pause


    Y = e;
    X = [ones(size(e,1),1) Pos(Target,:)];
    bX = regress(Y(:,1),X(:,[1 2]));
    bY = regress(Y(:,2),X(:,[1 3]));

    %  Set center
    centre = [bX(1) bY(1)];
    Scale.EyeOffset = centre; Scale.Flag = []; Scale.Gradient = [bX(2),0;0,bY(2)];
elseif ~isempty(find(Saccade>0 & Target>0 & Reward==3, 1))
    
    Trials = Trials(find(Saccade>0 & Target>0 & Reward==3));
    Target = getTarget(Trials);
    [E,H] = trialEyeHand(Trials,at,bn,1);
    e = [sq(mean(E,3))];
    if length(unique(Target))==1
        me(:,1) = e(:,1)-mean(e(:,1)); me(:,2) = e(:,2)-mean(e(:,2));
        Pos = [[10,0];[10,10];[0,10];[-10,10];[-10,0];[-10,-10];[0,-10];[10,-10];...
            [20,10];[-20,10];[0,0]];
        T = zeros(1,size(me,1));
        if Target(1) == 1 || Target(1) == 5
            T(1,find(me(:,1)>0)) = 1;
            T(1,find(me(:,1)<0)) = 5;
            Y = e;
            X = [ones(size(e,1),1) Pos(T,:)];
            bX = regress(Y(:,1),X(:,[1 2]));
            centre = [bX(1) mean(e(:,2))];
            Scale.EyeOffset = centre; Scale.Flag = []; Scale.Gradient = [bX(2),0;0,bX(2)];
        end
        if Target(1) == 3 || Target(1) == 7
            T(1,find(me(:,1)>0)) = 3;
            T(1,find(me(:,1)<0)) = 7;
            Y = e;
            X = [ones(size(e,1),1) Pos(T,:)];
            bY = regress(Y(:,2),X(:,[1 3]));
            centre = [mean(e(:,1)) bY(1)];
            Scale.EyeOffset = centre; Scale.Flag = []; Scale.Gradient = [bY(2),0;0,bY(2)];
        end
        if Target(1) == 2 || Target(1) == 6
            T(1,find(me(:,1)>0)) = 2;
            T(1,find(me(:,1)<0)) = 6;
            Y = e;
            X = [ones(size(e,1),1) Pos(T,:)];
            bX = regress(Y(:,1),X(:,[1 2]));
            bY = regress(Y(:,2),X(:,[1 3]));
            centre = [bX(1) bY(1)];
            Scale.EyeOffset = centre; Scale.Flag = []; Scale.Gradient = [bX(2),0;0,bY(2)];
        end
        if Target(1) == 4 || Target(1) == 8
            T(1,find(me(:,1)>0)) = 8;
            T(1,find(me(:,1)<0)) = 4;
            Y = e;
            X = [ones(size(e,1),1) Pos(T,:)];
            bX = regress(Y(:,1),X(:,[1 2]));
            bY = regress(Y(:,2),X(:,[1 3]));
            centre = [bX(1) bY(1)];
            Scale.EyeOffset = centre; Scale.Flag = []; Scale.Gradient = [bX(2),0;0,bY(2)];
        end
    end
else
    Scale.Gradient = [1,0;0,1];
    Scale.Flag = [];
    Scale.EyeOffset = [0,0];
end

%  Set scale gradient

EyeScale = Scale;
for iNum = 1:nNum
    file = ['rec' num{iNum}];
    cd([MONKEYDIR '/' day '/' num{iNum}]);
    if isfile(['rec' num{iNum} '.eye.dat'])
        save([file '.EyeScale.mat'],'EyeScale');
    end
end
%
% at = 'StartAq'; bn = [0,10];
% [E] = EyeHandTrial(Trials,at,bn,1,0);
% e = sq(mean(E,3));
% hold off; plot(e(:,1),e(:,2),'.');
% hold on; plot(0,0,'r.');
%[Trials.Target];
at = 'TargAq'; bn = [20,30];
[E,H] = trialEyeHand(Trials,at,bn,1,0);
e = sq(mean(E,3));
plot(e(:,1),e(:,2),'.');

axis([-25 25 -25 25])
title([MONKEYNAME ':' day ' Eye Calibration']);
cd(olddir);
