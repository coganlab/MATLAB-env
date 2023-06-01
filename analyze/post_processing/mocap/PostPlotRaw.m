function PostPlotRaw(day)

global MONKEYDIR
current_day = day;
fig_dir = ([MONKEYDIR '/fig/daily_metrics/' current_day '/RawPlot/']);
if(~isdir(fig_dir))
    mkdir(fig_dir)
end
disp('Plot raw LFP across channels')
recs = dayrecs(current_day);
load([MONKEYDIR '/' current_day '/' recs{1} '/rec' recs{1} '.experiment.mat']);
nTowers = length(experiment.hardware.microdrive);
norm = 1;
if(norm)
    clim = [0,1];
else
    clim = [-150,150];
end
t = 1:1e3;
for iRec = 1:length(recs)
    rec_num = recs{iRec};
   % try
        if(~isfile([fig_dir 'raw_lfp_' current_day '_' rec_num '_.jpg']))
            figure
            for iTower = 1:nTowers
                chans = length(experiment.hardware.microdrive(iTower).electrodes);
                tower = experiment.hardware.microdrive(iTower).name;
                cd([MONKEYDIR '/' current_day '/' rec_num '/']);
                fid = fopen(['rec' rec_num '.' tower '.lfp.dat']);
                data = fread(fid,[chans,2e3*100],'float');
                fclose(fid);
                subplot(nTowers,2,iTower*2-1)
                plot(data(:,t)')
                axis([0,1000,-150,150])
                ylabel('Electrodes')
                xlabel('Time (1 second)')
                title([tower ' Raw LFP']);
                subplot(nTowers,2,iTower*2)
                if(norm)
                    for i = 1:size(data,1)
                        data(i,:) =  (data(i,:)-min( data(i,:)))/(max( data(i,:))-min( data(i,:)));
                    end
                end
                imagesc(data(:,t),clim);
                colorbar
                if(iTower == 1)
                    title([current_day ' ' rec_num ' ' tower ' Raw LFP']);
                else
                    title([tower ' Raw LFP']);
                end
            end
            saveas(gcf,[fig_dir 'raw_lfp_' current_day '_' rec_num '_.jpg'],'jpg')
            saveas(gcf,[fig_dir 'raw_lfp_' current_day '_' rec_num '_.fig'],'fig')
            saveas(gcf,[fig_dir 'raw_lfp_' current_day '_' rec_num '_.eps'],'epsc')
        else
            disp(['Recording ' rec_num ' already processed'])
        end
end