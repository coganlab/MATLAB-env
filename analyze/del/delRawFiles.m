function delRawFiles(day,num)
%
%   delRawFiles(day,num)
%   to delete old raw files 

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
    if isfile(['rec' recs{iRec} '.raw.dat'])
        
        %Check for LIP and PRR.raw.dat
        %For added functionality we want to check what the drive names are in
        %experiment def file
        if (isfile(['rec' recs{iRec} '.MT1.raw.dat']) && isfile(['rec' recs{iRec} '.MT2.raw.dat']) || ...
                isfile(['rec' recs{iRec} '.MT_1.raw.dat']) && isfile(['rec' recs{iRec} '.MT_2.raw.dat'])) 
            %Check the file sizes are correct
                disp(['Deleting ' 'rec' recs{iRec} '.raw.dat'])
                delete(['rec' recs{iRec} '.raw.dat']);
        else
            disp('Processed raw files do not exist. Run ProcDay.');
        end
    else
         disp(['rec' recs{iRec} '.raw.dat does not exist.']);
    end
end

cd(olddir);