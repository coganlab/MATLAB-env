
function procElectrodeLog(day)

%  procElectrodeLog(day)
%
%  Saves electrode log for all recordings from the specified day.
%

global MONKEYDIR

disp([ 'procElectrodeLog: ' day]);

MSession = loadMovement_Database;
Towers = sessTower(MSession);
uTowers = unique(Towers);
nTowers = length(uTowers);
for iTower = 1:nTowers
    tower = uTowers{iTower};
    recs = dayrecs(day);
    nRecs = length(recs);
    dayDir = [MONKEYDIR '/' day];
    for iRec = 1:nRecs
        rec = recs{iRec};
        curDepth = calcCumulativeChannelDepth(day, rec, tower);
        f = fopen([ dayDir '/' rec '/rec' rec '.' tower '.electrodelog.txt'],'w');
        nElectrode = length(curDepth);
        dString = [ '0  ' ];
        for iCh = 1:nElectrode
            dString = [ dString num2str(curDepth(iCh)) ];
            if iCh < nElectrode
                dString = [ dString ' ' ];
            end
        end
        fprintf(f,dString);
        fclose(f);
    end
end
disp('done.');