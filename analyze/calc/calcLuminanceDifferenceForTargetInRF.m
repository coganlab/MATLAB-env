function LuminanceDifference = calcLuminanceDifferenceForTargetInRF(Trials)
%
%  LuminanceDifference = calcLuminanceDifferenceForChosenTarget(Trials)
%

LuminanceDifference = [];
if length(Trials)>0

% Calculate Luminance difference as (L_chosen - L_unchosen)
nLuminance = size(Trials(1).TargetLuminanceVals,2);
LD = reshape([Trials.TargetLuminanceVals],[nLuminance,length(Trials)]);
LD = log10(LD);
LuminanceDifference = -diff(LD(1:2,:),1,1);

chosenLocation = reshape([ Trials.SaccadeChoiceContinuousLocation ]',2,length(Trials))';
T1T2Locations = [ Trials.T1T2Locations ];
T2Location = reshape(T1T2Locations(2,:)',2,length(Trials))';
choseT2locs = find(sum(chosenLocation==T2Location,2)==2);
LuminanceDifference(choseT2locs) = -LuminanceDifference(choseT2locs);

% for i=1:length(Trials)
%   if ismember(Trials(i).SaccadeChoiceContinuousLocation,Trials(i).T1T2Locations(2,:),'rows')
%     LuminanceDifference(i) = -LuminanceDifference(i);  
%   end
% end

% If the chosen target was out of the RF, negate Luminance difference
chosenTargetInRFCode = [Trials.chosenTargetInRFCode];
outRFlocs = find(chosenTargetInRFCode==0);
LuminanceDifference(outRFlocs) = -LuminanceDifference(outRFlocs);

% If the chosen target was in an excluded area, set Luminance difference = NaN;
nanLocs = find(chosenTargetInRFCode==-1);
LuminanceDifference(nanLocs) = NaN;
end