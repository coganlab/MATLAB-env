function OrigJoint = unLinearizeJointAngles(LinearJoint, LinearParams)
%
%   OrigJoint = unLinearizeJointAngles(LinearJoint, LinearParams);
%
%   Inputs: Joint = Cell array.  {Joint_id}(TimeStamp,Value)  or
%           Joint = MxN matrix.  Joint(Joint_id, frame_idx)
%
%   Returns angles in degrees in original basis
%

if iscell(LinearJoint)
    nJoint = length(LinearJoint);
    for iJoint = 1:nJoint
        LinearJoint_Sequence(iJoint,1:length(LinearJoint{iJoint})) = (LinearJoint{iJoint}(2,:));
    end
else
    nJoint = size(LinearJoint,1);
    LinearJoint_Sequence = LinearJoint;
end
    
nT = size(LinearJoint_Sequence,2);
LinearParams
base_Sequence = LinearParams.Base;  % Takes scaled Joints to the base scaled pose
mJoint_Sequence = LinearParams.Mean; % Takes the degree Joints to the mean (unscaled) pose
reconCenteredJoint_Sequence = LinearJoint_Sequence + base_Sequence(:,ones(1,nT));  % Takes scaled Joints to the base scaled pose
reconOnCircleJoint_Sequence = tanh(reconCenteredJoint_Sequence)*pi + mJoint_Sequence(:,ones(1,nT)); % Takes the degree Joints to the mean (unscaled) pose

ReconJoint_Sequence = (180./pi)*reconOnCircleJoint_Sequence;

if iscell(LinearJoint)
    nJoint = size(ReconJoint_Sequence,1);
    OrigJoint = cell(1,nJoint);
    %nT = size(PCAJoint{1},2);
    for iJoint = 1:nJoint
        OrigJoint{iJoint}(1,:) = LinearJoint{1}(1,:);
        OrigJoint{iJoint}(2,:) = ReconJoint_Sequence(iJoint,:);
    end
else
    OrigJoint = ReconJoint_Sequence;
end
