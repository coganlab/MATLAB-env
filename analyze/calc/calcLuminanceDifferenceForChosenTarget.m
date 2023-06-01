function LuminanceDifference = calcLuminanceDifferenceForChosenTarget(Trials)
%
%  LuminanceDifference = calcLuminanceDifferenceForChosenTarget(Trials)
%
%  LuminanceDifference is Trials.BrightVals(1) - Trials.BrightVals(2);

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