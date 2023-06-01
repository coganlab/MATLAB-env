% Partial Coherence table panel
% Before calling, you need to set Session list, analysis ('LPL')
% and a list of the Monkeyname

global MONKEYNAME MONKEYDIR

clear Table
Table.Data.Sessions = Session; %Must be 3-part, and in this case UUF.
Table.Data.Monkey = Monkey; %Must be 3-part, and in this case UUF.
Table.Data.Values = [];
Table.CondParams.Name = [analysis '_UUFPartialCoherence'];
Table.AnalParams = [];
NSess = length(Session);

% Set the names. There will be a calc function for each
Table.Quantity(1).Name = 'SessNum1';
Table.Quantity(2).Name = 'SessNum2';
Table.Quantity(3).Name = 'SessNum3';
Table.Quantity(4).Name = 'SingleUnit1';
Table.Quantity(5).Name = 'SingleUnit2';
Table.Quantity(6).Name = 'MRS_TunedUnit1';
Table.Quantity(7).Name = 'MRS_TunedUnit2'; 
Table.Quantity(8).Name = 'MRS_TunedField'; 
Table.Quantity(9).Name = 'PrefDir';
Table.Quantity(10).Name = 'MRS_PrefNumTrials';
Table.Quantity(11).Name = 'MRS_PrefCohU1U2';
Table.Quantity(12).Name = 'MRS_PrefCohU1F';
Table.Quantity(13).Name = 'MRS_PrefCohU2F';
Table.Quantity(14).Name = 'MRS_PrefPartialCoh';
Table.Quantity(15).Name = 'NullDir';
Table.Quantity(16).Name = 'MRS_NullNumTrials';
Table.Quantity(17).Name = 'MRS_NullCohU1U2';
Table.Quantity(18).Name = 'MRS_NullCohU2F';
Table.Quantity(19).Name = 'MRS_NullCohU2F';
Table.Quantity(20).Name = 'MRS_NullPartialCoh';

Table.Quantity(21).Name = 'MST_TunedUnit1';
Table.Quantity(22).Name = 'MST_TunedUnit2'; 
Table.Quantity(23).Name = 'MST_TunedField'; 
Table.Quantity(24).Name = 'MST_PrefNumTrials';
Table.Quantity(25).Name = 'MST_PrefCohU1U2';
Table.Quantity(26).Name = 'MST_PrefCohU1F';
Table.Quantity(27).Name = 'MST_PrefCohU2F';
Table.Quantity(28).Name = 'MST_PrefPartialCoh';
Table.Quantity(29).Name = 'MST_NullNumTrials';
Table.Quantity(30).Name = 'MST_NullCohU1U2';
Table.Quantity(31).Name = 'MST_NullCohU2F';
Table.Quantity(32).Name = 'MST_NullCohU2F';
Table.Quantity(33).Name = 'MST_NullPartialCoh';

Table.Quantity(34).Name = 'both_TunedUnit1';
Table.Quantity(35).Name = 'both_TunedUnit2'; 
Table.Quantity(36).Name = 'both_TunedField'; 
Table.Quantity(37).Name = 'both_PrefNumTrials';
Table.Quantity(38).Name = 'both_PrefCohU1U2';
Table.Quantity(39).Name = 'both_PrefCohU1F';
Table.Quantity(40).Name = 'both_PrefCohU2F';
Table.Quantity(41).Name = 'both_PrefPartialCoh';
Table.Quantity(42).Name = 'both_NullNumTrials';
Table.Quantity(43).Name = 'both_NullCohU1U2';
Table.Quantity(44).Name = 'both_NullCohU2F';
Table.Quantity(45).Name = 'both_NullCohU2F';
Table.Quantity(46).Name = 'both_NullPartialCoh';

