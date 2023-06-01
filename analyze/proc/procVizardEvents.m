function ev = procVizardEvents(day, rec)
%  If a vizard events file exists, it overwrites the trials
% data structure to include vizard events.
%
%  PROCVIZARDEVENTS(DAY, REC)
%
%  Inputs:  DAY    = String '030603'
%           REC    = String '001', or num [1,2]




global MONKEYDIR
STROBE_THRESHOLD = 1e4;

olddir = pwd;

recs = dayrecs(day);
nRecs = length(recs);

if nargin < 2
    num = [1,nRecs];
elseif ischar(rec)
    num = [find(strcmp(recs,rec)),find(strcmp(recs,rec))];
elseif length(rec)==1
    num = [rec,rec];
elseif length(rec)==2
    num = rec;
end
for iNum = num(1):num(2)
    rec = recs{iNum};
    file_name = [MONKEYDIR '/' day '/' rec '/rec' rec '.viz.ev.txt']
    if(isfile(file_name))
        ev = dlmread(file_name,'\t');
        cd([MONKEYDIR '/' day '/' recs{iNum}]);
        load(['rec' recs{iNum} '.experiment.mat']);
        sampling_rate = experiment.hardware.acquisition(1).samplingrate;
        format = experiment.hardware.acquisition(1).data_format;
        
        
        % Parse the strobe and clock data
        if exist(['rec' recs{iNum} '.mocap.dat'])
            fid = fopen(['rec' recs{iNum} '.mocap.dat']);
            data = fread(fid,[2,inf],format);
            figure
            plot(data(:,:)')
            data = data - 32000;
            data(data < STROBE_THRESHOLD) = 0;
            data(data > STROBE_THRESHOLD) = 1;
            start_strobe = data(2,:);
            clock = data(1,:);
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
            markersets = experiment.software.markerfiles;
            marker_set = markersets{1};
            MocapFilename = ['rec' recs{iNum} '.Body.mocap.trc'];
            %Align to mocap data
            if exist(MocapFilename,'file');
                [header, marker_data] = parseMoCapFile(MocapFilename,1);
                missing_timestamps = length(clock_up)-size(marker_data,2);
                if(missing_timestamps > 100)
                    disp(['Number of missing timestamps: ' num2str(missing_timestamps)])
                    disp('Please press any key to continue');
                    pause(2)
                elseif(missing_timestamps < 0 )
                    disp(['Number of missing timestamps: ' num2str(missing_timestamps)])
                    disp('Please press any key to continue');
                    pause(2)
                    marker_data = marker_data(:,1:length(clock_up));
                end
                time_stamps = clock_up(1:size(marker_data,2)); % align timestamps to the first clock up.
            end
            
            frames = ev(:,1);
            if(max(frames) > length(time_stamps))
                max(find(frames < length(time_stamps)));
                frames = frames(1:max(find(frames < length(time_stamps))));
                ev = ev(1:max(find(frames < length(time_stamps))),:);
            end
            times = round(time_stamps(frames));%./sampling_rate.*1000;
        else
            times=1:length(ev);
        end
        ev = [times;ev'];
        save(['rec' recs{iNum} '.Vizard.mat'], 'ev');
    else
        disp(['No Vizard events file for recording: ' rec])
    end
end