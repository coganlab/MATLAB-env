function [PCAJoint,PCAParams] = processPCAJoint(Joint,PCAParams)
%
%   Assumes degrees upon input
%
%   Inputs: Joint = Cell array.  {Joint_id}(TimeStamp,Value)  or
%           Joint = MxN matrix.  Joint(Joint_id, frame_idx)
%
%   PCAParams.U
%   PCAParams.s 
%   PCAParams.MedParam
%   PCAParams.nDim
%   
%   PCAParams.Mean
%   PCAParams.Base;

if nargin < 2 || isempty(PCAParams)
    PCAParams.MedParam = 10;
end

if isfield(PCAParams,'nDim');
    nDim = PCAParams.nDim;
else
    nDim = length(Joint);
end

if isfield(PCAParams,'MedParam')
    MedParam = PCAParams.MedParam;
else
    MedParam = 10;
end

    
    clear Joint_Sequence
    if iscell(Joint)
        for iJoint = 1:length(Joint)
           Joint_Sequence(iJoint,1:length(Joint{iJoint})) = (Joint{iJoint}(2,:)); 
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
%         Joint_Sequence(iJoint,1:10)
%         mJoint_Sequence(iJoint)
        scJoint_Sequence(iJoint,:) = (1./pi).*(Joint_Sequence(iJoint,:) - mJoint_Sequence(iJoint));
    end
   
    ascJoint_Sequence = atanh(scJoint_Sequence);
    
     for iJoint = 1:nJoint
        if MedParam
            medascJoint_Sequence(iJoint,:) = medfilt1(ascJoint_Sequence(iJoint,:),MedParam);
        else
            medascJoint_Sequence(iJoint,:) = ascJoint_Sequence(iJoint,:);
        end
     end
    
    mascJoint_Sequence = nanmean(medascJoint_Sequence,2)';

    base_Sequence = mascJoint_Sequence(ones(nT,1),:)';
    dJoint_Sequence = medascJoint_Sequence - base_Sequence;
    
    if isfield(PCAParams,'U')
        u = PCAParams.U;
    else
        [u,s,v] = tqlisvd(dJoint_Sequence);
        PCAParams.s = s;
    end
    if isfield(PCAParams,'nDim')
        u = u(:,1:nDim);
    end
    PCAParams.U = u;
%     strim = s;
%     
%     % The indices in this loop are the tunable denoising piece
%     % parameterized by the integer pcaDim.
%     strimRecon = strim;
%     for iJointDelete = min([nJoint,pcaDim+1]):nJoint
%         strimRecon(iJointDelete,iJointDelete) = 0;
%     end
    %u(:,1) = -u(:,1);
    PCAJoint_Sequence = PCAParams.U'*dJoint_Sequence;
    PCAJoint = cell(1,nDim);
    if (iscell(Joint))
        for iJoint = 1:size(PCAJoint_Sequence,1)
          PCAJoint{iJoint}(1,:) = Joint{1}(1,:);
          PCAJoint{iJoint}(2,:) = PCAJoint_Sequence(iJoint,:);
        end
    else
        PCAJoint = PCAJoint_Sequence';
    end


    PCAParams.Mean = mJoint_Sequence';
    PCAParams.Base = mascJoint_Sequence';
    PCAParams.nDim = size(PCAJoint_Sequence,1);
%     reconCenteredJoint_Sequence = reconJoint_Sequence + base_Sequence;
%     reconOnCircleJoint_Sequence = tanh(reconCenteredJoint_Sequence)*pi + mJoint_Sequence(:,ones(1,nT));
