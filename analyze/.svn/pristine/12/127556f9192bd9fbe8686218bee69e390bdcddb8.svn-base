function procCalibrateRewardAndLuminance(day, rec,target_size_degrees)
%  PROCCALIBRATEREWARDANDLUMINANCE converts the Labview reward duration
%  and brightness parameters into fluid volume and luminance, respectively.
%
%  PROCCALIBRATEREWARDANDLUMINANCE(DAY, REC, TARGET_SIZE_DEGREES)
%
%  Inputs:  DAY    = String '030603'
%           REC    = String '001', or num [1,2]


global MONKEYDIR


olddir = pwd;

recs = dayrecs(day);
nRecs = length(recs);

if nargin < 2
    num = [1,nRecs];
elseif ischar(rec)
    num = [find(strcmp(recs,rec)),find(strcmp(recs,rec))];
elseif length(rec)==1
    num = [rec,rec];
elseif length(rec)==2
    num = rec;
end

if nargin < 3
  target_size_degrees = 2;
end


load([MONKEYDIR '/' day '/mat/calibration/brightness_calibration.mat']);
load([MONKEYDIR '/' day '/mat/calibration/solenoid_calibration.mat']);

% load([MONKEYDIR '/' day '/' recs{num(1)} '/rec' recs{num(1)} '.experiment.mat']);
% if isfield(experiment,'hardware')
%     format = getFileFormat('Broker');
% elseif isfile(['rec' rec '.experiment.mat'])
%     load(['rec' rec '.experiment.mat'])
%     format = getFileFormat('Broker');
% end


for iNum = num(1):num(2)
    close all
    disp(['Loading' MONKEYDIR '/' day '/' recs{iNum} '/rec' recs{iNum} '.Events.mat']);
    load([MONKEYDIR '/' day '/' recs{iNum} '/rec' recs{iNum} '.Events.mat']);

    for Tr = 1:length(Events.Trial)        

        rewardDur = Events.RewardDur(Tr,1:2);
        rewardDist = Events.RewardDist(Tr,1:2);
        
        brightVals = Events.BrightVals(Tr,1:2);
        brightDist = Events.BrightDist(Tr,1:2);
        
        CalibratedRewardVals = calcCalibratedRewardVolume(solenoid_calibration,rewardDur);
        CalibratedRewardDist = calcCalibratedRewardVolume(solenoid_calibration,rewardDist);
        
        CalibratedBrightVals = calcCalibratedTargetLuminance(brightness_calibration,target_size_degrees,brightVals);
        CalibratedBrightDist = calcCalibratedTargetLuminance(brightness_calibration,target_size_degrees,brightDist);
        
        Events.RewardVolumeVals(Tr,1:2) = CalibratedRewardVals;
        Events.RewardVolumeDist(Tr,1:2) = CalibratedRewardDist;
        
        Events.TargetLuminanceVals(Tr,1:2) = CalibratedBrightVals;
        % Events.TargetLuminanceDist(Tr,1:2) = CalibratedBrightDist;
        
    end
    
    save([MONKEYDIR '/' day '/' recs{iNum} '/rec' recs{iNum} '.Events.mat'],'Events');
    disp(['Saving ' MONKEYDIR '/' day '/' recs{iNum} '/rec' recs{iNum} '.Events.mat']);
end

saveTrials(day);

cd(olddir);

