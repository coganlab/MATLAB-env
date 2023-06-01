function PostPlotSpikeCount(day)

global MONKEYDIR
current_day = day;
disp('Plot spiking channel count')
fig_dir = ([MONKEYDIR '/fig/daily_metrics/' current_day '/SpikingCount/']);
if(~isdir(fig_dir))
    mkdir(fig_dir)
end
if(~isfile([fig_dir 'spiking_channels_' current_day '.jpg']))
    Session = loadMovement_Database;
    days = [dir([MONKEYDIR '/12*'])];
    days = [days.name];
    nDays = (strfind(days,day)-1)/6;
    days = [dir([MONKEYDIR '/12*'])];
    days = days(1:nDays);
    recs = dayrecs(current_day);
    load([MONKEYDIR '/' current_day '/' recs{1} '/rec' recs{1} '.experiment.mat']);
    nTowers = length(experiment.hardware.microdrive);
    
    
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
        title([current_day ' ' tower ' Spiking Channels']);
    end
    
    saveas(gcf,[fig_dir 'spiking_channels_' current_day '.jpg'],'jpg')
    saveas(gcf,[fig_dir 'spiking_channels_' current_day '.fig'],'fig')
    
else
    disp('Spike count already processed')
end
