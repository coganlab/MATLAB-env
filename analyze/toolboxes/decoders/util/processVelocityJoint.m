function [VelocityJoint, JointParams] = processVelocityJoint(Joint, JointParams)
%
%   Assumes degrees upon input
%
%   Inputs: Joint = Cell array.  {Joint_id}(TimeStamp,Value)  or
%           Joint = MxN matrix.  Joint(Joint_id, frame_idx)
%
%   JointParams.MedParam
%   JointParams.nDim
%   
%   JointParams.Mean
%   JointParams.Base;

if nargin < 2
    JointParams = [];
    MedParam = 10;
else
    if isfield(JointParams,'MedParam')
        MedParam = JointParams.MedParam;
    else
        MedParam = [];
    end
end
    nDim = length(Joint);

    
    clear Joint_Sequence
    if iscell(Joint)
        for iJoint = 1:length(Joint)
           Joint_Sequence(iJoint,1:length(Joint{iJoint})) = medfilt1(Joint{iJoint}(2,:),MedParam); 
        end
    else
        Joint_Sequence = Joint;
    end
    
   Joint_Sequence = (pi./180).*Joint_Sequence;
    % determine angle about which to center each joint, now in radians
    
    %mJoint_Sequence = circ_mean(Joint_Sequence,[],2);
    for j = 1:size(Joint_Sequence,1)% deal with nans
        tmp = sq(Joint_Sequence(j,:));
        tmp(isnan(tmp)) = [];
        mJoint_Sequence(j) = circ_mean(tmp,[],2);
    end
    scJoint_Sequence = zeros(size(Joint_Sequence));
    nT = size(scJoint_Sequence,2);
    nJoint = length(mJoint_Sequence);
    for iJoint = 1:nJoint;
        scJoint_Sequence(iJoint,:) = (1./pi).*(Joint_Sequence(iJoint,:) - mJoint_Sequence(iJoint));
    end
   
    ascJoint_Sequence = atanh(scJoint_Sequence);
    
     for iJoint = 1:nJoint
            medascJoint_Sequence(iJoint,:) = ascJoint_Sequence(iJoint,:);
     end
    
    mascJoint_Sequence = nanmean(medascJoint_Sequence,2)';

    base_Sequence = mascJoint_Sequence(ones(nT,1),:)';
    dJoint_Sequence = medascJoint_Sequence - base_Sequence;
    
    JointParams.StartJoint = dJoint_Sequence(:,1);
    VelocityJoint_Sequence = dJoint_Sequence(:,2:nT) - dJoint_Sequence(:,1:nT-1);
    VelocityJoint = cell(1,nJoint);
    if (iscell(Joint))
        for iJoint = 1:size(VelocityJoint_Sequence,1)
          VelocityJoint{iJoint}(1,:) = Joint{1}(1,2:nT);
          VelocityJoint{iJoint}(2,:) = VelocityJoint_Sequence(iJoint,:);
          JointParams.StartTime = Joint{1}(1,1);
        end
    else
        for iJoint = 1:size(VelocityJoint_Sequence,1)
            VelocityJoint(iJoint,:) = VelocityJoint_Sequence(iJoint,:);
        end
    end

    JointParams.Mean = mJoint_Sequence';
    JointParams.Base = mascJoint_Sequence';
%     reconCenteredJoint_Sequence = reconJoint_Sequence + base_Sequence;
%     reconOnCircleJoint_Sequence = tanh(reconCenteredJoint_Sequence)*pi + mJoint_Sequence(:,ones(1,nT));
