function [Trials] = dbInitTrials(Days, TrialType)
%  DBINITRIALS contructs Trials data structure across Days.
%
%  [TRIALS] = DBINITTRIALS(DAYS, TRIALTYPE);
%
%  Inputs:  DAYS    =   Cell array.  Days to include.
%                           ie to {'020822',020823','020824'}
%	    TRIALTYPE = 'Error' = Error Trials
%			 'Success' = Successful Trials
%
%  Outputs: TRIALS =  Structure array. Trials data structure for each recording.

global MONKEYDIR

olddir = pwd;
cd(MONKEYDIR);

if nargin == 1  TrialType = 'Success'; end

TrialsFields = {'Day','Fs','MT','MT1','MT2','Ch','Rec','Gain','Iso','Depth',...
	'AbortState','Trial','StartOn','StartAq','End','TargsOn',...
	'Go','TargAq','ReachStart','ReachStop','SaccStart','SaccStop',...
	'Sacc2Start','Sacc2Stop','TargetOff','InstOn','Targ2On',...
	'TargetRet','ReachGo','ReachAq','SaccadeGo','SaccadeAq',...
	'Reward2T','RewardConfig','RewardDist','Choice','RewardMag','RewardBlock',...
	'HandRewardBlock','EyeRewardBlock','Reward','RewardTask',...
	'EyeTarget','EyeTargetLocation','HandTargetLocation',...
	'AdaptationFeedback','AdaptationAction','AdaptationPhase',...
	'LEDBoard','RewardDur','Targ2','Separable4T','TargMove',...
	'EffInstOn','MinReachRT','MaxReachRT','MinReachAq','MaxReachAq','MinSaccadeRT',...
	'MaxSaccadeRT','MinSaccadeAq','MinSaccade2RT','MaxSaccade2RT',...
	'MinSaccade2Aq','HandCode','TaskCode','Joystick','Target',...
	'StartHand','StartEye','Success','Saccade','Reach','DoubleStep','MaxSaccadeAq',...
    'BrightVals','BrightDist','T1T2Locations','T1T2Delta'};

if ~iscell(Days)  Days = str2cell(Days);  end

disp('Initializing Trials data structure');

nd = length(Days);
ind = 0;
Trials = struct([]);
NumTrials = 0;
for d = 1:nd
    day = Days{d};
    if isdir([MONKEYDIR '/' day])
        cd([MONKEYDIR '/' day])
            recs = dayrecs(day);
            nr = length(recs);
            for r = 1:nr
                cd([MONKEYDIR '/' day '/' recs{r}]);
                if isfile(['rec' recs{r} '.Events.mat'])
                    load(['rec' recs{r} '.Events.mat']);
          
		 switch TrialType 
			case 'Success'
              ntr = sum(Events.Success);
			case 'Error'
			  ntr = sum(Events.Success==0);
			end
                    NumTrials = NumTrials + ntr
		end
	    end
   end
end

for iField = 1:length(TrialsFields)
   Trials(1).(TrialsFields{iField}) = [];
end

Trials = Trials(ones(1,NumTrials));
cd(olddir);
