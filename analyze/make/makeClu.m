function makeClu(day, rec, tower)
%
% makeClu(day, rec, tower)
%

global MONKEYDIR

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
    if exist([MONKEYDIR '/' day '/' prenum '/rec' prenum '.experiment.mat'],'file');
    load([MONKEYDIR '/' day '/' prenum '/rec' prenum '.experiment.mat'],'experiment');
    NumTowers = length(experiment.hardware.microdrive);
    else
        %load Rec file
    end
        
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
        
        if 0 %isfile([MONKEYDIR '/' day '/' prenum '/rec' prenum '.' towername '.clu.mat'])
            disp([MONKEYDIR '/' day '/' prenum '/rec' prenum '.' towername '.clu.mat exists']);
        else
            disp(['Checking ']);
            if isfile([MONKEYDIR '/' day '/' prenum '/rec' prenum '.' towername '.sp.mat'])
                disp(['Saving ']);
                load([MONKEYDIR '/' day '/' prenum '/rec' prenum '.' towername '.sp.mat'])
                nCh = length(sp);
                clu = cell(1,nCh);
                for iCh = 1:nCh
                    nSp = size(sp{iCh},1);
                    clu{iCh} = zeros(nSp,2);
                    clu{iCh}(:,1) = sp{iCh}(:,1);
                    clu{iCh}(:,2) = 1;
                end
              save([MONKEYDIR '/' day '/' prenum '/rec' prenum '.' towername '.clu.mat'],'clu')
            end
        end
    end
end
