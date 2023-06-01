function plot3DMetrics(day)
%
%  Generates a bunch of plots to allow a summary of Mocap experiments.
%
%  PLOT3DMETRICS(DAY)
%
%  Inputs:  DAY    = String '030603'

global MONKEYDIR
current_day = day;
fig_dir = ([MONKEYDIR '/fig/daily_metrics/' current_day '/']);
mkdir(fig_dir)
Session = loadMovement_Database;
days = [dir([MONKEYDIR '/12*'])];
days = [days.name];
nDays = (strfind(days,day)-1)/6;
days = [dir([MONKEYDIR '/12*'])];
days = days(1:nDays);
recs = dayrecs(current_day);
load([MONKEYDIR '/' current_day '/' recs{1} '/rec' recs{1} '.experiment.mat']);
nTowers = length(experiment.hardware.microdrive);
%%
disp('Plot spiking channel count')


for iTower = 1:nTowers
  tower = experiment.hardware.microdrive(iTower).name;
  eval(['Movement_' tower '_StartDepth']);
  TowerStartDepth{iTower} = StartDepth;
end

for iDay = 1:nDays
    day = days(iDay).name;
    recs = dayrecs(day);
    load([MONKEYDIR '/' day '/' recs{1} '/rec' recs{1} '.experiment.mat']);
    for iTower = 1:nTowers
        tower = experiment.hardware.microdrive(iTower).name;
        eval(['Movement_' tower '_' day])
        Spikes(iDay,iTower) = sum(endSP);
        Sess{1} = days(iDay).name;
        Sess{2} = {'001'};
        tmp = sessMocapDepth(Sess,tower);
        DayDepths = tmp(1:32) - TowerStartDepth{iTower}';
        mDepth(iDay,iTower) = median(DayDepths);
    end
end

smoothing = 0;
smooth_bin = 2;

figure
for iTower = 1:nTowers
    tower = experiment.hardware.microdrive(iTower).name;
    subplot(2,2,iTower)
    if(smoothing)
        plot(smooth(sq(mDepth(:,iTower))),Spikes(:,iTower),smooth_bin)
    else
        plot(sq(mDepth(:,iTower)),Spikes(:,iTower))
    end
    axis square
    ylabel('Spiking channels')
    xlabel('Depth')
    title([tower ' Spiking Channels']);
end

saveas(gcf,[fig_dir 'spiking_channels_' current_day '.jpg'],'jpg')
saveas(gcf,[fig_dir 'spiking_channels_' current_day '.fig'],'fig')

