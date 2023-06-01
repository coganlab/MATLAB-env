function [predicted_joint_velocity_sequence,dum] = predictVelocityMovements(Joints, Target, Params)
%
%   Assumes degrees upon input
%
%   Inputs: Joint = Array of initial joint angles
%           Target = Target location [x,y,z,pitch yaw, roll, identifier]
%           Params = Various parameters to define reach trajectory
%
%   Output: Predicted joint angle velocity sequence




if(isfield(Params,'ReachTime'))
    t = Params.ReachTime;
else
    t = 1e2;
end
if(isfield(Params,'ReachToGraspFraction'))
    grasp_time = Params.ReachToGraspFraction;
else
    grasp_time = 0;
end
if(isfield(Params,'TimePoints'))
    tps = Params.TimePoints;
else
    tps = t;
end
if(isfield(Params,'Return'))
    ret = Params.Return ;
else
    ret = 0;
end
if(isfield(Params,'EndPoints')) 
    grasps = Params.EndPoints;
else
    %load('/mnt/y7/sas1/Jester_PMd_PMv_LMF//mat/PowerGrasp.mat')
    %load('/mnt/y7/sas1/Jester_PMd_PMv_LMF//mat/PrecisionGrasp.mat')
    %load('/mnt/y7/sas1/Jester_PMd_PMv_LMF/mat/VirtualGraspsAligned.mat')
    %file = 'Power_140205_005';
    file = 'Precision_140124_005';
    load(['/mnt/y7/sas1/Jester_PMd_PMv_LMF/mat/' file '.mat'])
end
if(ret == 1)
    %load('/mnt/y7/sas1/Jester_PMd_PMv_LMF/mat/StaticGraspsAligned.mat')
    end_grasp_joints =  [40.0000, 50.0000, 7.4231, 84.7701, 69.0961, 1.3011, -2.0140, -7.8839, -14.0357,...
        0, 0, -10, 0, -10, -10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
    dum = 0;
else
    end_grasp_joints = nan(length(Joints),1);
    
    endPoint = grasps.endpoint;
    TargetEndPoint = Target(1:3);
    
    targetDist = mean([abs(endPoint(1,:)-TargetEndPoint(1));abs(endPoint(2,:)-TargetEndPoint(2));abs(endPoint(3,:)-TargetEndPoint(3))],1);
    [dum,ind] = min(targetDist);
    end_grasp_joints = grasps.grasp(ind,:);
end
predicted_joint_sequence = nan(length(Joints),t);
for iJoint = 1:7
    predicted_joint_sequence(iJoint,:) = linspace(Joints(iJoint), end_grasp_joints(iJoint),t);
end
for iJoint = 8:length(Joints)
    reach = floor(t*(grasp_time));
    grsp = t - reach;
    predicted_joint_sequence(iJoint,:) = [ones(1,reach).*Joints(iJoint),linspace(Joints(iJoint), end_grasp_joints(iJoint),grsp)];
end

dt = 50/1e3; %s
predicted_joint_velocity_sequence = (predicted_joint_sequence(:,2:end)-predicted_joint_sequence(:,1:end-1))/(t*dt);
predicted_joint_velocity_sequence =  predicted_joint_velocity_sequence(:,tps);








