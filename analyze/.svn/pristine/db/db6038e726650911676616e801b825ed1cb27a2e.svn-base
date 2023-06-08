function delLaserDatFiles(day,num)
%
%   delDatFiles(day,num)
%

global MONKEYDIR
olddir = pwd;
recs = dayrecs(day);
nRecs = length(recs);

if nargin < 2
    num = [1,nRecs];
elseif isstr(rec) 
    num = [find(strcmp(recs,rec)),find(strcmp(recs,rec))];
elseif length(rec)==1 
    num = [rec,rec];
elseif length(rec)==2
    num = rec;
end

for iRec = num(1):num(2)
    cd([MONKEYDIR '/' day '/' recs{iRec}]);
    if isfile(['rec' recs{iRec} '.Events.mat']);
        if isfile(['rec' recs{iRec} '.dat'])
            disp(['Deleting rec' recs{iRec} '.dat'])
            delete(['rec' recs{iRec} '.dat']);
        else
            disp(['rec' recs{iRec} '.dat does not exist']);
        end
        if isfile(['rec' recs{iRec} '.daq'])
            disp(['Deleting rec' recs{iRec} '.daq'])
            delete(['rec' recs{iRec} '.daq']);
        else
            disp(['rec' recs{iRec} '.daq does not exist']);
        end
    else
        disp(['rec' recs{iRec} '.Events.mat does not exist. Run procDay.']);
    end
  
end

cd(olddir);