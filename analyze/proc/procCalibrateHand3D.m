function marker_data = procCalibrateHand3D(MarkerFilename)


MARKER_DIMS = 3;

disp(['Opening marker file: ' MarkerFilename]);
fid = fopen(MarkerFilename);
if(fid > 0)
    chk = 1;
else
    disp(['Error opening marker file: ' MarkerFilename]);
    chk= 0;
end
marker_index = 1;
num_targets = 9;
marker_data = zeros(num_targets, MARKER_DIMS);
local_count = zeros(num_targets,MARKER_DIMS);
while chk
    data = fgetl(fid);
    chk = ischar(data);

    % Check if a line was read
    if(chk)
        [token,remain] = strtok(data);
        if(strcmp(token,'Target')) % find Target beginning
            marker_index = str2num(remain);
        else
            for i = 1:3
                [token,remain] = strtok(remain);
                marker_data(marker_index,i) = marker_data(marker_index,i) + str2num(token);
            end
            local_count(marker_index,:) = local_count(marker_index,:) + 1;
        end
    end
end

marker_data = marker_data./local_count;