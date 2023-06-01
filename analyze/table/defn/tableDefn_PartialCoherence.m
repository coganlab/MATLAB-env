% Partial Coherence table panel
% Before calling, you need to set Session list, analysis ('LPL')
% and a list of the Monkeyname

global MONKEYNAME MONKEYDIR

clear Table
Table.Data.Sessions = Session; %Must be 3-part, and in this case UFF.
Table.Data.Monkey = Monkey; %Must be 3-part, and in this case UFF.
Table.Data.Values = [];
NSess = length(Session);

% Set the names. There will be a calc function for each
% Or should I set simple ones here? It seems silly to have a function for
% each SessNum
Table.Quantity(1).Name = 'SessNum1';
Table.Quantity(2).Name = 'SessNum2';
Table.Quantity(3).Name = 'SessNum3';
Table.Quantity(4).Name = 'SingleUnit';
Table.Quantity(5).Name = 'TunedUnit';
Table.Quantity(6).Name = 'TunedField1'; 
Table.Quantity(7).Name = 'TunedField2'; 
Table.Quantity(8).Name = 'PrefDir';
Table.Quantity(9).Name = 'NumTrials';
Table.Quantity(10).Name = 'SigCohUnit_F1';
Table.Quantity(11).Name = 'SigCohUnit_F2';
Table.Quantity(12).Name = 'SigCohF1_F2';
Table.Quantity(13).Name = 'SigPartialCoh';
Table.Quantity(14).Name = 'NullDir';
Table.Quantity(15).Name = 'NullNumTrials';
Table.Quantity(16).Name = 'NullSigCohUnit_F1';
Table.Quantity(17).Name = 'NullSigCohUnit_F2';
Table.Quantity(18).Name = 'NullSigCohF1_F2';
Table.Quantity(19).Name = 'NullSigPartialCoh';

% Does something as simple as SessNum need a type and calc function?
% I guess I do want to be able to simply loop through Quantities later.
Table.Quantity(1).Type = 'SessNum1';
Table.Quantity(2).Type = 'SessNum2';
Table.Quantity(3).Type = 'SessNum3';
Table.Quantity(4).Type = 'SingleUnit';
Table.Quantity(5).Type = 'TunedUnitS1';
Table.Quantity(6).Type = 'TunedFieldS2'; 
Table.Quantity(7).Type = 'TunedFieldS3'; 
Table.Quantity(8).Type = 'PrefDirection';
Table.Quantity(9).Type = 'NumTrials';
Table.Quantity(10).Type = 'SigCoh12';
Table.Quantity(11).Type = 'SigCoh31';
Table.Quantity(12).Type = 'SigCoh23';
Table.Quantity(13).Type = 'SigPartialCoh';
Table.Quantity(14).Type = 'NullDirection';
Table.Quantity(15).Type = 'NullNumTrials';
Table.Quantity(16).Type = 'NullSigCoh12';
Table.Quantity(17).Type = 'NullSigCoh31';
Table.Quantity(18).Type = 'NullSigCoh23';
Table.Quantity(19).Type = 'NullSigPartialCoh';


NValues = length(Table.Quantity);
for iSess = 1:NSess
    for iValue = 1:NValues
        Table.Quantity(iValue).CondParams{iSess} = [];
        Table.Quantity(iValue).AnalParams{iSess} = [];
    end
end

