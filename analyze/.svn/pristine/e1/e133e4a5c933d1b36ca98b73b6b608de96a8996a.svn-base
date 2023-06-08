function [LinearJoint,LinearParams] = linearizeJointAngles(Joint,LinearParams)
%
%   Assumes degrees upon input
%
%   Inputs: Joint = Cell array.  {Joint_id}(TimeStamp,Value)  or
%           Joint = MxN matrix.  Joint(Joint_id, frame_idx)
%
%   LinearParams.MedParam
%   
%   LinearParams.Mean
%   LinearParams.Base;

if nargin < 2 || isempty(LinearParams)
    LinearParams.MedParam = 10;
end

if isfield(LinearParams,'MedParam')
    MedParam = LinearParams.MedParam;
else
    MedParam = 10;
end

if iscell(Joint)
    for iJoint = 1:length(Joint)
        Joint_Sequence(iJoint,1:length(Joint{iJoint})) = (Joint{iJoint}(2,:));
    end
else
    Joint_Sequence = Joint;
end

Joint_Sequence = (pi./180).*Joint_Sequence;
% determine angle about which to center each joint, now in radians
if nargin == 2
  mJoint_Sequence = LinearParams.Mean
else
  for iJoint = 1:size(Joint_Sequence,1)% deal with nans
    tmp = sq(Joint_Sequence(iJoint,:));
    tmp(isnan(tmp)) = [];
    mJoint_Sequence(iJoint) = circ_mean(tmp,[],2);
  end
end
scJoint_Sequence = zeros(size(Joint_Sequence));
nT = size(scJoint_Sequence,2);
nJoint = length(mJoint_Sequence);
for iJoint = 1:nJoint;
    scJoint_Sequence(iJoint,:) = (1./pi).*(Joint_Sequence(iJoint,:) - mJoint_Sequence(iJoint));
end
ascJoint_Sequence = atanh(scJoint_Sequence);
medascJoint_Sequence = zeros(size(ascJoint_Sequence));
for iJoint = 1:nJoint
    if MedParam
        medascJoint_Sequence(iJoint,:) = medfilt1(ascJoint_Sequence(iJoint,:),MedParam);
    else
        medascJoint_Sequence(iJoint,:) = ascJoint_Sequence(iJoint,:);
    end
end

if nargin == 2
  mmedscJoint_Sequence = LinearParams.Base;
else
  mmedscJoint_Sequence = nanmean(medascJoint_Sequence,2)';
end
base_Sequence = mmedscJoint_Sequence(ones(nT,1),:)';
whos base_Sequence
dJoint_Sequence = medascJoint_Sequence - base_Sequence;

LinearJoint = cell(1,size(dJoint_Sequence,1));
if (iscell(Joint))
    for iJoint = 1:size(dJoint_Sequence,1)
        LinearJoint{iJoint}(1,:) = Joint{1}(1,:);
        LinearJoint{iJoint}(2,:) = dJoint_Sequence(iJoint,:);
    end
else
    LinearJoint = dJoint_Sequence;
end


LinearParams.Mean = mJoint_Sequence';
LinearParams.Base = mmedscJoint_Sequence';
