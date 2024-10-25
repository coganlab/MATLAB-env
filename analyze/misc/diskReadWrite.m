function [Time,Speed] = diskReadWrite(vol,numFiles,sizeFile)
%
%  [Time,Speed] = diskReadWrite(vol,numFiles,sizeFile)
%

if nargin < 2 numFiles = 100; end
if nargin < 3 sizeFile = 1e7; end

unix(['rm ' vol '/file*']);
data = rand(1,sizeFile);
save([vol '/file1.mat'],'data');
tmp = dir([vol '/file1.mat']);
sizeofData = tmp.bytes;

disp('Writing to disk ...');
tic
for iFile = 1:numFiles
  save([vol '/file' num2str(iFile) '.mat'],'data');
end
WriteTime = toc;

disp('Reading from disk ...');
tic
for iFile = 1:numFiles
  load([vol '/file' num2str(iFile) '.mat']);
end
ReadTime = toc;

Time.Read = ReadTime;
Time.Write = WriteTime;
Speed.Read = numFiles.*sizeofData./(ReadTime.*1e6);
Speed.Write = numFiles.*sizeofData./(WriteTime.*1e6);

unix(['rm ' vol '/file*']);
