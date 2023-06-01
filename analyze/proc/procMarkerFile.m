function procMarkerFile(day, rec)
%  PROCMARKERFILE processes marker.txt
%
%  PROCMARKERFILE(DAY, REC)
%


global MONKEYDIR 

STROBE_THRESHOLD = 3.2e3;

olddir = pwd;
tmp = dir([MONKEYDIR '/' day '/0*']);
[recs{1:length(tmp)}] = deal(tmp.name);
nRecs = length(recs);
% COMEDICH = 8; %%%%%%%%%%% Needs to be taken from the exp def file
% recs

if nargin < 2 || isempty(rec)
    num = [1,nRecs];
elseif ischar(rec)
    num = [find(strcmp(recs,rec)),find(strcmp(recs,rec))];
elseif length(rec)==1
    num = [rec,rec];
else
    num = rec;
end
for iRec = num(1):num(2)
    cd([MONKEYDIR '/' day '/' recs{iRec}]);
    load(['rec' recs{iRec} '.experiment.mat']);
   
    MarkerDataFilename = ['rec' recs{iRec} '.MarkerData.mat'];
    MarkerFilename = ['rec' recs{iRec} '.marker'];
    
    [marker_data, marker_timecodes] = parseMarkerFile(MarkerFilename);
    
    MarkerData.marker_data = marker_data;
    MarkerData.marker_timecodes = marker_timecodes;
    
    save(MarkerDataFilename, 'MarkerData');
end
cd(olddir);