%Now go through and  and set Params for those that need to be calculated
% I also need a timeind and freqind set
for iSess = 1:length(Table.Data.Sessions)
    Sess = Table.Data.Sessions{iSess};
    MONKEYNAME = Table.Data.Monkey{iSess};
    MONKEYDIR = ['/mnt/raid/' MONKEYNAME];
    task = 'MRS';
    Dir = loadSessionDirections(Sess);
    panelDefn_PartialCoh
    CondParams(1,1).timeind = 5;
    f = linspace(0,200,204);
    CondParams(1,1).freqind = find(f>15,1);
    
    Table.Quantity(9).CondParams{iSess} = CondParams;
    Table.Quantity(9).AnalParams{iSess} = AnalParams;
    Table.Quantity(10).CondParams{iSess} = CondParams;
    Table.Quantity(10).AnalParams{iSess} = AnalParams;
    Table.Quantity(11).CondParams{iSess} = CondParams;
    Table.Quantity(11).AnalParams{iSess} = AnalParams;
    Table.Quantity(12).CondParams{iSess} = CondParams;
    Table.Quantity(12).AnalParams{iSess} = AnalParams;
    Table.Quantity(13).CondParams{iSess} = CondParams;
    Table.Quantity(13).AnalParams{iSess} = AnalParams;
    Table.Quantity(15).CondParams{iSess} = CondParams;
    Table.Quantity(15).AnalParams{iSess} = AnalParams;
    Table.Quantity(16).CondParams{iSess} = CondParams;
    Table.Quantity(16).AnalParams{iSess} = AnalParams;
    Table.Quantity(17).CondParams{iSess} = CondParams;
    Table.Quantity(17).AnalParams{iSess} = AnalParams;
    Table.Quantity(18).CondParams{iSess} = CondParams;
    Table.Quantity(18).AnalParams{iSess} = AnalParams;
    Table.Quantity(19).CondParams{iSess} = CondParams;
    Table.Quantity(19).AnalParams{iSess} = AnalParams;
    
    clear CondParams1 AnalParams1
    CondParams1{1}.Field = 'TargsOn';
    CondParams1{1}.Task = 'MemoryReachSaccade';
    CondParams1{1}.bn = [0, 500];
    CondParams1{2} = CondParams1{1};
    CondParams1{1}.conds = {[Dir.Pref]};
    CondParams1{2}.conds = {[Dir.Null]};
    AnalParams1 = [];
    Table.Quantity(5).CondParams{iSess} = CondParams1;
    Table.Quantity(5).AnalParams{iSess} = AnalParams1;
    AnalParams1.Tapers = [.5,10];
    AnalParams1.fk = [10 20];
    Table.Quantity(6).CondParams{iSess} = CondParams1;
    Table.Quantity(6).AnalParams{iSess} = AnalParams1;
    Table.Quantity(7).CondParams{iSess} = CondParams1;
    Table.Quantity(7).AnalParams{iSess} = AnalParams1;
end

Table.CondParams.Name = [analysis '_UFFPartialCoherence_MRS'];
Table.AnalParams = [];

% Table_line(2) = SessNum(order(2));
% Table_line(3) = SessNum(order(3));
% sSess = splitSession(Sess);
% UnitType = getSessionType(sSess{1});
% Table_line(4) = strcmp(UnitType,'Spike');
% Dir = loadSessionDirections(Sess);
% 
% %panelDefn_PartialCoh
% panelDefn_PartialCoherogram
% Panels = loadPanels(Sess, CondParams, AnalParams);
% Table_line(8) = Dir.Pref;
% Table_line(9) = Panels.Data(1,1).SubPanel(1,2).Data.NumTrials;
% Table_line(10) = abs(Panels.Data(1,1).SubPanel(1,2).Data.SuppData.Coh(timeind,betaind));
% Table_line(11) = abs(Panels.Data(1,1).SubPanel(1,2).Data.SuppData.Coh31(timeind,betaind));
% Table_line(12) = abs(Panels.Data(1,1).SubPanel(1,2).Data.SuppData.Coh23(timeind,betaind));
% Table_line(13) = abs(Panels.Data(1,1).SubPanel(1,2).Data.Data(timeind,betaind));
% Table_line(14) = Dir.Null;
% Table_line(15) = Panels.Data(2,1).SubPanel(1,2).Data.NumTrials;
% Table_line(16) = abs(Panels.Data(2,1).SubPanel(1,2).Data.SuppData.Coh(timeind,betaind));
% Table_line(17) = abs(Panels.Data(2,1).SubPanel(1,2).Data.SuppData.Coh31(timeind,betaind));
% Table_line(18) = abs(Panels.Data(2,1).SubPanel(1,2).Data.SuppData.Coh23(timeind,betaind));
% Table_line(19) = abs(Panels.Data(2,1).SubPanel(1,2).Data.Data(timeind,betaind));














