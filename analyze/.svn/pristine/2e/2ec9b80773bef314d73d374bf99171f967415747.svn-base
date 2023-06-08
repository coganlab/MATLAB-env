function  [header, marker_data] = parseMoCapFile(MarkerFilename,named)
% 
% [timestamps, marker_data] = parseMoCapFile(MarkerFilename)
% 

global experiment
MAXMARKERS = 60;

%disp('In parseMoCapFile')
disp(['Opening marker file: ' MarkerFilename]);
fid = fopen(MarkerFilename);
header{1} = textscan(fid,'%s%d%s%s',1);
header{2} = textscan(fid,'%s%s%s%s%s%s%s%s',1);
header{3} = textscan(fid,'%d%d%d%d%s%d%d%d',1);

if(named)
    markers = header{3}{4};
    disp(['Number of markers detected ' num2str(markers)])
    string = '%s%s';
    for i = 1:markers
        string = [string '%s']; 
    end
    header{4} = textscan(fid,string,1);;
    header{5} = fgetl(fid);
    header{6} = fgetl(fid);
else
    markers = MAXMARKERS;
    header{4} = fgetl(fid);
    header{5} = fgetl(fid);
    header{6} = fgetl(fid);
end




string = '%f%f';
for i = 1:markers
    string = [string '%f%f%f'];
end
data = textscan(fid,string,'delimiter','\t','EmptyValue',-Inf);
marker_data = cell2mat(data)';

if(~named)
    tmp = sum(marker_data' == -Inf);
    frames = size(marker_data,2);
    empty_columns = (tmp == frames);
    max_column = max(find(empty_columns == 0));
    marker_data = marker_data(1:max_column,:);
end
fclose(fid);
%disp('Leaving parseMoCapFile')