function procMocapFile(day, rec)
%  PROCMOCAPFILE processes mocap data files
%
%  PROCMOCAPFFILE(DAY, REC)
%
%   Takes as input the MARKENAME.txt file and saves as output a set of
%       recxxx.mocap.dat files.
%

global MONKEYDIR

STROBE_THRESHOLD = 1e4;

olddir = pwd;
tmp = dir([MONKEYDIR '/' day '/0*']);
[recs{1:length(tmp)}] = deal(tmp.name);
nRecs = length(recs);

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
    sampling_rate = experiment.hardware.acquisition(1).samplingrate;
    format = experiment.hardware.acquisition(1).data_format;
    
    
    % Parse the strobe and clock data
    fid = fopen(['rec' recs{iRec} '.mocap.dat']);
    data = fread(fid,[2,inf],format);
    figure
    plot(data(:,:)')
    data = data - 32000;
    data(data < STROBE_THRESHOLD) = 0;
    data(data > STROBE_THRESHOLD) = 1;
    start_strobe = data(2,:);
    clock = data(1,:);
    start_down_transitions = find((start_strobe(1:end-1) - start_strobe(2:end)) == 1);
    start_up_transitions = find((start_strobe(1:end-1) - start_strobe(2:end)) == -1);
    clock_down = find((clock(1:end-1) -clock(2:end)) == 1);
    clock_up = find((clock(1:end-1) - clock(2:end)) == -1);
    if(length(start_down_transitions) == 0)
        start_down_transitions = max(clock_up);
    end
    

    clock_up = clock_up(clock_up > start_up_transitions(1));
    clock_up = clock_up(clock_up < start_down_transitions(1));
    clock_up = (clock_up./sampling_rate).*1000;

%%%%%%%%%%%%%%%%%%%%%%%
% We no longer parse the unnamed marker data as it is of no use - YW
%     %Parse the unnamed mocap data
%     [header, unnamed_marker_data] = parseMoCapFile(['rec' recs{iRec} '.unnamed.mocap.txt'],0);
%     %size(unnamed_marker_data,2)
%     % length(clock_up)
%     %missing_timestamps = length(clock_up)-size(unnamed_marker_data,2)
%     clock_up = clock_up(1:size(unnamed_marker_data,2));
%     %Hand3D = [clock_up; unnamed_marker_data(3:end,:)];
%     for i = 1:((size(unnamed_marker_data,1) - 2)/3)
%         Marker{i}(1,:) = clock_up;
%         Marker{i}(2:4,:) = unnamed_marker_data((i-1)*3+3:i*3+2,:);
%         marker_names = {};
%     end
%     save(['rec' recs{iRec} '.unnamed.Marker.mat'], 'Marker');
%     save(['rec' recs{iRec} '.unnamed.marker_names.mat'],'marker_names');
%%%%%%%%%%%%%%%%%%%%%%%
    markersets = experiment.software.markerfiles;
    if(length(clock_up) == 0)
        % no clock signalis there a strobe if so align to strobe
        rec_length = start_down_transitions(1) - start_up_transitions(1);
        rec_samples = (rec_length./sampling_rate)*200;
        clock_up = start_up_transitions(1) + [0:rec_samples-1]*(sampling_rate/200);
        clock_up = (clock_up./sampling_rate).*1000;
        disp('No clock signal')
        pause(5)
    end
    for j = 1:size(markersets,2)
        clear Marker
        marker_set = markersets{j};
        MocapFilename = ['rec' recs{iRec} '.' marker_set '.mocap.trc'];
        %Parse named mocap data
        if exist(MocapFilename,'file');
            [header, marker_data] = parseMoCapFile(MocapFilename,1);

           %if(j == 1)
           missing_timestamps = length(clock_up)-size(marker_data,2);
           if(missing_timestamps > 100)
               disp(['Number of missing timestamps: ' num2str(missing_timestamps)])
               disp('Please press any key to continue');
               pause(5)
           elseif(missing_timestamps < 0 )
               disp(['Number of missing timestamps: ' num2str(missing_timestamps)])
               disp('Please press any key to continue');
               pause(5)
               marker_data = marker_data(:,1:length(clock_up));
           end
               %    %clock_up = clock_up(1:size(marker_data,2));
           %end
            for i = 1:((size(marker_data,1) - 2)/3)
                Marker{i}(1,:) = clock_up(1:size(marker_data,2)); % align timestamps to the first clock up.
                Marker{i}(2:4,:) = marker_data((i-1)*3+3:i*3+2,:);
            end
            marker_names = header{4}(3:end);
            for iMarker = 1:length(marker_names)
                marker_names(iMarker) = marker_names{iMarker};
            end
            save(['rec' recs{iRec} '.' marker_set '.Marker.mat'], 'Marker');
            save(['rec' recs{iRec} '.' marker_set '.marker_names.mat'], 'marker_names');
        end
    end
    
    
    
    %     %Save complete data set
    %     all_marker_data = unnamed_marker_data;
    %     for i = 1:((size(named_marker_data,1) - 2)/3)
    %         all_marker_data(i,(named_marker_data(i,:) ~= -Inf)) = named_marker_data(i,(named_marker_data(i,:) ~= -Inf));
    %     end
    %     %all_marker_data(named_marker_data ~= -Inf) = named_marker_data;
    %     clear Hand3D
    %     for i = 1:(size(all_marker_data,1) - 2)/3
    %         Hand3D{i}(1,:) = clock_up;
    %         Hand3D{i}(2:4,:) = all_marker_data((i-1)*3+3:i*3+2,:);
    %     end
    %     save(['rec' recs{iRec} '.Hand3D.all.mat'], 'Hand3D');
    %     %Hand3D = [clock_up; all_marker_data(3:end,:)];
    
end
cd(olddir);
