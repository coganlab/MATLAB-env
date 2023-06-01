
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% convert_all_tdms_sig_express_files - converts all the tdms files in this folder from
%     tdms files into .mat file. 
%   
%   Uses: Quick_TDMS_Convert.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function convert_all_tdms_sig_express_files(pathstr)

% process all tdms files in this directory
%fileList = dir(strcat(pathstr,'/*.tdms'));

% enhanced version
fileList = rdir([pathstr, '\**\*.tdms']);

% loop over all files
for i = 1:size(fileList,1)
    
    % make full filename, including path
    %namestr = strcat(pathstr,'/',fileList(i).name);        
    namestr = fileList(i).name;        
    
    disp(['Working on file:  ' namestr])
    
    % work on this file
    [~] = convertTDMS(true,namestr);
    
    % jv hack to delete files
    %delete(namestr);    
    
    [path name ext] = fileparts(namestr);
    
    convert2eeg_data([path '\' name '.mat'], 1, 1);
end

