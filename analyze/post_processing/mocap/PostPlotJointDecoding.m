function PostPlotJointDecoding(day,joint_file)

global MONKEYDIR

disp('In PostPlotJointDecoding')
if nargin < 2
    joint_file = [];
else
    joint_file_str = [joint_file '.'];
end

current_day = day;
fig_dir = ([MONKEYDIR '/fig/daily_metrics/' current_day '/JointDecoding/' joint_file '/']);
if(~isdir(fig_dir))
    mkdir(fig_dir)
end

sess = loadBehavior_Database;
days = sessDay(sess);

sess_days = find(strcmp(days,current_day));
for iDay = 1:length(sess_days)
    day_ind = sess_days(iDay);
    if(isfile([MONKEYDIR '/mat/Decode/Joints/' joint_file '/Session' num2str(day_ind) '_Joints_L_PMd_L_PMv_R_PMd_R_PMd.mat']))
        if(~isfile([fig_dir 'joint_decoding_' sessDay(sess{day_ind}) '_' num2str(day_ind) '.jpg']))
            load([MONKEYDIR '/mat/Decode/Joints' joint_file '/Session' num2str(day_ind) '_Joints_L_PMd_L_PMv_R_PMd_R_PMd.mat'])
            JointList = whichJointNames('Full_Markerset');
            coeff1 = Results.Joint(1).CorrCoef;
            coeff2 = Results.Joint(2).CorrCoef;
            ave_coeff = mean([coeff1;coeff2]);
            Joint = JointList([1:18,24:end]);
            figure
            bar(ave_coeff)
            set(gca,'ylim',[0,1],'xlim',[0,22]);
            axis([0,length(Joint)+1,0,1])
            box off
            ylabel('Correlation Coefficient')
            title([day ' Joint angle decoding, sess ' num2str(day_ind)]);
            set(gca,'XTick',1:length(Joint))
            for i = 1:length(Joint)
                tmp = Joint{i};
                ind = strfind(tmp,'_');
                tmp(ind) = ' ';
                tmp(ind(end):end) = '';
                Joint{i} = tmp;
            end
            set(gca,'XTickLabel',Joint)
            rotateticklabel(gca,45);
            saveas(gcf,[fig_dir 'joint_decoding_' sessDay(sess{day_ind})  '_' num2str(day_ind) '.jpg'],'jpg')
            saveas(gcf,[fig_dir 'joint_decoding_' sessDay(sess{day_ind})  '_' num2str(day_ind) '.ai'],'ai')
            saveas(gcf,[fig_dir 'joint_decoding_' sessDay(sess{day_ind})  '_' num2str(day_ind) '.fig'],'fig')
        else
        end
    else
        JointList = whichJointNames('Full_Markerset');
        session = sess{day_ind};
        day = session{1};
        recs = session{2};
        path = strcat(MONKEYDIR, '/', day, '/', recs{1}, '/rec', recs{1});
        load([path, '.Body.' joint_file_str  'Joint.mat'])
        load([path, '.Body.' joint_file_str  'joint_names.mat'])
        [dum,ind] = intersect(joint_names,JointList);
        joint_names = joint_names(ind);
        Results = sessTestKARMAJoint(session,{'L_PMd','L_PMv','R_PMd','R_PMv'},JointList([1:18,24:end])',[],[],joint_file);
        save([MONKEYDIR '/mat/Decode/Joints/' joint_file '/Session' num2str(day_ind) '_Joints_L_PMd_L_PMv_R_PMd_R_PMd.mat'],'Results')
    end
    if(isfile([MONKEYDIR '/mat/Decode/Joints/' joint_file '/Session' num2str(day_ind) '_PCA_Joints_L_PMd_L_PMv_R_PMd_R_PMd.mat']))
    else
        JointList = whichJointNames('Full_Markerset');
        sess = loadBehavior_Database;
        session = sess{day_ind};
        day = session{1};
        recs = session{2};
        path = strcat(MONKEYDIR, '/', day, '/', recs{1}, '/rec', recs{1});
        load([path, '.Body.' joint_file_str  'Joint.mat'])
        load([path, '.Body.' joint_file_str  'joint_names.mat'])
        [dum,ind] = intersect(joint_names,JointList);
        joint_names = joint_names(ind);
        PCAParams.nDim = 20;
        Results = sessTestKARMAPCAJoint(session,{'L_PMd','L_PMv','R_PMd','R_PMv'},JointList([1:16])',[],[],PCAParams, 0, joint_file);
        save([MONKEYDIR '/mat/Decode/Joints/' joint_file '/Session' num2str(day_ind) '_PCA_Joints_L_PMd_L_PMv_R_PMd_R_PMv_Dim' num2str(PCAParams.nDim) '.mat'],'Results')
    end
%     if(isfile([MONKEYDIR '/mat/Decode/Joints/Session' num2str(day_ind) '_PCA_ProximalJoints_L_PMd_L_PMv_R_PMd_R_PMd.mat']))
%     else
%         JointList = whichJointNames('Full_Markerset');
%         sess = loadBehavior_Database;
%         session = sess{day_ind};
%         day = session{1};
%         recs = session{2};
%         path = strcat(MONKEYDIR, '/', day, '/', recs{1}, '/rec', recs{1});
%         load(strcat(path, '.Body.Joint.mat'))
%         load(strcat(path, '.Body.joint_names.mat'))
%         [dum,ind] = intersect(joint_names,JointList);
%         joint_names = joint_names(ind);
%         PCAParams.nDim = 7;
%         Results = sessTestKARMAPCAJoint(session,{'L_PMd','L_PMv','R_PMd','R_PMv'},JointList([1:7])',[],[],PCAParams);
%         save([MONKEYDIR '/mat/Decode/Joints/Session' num2str(day_ind) '_PCA_ProximalJoints_L_PMd_L_PMv_R_PMd_R_PMv_Dim' num2str(PCAParams.nDim) '.mat'],'Results')
%     end
%     if(isfile([MONKEYDIR '/mat/Decode/Joints/Session' num2str(day_ind) '_PCA_DistalJoints_L_PMd_L_PMv_R_PMd_R_PMd.mat']))
%     else
%         JointList = whichJointNames('Full_Markerset');
%         sess = loadBehavior_Database;
%         session = sess{day_ind};
%         day = session{1};
%         recs = session{2};
%         path = strcat(MONKEYDIR, '/', day, '/', recs{1}, '/rec', recs{1});
%         load(strcat(path, '.Body.Joint.mat'))
%         load(strcat(path, '.Body.joint_names.mat'))
%         [dum,ind] = intersect(joint_names,JointList);
%         joint_names = joint_names(ind);
%         PCAParams.nDim = 15;
%         Results = sessTestKARMAPCAJoint(session,{'L_PMd','L_PMv','R_PMd','R_PMv'},JointList([8:18,24:end])',[],[],PCAParams);
%         save([MONKEYDIR '/mat/Decode/Joints/Session' num2str(day_ind) '_PCA_DistalJoints_L_PMd_L_PMv_R_PMd_R_PMv_Dim' num2str(PCAParams.nDim) '.mat'],'Results')
%     end
    
end