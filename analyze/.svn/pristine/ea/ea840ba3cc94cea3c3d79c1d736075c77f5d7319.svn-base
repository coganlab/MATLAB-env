function Scale = procCalibrateHandContinuous(day,num)
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
% only DelayReach (DR (9)), Delay Reach and Saccade (DRS) when eye & hand
% move to the same location

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


% Get trials only for Delay Reach (9),Delay Reach and Saccade(13)% yvz added
a=getTaskCode(Trials);
indx_tc=find(a==9 | a==13);
Trials=Trials(indx_tc);

% get DRS trials where Eye and Hand have exact SAME position (added yvz)
% --> usefule to remove Dissociated trials, where hand accuracy is low
% perform calibratio with One-Eye hand target ON. 
for i=1:length(Trials);
    eq(i,1)=isequal([Trials(i).ContinuousTarget1Cood], [Trials(i).ContinuousTarget2Cood]);
end
idx_eq=find(eq==1);
Trials=Trials(idx_eq);

% Reduce to simple center out reach trials on continuous targets
Continuous = [Trials.ContinuousTargets];
Reach = [Trials.Reach];
Saccade = [Trials.Saccade];
RewardTask = [Trials.RewardTask];
Choice = [Trials.Choice]; % added yvz


Tc = [Trials.TaskCode];
idx_reach = find(Reach>0 & (RewardTask==1) & (Continuous==1) & (Choice==1)); % yvz added Choice=1
%idx_saccade = find(Saccade>0 & (RewardTask==1) & (Continuous==1) &(Choice==1)); % yvz not needed
Trials = Trials(idx_reach);


[E,H] = trialEyeHand(Trials,at,bn,1,1);
h = sq(mean(H,3));
%e = sq(mean(E,3)); % removed not necessary yvz

ntr = numel(Trials);
%h = h(idx_reach,:); % removed yvz
%e=e(idx_saccade,:); % removed yvz


if(ntr<10)
    fprintf('Too few trials: %d\n',ntr);
    return;
else
	fprintf('Performing Continuous Hand Calibration on %d Trials\n',ntr);
end


% Throw out outliers
nrms = sqrt(sum(h.^2,2));
nrmsz=(nrms-mean(nrms))./std(nrms);
idx_outlier = find(abs(nrmsz)>3);
if ~isempty(idx_outlier)
    Trials(idx_outlier)=[];
    h(idx_outlier,:)=[];
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
    Pos(itr,:) = [Trials(itr).ContinuousTarget2Cood]; % mod yvz (before ContinuousTarget1Cood, should be 2 according to Labview)
end


% find out about a possible lag between labview and acquisition machine (computer clocks not in sync)
[ccx lx]=xcorr(h(:,1),Pos(:,1));
[ccy ly]=xcorr(h(:,2),Pos(:,2));
lx=lx(find(ccx==max(ccx)));
ly=ly(find(ccy==max(ccy)));

if lx ~= 0 | ly ~=0
   fprintf('There is a Lag between LabView and Recording Machines: %d Trials\nSwitching to state code coordinates for calibration',lx)
%       h = h(lx+1:end,:);
%       Pos = Pos(1:end-lx,:)
%    else
%       Pos = Pos(lx+1:end,:);
%       h = h(1:end-lx,:) ;
%    end
   clear Pos
   tmp =[Trials(:).ContinuousTarget2]./18.*2.*pi; % mod yvz, before tmp =[Trials(:).ContinuousTarget1]./18.*2.*pi;
   tmp = [Trials(:).ContinuousRadius2].*exp(1i.*tmp); % mod yvz, before tmp = [Trials(:).ContinuousRadius1].*exp(1i.*tmp);
   Pos = [real(tmp)' imag(tmp)'];
    
end

% pre shift and scale
% nrms_Pos = sqrt(sum(Pos.^2,2));
% shift = mean(h - Pos);
% scale = mean(nrms_Pos./nrms);
% hs=(h-repmat(shift,size(h,1),1)).*scale;


% Regression
Y = h;
X = [ones(size(h,1),1) Pos];
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
	if isfile(['rec' num{iNum} '.hnd.dat']);
		save([file '.HandScale.mat'],'HandScale');
	end
end
tmp = (h-repmat(Scale.HandOffset,size(h,1),1));
tmp = tmp*Scale.Gradient^(-1);
plot(tmp(:,1),tmp(:,2),'.g');
hold on
plot(Pos(:,1),Pos(:,2),'k.');
axis([-25 25 -25 25])
title([MONKEYNAME ':' day ' Hand Calibration']);

% % Load data for recordings
% Trials = dbSelectTrials(day);
% ntr = length(Trials);
% if(ntr<1)
%     disp('No trials for day.');
%     return;
% end
% clear Rec
% [Rec{1:ntr}] = deal(Trials.Rec);
% dum = zeros(1,ntr);
% nNum = length(num);
% for iNum = 1:nNum
%     for i = 1:ntr
%         RecTmp(i,:) = num2str(cell2num(Rec(i)));
%         if RecTmp(i,:) == num{iNum}
%             dum(i) = 1;
%         end
%     end
% end
% Trials = Trials(find(dum));
% clear Rec
% 
% [E,H] = trialEyeHand(Trials,at,bn,1,1);
% h = sq(mean(H,3));
% e = sq(mean(E,3));
% keyboard

cd(olddir);
