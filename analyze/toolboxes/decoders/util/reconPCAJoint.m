function ReconJoint = reconPCAJoint(PCAJoint, PCAParams)
%
%   ReconJoint = reconPCAJoint(PCAJoint, PCAParams);
%
%   Inputs: Joint = Cell array.  {Joint_id}(TimeStamp,Value)  or
%           Joint = MxN matrix.  Joint(Joint_id, frame_idx)
%
%   Returns angles in degrees in original basis
%

if iscell(PCAJoint)
    nJoint = length(PCAJoint);
    for iJoint = 1:nJoint
        PCAJoint_Sequence(iJoint,1:length(PCAJoint{iJoint})) = (PCAJoint{iJoint}(2,:));
    end
else
    nJoint = size(PCAJoint,1);
    PCAJoint_Sequence = PCAJoint;
end
%reconJoint_Sequence = PCAParams.s(1:nJoint,1:nJoint)*PCAParams.U'*PCAJoint_Sequence;
    
reconJoint_Sequence = PCAParams.U*PCAJoint_Sequence;
nT = size(PCAJoint_Sequence,2);
base_Sequence = PCAParams.Base;  % Takes scaled Joints to the base scaled pose
mJoint_Sequence = PCAParams.Mean; % Takes the degree Joints to the mean (unscaled) pose
tmp = base_Sequence(:,ones(1,nT));
tmp2 = mJoint_Sequence(:,ones(1,nT));
 %whos reconJoint_Sequence tmp tmp2 mJointSequence base_Sequence mJoint_Sequence PCAJoint_Sequence
reconCenteredJoint_Sequence = reconJoint_Sequence + base_Sequence(:,ones(1,nT));  % Takes scaled Joints to the base scaled pose
tmp = tanh(reconCenteredJoint_Sequence)*pi;
tmp2 = mJoint_Sequence(:,ones(1,nT));
%whos reconCenteredJoint_Sequence tmp tmp2
reconOnCircleJoint_Sequence = tanh(reconCenteredJoint_Sequence)*pi + mJoint_Sequence(:,ones(1,nT)); % Takes the degree Joints to the mean (unscaled) pose


ReconJoint_Sequence = (180./pi)*reconOnCircleJoint_Sequence;


if iscell(PCAJoint)
    nJoint = size(ReconJoint_Sequence,1);
    ReconJoint = cell(1,nJoint);
    %nT = size(PCAJoint{1},2);
    for iJoint = 1:nJoint
        ReconJoint{iJoint}(1,:) = PCAJoint{1}(1,:);
        ReconJoint{iJoint}(2,:) = ReconJoint_Sequence(iJoint,:);
    end
else
    ReconJoint = ReconJoint_Sequence;
end