
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Quick_TDMS_Convert - 
%   converts a TMDS file produced by the Labview Data acquisition system to
%   MATLAB format. 
% 
%   Inputs:
%       filename: full name and path to the file
%
%   Outputs: 
%       Writes out a .mat file in the same folder as the input fil
%       Note: All the parameters of the acquisition are saved
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Quick_TDMS_Convert(filename)

tic

% work on this file
[info.location, info.name] = fileparts(filename);

% load this file
[ConvertedData,info.ConvertVer,info.ChanNames]=convertTDMS(false,filename);
clear filename;

% node 1 seems to just have the file name
% node 2 has all the recording properties
% node 3 through the end has the recorded data
propNode = 2;
for i = 1:length(ConvertedData.Data.MeasuredData(1,propNode).Property)
    % convert all properties into matlab variables
    eval(['info.' ConvertedData.Data.MeasuredData(1,propNode).Property(1,i).Name ' = ConvertedData.Data.MeasuredData(1,propNode).Property(1,i).Value;'])
end
clear propNode;  % cleanup extra variables so they are not saved later

% translate new variables into old names, for code compatibility
sampRate = info.SamplingRate;
numRow = info.nrRows;
OSR = info.OverSampling;
numChan = info.nrColumns + info.nrBNCs;
numCol = info.nrColumns;

% Calculate effective sampling rate
Fs = sampRate / (numRow * OSR);  % Sampling Frequency

% node 3 through the end has the recorded data
dataNode = 3;
data = zeros(length(ConvertedData.Data.MeasuredData) - dataNode + 1,length(ConvertedData.Data.MeasuredData(1,dataNode).Data));
for i = dataNode:length(ConvertedData.Data.MeasuredData)
    data(i - dataNode +1,:) = ConvertedData.Data.MeasuredData(1,i).Data;
end

%temp
disp(['The recording length= ' num2str(size(data,2) / Fs)])

% cleanup for save
clear dataNode;
clear i;
clear ConvertedData;

% save the data
save(strcat(info.location,'/',info.name,'.mat'), '-v7.3');

toc

end

