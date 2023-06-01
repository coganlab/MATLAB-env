function PostPlotJointDecodingHandArm(day,jnt_file)

global MONKEYDIR
disp('In PostPlotJointDecodingHandArm')

if nargin < 2
    jnt_file_str  = [];
else
    jnt_file_str = [jnt_file '.'];
end


current_day = day;
fig_dir = ([MONKEYDIR '/fig/daily_metrics/' current_day '/JointDecoding/' jnt_file(1:end-1) '/']);
if(~isdir(fig_dir))
    mkdir(fig_dir)
end

sess = loadBehavior_Database;
days = sessDay(sess);

sess_days = find(strcmp(days,current_day));
for iDay = 1:length(sess_days)
    day_ind = sess_days(iDay);
    PCAParams.nDim = 7;
    if(isfile([MONKEYDIR '/mat/Decode/Joints/' jnt_file '/Session' num2str(day_ind) '_PCA_ProximalJoints_L_PMd_Dim' num2str(PCAParams.nDim) '.mat']))

    else
        JointList = whichJointNames('Full_Markerset');
        sess = loadBehavior_Database;
        session = sess{day_ind};
        day = session{1};
        recs = session{2};
        path = strcat(MONKEYDIR, '/', day, '/', recs{1}, '/rec', recs{1});
        load([path, '.Body.' jnt_file_str  'Joint.mat'])
        load([path, '.Body.' jnt_file_str  'joint_names.mat'])
        [dum,ind] = intersect(joint_names,JointList);
        joint_names = joint_names(ind);
        Results = sessTestKARMAPCAJoint(session,{'L_PMd'},JointList([1:7])',[],[],PCAParams,1,jnt_file);
        save([MONKEYDIR '/mat/Decode/Joints/' jnt_file '/Session' num2str(day_ind) '_PCA_ProximalJoints_L_PMd_Dim' num2str(PCAParams.nDim) '.mat'],'Results')
    end

    if(isfile([MONKEYDIR '/mat/Decode/Joints/' jnt_file '/Session' num2str(day_ind) '_PCA_ProximalJoints_L_PMv_Dim' num2str(PCAParams.nDim) '.mat']))
    else
        JointList = whichJointNames('Full_Markerset');
        sess = loadBehavior_Database;
        session = sess{day_ind};
        day = session{1};
        recs = session{2};
        path = strcat(MONKEYDIR, '/', day, '/', recs{1}, '/rec', recs{1});
        load([path, '.Body.' jnt_file_str  'Joint.mat'])
        load([path, '.Body.' jnt_file_str  'joint_names.mat'])
        [dum,ind] = intersect(joint_names,JointList);
        joint_names = joint_names(ind);
        Results = sessTestKARMAPCAJoint(session,{'L_PMv'},JointList([1:7])',[],[],PCAParams,1,jnt_file);
        save([MONKEYDIR '/mat/Decode/Joints/' jnt_file '/Session' num2str(day_ind) '_PCA_ProximalJoints_L_PMv_Dim' num2str(PCAParams.nDim) '.mat'],'Results')
    end
    
    if(isfile([MONKEYDIR '/mat/Decode/Joints/' jnt_file '/Session' num2str(day_ind) '_PCA_ProximalJoints_R_PMd_Dim' num2str(PCAParams.nDim) '.mat']))
    else
        JointList = whichJointNames('Full_Markerset');
        sess = loadBehavior_Database;
        session = sess{day_ind};
        day = session{1};
        recs = session{2};
        path = strcat(MONKEYDIR, '/', day, '/', recs{1}, '/rec', recs{1});
        load([path, '.Body.' jnt_file_str  'Joint.mat'])
        load([path, '.Body.' jnt_file_str  'joint_names.mat'])
        [dum,ind] = intersect(joint_names,JointList);
        joint_names = joint_names(ind);
        Results = sessTestKARMAPCAJoint(session,{'R_PMd'},JointList([1:7])',[],[],PCAParams,1,jnt_file);
        save([MONKEYDIR '/mat/Decode/Joints/' jnt_file '/Session' num2str(day_ind) '_PCA_ProximalJoints_R_PMd_Dim' num2str(PCAParams.nDim) '.mat'],'Results')
    end
    
    if(isfile([MONKEYDIR '/mat/Decode/Joints/' jnt_file '/Session' num2str(day_ind) '_PCA_ProximalJoints_R_PMv_Dim' num2str(PCAParams.nDim) '.mat']))
    else
        JointList = whichJointNames('Full_Markerset');
        sess = loadBehavior_Database;
        session = sess{day_ind};
        day = session{1};
        recs = session{2};
        path = strcat(MONKEYDIR, '/', day, '/', recs{1}, '/rec', recs{1});
        load([path, '.Body.' jnt_file_str  'Joint.mat'])
        load([path, '.Body.' jnt_file_str  'joint_names.mat'])
        [dum,ind] = intersect(joint_names,JointList);
        joint_names = joint_names(ind);
        Results = sessTestKARMAPCAJoint(session,{'R_PMv'},JointList([1:7])',[],[],PCAParams,1,jnt_file);
        save([MONKEYDIR '/mat/Decode/Joints/' jnt_file '/Session' num2str(day_ind) '_PCA_ProximalJoints_R_PMv_Dim' num2str(PCAParams.nDim) '.mat'],'Results')
    end
    
     PCAParams.nDim = 15;
    if(isfile([MONKEYDIR '/mat/Decode/Joints/' jnt_file '/Session' num2str(day_ind) '_PCA_ProximalJoints_L_PMd_Dim' num2str(PCAParams.nDim) '.mat']))
    else
        JointList = whichJointNames('Full_Markerset');
        sess = loadBehavior_Database;
        session = sess{day_ind};
        day = session{1};
        recs = session{2};
        path = strcat(MONKEYDIR, '/', day, '/', recs{1}, '/rec', recs{1});
        load([path, '.Body.' jnt_file_str  'Joint.mat'])
        load([path, '.Body.' jnt_file_str  'joint_names.mat'])
        [dum,ind] = intersect(joint_names,JointList);
        joint_names = joint_names(ind);
        Results = sessTestKARMAPCAJoint(session,{'L_PMd'},JointList([8:18,24:end])',[],[],PCAParams,1,jnt_file);
        save([MONKEYDIR '/mat/Decode/Joints/' jnt_file '/Session' num2str(day_ind) '_PCA_ProximalJoints_L_PMd_Dim' num2str(PCAParams.nDim) '.mat'],'Results')
    end

    if(isfile([MONKEYDIR '/mat/Decode/Joints/' jnt_file '/Session' num2str(day_ind) '_PCA_ProximalJoints_L_PMv_Dim' num2str(PCAParams.nDim) '.mat']))
    else
        JointList = whichJointNames('Full_Markerset');
        sess = loadBehavior_Database;
        session = sess{day_ind};
        day = session{1};
        recs = session{2};
        path = strcat(MONKEYDIR, '/', day, '/', recs{1}, '/rec', recs{1});
        load([path, '.Body.' jnt_file_str  'Joint.mat'])
        load([path, '.Body.' jnt_file_str  'joint_names.mat'])
        [dum,ind] = intersect(joint_names,JointList);
        joint_names = joint_names(ind);
        Results = sessTestKARMAPCAJoint(session,{'L_PMv'},JointList([8:18,24:end])',[],[],PCAParams,1,jnt_file);
        save([MONKEYDIR '/mat/Decode/Joints/' jnt_file '/Session' num2str(day_ind) '_PCA_ProximalJoints_L_PMv_Dim' num2str(PCAParams.nDim) '.mat'],'Results')
    end
    
    if(isfile([MONKEYDIR '/mat/Decode/Joints/' jnt_file '/Session' num2str(day_ind) '_PCA_ProximalJoints_R_PMd_Dim' num2str(PCAParams.nDim) '.mat']))
    else
        JointList = whichJointNames('Full_Markerset');
        sess = loadBehavior_Database;
        session = sess{day_ind};
        day = session{1};
        recs = session{2};
        path = strcat(MONKEYDIR, '/', day, '/', recs{1}, '/rec', recs{1});
        load([path, '.Body.' jnt_file_str  'Joint.mat'])
        load([path, '.Body.' jnt_file_str  'joint_names.mat'])
        [dum,ind] = intersect(joint_names,JointList);
        joint_names = joint_names(ind);
        Results = sessTestKARMAPCAJoint(session,{'R_PMd'},JointList([8:18,24:end])',[],[],PCAParams,1,jnt_file);
        save([MONKEYDIR '/mat/Decode/Joints/' jnt_file '/Session' num2str(day_ind) '_PCA_ProximalJoints_R_PMd_Dim' num2str(PCAParams.nDim) '.mat'],'Results')
    end
    
    if(isfile([MONKEYDIR '/mat/Decode/Joints/' jnt_file '/Session' num2str(day_ind) '_PCA_ProximalJoints_R_PMv_Dim' num2str(PCAParams.nDim) '.mat']))
    else
        JointList = whichJointNames('Full_Markerset');
        sess = loadBehavior_Database;
        session = sess{day_ind};
        day = session{1};
        recs = session{2};
        path = strcat(MONKEYDIR, '/', day, '/', recs{1}, '/rec', recs{1});
        load([path, '.Body.' jnt_file_str  'Joint.mat'])
        load([path, '.Body.' jnt_file_str  'joint_names.mat'])
        [dum,ind] = intersect(joint_names,JointList);
        joint_names = joint_names(ind);
        Results = sessTestKARMAPCAJoint(session,{'R_PMv'},JointList([8:18,24:end])',[],[],PCAParams,1,jnt_file);
        save([MONKEYDIR '/mat/Decode/Joints/' jnt_file '/Session' num2str(day_ind) '_PCA_ProximalJoints_R_PMv_Dim' num2str(PCAParams.nDim) '.mat'],'Results')
    end
    
end