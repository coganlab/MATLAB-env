function PostPlotJointAngles(day, joint_file)

global MONKEYDIR
if nargin < 2
    joint_file = [];
else
    joint_file = [joint_file '.'];
end
current_day = day
fig_dir = ([MONKEYDIR '/fig/daily_metrics/' current_day '/JointAngles/' joint_file(1:end-1) '/']);
if(~isdir(fig_dir))
    mkdir(fig_dir)
end
disp('Plot joint angle traces')
recs = dayrecs(current_day);
clim = [-150,150];
t = 1:1e3;
labelled_data = 0;
t = 1e3:4e3;
for iRec = 1:length(recs)
    rec = recs{iRec};
    cd([MONKEYDIR '/' current_day '/' rec '/']);
  
    if(isfile(['rec' rec '.Body.' joint_file 'Joint.mat']))
        labelled_data = labelled_data+1;
        load(['rec' rec '.Body.' joint_file 'Joint.mat'])
        load(['rec' rec '.Body.' joint_file 'joint_names.mat'])
        for iJoint = 1:length(Joint)
            if(~isfile([fig_dir 'joint_angles_' joint_names{iJoint} '_' current_day '_' rec '_' joint_file  '.jpg']))
                data = Joint{iJoint};
                figure
                plot(data(2,t))
                axis tight
                box off
                xlabel('sample')
                ylabel('angle')
                title([current_day ' ' rec ' ' joint_names{iJoint} ' jntfile:' joint_file])
                saveas(gcf,[fig_dir 'joint_angles_' joint_names{iJoint} '_' current_day '_' rec '_' joint_file  '.jpg'],'jpg')
                %saveas(gcf,[fig_dir 'joint_angles_' joint_names{iJoint} '_' current_day '_' rec '_' jointFile  '.fig'],'fig')
            else
                disp(['Recording ' rec ' ' joint_names{iJoint} ' already processed'])
            end
        end
    end
    
end


if(labelled_data == 0)
    disp('No data jointed')
    pause(10)
end