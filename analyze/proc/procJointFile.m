function procJointFile(day, rec, jointfile)
%  PROCJOINTFILE processes mocap data files
%
%  PROCJOINTFILE(DAY, REC)
%


global MONKEYDIR

STROBE_THRESHOLD = 1e4;
disp('In procJointFile')
olddir = pwd;
tmp = dir([MONKEYDIR '/' day '/0*']);
[recs{1:length(tmp)}] = deal(tmp.name);
nRecs = length(recs);
file = 1;
if nargin < 2 || isempty(rec)
    num = [1,nRecs];
elseif ischar(rec)
    num = [find(strcmp(recs,rec)),find(strcmp(recs,rec))];
elseif length(rec)==1
    num = [rec,rec];
else
    num = rec;
end

if nargin < 3
    file = 0;
end

for iRec = num(1):num(2)
    cd([MONKEYDIR '/' day '/' recs{iRec}]);
    load(['rec' recs{iRec} '.experiment.mat']);
    sampling_rate = experiment.hardware.acquisition(1).samplingrate;
    format = experiment.hardware.acquisition(1).data_format;
    
    
    % Parse the strobe and clock data
    fid = fopen(['rec' recs{iRec} '.mocap.dat']);
    data = fread(fid,[2,inf],format);
    %figure
    %plot(data(:,:)')
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
    
    if(length(clock_up) == 0)
        % no clock signalis there a strobe if so align to strobe
        rec_length = start_down_transitions(1) - start_up_transitions(1);
        rec_samples = (rec_length./sampling_rate)*200;
        clock_up = start_up_transitions(1) + [0:rec_samples-1]*(sampling_rate/200);
        clock_up = (clock_up./sampling_rate).*1000;
        disp('No clock signal')
        pause(10)
    end
    
    markerset = experiment.software.markerfiles;
    for i = 1:size(markerset,2)
        marker_set = markerset{i};
        clear Joint
        %Parse named joint data
        if(file == 1)
            JointFilename = ['rec' recs{iRec} '.' marker_set '.' jointfile '.mocap.mot'];
        else
            JointFilename = ['rec' recs{iRec} '.' marker_set '.mocap.mot'];
        end
        MocapFilename = ['rec' recs{iRec} '.' marker_set '.mocap.trc'];
        if exist(JointFilename,'file')
            disp(['Processing ' JointFilename]);
            [header, joint_data, joint_names] = parseJointFile(JointFilename,1);
            [marker_header, marker_data] = parseMoCapFile(MocapFilename,1);
            missing_timestamps = length(clock_up)-size(marker_data,2);
            if(missing_timestamps > 100)
                disp(['Number of missing timestamps: ' num2str(missing_timestamps)])
                disp('Please press any key to continue');
                pause(5)
           elseif(missing_timestamps < 0 )
               disp(['Number of missing timestamps: ' num2str(missing_timestamps)])
               disp('Please press any key to continue');
               pause(5)
               max_length = min([size(marker_data,2),length(clock_up),size(joint_data,2)]);
               marker_data = marker_data(:,1:max_length);
               joint_data = joint_data(:,1:max_length);
            end
            % Align joint data with marker data
            joint_index = 1;
            aligned_joint_data = nan(size(joint_data,1),size(marker_data,2));
            for iTime = 1:size(marker_data,2)
                time_stamp = marker_data(2,iTime);
                while(joint_index <= size(joint_data,2))
                    if(time_stamp >= joint_data(1,joint_index))
                        if(time_stamp ~= joint_data(1,joint_index))
                         joint_index = joint_index +1;
                        else
                         aligned_joint_data(:,iTime) = joint_data(:,joint_index);
                         break
                        end
                    else
                        break
                    end
                end
            end
            
            clear Joint
            for iJoint = 1:length(joint_names)
                Joint{iJoint}(1,:) = clock_up(1:size(aligned_joint_data,2));  % missing timestamp solution
                Joint{iJoint}(2,:) = aligned_joint_data(iJoint+2,:);
            end
            if(file == 1)
                if(exist([MONKEYDIR '/' day '/' recs{iRec} '/jntfiles/' jointfile '.jnt'],'file'))
                    save(['rec' recs{iRec} '.' marker_set '.' jointfile '.Joint.mat'], 'Joint');
                    save(['rec' recs{iRec} '.' marker_set '.' jointfile '.joint_names.mat'], 'joint_names');
                else
                    disp('Not saving any files')
                    disp('Please put the jnt files in day/rec/jntfiles/')
                    pause
                end
            else
                save(['rec' recs{iRec} '.' marker_set '.Joint.mat'], 'Joint');
                save(['rec' recs{iRec} '.' marker_set '.joint_names.mat'], 'joint_names');
            end
        else
            disp([JointFilename ' does not exist'])
        end
    end
    if exist('importVariables.txt','file');
      unix('rm importVariables.txt');
    end
end
cd(olddir);
