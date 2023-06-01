function Scale = procHumanCalibrateHandContinuous(day,num)
%  procHUMANCALIBRATEHANDCONTINUOUS determines scale for Hand position
%
%  Inputs:  DAY        =   String. Day to calibrate.
%           NUM        =   Cell. Recording number to calibrate
%                               Defaults to the first recording of the day
%       Then copies the Scale.mat file for that rec to all the others.
%
%  Outputs: SCALE   =   Structure.  Scaling for hand position.  
%
%

global MONKEYDIR MONKEYNAME

olddir = pwd;

if nargin < 2
    num = {'001'};
end

% Load data for recordings
Trials = dbSelectTrials(day);
% Trials = dbSelectTrialsByTarget(day,1);
ntr = length(Trials);

if(ntr<1)
    disp('No trials for day.');
    return;
end
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

Reach = [Trials.Reach];
Target = [Trials.Target];
Joy = [Trials.Joystick];
Reward = [Trials.Reward];
RewardTask = [Trials.RewardTask];
EyeTarget = [Trials.EyeTarget];
Continuous = calcContinuous(Trials);
if isfield(Trials,'AdaptationPhase')
    Adaptation = [Trials.AdaptationPhase];
else
    Adaptation = 9*ones(1,length(Trials));
end

at = 'TargAq'; bn = [20,30];

% Why should Target==EyeTarget?  And why doesn't it in some cases?
% if ~isempty(find(Continuous==0 & Reach>0 & Target>0 & Adaptation>8 & Joy==0 & (Reward==1 | RewardTask==1) & Target==EyeTarget, 1))
%   Trials = Trials(find(Continuous==0 & Reach>0 & Target>0 & Adaptation>8 & Joy==0 & (Reward==1 | RewardTask==1) & Target==EyeTarget));

if ~isempty(find(Continuous==1 & Reach>0 & Target>0 & Adaptation>8 & Joy==0 & (Reward==1 | RewardTask==1), 1))
    Trials = Trials(find(Continuous==1 & Reach>0 & Target>0 & Adaptation>8 & Joy==0 & (Reward==1 | RewardTask==1)));
    
    %  Load up target data
    [E,H] = trialEyeHand(Trials,at,bn,1,1);
    h = sq(mean(H,3));
    plot(h(:,1),h(:,2),'x');
    Pos = calcHandTargetLocation(Trials);
    Y = h;
    X = [ones(size(h,1),1) Pos(:,:)];
    bX = regress(Y(:,1),X(:,[1 2]));
    bY = regress(Y(:,2),X(:,[1 3]));
    
    %  Set center
    centre = [bX(1) bY(1)];
    Scale.HandOffset = centre; Scale.Flag = []; Scale.Gradient = [bX(2),0;0,bY(2)];
end
%  Set scale gradient
allrecs= dayrecs(day);
if(exist('Scale')==1)
    HandScale = Scale;
    for iNum = 1:length(allrecs)
        file = ['rec' allrecs{iNum}];
        cd([MONKEYDIR '/' day '/' allrecs{iNum}]);
        if isfile(['rec' allrecs{iNum} '.hnd.dat']);
            save([file '.HandScale.mat'],'HandScale');
        end
    end
    
    figure;
    at = 'TargAq'; bn = [20,30];
    [E,H] = trialEyeHand(Trials,at,bn,1,0);
    h = sq(mean(H,3));
    plot(h(:,1),h(:,2),'x');
    
    axis([-25 25 -25 25])
    title([MONKEYNAME ':' day ' Hand Calibration']);
else
    disp('Scale doesnt exist. Probably no Hand trials.');
end
cd(olddir);
