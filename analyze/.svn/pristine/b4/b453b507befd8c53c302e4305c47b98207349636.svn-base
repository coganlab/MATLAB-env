function PostPlotMarkerDecoding(day)

global MONKEYDIR
current_day = day;
fig_dir = ([MONKEYDIR '/fig/daily_metrics/' current_day '/MarkerDecoding/']);
if(~isdir(fig_dir))
    mkdir(fig_dir)
end


sess = loadBehavior_Database;
days = sessDay(sess);

sess_days = find(strcmp(days,day));
for iDay = 1:length(sess_days)
    day_ind = sess_days(iDay);
    if(isfile([MONKEYDIR '/mat/DecodeMarkers/Session' num2str(day_ind) '_Markers_L_PMd_L_PMv_R_PMd_R_PMv.mat']))
        if(~isfile([fig_dir 'marker_decoding_' sessDay(sess{day_ind}) '.jpg']))
            load([MONKEYDIR '/mat/Decode/Markers/Session' num2str(day_ind) '_Markers_L_PMd_L_PMv_R_PMd_R_PMv.mat'])
            MarkerList = whichMarkerNames('Full_Markerset');
            coeff1 = Results.Marker(1).CorrCoef;
            coeff2 = Results.Marker(2).CorrCoef;
            ave_coeff = mean([coeff1;coeff2]);
            Marker = MarkerList([1:18,24:end]);
            figure
            bar(ave_coeff)
            set(gca,'ylim',[0,1],'xlim',[0,22]);
            axis([0,length(Marker)+1,0,1])
            box off
            ylabel('Correlation Coefficient')
            title([day ' Marker angle decoding, sess ' num2str(day_ind)]);
            set(gca,'XTick',1:length(Marker))
            for i = 1:length(Marker)
                tmp = Marker{i};
                ind = strfind(tmp,'_');
                tmp(ind) = ' ';
                tmp(ind(end):end) = '';
                Marker{i} = tmp;
            end
            set(gca,'XTickLabel',Marker)
            rotateticklabel(gca,45);
            saveas(gcf,[fig_dir 'marker_decoding_' sessDay(sess{day_ind}) '.jpg'],'jpg')
            saveas(gcf,[fig_dir 'marker_decoding_' sessDay(sess{day_ind}) '.ai'],'ai')
            saveas(gcf,[fig_dir 'marker_decoding_' sessDay(sess{day_ind}) '.fig'],'fig')
        else
        end
    else
        MarkerList = whichMarkerNames('Full_Markerset');
        session = sess{day_ind};
        day = session{1};
        recs = session{2};
        path = strcat(MONKEYDIR, '/', day, '/', recs{1}, '/rec', recs{1});
        load(strcat(path, '.Body.Marker.mat'))
        load(strcat(path, '.Body.marker_names.mat'))
        [dum,ind] = intersect(marker_names,MarkerList);
        marker_names = marker_names(ind);
        MarkerList
        Results = sessTestKARMAMarker(session,{'L_PMd','L_PMv','R_PMd','R_PMv'},MarkerList([12]));
        save([MONKEYDIR '/mat/Decode/Markers/Session' num2str(day_ind) '_Markers_L_PMd_L_PMv_R_PMd_R_PMv.mat'],'Results')
    end
end