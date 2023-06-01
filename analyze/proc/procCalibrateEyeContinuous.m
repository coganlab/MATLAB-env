function Scale = procCalibrateEyeContinuous(day,num)
%  procCALIBRATEHANDCONTINUOUS determines scale for Hand position for
%  continuous targets
%
%  Inputs:  DAY        =   String. Day to calibrate.
%           NUM        =   Cell. Recording number to calibrate
%                               Defaults to all recordings in given day
%                               with the "right" task type.
%
%  Outputs: SCALE   =   Structure.  Scaling for hand position.  
%
%
% Requires trial structure information from LabView Task Controller v7.0 or later 
% (Information about continuous targets in state code)
% yvz: this code was modified so that the calibration is performed using
% only (11)DelaySaccade,(12)DelaySaccadeTouch,(13)Delay Reach and Saccade when eye n hand
% move to the same location.


global MONKEYDIR MONKEYNAME

olddir = pwd;

if nargin < 2
    num = dayrecs(day);
end

at = 'TargAq'; bn = [5,50];

% Load data for recordings
Trials = dbSelectTrials(day);
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
clear Rec

% Get only these tasks for eye calibration: (11)DS,(12)DST,(13)DRS % yvz added
a=getTaskCode(Trials);
indx_tc=find(a==11 | a==12 | a==13);
idrs=find(a==12);
Trials=Trials(indx_tc);

% Saccade trials
idx_saccade = find([Trials.Saccade]>0 & [Trials.RewardTask]==1 & [Trials.ContinuousTargets]==1 & [Trials.Choice]==1); % saccade trial, simple click, continuous targets
Trials = Trials(idx_saccade);

% get DRS  trials where Eye and Hand have exact SAME position (added yz)
for i=1:length(Trials);
    eq(i,1)=isequal([Trials(i).ContinuousTarget1Cood], [Trials(i).ContinuousTarget2Cood]);
end
idx_eq=find(eq==1);
Trials=Trials(idx_eq);


[E,~] = trialEyeHand(Trials,at,bn,1,1);
e = sq(mean(E,3));

ntr = numel(Trials);


if(ntr<10)
    fprintf('Too few trials: %d\n',ntr);
    return;
else
	fprintf('Performing Continuous Eye Calibration on %d Trials\n',ntr);
end


% Throw out outliers
nrms = sqrt(sum(e.^2,2));
nrmsz=(nrms-mean(nrms))./std(nrms);
idx_outlier = find(abs(nrmsz)>3);
if ~isempty(idx_outlier)
    Trials(idx_outlier)=[];
    e(idx_outlier,:)=[]; % 140514 Maureen changed from h to e
    nrms(idx_outlier)=[];
end
ntr = numel(Trials);
fprintf('Removing %d Trials due to exceeding variance\n',numel(idx_outlier));
if(ntr<10)
    fprintf('Too few trials: %d\n',ntr);
    return;
end


% True Target Positions
for itr=1:ntr
    Pos(itr,:) = [Trials(itr).ContinuousTarget1Cood];
end
% Regression
Y = e;
X = [ones(size(e,1),1) Pos];
bX = regress(Y(:,1),X(:,[1 2]));
bY = regress(Y(:,2),X(:,[1 3]));

%  Set center
centre = [bX(1) bY(1)];
Scale.EyeOffset = centre; Scale.Flag = []; Scale.Gradient = [bX(2),0;0,bY(2)];

%  Set scale gradient
EyeScale = Scale;
for iNum = 1:nNum
	file = ['rec' num{iNum}];
	cd([MONKEYDIR '/' day '/' num{iNum}]);
	if isfile(['rec' num{iNum} '.hnd.dat']);
		save([file '.EyeScale.mat'],'EyeScale');
	end
end
tmp = (e-repmat(Scale.EyeOffset,size(e,1),1));
tmp = tmp*Scale.Gradient^(-1);
plot(tmp(:,1),tmp(:,2),'.r');
hold on
plot(Pos(:,1),Pos(:,2),'k.');
axis([-25 25 -25 25])
axis square
title([MONKEYNAME ':' day ' Eye Calibration']);

cd(olddir);
