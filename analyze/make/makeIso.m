function makeIso(day, rec, tower)
%
% makeIso(day, rec, tower)
%

global MONKEYDIR

olddir = pwd;

IsoWin = 1e5;
MAXNUMCLUST = 14;

recs = dayrecs(day);
nRecs = length(recs);

if nargin < 2 || isempty(rec)
    num = [1,nRecs];
elseif ischar(rec)
    num = [find(strcmp(recs,rec)),find(strcmp(recs,rec))];
elseif length(rec)==1
    num = [rec,rec];
else
    num = rec;
end

if nargin < 3; tower = []; end

for iRec = num(1):num(2)
    prenum = recs{iRec};
    disp(['Processing ' day ':' prenum]);
    cd([MONKEYDIR '/' day '/' prenum]);
    load([MONKEYDIR '/' day '/' prenum '/rec' prenum '.experiment.mat']);
    NumTowers = length(experiment.hardware.microdrive);
    
    if isempty(tower)
        first_tower = 1;
        last_tower = NumTowers;
        towers = first_tower:last_tower;
    else
        [tower_names{1:length(experiment.hardware.microdrive)}] = deal(experiment.hardware.microdrive.name);
        [dum,towers] = intersect(tower_names,tower);
    end
    for iMT = towers;
        towername = experiment.hardware.microdrive(iMT).name;
        
        if 0 %isfile([MONKEYDIR '/' day '/' prenum '/rec' prenum '.' towername '.iso.mat'])
            disp([MONKEYDIR '/' day '/' prenum '/rec' prenum '.' towername '.iso.mat exists']);
        else
            disp(['Checking ... ']);
            if isfile([MONKEYDIR '/' day '/' prenum '/rec' prenum '.' towername '.clu.mat'])
                disp(['Saving ... ']);
                load([MONKEYDIR '/' day '/' prenum '/rec' prenum '.' towername '.clu.mat'])
                nCh = length(clu);
                iso = cell(1,nCh); nWin = zeros(1,nCh);
                for iCh = 1:nCh
                    nWin(iCh) = ceil(clu{iCh}(end,1)./IsoWin);
                end
                nWin = max(nWin);
                for iCh = 1:nCh
                    iso{iCh} = zeros(nWin,MAXNUMCLUST);
                    iso{iCh}(:,1) = 1;
                end
                save([MONKEYDIR '/' day '/' prenum '/rec' prenum '.' towername '.iso.mat'],'iso')
            end
        end
    end
end

cd(olddir);
