% Partial Coherence table panel
% Before calling, you need to set Session list, analysis ('LPL')
% and a list of the Monkeyname

global MONKEYNAME MONKEYDIR

clear Table
Table.Data.Sessions = Session; %Must be 3-part, and in this case UUF.
Table.Data.Monkey = Monkey; %Must be 3-part, and in this case UUF.
Table.Data.Values = [];
Table.CondParams.Name = [analysis '_UUFPartialCoherence_MRS'];
Table.AnalParams = [];
NSess = length(Session);

% Set the names. There will be a calc function for each
Table.Quantity(1).Name = 'SessNum1';
Table.Quantity(2).Name = 'SessNum2';
Table.Quantity(3).Name = 'SessNum3';
Table.Quantity(4).Name = 'SingleUnit1';
Table.Quantity(5).Name = 'SingleUnit2';
Table.Quantity(6).Name = 'TunedUnit1';
Table.Quantity(7).Name = 'TunedUnit2'; 
Table.Quantity(8).Name = 'TunedField'; 
Table.Quantity(9).Name = 'PrefDir';
Table.Quantity(10).Name = 'PrefNumTrials';
Table.Quantity(11).Name = 'PrefCohU1U2';
Table.Quantity(12).Name = 'PrefCohU1F';
Table.Quantity(13).Name = 'PrefCohU2F';
Table.Quantity(14).Name = 'PrefPartialCoh';
Table.Quantity(15).Name = 'NullDir';
Table.Quantity(16).Name = 'NullNumTrials';
Table.Quantity(17).Name = 'NullCohU1U2';
Table.Quantity(18).Name = 'NullCohU2F';
Table.Quantity(19).Name = 'NullCohU2F';
Table.Quantity(20).Name = 'NullPartialCoh';

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
end
















