function Scale = procCalibrateHand(day,num)
%  procCALIBRATEHAND determines scale for Hand position
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

global MONKEYDIR MONKEYNAME

olddir = pwd;

if nargin < 2
    num = dayrecs(day);
end
figure;
% Load data for recordings
Trials = dbSelectTrials(day);
% Trials = dbSelectTrialsByTarget(day,1);
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

Reach = getReach(Trials);
Target = getTarget(Trials);
if isfield(Trials,'AdaptationPhase')
    Adaptation = [Trials.AdaptationPhase];
else
    Adaptation = 9*ones(1,length(Trials));
end

TaskCode = [Trials.TaskCode];
RewardConfig = [Trials.RewardConfig];

Trials = Trials(find(Reach>0 & Target>0 & Adaptation>8 & TaskCode<23 & RewardConfig<2));
Target = getTarget(Trials);
% 
% %  Determine offset
% at = 'StartAq'; bn = [0,10];
% [E] = EyeHandTrial(Trials,at,bn,1);
% e1 = sq(mean(E,3));
% % hold off; plot(e(:,1),e(:,2),'.'); hold on;
% % 
%  Load up target data
at = 'TargAq'; bn = [20,30];
[E,H] = EyeHandTrial(Trials,at,bn,1);
h = sq(mean(H,3));
% plot(h(:,1),h(:,2),'r.');


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
        [20,10];[-20,10];[20,-10];[-20,-10];[25,15];...
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
    
% tempind=find(ReachEnd(:,1)>17)
% clf; hold on; %axis([1500 2495 1500 2495])
% for i = 1:size(Pos,1)
%  disp(['Target is ' num2str(i)])
%  Pos(i,:)
%  ind = find(Target==i);
%  plot((h(ind,1)),(h(ind,2)),'.')
%  plot(mean(h(ind,1)),mean(h(ind,2)),'rx')
%  pause
% end

Y = h;
if size(Trials,2) > 1
    X = [ones(size(h,1),1) Pos(Target,:)];
    bX = regress(Y(:,1),X(:,[1 2]));
    bY = regress(Y(:,2),X(:,[1 3]));

    %  Set center
    centre = [bX(1) bY(1)];
    Scale.HandOffset = centre; Scale.Flag = []; Scale.Gradient = [bX(2),0;0,bY(2)];

    %  Set scale gradient
    HandScale = Scale;
    for iNum = 1:nNum
        file = ['rec' num{iNum}];
        cd([MONKEYDIR '/' day '/' num{iNum}]);
        save([file '.HandScale.mat'],'HandScale');
    end
    %
    % at = 'StartAq'; bn = [0,10];
    % [E] = EyeHandTrial(Trials,at,bn,1,0);
    % e = sq(mean(E,3));
    % hold off; plot(e(:,1),e(:,2),'.');
    % hold on; plot(0,0,'r.');

    at = 'TargAq'; bn = [20,30];
    [E,H] = EyeHandTrial(Trials,at,bn,1,0);
    h = sq(mean(H,3));
    plot(h(:,1),h(:,2),'.');

    axis([-25 25 -25 25])
    title([MONKEYNAME ':' day ' Hand Calibration']);
    cd(olddir);
end
