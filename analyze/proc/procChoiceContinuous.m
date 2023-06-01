function procChoiceContinuous(day, rec)
%  PROCCHOICECONTINUOUS determines actual reach and saccade movement
%  directions and whether the low or high reward target was chosen. Note:
%  For continuous targets the circle is always drawn on Target1 location,
%  Triangle is always drawn on Target2 location
%
%  PROCCHOICECONTINUOUS(DAY, REC)
%
%  Inputs:  DAY    = String '030603'
%           REC    = String '001', or num [1,2]
%
% Generates fields:
% Events.MovementChoiceContinuous; -> ContinuousTarget number
% Events.MovementErrorContinuous; -> [HandError EyeError]
% Events.ChoseHighRewContinuous; -> Boolean
% Events.ChoseLowRewContinuous; -> Boolean
% Events.ChoseCircleContinuous; -> Boolean
% Events.ChoseTriangleContinuous; -> Boolean


global MONKEYDIR
global ReachCode
global SaccadeCode
global ReachSaccadeCode
global DelSaccadeCode ReachFixCode

olddir = pwd;

recs = dayrecs(day);
nRecs = length(recs);

at = 'TargAq'; bn = [5,50];
bn = [5,50];
number = 1;

ReachCode = 9;
ReachFixCode = 10;
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

for iNum = num(1):num(2)
	close all
	disp(['Loading' MONKEYDIR '/' day '/' recs{iNum} '/rec' recs{iNum} '.Events.mat']);
	load([MONKEYDIR '/' day '/' recs{iNum} '/rec' recs{iNum} '.Events.mat']);
	
	disp('Loading hand/eye data');
    try
        load([MONKEYDIR '/' day '/' recs{iNum} '/rec' recs{iNum} '.HandScale.mat']);
        handdata=1;
    catch
        fprintf('Couldnt load Hand Scale\n')
        handdata=0;
    end
    try
        load([MONKEYDIR '/' day '/' recs{iNum} '/rec' recs{iNum} '.EyeScale.mat']);
        eyedata=1;
	catch
        fprintf('Couldnt load Eye Scale\n')
        eyedata=0;
    end
	
	Events.MovementChoiceContinuous = nan(1,length(Events.Trial));
	Events.MovementErrorContinuous = nan(2,length(Events.Trial));
	Events.ChoseHighRewContinuous = nan(1,length(Events.Trial));
	Events.ChoseLowRewContinuous = nan(1,length(Events.Trial));
	Events.ChoseCircleContinuous = nan(1,length(Events.Trial));
	Events.ChoseTriangleContinuous = nan(1,length(Events.Trial));
	
	if sum(Events.Success)>0
		% Load eye and hand data
		Trials = dbSelectTrials(day,recs{iNum});
		[E,H] = trialEyeHand(Trials,at,bn,1,1);
		H=mean(H,3);E=mean(E,3);
        if handdata
            H = (H-repmat(HandScale.HandOffset,size(H,1),1)); H = H*HandScale.Gradient^(-1);
        end
        if eyedata
            E = (E-repmat(EyeScale.EyeOffset,size(E,1),1)); E = E*EyeScale.Gradient^(-1);
        end

		ind=0;
		for Tr = 1:length(Events.Trial)
			if Events.Success(Tr) == 1
				ind=ind+1;
				e = E(ind,:);
				h = H(ind,:);
				Ch = Events.RewardTask(Tr);
				tc = Events.TaskCode(Tr);
				switch Ch
					case 1 % Simple Reward, there is only one target
						Events.MovementChoiceContinuous(Tr) = Events.ContinuousTarget1(Tr);
					case 3 % 2TRM Choice, targets are placed 180deg apart
						if any(tc==[ReachCode ReachFixCode SaccadeCode ReachSaccadeCode])
							% Location of Targets
							t1 = Events.ContinuousTarget1Cood(Tr,:);
							t2 = Events.ContinuousTarget2Cood(Tr,:);
							
							% Difference between targets and hand/eye positions
							t1dh = norm(t1-h); t2dh=norm(t2-h); tdh=[t1dh t2dh];
							t1de = norm(t1-e); t2de=norm(t2-e); tde=[t1de t2de];
							
							% Check movement depending on task type
							if tc==ReachCode
								[dummy mc]=min(tdh);
								merr = [tdh(mc) norm(e)];
                            elseif tc==ReachFixCode
								[dummy mc]=min(tdh);
								merr = [tdh(mc) norm(e)];
							elseif tc==SaccadeCode
								[dummy mc]=min(tde);
								merr = [norm(h) tde(mc)];
							elseif tc==ReachSaccadeCode
								[dummy mch]=min(tdh);
								[dummy mce]=min(tde);
								mc=mch;
								merr = [tdh(mc) tde(mc)];
								if mch~=mce; warning('Divergent Reach and Saccade Choice\nError Hand: %.2f, Error Eye: %.2f',merr(1),merr(2)); end
								
							end
							
							if mc == 1 % Circle is Chosen
								Events.MovementChoiceContinuous(Tr) = Events.ContinuousTarget1(Tr);
							else % Triangle is chosen
 								Events.MovementChoiceContinuous(Tr) = Events.ContinuousTarget2(Tr);
							end
							

							Events.ChoseCircleContinuous(Tr) = (mc==1);
							Events.ChoseTriangleContinuous(Tr) = (mc==2);
							
							% Assign Movement error
							Events.MovementErrorContinuous(:,Tr)=merr;
							
							% Assign reward choice
							rew = Events.RewardDur(Tr,1:2);
							Events.ChoseHighRewContinuous(Tr) = rew(mc)>rew(setdiff([1 2],mc));
							Events.ChoseLowRewContinuous(Tr) = rew(mc)<rew(setdiff([1 2],mc));
						else
							fprintf('Undefined Task Type: %s, %s, Trial %d\nTaskCode: %d',day,recs{iNum},Tr,tc)
						end
					otherwise
						fprintf('Undefined Reward Type: %s, %s, Trial %d\n',day,recs{iNum},Tr)
				end
			end
		end
	end
	save([MONKEYDIR '/' day '/' recs{iNum} '/rec' recs{iNum} '.Events.mat'],'Events');
	disp(['Saving ' MONKEYDIR '/' day '/' recs{iNum} '/rec' recs{iNum} '.Events.mat']);
end



saveTrials(day);
cd(olddir);

