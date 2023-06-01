function procHand3D(day, rec)
%  PROCHAND3D processes marker.txt and timecode.dat to generate
%	hand3d_sync.txt and hand3d.dat files
%
%  PROCHAND3D(DAY, REC)
%


global MONKEYDIR
STROBE_VOLTAGE_THRESHOLD = 1;  %  In volts!


%STROBE_THRESHOLD = 3.2e3;

olddir = pwd;
tmp = dir([MONKEYDIR '/' day '/0*']);
[recs{1:length(tmp)}] = deal(tmp.name);
nRecs = length(recs);
%recs

if nargin < 2 || isempty(rec)
    num = [1,nRecs];
elseif ischar(rec)
    num = [find(strcmp(recs,rec)),find(strcmp(recs,rec))];
elseif length(rec)==1
    num = [rec,rec];
else
    num = rec;
end
for iRec = num(1):num(2)
    cd([MONKEYDIR '/' day '/' recs{iRec}]);
    load(['rec' recs{iRec} '.experiment.mat']);
    
    MarkerFilename = ['rec' recs{iRec} '.marker'];
    TimecodeFilename = ['rec' recs{iRec} '.timecode.dat'];
    StrobeFilename = ['rec' recs{iRec} '.strobe.dat'];
    MarkerDataFilename = ['rec' recs{iRec} '.MarkerData.mat'];
    Hand3DFilename = ['rec' recs{iRec} '.Hand3D.mat'];
    
    acquisition = experiment.hardware.acquisition;
    acquisitiontype = cell(1,length(acquisition));
    [acquisitiontype{:}] = deal(acquisition.type);
    
    NIHardware = find(ismember(acquisitiontype,'Broker'));
    if(length(NIHardware) == 0)
        % It maybe better to do a search to see if it is a Recording or
        % Behaviour session and select hardware type based on that.
        NIHardware = find(ismember(acquisitiontype,'nstream128_32'));
    end
    PhaseSpaceHardware = find(ismember(acquisitiontype,'PhaseSpace'));
    NISampleRate = acquisition(NIHardware).samplingrate;
    %     PhaseSpaceSampleRate = acquisition(PhaseSpaceHardware).samplingrate;
    acquisition = experiment.hardware.acquisition;
    
    switch acquisition(NIHardware).data_format
        case 'short'
            strobe_threshold = 2048 + STROBE_VOLTAGE_THRESHOLD*4096./10;
        case 'ushort'
            strobe_threshold = 32768 + STROBE_VOLTAGE_THRESHOLD*65536./10;
    end
    NUMMARKERS = acquisition(ismember(acquisitiontype,'PhaseSpace')).num_channels;
    
    fid = fopen(TimecodeFilename);
    timecode = fread(fid,inf,acquisition(NIHardware).data_format);
    fclose(fid);
    
    fid = fopen(StrobeFilename);
    strobe = fread(fid,inf,acquisition(NIHardware).data_format);
    fclose(fid);
    
    NISampleRate_to_sample_per_ms = NISampleRate./1e3;
    strobe_indices = find(strobe > strobe_threshold);
    dstrobe = find(diff(strobe_indices) > 2)+1;
    strobe_timesamples = strobe_indices(dstrobe)./NISampleRate_to_sample_per_ms;  % in ms
    [digital_timecodes, digital_timesamples] = ...
        parsePhasespaceTimeCode(timecode, strobe_threshold);
    
    
    if isfile(MarkerDataFilename)
        disp(['Loading from ' MarkerDataFilename]);
        load(MarkerDataFilename);
        marker_data = MarkerData.marker_data;
        marker_timecodes = MarkerData.marker_timecodes;
    else
        disp(['Generating ' MarkerDataFilename]);
        [marker_data, marker_timecodes] = parseMarkerFile(MarkerFilename);
    end
    
    [sync_timecodes, digital_ind] = intersect(digital_timecodes,marker_timecodes);
    sync_timesamples = digital_timesamples(digital_ind);
    
    %Sync data contains a mapping between the marker timecode in the first
    %column and the time index from the broker in the second column for all
    %the timecodes between the first and last digital time codes.  I
    %checked for 001 and these are good within a ms.
    %  rat = (sync_data(:,2)-digital_timesamples(1))./(sync_data(:,1) - sync_data(1,1));
    %  gives how close the two valuegs are in time.
    %
    %  Timestamped_Marker_Data contains the actual timestamped data - I
    %  didn't interpolate - 3D data in dimensions 1-3 and timestamp in
    %  dimension 4.  We're treating it like spike data (ie irregularly
    %  sampled).
    Hand3D = cell(1,NUMMARKERS);
    if(length(sync_timecodes ~= 0))
        pre_marker_indices = find(marker_timecodes < sync_timecodes(1));
        pre_strobe_indices = find(strobe_timesamples < sync_timesamples(1));
        
