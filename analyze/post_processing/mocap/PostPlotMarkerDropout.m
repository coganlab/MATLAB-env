function PostPlotMarkerDropout(day)

global MONKEYDIR
disp('Plot marker dropout fractions')
current_day = day;
recs = dayrecs(current_day);
fig_dir = ([MONKEYDIR '/fig/daily_metrics/' current_day '/MarkerDropout/']);
if(~isdir(fig_dir))
    mkdir(fig_dir)
end
labelled_data = 0;
for iRec = 1:length(recs)
    rec = recs{iRec};
    cd([MONKEYDIR '/' current_day '/' rec '/']);
    if(isfile(['rec' rec '.Body.Marker.mat']))
        if(~isfile([fig_dir 'marker_dropout_' current_day '_' rec '.jpg']))
            clear marker_present
            labelled_data = labelled_data+1;
            load(['rec' rec '.Body.Marker.mat'])
            load(['rec' rec '.Body.marker_names.mat'])
            for iMarker = 1:length(Marker)
                data = Marker{iMarker};
                marker_present(iMarker) = sum(data(2,:) < 2000 & data(2,:) > -2000)/ length(data(2,:));
            end
            figure
            bar(1-marker_present([1:3,5:end]))
            %axis([0,length(Marker)+1,0,1])
            axis tight
            box off
            ylabel('Marker dropout fraction')
            title([current_day ' Marker droput rate rec ' rec]);
            set(gca,'XTick',1:length(Marker([1:3,5:end])))
            set(gca,'XTickLabel',marker_names([1:3,5:end]))
            rotateticklabel(gca,45);
            saveas(gcf,[fig_dir 'marker_dropout_' current_day '_' rec '.jpg'],'jpg')
            saveas(gcf,[fig_dir 'marker_dropout_' current_day '_' rec '.fig'],'fig')
        else
            disp(['Recording ' rec ' already processed'])
            labelled_data = 1;
        end
    end
end
if(labelled_data == 0)
    disp('No data labelled')
    pause(1)
end