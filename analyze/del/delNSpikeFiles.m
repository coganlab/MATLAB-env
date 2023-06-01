function delNSpikeFiles(day,rec)
%
%   delNSpikeFiles(day,num)
%
%

BYTEMIN = 40;  %%  Sets minimum number of bytes in stim.txt file
               %%  required for keeping stim files

global MONKEYDIR
olddir = pwd;
recs = dayrecs(day);
nRecs = length(recs);

if nargin < 2
    num = [1,nRecs];
elseif ischar(rec) 
    num = [find(strcmp(recs,rec)),find(strcmp(recs,rec))];
elseif length(rec)==1 
    num = [rec,rec];
elseif length(rec)==2
    num = rec;
end

for iRec = num(1):num(2)

    cd([MONKEYDIR '/' day '/' recs{iRec}]);
    %delete nspike file
    try
        load([MONKEYDIR '/' day '/' recs{iRec} '/rec' recs{iRec} '.experiment.mat']);
        data_processed = 0;
        for i = 1:length(experiment.hardware.microdrive)
            tower = experiment.hardware.microdrive(i).name;
            data_processed = data_processed + isfile(['rec' recs{iRec} '.' tower '.raw.dat']);
        end
        if (data_processed == length(experiment.hardware.microdrive))
            if isfile(['rec' recs{iRec} '.nspike.dat'])
                disp(['Deleting rec' recs{iRec} '.nspike.dat'])
                delete(['rec' recs{iRec} '.nspike.dat']);
            else
                disp(['rec' recs{iRec} '.nspike.dat does not exist'])
            end
        else
            disp(['Processed dat files do not exist. Run procDay'])
        end
        %Delete comedi file
        if isfile(['rec' recs{iRec} '.display.dat']);
            if isfile(['rec' recs{iRec} '.comedi.dat']);
                disp(['Deleting rec' recs{iRec} '.comedi.dat'])
                delete(['rec' recs{iRec} '.comedi.dat']);
            else
                disp(['rec' recs{iRec} '.comedi.dat does not exist']);
            end
        else
            disp(['rec' recs{iRec} '.dispay.dat does not exist. Run procDay.']);
        end
    catch
    end
end

cd(olddir);