%         if ~isempty(pre_marker_indices) && ~isempty(pre_strobe_indices)
% 
%               % shorten arrays in case marker file starts before strobe data
%              if(length(pre_strobe_indices) ~= length(pre_marker_indices))
%                  tmp_size = min(length(pre_strobe_indices), length(pre_marker_indices))
%                  pre_marker_indices = pre_marker_indices(end-tmp_size+1:end);
%                  pre_strobe_indices = pre_strobe_indices(end-tmp_size+1:end);
%              end
%             pre_marker_timecodes = marker_timecodes(pre_marker_indices);
%             pre_marker_timecode_strobes = pre_marker_timecodes - sync_timecodes(1);
%             pre_marker_timecode_strobes = abs(pre_marker_timecode_strobes(end:-1:1));
%             pre_strobe_timesamples = strobe_timesamples(pre_strobe_indices);
%             pre_strobe_timesamples = pre_strobe_timesamples(end:-1:1);
%             
% 
%             sync_data(pre_marker_indices,1) = pre_marker_timecodes;
%             sync_data(pre_marker_indices(end:-1:1),2) = ...
%                 pre_strobe_timesamples(pre_marker_timecode_strobes);
%         end
        
        post_marker_indices = find(marker_timecodes >= sync_timecodes(end));
        post_strobe_indices = find(strobe_timesamples >= sync_timesamples(end));
        if ~isempty(post_marker_indices) && ~isempty(post_strobe_indices)
            post_marker_timecodes = marker_timecodes(post_marker_indices);
            post_marker_timecode_strobes = post_marker_timecodes - sync_timecodes(end)+1;
            post_strobe_timesamples = strobe_timesamples(post_strobe_indices);
            
            %  Only keep markers that we have strobes for
            ind = post_marker_timecode_strobes <= length(post_strobe_timesamples);
            ind_too_over = (post_marker_timecode_strobes > length(post_strobe_timesamples));
            if ~isempty(ind_too_over)
                disp([num2str(sum(ind_too_over)) ' marker timecodes are after strobes'])
            end
            post_marker_timecode_strobes = post_marker_timecode_strobes(ind);
            post_marker_indices = post_marker_indices(ind);
            post_marker_timecodes = post_marker_timecodes(ind);
            
            sync_data(post_marker_indices,1) = post_marker_timecodes;
            sync_data(post_marker_indices,2) = ...
                post_strobe_timesamples(post_marker_timecode_strobes);
        end
        
        for iSync = 1:length(sync_timecodes)-1
            [intermediate_marker_indices] = find((marker_timecodes >= sync_timecodes(iSync)) ...
                & (marker_timecodes < sync_timecodes(iSync+1)));
            intermediate_marker_timecodes = marker_timecodes(intermediate_marker_indices);
            intermediate_marker_timecode_strobes = intermediate_marker_timecodes - sync_timecodes(iSync) + 1;
            
            [intermediate_strobe_indices] = ((strobe_timesamples >= sync_timesamples(iSync)) ...
                & (strobe_timesamples < sync_timesamples(iSync+1)));
            intermediate_strobe_timesamples = strobe_timesamples(intermediate_strobe_indices);
            
            if max(intermediate_marker_timecode_strobes) <= length(intermediate_strobe_timesamples)
                sync_data(intermediate_marker_indices,1) = intermediate_marker_timecodes;
                sync_data(intermediate_marker_indices,2) = ...
                    intermediate_strobe_timesamples(intermediate_marker_timecode_strobes);
            else
                num_missing_samples = max(intermediate_marker_timecode_strobes)-length(intermediate_strobe_timesamples);
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %                 intermediate_strobe_timesamples(end)
                %                 sync_timecodes(iSync)
                %                 sync_timecodes(iSync+1)
                
                strobe_spacing = diff(intermediate_strobe_timesamples);
                STROBERATE = 480;
                % the 0.1 ius a hack as the strobes are not quick exactly
                % 480Hz
                STROBE_SEPARATION = (1/STROBERATE)*1000-0.05;
                missing_timecode_index = round(strobe_spacing./STROBE_SEPARATION)-1;
                %                 diff(intermediate_strobe_timesamples(1:10))
                %                 missing_timecode_index(1:10)
                %                 length(intermediate_strobe_timesamples)
                tmp_intermediate_marker_timecode_strobes = zeros(1,max(intermediate_marker_timecode_strobes));
                if(length(intermediate_strobe_timesamples) ~= 0)
                    tmp_intermediate_marker_timecode_strobes(1) = intermediate_strobe_timesamples(1);
                    strobe_index = 2;
                    for iMissingData = 1:length(missing_timecode_index)
                        %   iMissingData
                        if(missing_timecode_index(iMissingData) ~= 0)
                            %                          intermediate_strobe_timesamples(iMissingData+1)-intermediate_strobe_timesamples(iMissingData)
                            missing_timecode = [intermediate_strobe_timesamples(iMissingData):STROBE_SEPARATION:...
                                intermediate_strobe_timesamples(iMissingData+1)];
                            %                         missing_timecode_index(iMissingData)
                            %                         x = length(missing_timecode)
                            %                         y = missing_timecode(2:end)
                            %                         z =diff(missing_timecode)
                            %                          strobe_index:(strobe_index+missing_timecode_index(iMissingData))
                            tmp_intermediate_marker_timecode_strobes(strobe_index:(strobe_index+missing_timecode_index(iMissingData))) = missing_timecode(2:end);
                            %                         missing_timecode_index(iMissingData)
                            strobe_index = strobe_index+missing_timecode_index(iMissingData)+1;
                        else
                            tmp_intermediate_marker_timecode_strobes(strobe_index) = intermediate_strobe_timesamples(iMissingData+1);
                            strobe_index = strobe_index+1;
                        end
                    end
                    for iStrobe = strobe_index:max(intermediate_marker_timecode_strobes)
                        tmp_intermediate_marker_timecode_strobes(iStrobe) = tmp_intermediate_marker_timecode_strobes(iStrobe-1)+STROBE_SEPARATION;
                    end
