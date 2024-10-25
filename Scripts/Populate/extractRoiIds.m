function roiIds = extractRoiIds(Subject, channelNames, roiTerms)
% EXTRACTROIIDS - Extracts Region of Interest (ROI) IDs based on channel names and ROI terms.
%
%   roiIds = extractRoiIds(Subject, channelNames, roiTerms)
%
%   INPUTS:
%     - Subject: A structure or data source representing the subject's information.
%     - channelNames: A cell array of channel names to consider for ROI extraction.
%     - roiTerms: A cell array of ROI terms to match against channel locations.
%
%   OUTPUT:
%     - roiIds: A logical array where each element indicates whether the corresponding
%               channel matches any of the specified ROI terms.
%
%   DESCRIPTION:
%     This function extracts ROI IDs by comparing channel names with a list of
%     ROI terms. It returns a logical array where each element corresponds to
%     a channel and indicates whether it matches any of the specified ROI terms.
%
%
%   SEE ALSO:
%     extractChannelLocation

    % Extract channel location information for the specified subject and channels
    channelInfoAll = extractChannelLocation(Subject, channelNames);
    chanLoc = {channelInfoAll.Location};
    % Determine which channels match any of the specified ROI terms
    roiIds = ismember(chanLoc, roiTerms);
    %roiIds = cellfun(@(m)isequal(m,roiTerms),chanLoc);
end
