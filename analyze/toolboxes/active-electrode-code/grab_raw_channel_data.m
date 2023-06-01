
filename = 'C:\Users\jviventi\Downloads\test_41.tdms';

% work on this file
[info.location, info.name] = fileparts(filename);

% load this file
[ConvertedData,info.ConvertVer,info.ChanNames]=convertTDMS(0,filename);
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


for i = 3: size(ConvertedData.Data.MeasuredData,2)
    ChannelData = ConvertedData.Data.MeasuredData(1,i).Data;
    fileout = strcat('channel_',num2str(i),'.mat');
    save(fileout, 'ChannelData')
end
    