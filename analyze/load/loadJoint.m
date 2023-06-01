function [joints, jointname] = loadJoint(file, Events, trials, field, bn, jointname)
%  LOADJOINT loads joint data 
%
%  [Joints, JointNames] = LOADJOINT(FILE, EVENTS, TRIALS, FIELD, BN, JOINTNAME)
%
%  Inputs:  FILE    = String.  Recording file prefix.  Can also be hand3d cell array.
%           EVENTS  = Structure.  Trial mocap events data structure.
%           TRIALS  = Vector.  Trials to load data for.
%           FIELD   = Scalar.  Event to align data to.
%           BN      = Vector or array.  Time to start and stop loading data in ms.
%			Can enter a different set of times for each trial. ie size(bn) = [Ntr,2];
%           JOINTNAME      =  Cell array.  Joints to load data for.
%               Defaults to global JOINTLIST.  
%			Note: If FILE is data, then JOINTNAME should be ch
%				which are the indices to access that data.
%
%           Note:  Times should be in ms.
%
%   Outputs:   JOINTS  = (Joint,Time) Joint Angle Time series
%              JOINTNAME = Cell array of joint names for requested
%               joint angle time series
%
%

global experiment MARKER_TYPE_LIST

joint_names = {};

if nargin < 4; field = 'TargsOn'; end
if nargin < 5; bn = [1,1000]; end

if ischar(file)
    
    disp(['loading ' file '.Body.Joint.mat']);
    load([file '.Body.Joint.mat']);  % Joint.mat contains joint_names for this data
    load([file '.Body.joint_names.mat']);
    if nargin < 6
        ch = 1:length(whichJointNames(marker_set));
    else
        ch = find(ismember(joint_names,jointname));
        joint_names = joint_names(ch);
    end
    
else
    Joint = file;
    ch = jointname;
end

ntr = length(trials);    njoint = length(ch);
if length(bn)==2 bn = repmat(bn,ntr,1); end
joints = cell(ntr, njoint);
event_time_stamp = Events.(field);%
for iTr = 1:ntr
    at = event_time_stamp(iTr); % in ms
    start = at + bn(iTr,1); %  in ms
    for iJoint = 1:njoint
        joint_tmp = Joint{ch(iJoint)};
        if ~isempty(joint_tmp)
            timestamps = joint_tmp(1,:)-start;  % in ms
            ind = (timestamps > 0) & (timestamps < diff(bn(iTr,:)));
            joint_data = joint_tmp(2,ind);
            joints{iTr,iJoint} = [timestamps(ind); joint_data];
        end
    end
end