%%
disp('Plot raw LFP across channels')
rec_num = '002';
clim = [-150,150];
t = 1:1e3;
figure
for iTower = 1:nTowers
    tower = experiment.hardware.microdrive(iTower).name;
    cd([MONKEYDIR '/' current_day '/' rec_num '/']);
    fid = fopen(['rec' rec_num '.' tower '.lfp.dat']); 
    data = fread(fid,[32,2e3*100],'float');
    fclose(fid);
    subplot(4,2,iTower*2-1)
    plot(data(:,t)')
    axis([0,1000,-150,150])
    ylabel('Electrodes')
    xlabel('Time (1 second)')
    title([tower ' Raw LFP']);
    subplot(4,2,iTower*2)
    imagesc(data(:,t),clim);
    title([tower ' Raw LFP']);
end
saveas(gcf,[fig_dir 'raw_lfp1_' current_day '.jpg'],'jpg')
saveas(gcf,[fig_dir 'raw_lfp1_' current_day '.fig'],'fig')
clim = [-150,150];
t = 1e4:1.02e4;
figure
for iTower = 1:nTowers
    tower = experiment.hardware.microdrive(iTower).name;
    cd([MONKEYDIR '/' current_day '/004/']);
    fid = fopen(['rec004.' tower '.lfp.dat']); 
    data = fread(fid,[32,2e3*100],'float');
    fclose(fid);
    subplot(4,2,iTower*2-1)
    plot(data(:,t)')
    axis([0,200,-150,150])
    ylabel('Electrodes')
    xlabel('Time (200 ms)')
    title([tower ' Raw LFP']);
    subplot(4,2,iTower*2)
    imagesc(data(:,t),clim);
    title([tower ' Raw LFP']);
end
saveas(gcf,[fig_dir 'raw_lfp2_' current_day '.jpg'],'jpg')
saveas(gcf,[fig_dir 'raw_lfp2_' current_day '.fig'],'fig')
        
%%
disp('Plot marker dropout fractions')
labelled_data = 0;
for iRec = 1:length(recs)
   rec = recs{iRec};
   cd([MONKEYDIR '/' current_day '/' rec '/']);
   if(isfile(['rec' rec '.Body.Marker.mat']))
        clear marker_present
        labelled_data = labelled_data+1;
        load(['rec' rec '.Body.Marker.mat'])
        load(['rec' rec '.Body.marker_names.mat'])
        for iMarker = 1:length(Marker)
            data = Marker{iMarker};
            marker_present(iMarker) = sum(data(2,:) < 360 & data(2,:) > -360)/ length(data(2,:));
        end
        figure
        bar(marker_present)
        axis([0,length(Marker)+1,0,1])
        box off
        ylabel('Marker present fraction')
        title(['Marker droput rate rec ' rec]);  
        set(gca,'XTick',1:length(Marker))
        set(gca,'XTickLabel',marker_names)
        rotateticklabel(gca,45);
        saveas(gcf,[fig_dir 'marker_present_' current_day '_' rec '.jpg'],'jpg')
        saveas(gcf,[fig_dir 'marker_present_' current_day '_' rec '.fig'],'fig')
   end
end


if(labelled_data == 0)
    disp('No data labelled')
    pause
end


%%
disp('Plot joint file traces')
disp('Plot marker dropout fractions')
labelled_data = 0;
t = 1e3:4e3;
for iRec = 1:length(recs)
   rec = recs{iRec};
   cd([MONKEYDIR '/' current_day '/' rec '/']);
   if(isfile(['rec' rec '.Body.Joint.mat']))
        labelled_data = labelled_data+1;
        load(['rec' rec '.Body.Joint.mat'])
        load(['rec' rec '.Body.joint_names.mat'])
        for iJoint = 1:length(Joint)
            data = Joint{iJoint};
            figure
            plot(data(2,t))
            axis tight
            box off
            xlabel('sample')
            ylabel('angle')
            title(joint_names{iJoint})
            saveas(gcf,[fig_dir 'joint_angles_' joint_names{iJoint} '_' current_day '_' rec '.jpg'],'jpg')
            saveas(gcf,[fig_dir 'joint_angles_' joint_names{iJoint} '_' current_day '_' rec '.fig'],'fig')
        end
   end
end


if(labelled_data == 0)
    disp('No data jointed')
    pause
end


%%
disp('Plot 3D task metrics')
trials = dbSelectTrials(day);
disp(['number of trials correct: ' num2str(length(trials))])
disp(['total trials: ' num2str(trials(end).Trial)])
tmp = mean([Trials.StartAq]) - mean([trials.Start]);
disp(['average time to start acquire: ' num2str(tmp) ' ms'])
tmp = mean([Trials.TargAq]) - mean([trials.Go]);
disp(['average time to target acquire: ' num2str(tmp) ' ms'])

rec = trials(1).Rec;
cd([MONKEYDIR '/' day '/' rec '/'])
load(['rec' rec '.Body.Marker.mat'])
load(['rec' rec '.Body.marker_names.mat'])

wrist = Marker{7};

start_times = [Trials.StartAq];
end_times = [Trials.TargAq];
times = wrist(1,:);
for i = 1:length(start_times)
    start_index(i) = find(times == start_times(i));
end
for i = 1:length(end_times)
    end_index(i) = find(times == end_times(i));
end

clear start_x_data start_y_data start_z_data
clear end_x_data end_y_data end_z_data
bn = [-100:100];

for i = 1:length(start_index)
   start_x_data(i,1:length(bn)) = wrist(2,start_index(i)+bn(1):start_index(i)+bn(end));
   start_y_data(i,1:length(bn)) = wrist(3,start_index(i)+bn(1):start_index(i)+bn(end));
   start_z_data(i,1:length(bn)) = wrist(4,start_index(i)+bn(1):start_index(i)+bn(end)); 
end

for i = 1:length(end_index)
    end_x_data(i,1:length(bn)) = wrist(2,end_index(i)+bn(1):end_index(i)+bn(end));
    end_y_data(i,1:length(bn)) = wrist(3,end_index(i)+bn(1):end_index(i)+bn(end));
    end_z_data(i,1:length(bn)) = wrist(4,end_index(i)+bn(1):end_index(i)+bn(end)); 
end
figure
hold on
subplot(3,1,1)
plot(start_x_data')
axis tight
title('aligned to start acquire')
subplot(3,1,2)
plot(start_y_data')
axis tight
subplot(3,1,3)
plot(start_z_data')
axis tight
figure
hold on
subplot(3,1,1)
plot(end_x_data')
axis tight
title('aligned to target acquire')
subplot(3,1,2)
plot(end_y_data')
axis tight
subplot(3,1,3)
plot(end_z_data')
axis tight

figure
plot3(start_x_data,start_y_data,start_z_data,'x')

figure
plot3(end_x_data,end_y_data,end_z_data,'x')



%%
disp('Plot joint angle decoding performance')

Session = loadBehavior_Database
for i = 1:length(Session)
    if(strcmp(day,Session{i}(1)))
        disp(['processing session ' num2str(i) ])
        JointList = whichJointNames('Full_Markerset');
        sess = Session{i};
        figure
        day = sess{1};
        recs = sess{2};
        path = strcat(MONKEYDIR, '/', day, '/', recs{1}, '/rec', recs{1});
        load(strcat(path, '.Body.Joint.mat'))
        load(strcat(path, '.Body.joint_names.mat'))
        [dum,ind] = intersect(joint_names,JointList);
        joints = Joint(10:end);
        joint_names = joint_names(10:end);
        Test = sessTestKARMAJoint(sess,{'L_PMd','L_PMv','R_PMd','R_PMv'},JointList([1:17,20:end]));
        coeff1 = Test.Joint(1).CorrCoef;
        coeff2 = Test.Joint(2).CorrCoef;
        ave_coeff = mean([coeff1;coeff2])
        bar(ave_coeff);
        set(gca,'ylim',[0,1],'xlim',[0,28]);
    end
end

%%
disp('Plot marker position decoding performance')

