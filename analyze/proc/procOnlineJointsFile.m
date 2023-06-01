function procOnlineJointsFile(day, recs)
%  PROCONLINEJOINTSFILE processes online joint files from cortex/jarecord 
%  and puts them in the cell array/timestamp row format 
%
%  PROCONLINEJOINTSFILE(day, recs)
%

global MONKEYDIR

olddir = pwd;

if nargin < 2 recs = dayrecs(day); end
if ischar(recs) recs = {recs}; end

for iRec = 1:length(recs)
    clear Joint experiment sampling_rate joint_data joint_names
    clear joint_names_line;
    
    cd([MONKEYDIR '/' day '/' recs{iRec}]);
    j_fname = ['rec' recs{iRec} '.onlinejoints.txt'];
    n_fname = ['rec' recs{iRec} '.onlinejointnames.txt'];
    
    if (~exist(j_fname, 'file'))
        disp([j_fname ' does not exist.  skipping.']);
        continue;
    end
    
    if (~exist(n_fname, 'file'))
        disp([n_fname ' does not exist.  skipping.']);
        continue;
    end
    
    load(['rec' recs{iRec} '.experiment.mat']);
    sampling_rate = experiment.hardware.acquisition(1).samplingrate;
    samp_to_ms = sampling_rate*.001;
   
    try
        joint_data = dlmread(j_fname);
    catch err
        disp([j_fname ' parse error. skipping.']);
        continue;
    end
    
    try
        joint_names_line = importdata(n_fname);
        joint_names = regexp(joint_names_line{1}, ',', 'split');
    catch err
        disp([n_fname ' parse error. skipping.']);
        continue;
    end
    
    nJoint = size(joint_data,2)-2;
    nFrame = size(joint_data,1);
    Joint = cell(nJoint,1);
    
    for i=1:nJoint
        Joint{i} = zeros(2,nFrame);
        Joint{i}(1,:) = joint_data(:,2)./samp_to_ms;
        Joint{i}(2,:) = joint_data(:,i+2);
    end
    
    out_j_fname = ['rec' recs{iRec} '.Body.onlinejoints.Joint.mat'];
    out_n_fname = ['rec' recs{iRec} '.Body.onlinejoints.joint_names.mat'];
    
    save(out_j_fname, 'Joint');
    save(out_n_fname, 'joint_names');
    disp(['created ' out_j_fname]);
    disp(['created ' out_n_fname]);
end

cd(olddir)

    
    
    