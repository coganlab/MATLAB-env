function updateIso(day, rec, tower)
%
% updateIso(day, rec, tower)
%

global MONKEYDIR

IsoWin = 1e5;

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
        
        if isfile([MONKEYDIR '/' day '/' prenum '/rec' prenum '.' towername '.iso.mat'])
          disp([MONKEYDIR '/' day '/' prenum '/rec' prenum '.' towername '.iso.mat exists']);
          load([MONKEYDIR '/' day '/' prenum '/rec' prenum '.' towername '.iso.mat'])
          nCh = length(experiment.hardware.microdrive.electrodes);
          flag = 1; nWin = 0;
          if length(iso) < nCh; for iCh = length(iso)+1:nCh iso{iCh} = []; end; end
          for iCh = 1:nCh
            if ~isempty(iso{iCh})
              flag = 0;
              nWin = size(iso{iCh},1);
            end
          end
          if flag
            disp(['Loading ' MONKEYDIR '/' day '/' prenum '/rec' prenum '.' towername '.sp.mat']);
            load([MONKEYDIR '/' day '/' prenum '/rec' prenum '.' towername '.sp.mat'])
            for iCh = 1:nCh
	      nWin = max([nWin,ceil(sp{iCh}(end,1)./IsoWin)]);
            end
          end
          for iCh = 1:nCh
            if isempty(iso{iCh})
              iso{iCh} = zeros(nWin,14);
              iso{iCh}(:,1) = 1;
            end
          end
          save([MONKEYDIR '/' day '/' prenum '/rec' prenum '.' towername '.iso.mat'],'iso')
        else
          disp([MONKEYDIR '/' day '/' prenum '/rec' prenum '.' towername '.iso.mat does not exist']);
          disp('Run makeIso.m')
        end
    end
end
