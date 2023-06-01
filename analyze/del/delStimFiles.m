function delStimFiles(day,num)
%
%   delStimFiles(day,num)
%   to delete old stim files

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
    if (isfile('file.stimpulse.dat') || ...
            isfile('file.stimraw.dat'))
        
        disp(['Deleting Stim Files ' 'rec' recs{iRec}])
        
        delete('file.stimpulse.dat')
        delete('file.stimraw.dat')
    else
        disp('Stim do not exist.')
    end
    
end

cd(olddir);