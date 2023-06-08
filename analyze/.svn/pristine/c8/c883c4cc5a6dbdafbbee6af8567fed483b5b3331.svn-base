function PostPlotJointNullDecoding(day)

global MONKEYDIR

disp('In PostPlotJointDecoding')

current_day = day;
fig_dir = ([MONKEYDIR '/fig/daily_metrics/' current_day '/JointDecoding/']);
if(~isdir(fig_dir))
    mkdir(fig_dir)
end

sess = loadBehavior_Database;
days = sessDay(sess);

sess_days = find(strcmp(days,current_day));
for iDay = 1:length(sess_days)
    day_ind = sess_days(iDay);
    if(isfile([MONKEYDIR '/mat/Decode/Joints/Session' num2str(day_ind) '_Joints_L_PMd_L_PMv_R_PMd_R_PMv_Null.mat']))
        if(~isfile([fig_dir 'joint_decoding_' sessDay(sess{day_ind}) '_' num2str(day_ind) '.jpg']))
            load([MONKEYDIR '/mat/Decode/Joints/Session' num2str(day_ind) '_Joints_L_PMd_L_PMv_R_PMd_R_PMv_Null.mat'])
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
        load(strcat(path, '.Body.Joint.mat'))
        load(strcat(path, '.Body.joint_names.mat'))
        [dum,ind] = intersect(joint_names,JointList);
        joint_names = joint_names(ind);
        Results = sessTestKARMAJointNull(session,{'L_PMd','L_PMv','R_PMd','R_PMv'},JointList([1:18,24:end])');
        save([MONKEYDIR '/mat/Decode/Joints/Session' num2str(day_ind) '_Joints_L_PMd_L_PMv_R_PMd_R_PMv_Null.mat'],'Results')
    end
   
    
end