function [output_marker_data,marker_timecodes] = parseMarkerFile(MarkerFilename)
%
%  [marker_data,marker_timecodes] = parseMarkerFile(MarkerFilename)
%
% marker_data = contains 1:3 spatial marker locations 4 framenumber
% marker_timecodes contains timecodes which are not framenumbers
%

global experiment

acquisition = experiment.hardware.acquisition;
acquisitiontype = cell(1,length(acquisition));
[acquisitiontype{:}] = deal(acquisition.type);
NUMMARKERS = acquisition(ismember(acquisitiontype,'PhaseSpace')).num_channels;
MARKER_DIMS = 4; % Each marker is in 3D space
marker_data = cell(1,NUMMARKERS);
for i = 1:NUMMARKERS
    disp('In parseMarkerFile');
    disp(['Opening marker file: ' MarkerFilename num2str(i)]);
    fid = fopen([MarkerFilename num2str(i) '.dat']);
    data = fread(fid,[8,inf],'double');
    if(length(data))
        timecode = data(6,:)'+ data(7,:)'*2^8 + data(8,:)'*2^16;
        marker_data{i} = [data(2:5,:)', timecode];
    else
        disp(['Marker ' num2str(i) ' not detected for recording']); 
    end
end

timecodes = [];
for iMarker = 1:NUMMARKERS
    if ~isempty(marker_data{iMarker})
        timecodes = [timecodes marker_data{iMarker}(:,5)'];
    end
end
marker_timecodes = unique(timecodes)';
num_timecodes = length(marker_timecodes);
output_marker_data = zeros(MARKER_DIMS,NUMMARKERS,num_timecodes);

for iMarker = 1:NUMMARKERS
    if ~isempty(marker_data{iMarker})
        [dum1, dum2, ind] = intersect(marker_data{iMarker}(:,5),marker_timecodes);
        output_marker_data(:,iMarker,ind) = marker_data{iMarker}(dum2,1:4)';
    end
end



