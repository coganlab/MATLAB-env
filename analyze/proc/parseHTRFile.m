function [HTR_Data, HTR_Header, HTR_Skeleton, HTR_BasePosition] = parseHTRFile(HTRFilename)
%
%  [HTR_Data, HTR_Header, HTR_Skeleton, HTR_BasePosition] = parseHTRFile(HTRFilename)
%

fid= fopen(HTRFilename,'r');

x = ''; i = 1; header = {};
while ~strcmp(x,'[SegmentNames&Hierarchy]')
  x = fgetl(fid);
  header{i} = x;
  i = i+1;
end

clear Header;
Header.FileType = '';
for iLine = 2:length(header)-1
  tmp = textscan(header{iLine},'%s%s');
  FieldName = tmp{1}{1}; FieldValue = tmp{2}{1};
  Header.(FieldName) = FieldValue;
end
HTR_Header = Header;

x = ''; i = 1; skeleton = {};
while ~strcmp(x,'[BasePosition]')
  x = fgetl(fid);
  skeleton{i} = x;
  i = i+1;
end

clear Skeleton
Skeleton.Child = '';
Skeleton.Parent = '';
i = 1;
for iLine = 2:length(skeleton)-1
  tmp = textscan(skeleton{iLine},'%s%s');
  Skeleton(i).Child = tmp{1}{1};
  Skeleton(i).Parent = tmp{2}{1};
  i = i + 1;
end
HTR_Skeleton = Skeleton;

x = ''; i = 1; baseposition = {};
while ~strcmp(x,['[' Skeleton(1).Child ']'])
  x = fgetl(fid);
  baseposition{i} = x;
  i = i+1;
end

clear BasePosition
BasePosition.Prepelvis = [];
for iLine = 2:length(skeleton)-1
  tmp = textscan(baseposition{iLine},'%s%f%f%f%f%f%f%f');
  BasePosition.(tmp{1}{1}) = cell2mat(tmp(2:end));
end
HTR_BasePosition = BasePosition;

NumFrames = str2num(Header.NumFrames)
clear HTR_Data
for iSegment = 1:length(Skeleton);
  SegmentName = Skeleton(iSegment).Child
  fseek(fid,0,'bof');
  x = ''; 
  while ~strcmp(x,['[' SegmentName ']'])
    x = fgetl(fid);
  end
  if length(x)
    FrameHeader = fgetl(fid);
    skeleton_data = {};
    for iFrame = 1:NumFrames
      skeleton_data = fgetl(fid);
      tmp = textscan(skeleton_data,'%f%f%f%f%f%f%f%f');
      HTR_Data.(SegmentName)(iFrame,:) = cell2mat(tmp);
    end
  end
end

HTR_Data.FrameHeader= FrameHeader;

fclose(fid);
