function procDaySemiChronicElectrodeLogs(day)

%  procDaySemiChronicElectrodeLogs(day)
%
%  Saves electrode logs for all recordings from the specified day.
%

%saveMovement_Database

global MONKEYDIR

disp([ 'procDaySemiChronicElectrodeLogs: ' day]);

MSession = loadMovement_Database;
Towers = sessTower(MSession);
uTowers = unique(Towers);
nTowers = length(uTowers);
for iTower = 1:nTowers
    MSessionTower = MSession(ismember(Towers,uTowers(iTower)));
    [depths, dDays, dRecs] = calcSemiChronicChannelDepth(MSessionTower,1);
    tower = uTowers{iTower};
    recs = dayrecs(day);
    nRecs = length(recs);
    dayDir = [MONKEYDIR '/' day];
    for k = 1:nRecs
        rec = recs{k};
        loc1 = find(ismember(dDays,day));
        loc2 = find(ismember(dRecs,rec));
        if ~isempty(loc1) && ~isempty(loc2)
            dLocs = find(ismember(loc1,loc2));
            dLoc = loc1(dLocs(end));
            curDepth = depths(dLoc,:);
            f = fopen([ dayDir '/' rec '/rec' rec '.' tower '.electrodelog.txt'],'w');
            dString = [ '0  ' ];
            for iCh = 1:32
                dString = [ dString num2str(curDepth(iCh)) ];
                if iCh < 32
                    dString = [ dString ' ' ];
                end
            end
            fprintf(f,dString);
            fclose(f);
        else
            disp(['--> ERROR: ' day ' rec' rec ' not found in movement database! Skipping...']);
        end
    end
end
disp('done.');