% Does something as simple as SessNum need a type and calc function?
% I guess I do want to be able to simply loop through Quantities later.
Table.Quantity(1).Type = 'SessNum1';
Table.Quantity(2).Type = 'SessNum2';
Table.Quantity(3).Type = 'SessNum3';
Table.Quantity(4).Type = 'SingleUnit';
Table.Quantity(5).Type = 'SingleUnit';
Table.Quantity(6).Type = 'TunedUnitS1';
Table.Quantity(7).Type = 'TunedUnitS2'; 
Table.Quantity(8).Type = 'TunedFieldS3'; 
Table.Quantity(9).Type = 'PrefDirection';
Table.Quantity(10).Type = 'PrefNumTrials';
Table.Quantity(11).Type = 'PrefCoh12';
Table.Quantity(12).Type = 'PrefCoh31';
Table.Quantity(13).Type = 'PrefCoh23';
Table.Quantity(14).Type = 'PrefPartialCoh';
Table.Quantity(15).Type = 'NullDirection';
Table.Quantity(16).Type = 'NullNumTrials';
Table.Quantity(17).Type = 'NullCoh12';
Table.Quantity(18).Type = 'NullCoh31';
Table.Quantity(19).Type = 'NullCoh23';
Table.Quantity(20).Type = 'NullPartialCoh';
Table.Quantity(21).Type = 'TunedUnitS1';
Table.Quantity(22).Type = 'TunedUnitS2'; 
Table.Quantity(23).Type = 'TunedFieldS3'; 
Table.Quantity(24).Type = 'PrefNumTrials';
Table.Quantity(25).Type = 'PrefCoh12';
Table.Quantity(26).Type = 'PrefCoh31';
Table.Quantity(27).Type = 'PrefCoh23';
Table.Quantity(28).Type = 'PrefPartialCoh';
Table.Quantity(29).Type = 'NullNumTrials';
Table.Quantity(30).Type = 'NullCoh12';
Table.Quantity(31).Type = 'NullCoh31';
Table.Quantity(32).Type = 'NullCoh23';
Table.Quantity(33).Type = 'NullPartialCoh';
Table.Quantity(34).Type = 'TunedUnitS1';
Table.Quantity(35).Type = 'TunedUnitS2'; 
Table.Quantity(36).Type = 'TunedFieldS3'; 
Table.Quantity(37).Type = 'PrefNumTrials';
Table.Quantity(38).Type = 'PrefCoh12';
Table.Quantity(39).Type = 'PrefCoh31';
Table.Quantity(40).Type = 'PrefCoh23';
Table.Quantity(41).Type = 'PrefPartialCoh';
Table.Quantity(42).Type = 'NullNumTrials';
Table.Quantity(43).Type = 'NullCoh12';
Table.Quantity(44).Type = 'NullCoh31';
Table.Quantity(45).Type = 'NullCoh23';
Table.Quantity(46).Type = 'NullPartialCoh';

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
    
    Table.Quantity(10).CondParams{iSess} = CondParams;
    Table.Quantity(10).AnalParams{iSess} = AnalParams;
    Table.Quantity(11).CondParams{iSess} = CondParams;
    Table.Quantity(11).AnalParams{iSess} = AnalParams;
    Table.Quantity(12).CondParams{iSess} = CondParams;
    Table.Quantity(12).AnalParams{iSess} = AnalParams;
    Table.Quantity(13).CondParams{iSess} = CondParams;
    Table.Quantity(13).AnalParams{iSess} = AnalParams;
    Table.Quantity(14).CondParams{iSess} = CondParams;
    Table.Quantity(14).AnalParams{iSess} = AnalParams;
    Table.Quantity(16).CondParams{iSess} = CondParams;
    Table.Quantity(16).AnalParams{iSess} = AnalParams;
    Table.Quantity(17).CondParams{iSess} = CondParams;
    Table.Quantity(17).AnalParams{iSess} = AnalParams;
    Table.Quantity(18).CondParams{iSess} = CondParams;
    Table.Quantity(18).AnalParams{iSess} = AnalParams;
    Table.Quantity(19).CondParams{iSess} = CondParams;
    Table.Quantity(19).AnalParams{iSess} = AnalParams;
    Table.Quantity(20).CondParams{iSess} = CondParams;
    Table.Quantity(20).AnalParams{iSess} = AnalParams;
    
    clear CondParams1 AnalParams1
    CondParams1{1}.Field = 'TargsOn';
    CondParams1{1}.Task = 'MemoryReachSaccade';
    CondParams1{1}.bn = [0, 500];
    CondParams1{2} = CondParams1{1};
    CondParams1{1}.conds = {[Dir.Pref]};
    CondParams1{2}.conds = {[Dir.Null]};
    AnalParams1 = [];
    Table.Quantity(6).CondParams{iSess} = CondParams1;
    Table.Quantity(6).AnalParams{iSess} = AnalParams1;
    Table.Quantity(7).CondParams{iSess} = CondParams1;
    Table.Quantity(7).AnalParams{iSess} = AnalParams1;
    AnalParams1.Tapers = [.5,10];
    AnalParams1.fk = [10 20];
    Table.Quantity(8).CondParams{iSess} = CondParams1;
    Table.Quantity(8).AnalParams{iSess} = AnalParams1;
    
    
    task = 'MST';
    Dir = loadSessionDirections(Sess);
    panelDefn_PartialCoh
    CondParams(1,1).timeind = 5;
    CondParams(1,1).freqind = find(f>15,1);
    
    Table.Quantity(24).CondParams{iSess} = CondParams;
    Table.Quantity(24).AnalParams{iSess} = AnalParams;
    Table.Quantity(25).CondParams{iSess} = CondParams;
    Table.Quantity(25).AnalParams{iSess} = AnalParams;
    Table.Quantity(26).CondParams{iSess} = CondParams;
    Table.Quantity(26).AnalParams{iSess} = AnalParams;
    Table.Quantity(27).CondParams{iSess} = CondParams;
    Table.Quantity(27).AnalParams{iSess} = AnalParams;
    Table.Quantity(28).CondParams{iSess} = CondParams;
    Table.Quantity(28).AnalParams{iSess} = AnalParams;
    Table.Quantity(29).CondParams{iSess} = CondParams;
    Table.Quantity(29).AnalParams{iSess} = AnalParams;
    Table.Quantity(30).CondParams{iSess} = CondParams;
    Table.Quantity(30).AnalParams{iSess} = AnalParams;
    Table.Quantity(31).CondParams{iSess} = CondParams;
    Table.Quantity(31).AnalParams{iSess} = AnalParams;
    Table.Quantity(32).CondParams{iSess} = CondParams;
    Table.Quantity(32).AnalParams{iSess} = AnalParams;
    Table.Quantity(33).CondParams{iSess} = CondParams;
    Table.Quantity(33).AnalParams{iSess} = AnalParams;
    
    clear CondParams1 AnalParams1
    CondParams1{1}.Field = 'TargsOn';
    CondParams1{1}.Task = 'MemorySaccadeTouch';
    CondParams1{1}.bn = [0, 500];
    CondParams1{2} = CondParams1{1};
    CondParams1{1}.conds = {[Dir.Pref]};
    CondParams1{2}.conds = {[Dir.Null]};
    AnalParams1 = [];
    Table.Quantity(21).CondParams{iSess} = CondParams1;
    Table.Quantity(21).AnalParams{iSess} = AnalParams1;
    Table.Quantity(22).CondParams{iSess} = CondParams1;
    Table.Quantity(22).AnalParams{iSess} = AnalParams1;
    AnalParams1.Tapers = [.5,10];
    AnalParams1.fk = [10 20];
    Table.Quantity(23).CondParams{iSess} = CondParams1;
    Table.Quantity(23).AnalParams{iSess} = AnalParams1;

    
    task = '';
    Dir = loadSessionDirections(Sess);
    panelDefn_PartialCoh
    CondParams(1,1).timeind = 5;
    CondParams(1,1).freqind = find(f>15,1);
    
    Table.Quantity(37).CondParams{iSess} = CondParams;
    Table.Quantity(37).AnalParams{iSess} = AnalParams;
    Table.Quantity(38).CondParams{iSess} = CondParams;
    Table.Quantity(38).AnalParams{iSess} = AnalParams;
    Table.Quantity(39).CondParams{iSess} = CondParams;
    Table.Quantity(39).AnalParams{iSess} = AnalParams;
    Table.Quantity(40).CondParams{iSess} = CondParams;
    Table.Quantity(40).AnalParams{iSess} = AnalParams;
    Table.Quantity(41).CondParams{iSess} = CondParams;
    Table.Quantity(41).AnalParams{iSess} = AnalParams;
    Table.Quantity(42).CondParams{iSess} = CondParams;
    Table.Quantity(42).AnalParams{iSess} = AnalParams;
    Table.Quantity(43).CondParams{iSess} = CondParams;
    Table.Quantity(43).AnalParams{iSess} = AnalParams;
    Table.Quantity(44).CondParams{iSess} = CondParams;
    Table.Quantity(44).AnalParams{iSess} = AnalParams;
    Table.Quantity(45).CondParams{iSess} = CondParams;
    Table.Quantity(45).AnalParams{iSess} = AnalParams;
    Table.Quantity(46).CondParams{iSess} = CondParams;
    Table.Quantity(46).AnalParams{iSess} = AnalParams;
    
    clear CondParams1 AnalParams1
    CondParams1{1}.Field = 'TargsOn';
    CondParams1{1}.Task = {'MemoryReachSaccade','MemorySaccadeTouch'};
    CondParams1{1}.bn = [0, 500];
    CondParams1{2} = CondParams1{1};
    CondParams1{1}.conds = {[Dir.Pref]};
    CondParams1{2}.conds = {[Dir.Null]};
    AnalParams1 = [];
    Table.Quantity(34).CondParams{iSess} = CondParams1;
    Table.Quantity(34).AnalParams{iSess} = AnalParams1;
    Table.Quantity(35).CondParams{iSess} = CondParams1;
    Table.Quantity(35).AnalParams{iSess} = AnalParams1;
    AnalParams1.Tapers = [.5,10];
    AnalParams1.fk = [10 20];
    Table.Quantity(36).CondParams{iSess} = CondParams1;
    Table.Quantity(36).AnalParams{iSess} = AnalParams1;
    
end
















