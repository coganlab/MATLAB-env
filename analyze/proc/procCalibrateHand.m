function Scale = procCalibrateHand(day,num)
%  procCALIBRATEHAND determines scale for Hand position
%
%  Inputs:  DAY        =   String. Day to calibrate.
%           NUM        =   Cell. Recording number to calibrate
%                               Defaults to all recordings in given day
%                               with the "right" task type.
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

if ~isempty(find(Continuous==0 & Reach>0 & Target>0 & Adaptation>8 & Joy==0 & (Reward==1 | RewardTask==1), 1))
  Trials = Trials(find(Continuous==0 & Reach>0 & Target>0 & Adaptation>8 & Joy==0 & (Reward==1 | RewardTask==1)));
  Target = [Trials.Target];
% 
% %  Determine offset
% at = 'StartAq'; bn = [0,10];
% [E] = EyeHandTrial(Trials,at,bn,1);
% e1 = sq(mean(E,3));
% % hold off; plot(e(:,1),e(:,2),'.'); hold on;
% % 
%  Load up target data
  [E,H] = trialEyeHand(Trials,at,bn,1,1);
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

% keyboard
% kill = find(h(:,1)<2e4);
% h(kill,:)=[];
% Target(kill)=[];
% Y = h;
% X = [zeros(size(h,1),1) Pos(Target,:)];
% 
% pos = Pos(Target,:);
% [ax bx rx px] = djh_linreg(h(:,1),pos(:,1));
% xCal = ax+bx.*h(:,1);
% [ay by ry py] = djh_linreg(h(:,2),pos(:,2));
% yCal = ay+by.*h(:,2);

  l = 1;
  lambda = 0;
%   covsum = sum(diag(Y(:,1)*Y(:,1)'));
%   lambda = covsum/l.*eye(size(Xt)); % regularization
  Xt = X(:,[1 2])'*X(:,[1 2]);
  bX = pinv(Xt+lambda)*X(:,[1 2])'*Y(:,1);
   
  Xt = X(:,[1 3])'*X(:,[1 3]);
  bY = pinv(Xt+lambda)*X(:,[1 3])'*Y(:,2);

%   bX = regress(Y(:,1),X(:,[1 2]));
%   bY = regress(Y(:,2),X(:,[1 3]));

%  Set centers
  centre = [bX(1) bY(1)];
  Scale.HandOffset = centre; Scale.Flag = []; Scale.Gradient = [bX(2),0;0,bY(2)];
  
elseif ~isempty(find(Reach>0 & Target>0 & Joy==0 & Reward==3, 1))
  Trials = Trials(find(Reach>0 & Target>0 & Joy==0 & Reward==3));
  Target = getTarget(Trials);
  [E,H] = EyeHandTrial(Trials,at,bn,1);
  h = [sq(mean(H,3))];
  if length(unique(Target))==1
    mh(:,1) = h(:,1)-mean(h(:,1)); mh(:,2) = h(:,2)-mean(h(:,2));
    Pos = [[10,0];[10,10];[0,10];[-10,10];[-10,0];[-10,-10];[0,-10];[10,-10];...
        [20,10];[-20,10];[0,0]];
    T = zeros(1,size(mh,1));
    if Target(1) == 1 || Target(1)==5 %%  Need to add cases for other directions
      T(1,find(mh(:,1)>0)) = 1;
      T(1,find(mh(:,1)<0)) = 5;
      Y = h;
      X = [ones(size(h,1),1) Pos(T,:)];
      bX = regress(Y(:,1),X(:,[1 2]));
      centre = [bX(1) mean(h(:,2))];
      Scale.HandOffset = centre; Scale.Flag = []; Scale.Gradient = [bX(2),0;0,bX(2)];
    end
    if Target(1) == 3 || Target(1)==7 %%  Need to add cases for other directions
      T(1,find(mh(:,2)>0)) = 3;
      T(1,find(mh(:,2)<0)) = 7;
      Y = h;
      X = [ones(size(h,1),1) Pos(T,:)];
      bY = regress(Y(:,2),X(:,[1 3]));
      centre = [mean(h(:,1)) bY(1)];
      Scale.HandOffset = centre; Scale.Flag = []; Scale.Gradient = [bY(2),0;0,bY(2)];
    end
    if Target(1) == 2 || Target(1) == 6
      T(1,find(mh(:,1)>0)) = 2;
      T(1,find(mh(:,1)<0)) = 6;
      Y = h;
      X = [ones(size(h,1),1) Pos(T,:)];
      bX = regress(Y(:,1),X(:,[1 2]));
      bY = regress(Y(:,2),X(:,[1 3]));
      centre = [bX(1) bY(1)];
      Scale.HandOffset = centre; Scale.Flag = []; Scale.Gradient = [bX(2),0;0,bY(2)];
    end 
    if Target(1) == 4 || Target(1) == 8
      T(1,find(mh(:,1)>0)) = 8;
      T(1,find(mh(:,1)<0)) = 4;
      Y = h;
      X = [ones(size(h,1),1) Pos(T,:)];
      bX = regress(Y(:,1),X(:,[1 2]));
      bY = regress(Y(:,2),X(:,[1 3]));
      centre = [bX(1) bY(1)];
      Scale.HandOffset = centre; Scale.Flag = []; Scale.Gradient = [bX(2),0;0,bY(2)];
    end
  end
end
%  Set scale gradient
if(exist('Scale')==1)
    HandScale = Scale;
    for iNum = 1:nNum
        file = ['rec' num{iNum}];
        cd([MONKEYDIR '/' day '/' num{iNum}]);
        if isfile(['rec' num{iNum} '.hnd.dat']);
          save([file '.HandScale.mat'],'HandScale');
        end
    end
    % 
    % at = 'StartAq'; bn = [0,10];
    % [E] = EyeHandTrial(Trials,at,bn,1,0);
    % e = sq(mean(E,3));
    % hold off; plot(e(:,1),e(:,2),'.');
    % hold on; plot(0,0,'r.');
    figure;
    at = 'TargAq'; bn = [20,30];
    [E,H] = trialEyeHand(Trials,at,bn,1,0);
    h = sq(mean(H,3));
    plot(h(:,1),h(:,2),'.');

    axis([-25 25 -25 25])
    title([MONKEYNAME ':' day ' Hand Calibration']);
else
    disp('Scale doesnt exist. Probably no Hand trials.');
end
cd(olddir);