%                     iStrobe
%                     diff(tmp_intermediate_marker_timecode_strobes(1:10))
%                     pause
                    intermediate_strobe_timesamples = tmp_intermediate_marker_timecode_strobes;
                else
                    
                end
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    %Old code
%                  pad = repmat(intermediate_strobe_timesamples(end), 1, num_missing_samples);
%                  intermediate_strobe_timesamples = [intermediate_strobe_timesamples;pad'];
                 
                sync_data(intermediate_marker_indices,1) = intermediate_marker_timecodes;
                sync_data(intermediate_marker_indices,2) = ...
                    intermediate_strobe_timesamples(intermediate_marker_timecode_strobes);
                disp([num2str(iSync) ': Need to supplement ' num2str(num_missing_samples) ' timecode strobe(s)']);
            end
        end
        for iMarker = 1:NUMMARKERS
            Marker_data_Indices = find(marker_data(1,iMarker,:));
            if ~isempty(Marker_data_Indices)
                Marker_data_timecodes = marker_timecodes(Marker_data_Indices);
                [dum,ia,ib] = intersect(sync_data(:,1),Marker_data_timecodes);
                if length(ia) ~= length(Marker_data_timecodes)
                    nummissing = length(Marker_data_timecodes) - length(ia);
                    disp(['Error:  Marker ' num2str(iMarker) ' has ' num2str(nummissing) ' missing timestamps']);
                end
                timestamps = sync_data(ia,2);
                Hand3D{iMarker}(1,:) = timestamps';
                a = sq(marker_data(1:3,iMarker,Marker_data_Indices(ib)));
                Hand3D{iMarker}(2:4,:) = a;
            end
        end
        
        
        %     for iMarker_index = minimum_marker_timecode_index:maximum_marker_timecode_index
        %         [ds, index] = min(abs(marker_timecodes(iMarker_index) - sync_timecodes));
        %
        %         distance = marker_timecodes(iMarker_index) - sync_timecodes(index);
        %         %pause
        %         if distance > 0
        %             check_ind = find(strobe_timesamples > digital_timesamples(index));
        %             [dum, strobe_index] = min(abs(strobe_timesamples(check_ind) - digital_timesamples(index)));
        %             strobe_index = check_ind(strobe_index);
        %         elseif distance < 0
        %             check_ind = find(strobe_timesamples < digital_timesamples(index));
        %             [dum, strobe_index] = min(abs(strobe_timesamples(check_ind) - digital_timesamples(index)));
        %             strobe_index = check_ind(strobe_index);
        %         elseif distance == 0
        %             [dum, strobe_index] = min(abs(strobe_timesamples - digital_timesamples(index)));
        %         end
        %
        %         %  Assign time code and sample
        %         sync_data(iMarker_index - minimum_marker_timecode_index + 1,1) = marker_timecodes(iMarker_index);
        %         %strobe_timesamples(strobe_index+distance);
        %         sync_data(iMarker_index - minimum_marker_timecode_index + 1,2) = strobe_timesamples(strobe_index+distance);
        %         for iMarkerNumber = 1:NUMMARKERS
        %             if marker_data(1,iMarkerNumber,iMarker_index)
        %                 Nmarker(iMarkerNumber) = Nmarker(iMarkerNumber)+1;
        %                 Hand3D{iMarkerNumber}(Nmarker(iMarkerNumber),1) = strobe_timesamples(strobe_index + distance);
        %                 Hand3D{iMarkerNumber}(Nmarker(iMarkerNumber),2:4) = marker_data(1:3,iMarkerNumber,iMarker_index);
        %             end
        %         end
        %     end
        %plot(Hand3D{9}(:,1),Hand3D{9}(:,2),'.') to look at data for x
        %dimension
    else
        disp('No marker data')
        %pause(1)
        %Hand3D = cell(1,NUMMARKERS);
    end
    
    save(Hand3DFilename, 'Hand3D');
end
cd(olddir);
