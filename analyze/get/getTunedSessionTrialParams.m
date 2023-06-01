function TrialParams = getTunedSessionTrialParams(Tuning,TuningAnalParams,Trials,doNonSpatialAnalysis);

%  TrialParams = getTunedSessionTrialParams(Session,Tuning,TuningAnalParams,Trials);
% 
%  Returns a list of parameters for the specified trials, with reference to
%  the target in the response field of the specified Session. If no target
%  appears in the RF for a given trial, Null values are returned.
% 
%  TUNING   =   Tuning properties of the Session
%  TUNINGANALPARAMS = Defines how to identify the RF / surround regions
%  TRIALS   =   The Trials structure to analyze
% 

if nargin<4
  doNonSpatialAnalysis = 0;
end

TrialParams = [];

isChoiceTrial = zeros(1,length(Trials));
chosenTargetID =  ones(1,length(Trials));
chosenTargetInRFCode =  -ones(1,length(Trials));
ReactionTime =  zeros(1,length(Trials));
ReceivedReward =  zeros(1,length(Trials));
ChosenTargetLuminance =  NaN*zeros(1,length(Trials));
RewardBlockTrial =  zeros(1,length(Trials));
LuminanceDiff =  zeros(1,length(Trials));
RewardDistDiff =  zeros(1,length(Trials));
RFTargetAngularDistance =  NaN*zeros(1,length(Trials));
ChosenTargetAngle =  NaN*zeros(1,length(Trials));


TuningTrig = Tuning.TuningTrig;
TuningVM = Tuning.TuningVM;

choiceTrialCode = [Trials.Choice]==2;  
isChoiceTrial = choiceTrialCode;

choiceLocs = find(choiceTrialCode==1);
nonChoiceLocs = find(choiceTrialCode==0);

