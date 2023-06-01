function updateClu(day, rec, tower)
%
% updateClu(day, rec, tower)
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
        
        if isfile([MONKEYDIR '/' day '/' prenum '/rec' prenum '.' towername '.clu.mat'])
          disp([MONKEYDIR '/' day '/' prenum '/rec' prenum '.' towername '.clu.mat exists']);
          load([MONKEYDIR '/' day '/' prenum '/rec' prenum '.' towername '.clu.mat'])
          nCh = length(experiment.hardware.microdrive.electrodes);
          if length(clu) < nCh; for iCh = length(clu)+1:nCh clu{iCh} = []; end; end
          flag = 0;
          for iCh = 1:nCh
            if isempty(clu{iCh})
              flag = 1;
            end
          end
          if flag
            disp(['Loading ' MONKEYDIR '/' day '/' prenum '/rec' prenum '.' towername '.sp.mat']);
            load([MONKEYDIR '/' day '/' prenum '/rec' prenum '.' towername '.sp.mat'])
            for iCh = 1:nCh
              if isempty(clu{iCh})
                nSp = size(sp{iCh},1);
                clu{iCh} = zeros(nSp,2);
                clu{iCh}(:,1) = sp{iCh}(:,1);
                clu{iCh}(:,2) = 1;
              end
            end
            save([MONKEYDIR '/' day '/' prenum '/rec' prenum '.' towername '.clu.mat'],'clu')
          end
        else
          disp([MONKEYDIR '/' day '/' prenum '/rec' prenum '.' towername '.clu.mat does not exist']);
          disp('Run makeClu.m')
        end
    end
end
