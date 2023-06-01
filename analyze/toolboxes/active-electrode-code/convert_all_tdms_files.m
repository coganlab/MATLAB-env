
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% convert_all_tdms_files - converts all the tdms files in this folder from
%     tdms files into .mat file. 
%   
%   Uses: Quick_TDMS_Convert.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function convert_all_tdms_files(pathstr)

% process all tdms files in this directory
fileList = dir(strcat(pathstr,'/*.tdms'));

% loop over all files
for i = 1:size(fileList,1)
    
    % make full filename, including path
    namestr = strcat(pathstr,'/',fileList(i).name);        
    
    % work on this file
    Quick_TDMS_Convert(namestr);
end

