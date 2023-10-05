function chanInfo = assignRoiInformation(subjRoiInfo, options)
% Assigns region of interest (ROI) information to each channel for every subject.
%
% Args:
%   subjRoiInfo (struct array): ROI information for each subject.
%   options (struct, optional): Options for the assignment process.
%       - gmThresh (double): Grey matter threshold for assigning channels (default: 0.05).
%
% Returns:
%   chanInfo (struct array): Assigned ROI information for each channel.

arguments
    subjRoiInfo
    options.gmThresh = 0.05;
    
end

chanInfo = [];

for iSubj = 1:length(subjRoiInfo)
    TrestSubj = subjRoiInfo(iSubj).Trest;
    whiteIds = contains({TrestSubj{:, 1}}, ["White", "hypointensities", "nknown"]);
    
    for iChan = 1:size(TrestSubj, 1)
        % Iterating through each channel
        chanInfo(iSubj).ChannelInfo(iChan).Name = subjRoiInfo(iSubj).Tname{iChan};
        chanInfo(iSubj).ChannelInfo(iChan).xyz = subjRoiInfo(iSubj).elecInfo.xyz(iChan,:);
        if (~whiteIds(iChan))
            % If grey matter channel, assign the center electrode
            %disp('Assigning Grey matter channel with center')
            chanInfo(iSubj).ChannelInfo(iChan).Location = TrestSubj{iChan, 1};
        else
            %disp('Detected white matter channel')
            iCol = 3;
            iColWhite = [];
            
            while (contains(TrestSubj{iChan, iCol}, ["White", "hypointensities", "nknown"]))
                % Checking for white-matter or unknown info and landing
                % on the first grey matter ROI
                if (contains(TrestSubj{iChan, iCol}, ["White", "hypointensities"]))
                    % Marking the position of white matter ROI, in case
                    % there is no grey matter ROI available
                    iColWhite = [iColWhite iCol];
                end
                iCol = iCol + 2;
            end
            
            iColAssign = [];
            
            if (~isempty(TrestSubj{iChan, iCol})) && (TrestSubj{iChan, iCol + 1} >= options.gmThresh)
                % Check if the ROI column landed is not empty, and if so, check
                % if the corresponding ROI voxel percentage exceeds the
                % grey matter threshold assigned
                %disp('Grey matter ROI identified')
                iColAssign = iCol;
            else                
                %disp('No Grey matter ROI identified')
                if (~isempty(iColWhite))
                    %disp('Assigning to the white matter contact location')
                    iColAssign = iColWhite(1); 
                else
                    disp('No white or grey matter identified')
                    iColAssign = 3;
                end
            end
            
            chanInfo(iSubj).ChannelInfo(iChan).Location = TrestSubj{iChan, iColAssign};            
        end   
    end
end
end
