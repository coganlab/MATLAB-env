
function convert_all_demux_files_to_eeg(pathstr,eeg_chan,eeg_gain)
% eeg_chan is an extra channel that you may have (like a BNC)
% eeg_gain is the factor used to reduce the signal. EEG data often has high
% gain.
% process all tdms files in this directory
% list 'em
fileList = dir(strcat(pathstr,'\*.mat'));

% loop
for i = 1:size(fileList,1)
    
    fileList(i).name
    namestr = strcat(pathstr,'\',fileList(i).name);        % demux the channel we just converted in subfolder
    convert2eeg_data(namestr,eeg_chan,eeg_gain);
    
end


end