if length(nonChoiceLocs)>0
  targetLocation(nonChoiceLocs) = [Trials(nonChoiceLocs).Target];
  chosenTargetID(nonChoiceLocs) = 1;
  [ rfCode, targetAngle ] = calcTargetRFCode(TuningTrig,targetLocation(nonChoiceLocs),TuningAnalParams);
  if doNonSpatialAnalysis
    rfCode(:) = 1; 
  end
  chosenTargetInRFCode(nonChoiceLocs) = rfCode;
  ChosenTargetAngle = targetAngle;
  MinTargetAngularDistance(nonChoiceLocs) = NaN;
  LuminanceDiff(nonChoiceLocs) = NaN ;
  RewardDistDiff(nonChoiceLocs) = NaN;
  if size([Trials(nonChoiceLocs).TargetLuminanceVals],2)==2
    tChosenTargetLuminance = reshape([Trials(nonChoiceLocs).TargetLuminanceVals]',2,length(nonChoiceLocs));
    ChosenTargetLuminance(nonChoiceLocs) = tChosenTargetLuminance(1,:);
  end
  if size([Trials(nonChoiceLocs).RewardVolumeVals],2)==2
    tReceivedReward = reshape([Trials(nonChoiceLocs).RewardVolumeVals]',2,length(nonChoiceLocs));
    ReceivedReward(nonChoiceLocs) = tReceivedReward(1,:);
  end
end

if length(choiceLocs)>0
  chosenTargetContinuousLocation = reshape([Trials(choiceLocs).SaccadeChoiceContinuousLocation]',2,length(choiceLocs))';
  unchosenTargetContinuousLocation = reshape([Trials(choiceLocs).UnchosenTargetContinuousLocation]',2,length(choiceLocs))';
  [chooseRFCode, chooseAngle] = calcTargetRFCode(TuningVM,chosenTargetContinuousLocation,TuningAnalParams);
  ChosenTargetAngle = chooseAngle;
  ignoreRFCode = calcTargetRFCode(TuningVM,unchosenTargetContinuousLocation,TuningAnalParams);
    
  if doNonSpatialAnalysis
    chooseRFCode(:) = 1;
    ignoreRFCode(:) = 0;
  end
  
  targetLocations = [Trials(choiceLocs).T1T2Locations];
  T1Location = reshape(targetLocations(1,:)',2,length(choiceLocs))';
  T2Location = reshape(targetLocations(2,:)',2,length(choiceLocs))';
  choseT1 = [sum(chosenTargetContinuousLocation==T1Location,2)==2]';
  choseT2 = [sum(chosenTargetContinuousLocation==T2Location,2)==2]';
  choseT1Locs = find(choseT1);
  choseT2Locs = find(choseT2);
  chosenTargetID(choiceLocs(choseT1Locs)) = 1;
  chosenTargetID(choiceLocs(choseT2Locs)) = 2;
  
  inRFlocs  = find(chooseRFCode==1&ignoreRFCode==0);
  outRFlocs = find(chooseRFCode==0&ignoreRFCode==1);
  chosenTargetInRFCode(choiceLocs(inRFlocs)) = 1;
  chosenTargetInRFCode(choiceLocs(outRFlocs)) = 0;
                
  tChosenTargetLuminance = reshape([Trials(choiceLocs).TargetLuminanceVals]',2,length(choiceLocs));
  ChosenTargetLuminance(choiceLocs(choseT1Locs)) = tChosenTargetLuminance(1,choseT1Locs);
  ChosenTargetLuminance(choiceLocs(choseT2Locs)) = tChosenTargetLuminance(2,choseT2Locs);

  choseT1InRFlocs = choseT1Locs(find(ismember(choseT1Locs,inRFlocs)));
  choseT2InRFlocs = choseT2Locs(find(ismember(choseT2Locs,inRFlocs)));

  for refIter=1:2
    if refIter==1
      refLocation = T1Location(choseT1InRFlocs,:);
      testLocation = T2Location(choseT1InRFlocs,:);
    else
      refLocation = T2Location(choseT2InRFlocs,:);
      testLocation = T1Location(choseT2InRFlocs,:);
    end
    refAngle = angle([refLocation(:,1)+refLocation(:,2)*i]);
    negLocs = find(refAngle<0);
    refAngle(negLocs) = 2*pi+refAngle(negLocs);
  
    testAngle = angle([testLocation(:,1)+testLocation(:,2)*i]);
    negLocs = find(testAngle<0);
    testAngle(negLocs) = 2*pi+testAngle(negLocs);  
    
    angDiff = testAngle-refAngle;
    posLocs = find(angDiff>pi);
    angDiff(posLocs) = -(2*pi-angDiff(posLocs));
    negLocs = find(angDiff<-pi);
    angDiff(negLocs) = 2*pi+angDiff(negLocs);

    if refIter==1
      RFTargetAngularDistance(choiceLocs(choseT1InRFlocs)) = angDiff;
    else
      RFTargetAngularDistance(choiceLocs(choseT2InRFlocs)) = angDiff;      
    end
  end

  
  % Calculate log lum ratio and reward difference w.r.t. the target in the
  % response field, regardless of choice. These values are undefined when
  % there is no target in the RF.
  
  T1InRFLocs = find((chosenTargetInRFCode==1&choseT1)|...
                    (chosenTargetInRFCode==0&choseT2));
  T2InRFLocs = find((chosenTargetInRFCode==1&choseT2)|...
                    (chosenTargetInRFCode==0&choseT1));
  
%  % Old code (didn't work correctly)               
%   ref1Locs = [1:length(choiceLocs)];
%   ref2Locs = [ find(ismember(inRFlocs,choseT1Locs))' find(ismember(outRFlocs,choseT2Locs))' ];
%   ref1Locs(ref2Locs) = [];
%   tReceivedReward = reshape([Trials(choiceLocs).RewardVolumeVals]',2,length(choiceLocs));
%   ReceivedReward(choiceLocs) = tReceivedReward(1,:);

  tLuminance = reshape([Trials(choiceLocs).TargetLuminanceVals]',2,length(choiceLocs));
  LuminanceDiff(choiceLocs) = log10(tLuminance(1,:)./(tLuminance(2,:)+eps)); % default to T1-T2
  LuminanceDiff(choiceLocs(T1InRFLocs)) = log10(tLuminance(1,T1InRFLocs)./(tLuminance(2,T1InRFLocs)+eps));
  LuminanceDiff(choiceLocs(T2InRFLocs)) = log10(tLuminance(2,T2InRFLocs)./(tLuminance(1,T2InRFLocs)+eps));

  tReward = reshape([Trials(choiceLocs).RewardVolumeDist]',2,length(choiceLocs));
  RewardDistDiff(choiceLocs) = tReward(1,:)-tReward(2,:); % default to T1-T2
  RewardDistDiff(choiceLocs(T1InRFLocs)) = tReward(1,T1InRFLocs)-tReward(2,T1InRFLocs);
  RewardDistDiff(choiceLocs(T2InRFLocs)) = tReward(2,T2InRFLocs)-tReward(1,T2InRFLocs);
  
  tReceivedReward = reshape([Trials(choiceLocs).RewardVolumeVals]',2,length(choiceLocs));  
  ReceivedReward(choiceLocs(choseT1Locs)) = tReceivedReward(1,choseT1Locs);
  ReceivedReward(choiceLocs(choseT2Locs)) = tReceivedReward(2,choseT2Locs);
  
end

RewardBlockTrial = [Trials.RewardBlockTrial ];
ReactionTime = [Trials.SaccStart]-[Trials.Go];
  
TrialParams.chosenTargetID = chosenTargetID;
TrialParams.isChoiceTrial = isChoiceTrial;
TrialParams.ChosenTargetInRFCode = chosenTargetInRFCode;
TrialParams.ChosenTargetLuminance = ChosenTargetLuminance;
TrialParams.RewardBlockTrial = RewardBlockTrial;
TrialParams.ReactionTime = ReactionTime;
TrialParams.LuminanceDiff = LuminanceDiff;
TrialParams.RewardDistDiff = RewardDistDiff;
TrialParams.ReceivedReward = ReceivedReward;
TrialParams.RFTargetAngularDistance = RFTargetAngularDistance;
TrialParams.ChosenTargetAngle = ChosenTargetAngle;
