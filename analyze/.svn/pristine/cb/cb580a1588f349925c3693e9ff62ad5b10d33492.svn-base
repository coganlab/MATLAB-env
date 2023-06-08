function joint = trialJoint(Trials, jointname, field, bn)
%  TRIALJOINT loads joint data for markers for a trial
%
%  JOINT = TRIALJOINT(TRIALS, JOINTNAME, FIELD, BN)
%
%  Inputs:	TRIALS = Trials data structure
%           JOINTNAME = Cell.  jointnames to load data for.
%                       Defaults to whichJointNames(marker_set)
%          	FIELD   = Scalar.  Event to align data to.
%                       Defaults to 'ReachStart'
%         	BN      = Vector or array.  Time to start and stop loading data.
%                       Can enter a different set of times for each trial. ie size(bn) = [Ntr,2];
%                       Defaults to [-500,500];

%
%  Outputs:	JOINT	= {Trial,Joint}. JOINT data for a specific set of joints for
%                                         a subset of trials.
%

global MONKEYDIR experiment JOINTLIST

if nargin < 3 || isempty(field)
    field = 'ReachStart'; 
end
if nargin < 4 || isempty(bn)
    bn = [-500,500]; 
end

olddir = pwd;

%oldrec = ''; oldday = '';
ntr = length(Trials);
njoint = length(jointname);
if length(bn)==2 bn = repmat(bn,ntr,1); end

joint = cell(ntr,njoint);

Recs = getRec(Trials);
DayRecs = unique(Recs);

if nargin < 2 || isempty(jointname)
    marker_set = Trials(1).MarkerSet{2};
    jointname = whichJointNames(marker_set); 
end

%  Assume all data from the same day
day = Trials(1).Day;
for iRec = 1:length(DayRecs)
    Tr_ind = find(ismember(Recs,DayRecs{iRec}));
    rec = DayRecs{iRec};
    subtrial = [Trials(Tr_ind).Trial];
    cd([MONKEYDIR '/' day '/' rec]);
    load(['rec' rec '.Body.Joint.mat']);
    load(['rec' rec '.Body.joint_names.mat']);
    ch = find(ismember(joint_names, jointname));
    
    load(['rec' rec '.MocapEvents.mat']);
    joint_tmp = loadJoint(Joint, MocapEvents, subtrial, field, bn(Tr_ind,:), ch);
    joint(Tr_ind,:) = joint_tmp;
end
cd(olddir);
