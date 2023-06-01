% Partial Coherence table panel
% Before calling, you need to set Session list, analysis ('LPL')
% and a list of the Monkeyname

global MONKEYNAME MONKEYDIR

clear Table
Table.Data.Sessions = Session; %Must be 3-part, and in this case UFF.
%Table.Data.Monkey = Monkey; %Must be 3-part, and in this case UFF.
Table.Data.Values = [];
Table.CondParams.Name = [analysis '_UFFPartialCoherence_MST'];
Table.AnalParams = [];
NSess = length(Session);

% Set the names. There will be a calc function for each
% Or should I set simple ones here? It seems silly to have a function for
% each SessNum
Table.Quantity(1).Name = 'SessNum1';
Table.Quantity(2).Name = 'SessNum2';
Table.Quantity(3).Name = 'SessNum3';
Table.Quantity(4).Name = 'Area1';
Table.Quantity(5).Name = 'Area2';
Table.Quantity(6).Name = 'Area3';
Table.Quantity(7).Name = 'SingleUnit';
Table.Quantity(8).Name = 'BaselineFR';
Table.Quantity(9).Name = 'preGoFR';
Table.Quantity(10).Name = 'TunedUnitpostTO';
Table.Quantity(11).Name = 'TunedUnitpostTO500';
Table.Quantity(12).Name = 'TunedUnitpreGo';
Table.Quantity(13).Name = 'TunedField1postTO'; 
Table.Quantity(14).Name = 'TunedField1postTO500'; 
Table.Quantity(15).Name = 'TunedField1preGo'; 
Table.Quantity(16).Name = 'TunedField2postTO'; 
Table.Quantity(17).Name = 'TunedField2postTO500'; 
Table.Quantity(18).Name = 'TunedField2preGo'; 
Table.Quantity(19).Name = 'PrefDir';
Table.Quantity(20).Name = 'PrefNumTrials';
Table.Quantity(21).Name = 'PrefCohF1_Unit';
Table.Quantity(22).Name = 'PrefCohF2_Unit';
Table.Quantity(23).Name = 'PrefCohF1_F2';
Table.Quantity(24).Name = 'PrefPartialCoh';
Table.Quantity(25).Name = 'NullDir';
Table.Quantity(26).Name = 'NullNumTrials';
Table.Quantity(27).Name = 'NullSigCohF1_Unit';
Table.Quantity(28).Name = 'NullSigCohF2_Unit';
Table.Quantity(29).Name = 'NullSigCohF1_F2';
Table.Quantity(30).Name = 'NullSigPartialCoh';
Table.Quantity(31).Name = 'PrefTargsOnPSTH';
Table.Quantity(32).Name = 'PrefGoPSTH';
Table.Quantity(33).Name = 'NullTargsOnPSTH';
Table.Quantity(34).Name = 'NullGoPSTH';
Table.Quantity(35).Name = 'PrefSigCoh21';
Table.Quantity(36).Name = 'PrefSigCoh31';
Table.Quantity(37).Name = 'PrefSigCoh23';
Table.Quantity(38).Name = 'PrefSigPartialCoh';
Table.Quantity(39).Name = 'NullSigCoh21';
Table.Quantity(40).Name = 'NullSigCoh31';
Table.Quantity(41).Name = 'NullSigCoh23';
Table.Quantity(42).Name = 'NullSigPartialCoh';
Table.Quantity(43).Name = 'SameElectrodeF1_Unit';
Table.Quantity(44).Name = 'SameElectrodeF2_Unit';
Table.Quantity(45).Name = 'SpikeWaveform_tophalf';
Table.Quantity(46).Name = 'WaveformSNR';
Table.Quantity(47).Name = 'Monkey';
Table.Quantity(48).Name = 'TunedUnitpostGo';
Table.Quantity(49).Name = 'TunedField1postGo'; 
Table.Quantity(50).Name = 'TunedField2postGo'; 

% Does something as simple as SessNum need a type and calc function?
% I guess I do want to be able to simply loop through Quantities later.
Table.Quantity(1).Type = 'SessNum1';
Table.Quantity(2).Type = 'SessNum2';
Table.Quantity(3).Type = 'SessNum3';
Table.Quantity(4).Type = 'AreaS1';
Table.Quantity(5).Type = 'AreaS2';
Table.Quantity(6).Type = 'AreaS3';
Table.Quantity(7).Type = 'SingleUnitS1';
Table.Quantity(8).Type = 'FiringRateS1';
Table.Quantity(9).Type = 'FiringRateS1';
Table.Quantity(10).Type = 'TunedUnitS1';
Table.Quantity(11).Type = 'TunedUnitS1';
Table.Quantity(12).Type = 'TunedUnitS1';
Table.Quantity(13).Type = 'TunedFieldS2'; 
Table.Quantity(14).Type = 'TunedFieldS2'; 
Table.Quantity(15).Type = 'TunedFieldS2'; 
Table.Quantity(16).Type = 'TunedFieldS3'; 
Table.Quantity(17).Type = 'TunedFieldS3'; 
Table.Quantity(18).Type = 'TunedFieldS3'; 
Table.Quantity(19).Type = 'PrefDirection';
Table.Quantity(20).Type = 'NumTrials';
Table.Quantity(21).Type = 'Coh21';
Table.Quantity(22).Type = 'Coh31';
Table.Quantity(23).Type = 'Coh23';
Table.Quantity(24).Type = 'PartialCoh';
Table.Quantity(25).Type = 'NullDirection';
Table.Quantity(26).Type = 'NumTrials';
Table.Quantity(27).Type = 'Coh21';
Table.Quantity(28).Type = 'Coh31';
Table.Quantity(29).Type = 'Coh23';
Table.Quantity(30).Type = 'PartialCoh';
Table.Quantity(31).Type = 'PSTHS1';
Table.Quantity(32).Type = 'PSTHS1';
Table.Quantity(33).Type = 'PSTHS1';
Table.Quantity(34).Type = 'PSTHS1';
Table.Quantity(35).Type = 'SigCoh21';
Table.Quantity(36).Type = 'SigCoh31';
Table.Quantity(37).Type = 'SigCoh23';
Table.Quantity(38).Type = 'SigPartialCoh';
Table.Quantity(39).Type = 'SigCoh21';
Table.Quantity(40).Type = 'SigCoh31';
Table.Quantity(41).Type = 'SigCoh23';
Table.Quantity(42).Type = 'SigPartialCoh';
Table.Quantity(43).Type = 'SameElectrodeS1S2';
Table.Quantity(44).Type = 'SameElectrodeS1S3';
Table.Quantity(45).Type = 'SpikeWaveformS1';
Table.Quantity(46).Type = 'WaveformSNRS1';
Table.Quantity(47).Type = 'Monkey';
Table.Quantity(48).Type = 'TunedUnitS1';
Table.Quantity(49).Type = 'TunedFieldS2'; 
Table.Quantity(50).Type = 'TunedFieldS3'; 

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
    MONKEYNAME = Sess{7};
    MONKEYDIR = ['/mnt/raid/' MONKEYNAME];
    task = 'MST';
    Dir = loadSessionDirections(Sess);
    panelDefn_PartialCoh
    CondParams(1,1).timeind = 5;
    f = linspace(0,200,204);
    CondParams(1,1).freqind = find(f>15,1);
    
    for iQ = 1:length(Table.Quantity)
        Table.Quantity(iQ).CondParams{iSess} = CondParams;
        Table.Quantity(iQ).AnalParams{iSess} = AnalParams;
    end
    
    clear CondParams1 AnalParams1
    CondParams1{1}.Field = 'TargsOn';
    CondParams1{1}.Task = 'MemorySaccadeTouch';
    CondParams1{1}.bn = [0, 500];
    CondParams1{2} = CondParams1{1};
    CondParams1{1}.conds = {[Dir.Pref]};
    CondParams1{2}.conds = {[Dir.Null]};
    AnalParams1 = [];
    Table.Quantity(10).CondParams{iSess} = CondParams1;
    Table.Quantity(10).AnalParams{iSess} = AnalParams1;
    AnalParams1.Tapers = [.5,10];
    AnalParams1.fk = [10 20];
    Table.Quantity(13).CondParams{iSess} = CondParams1;
    Table.Quantity(13).AnalParams{iSess} = AnalParams1;
    Table.Quantity(16).CondParams{iSess} = CondParams1;
    Table.Quantity(16).AnalParams{iSess} = AnalParams1;
    CondParams1{1}.bn = [500, 1000];
    CondParams1{2}.bn = [500, 1000];
    Table.Quantity(11).CondParams{iSess} = CondParams1;
    Table.Quantity(11).AnalParams{iSess} = AnalParams1;
    Table.Quantity(14).CondParams{iSess} = CondParams1;
    Table.Quantity(14).AnalParams{iSess} = AnalParams1;
    Table.Quantity(17).CondParams{iSess} = CondParams1;
    Table.Quantity(17).AnalParams{iSess} = AnalParams1;
    CondParams1{1}.Field = 'Go';
    CondParams1{2}.Field = 'Go';
    CondParams1{1}.bn = [-500, 0];
    CondParams1{2}.bn = [-500, 0];
    Table.Quantity(12).CondParams{iSess} = CondParams1;
    Table.Quantity(12).AnalParams{iSess} = AnalParams1;
    Table.Quantity(15).CondParams{iSess} = CondParams1;
    Table.Quantity(15).AnalParams{iSess} = AnalParams1;
    Table.Quantity(18).CondParams{iSess} = CondParams1;
    Table.Quantity(18).AnalParams{iSess} = AnalParams1;
    CondParams1{1}.bn = [0, 500];
    CondParams1{2}.bn = [0, 500];
    Table.Quantity(48).CondParams{iSess} = CondParams1; %'TunedUnitpostGo'
    Table.Quantity(48).AnalParams{iSess} = AnalParams1;
    Table.Quantity(49).CondParams{iSess} = CondParams1; %'TunedField1postGo'
    Table.Quantity(49).AnalParams{iSess} = AnalParams1;
    Table.Quantity(50).CondParams{iSess} = CondParams1; %'TunedFieldpostGo'
    Table.Quantity(50).AnalParams{iSess} = AnalParams1;
       
    CondParams1 = [];
    CondParams1.Task = CondParams(1).Task;
    CondParams1.conds = {[Dir.Pref]};
    CondParams1.Field = 'TargsOn';
    CondParams1.Task = 'MemorySaccadeTouch';
    CondParams1.bn = [-500, 0];
    AnalParams = [];
    Table.Quantity(8).CondParams{iSess} = CondParams1;
    Table.Quantity(8).AnalParams{iSess} = AnalParams;
    
    CondParams1 = [];
    CondParams1.Task = CondParams(1).Task;
    CondParams1.conds = {[Dir.Pref]};
    CondParams1.Field = 'Go';
    CondParams1.Task = 'MemorySaccadeTouch';
    CondParams1.bn = [-500, 0];
    AnalParams = [];
    Table.Quantity(9).CondParams{iSess} = CondParams1;
    Table.Quantity(9).AnalParams{iSess} = AnalParams;
    
    CondParams1 = CondParams;
    CondParams1(1).iPanel = 1; %Pref
    CondParams1(1).isubPanel = 2; %Go
    Table.Quantity(20).CondParams{iSess} = CondParams1; %'PrefNumTrials'

    CondParams1 = CondParams;
    CondParams1(1).iPanel = 1; %Pref
    CondParams1(1).isubPanel = 2; %Go
    Table.Quantity(21).CondParams{iSess} = CondParams1; %'PrefCohF1_Unit'

    CondParams1 = CondParams;
    CondParams1(1).iPanel = 1; %Pref
    CondParams1(1).isubPanel = 2; %Go
    Table.Quantity(22).CondParams{iSess} = CondParams1; %'PrefCohF2_Unit'

    CondParams1 = CondParams;
    CondParams1(1).iPanel = 1; %Pref
    CondParams1(1).isubPanel = 2; %Go
    Table.Quantity(23).CondParams{iSess} = CondParams1; %'PrefCohF1_F2'

    CondParams1 = CondParams;
    CondParams1(1).iPanel = 1; %Pref
    CondParams1(1).isubPanel = 2; %Go
    Table.Quantity(24).CondParams{iSess} = CondParams1; %'PrefPartialCoh'

    CondParams1 = CondParams;
    CondParams1(1).iPanel = 2; %Null
    CondParams1(1).isubPanel = 2; %Go
    Table.Quantity(26).CondParams{iSess} = CondParams1; %'NullNumTrials'

    CondParams1 = CondParams;
    CondParams1(1).iPanel = 2; %Null
    CondParams1(1).isubPanel = 2; %Go
    Table.Quantity(27).CondParams{iSess} = CondParams1; %'NullCohF1_Unit'

    CondParams1 = CondParams;
    CondParams1(1).iPanel = 2; %Null
    CondParams1(1).isubPanel = 2; %Go
    Table.Quantity(28).CondParams{iSess} = CondParams1; %'NullCohF2_Unit'

    CondParams1 = CondParams;
    CondParams1(1).iPanel = 2; %Null
    CondParams1(1).isubPanel = 2; %Go
    Table.Quantity(29).CondParams{iSess} = CondParams1; %'NullCohF1_F2'

    CondParams1 = CondParams;
    CondParams1(1).iPanel = 2; %Null
    CondParams1(1).isubPanel = 2; %Go
    Table.Quantity(30).CondParams{iSess} = CondParams1; %'NullPartialCoh'
    
    CondParams1 = CondParams(1);
    CondParams1.Field = 'TargsOn';
    CondParams1.bn = [-500, 1000];
    Table.Quantity(31).CondParams{iSess} = CondParams1;
    Table.Quantity(31).AnalParams{iSess} = AnalParams;
    CondParams1.Field = 'Go';
    Table.Quantity(32).CondParams{iSess} = CondParams1;
    Table.Quantity(32).AnalParams{iSess} = AnalParams;

    CondParams1.conds = {[Dir.Null]};
    CondParams1.Field = 'TargsOn';
    CondParams1.bn = [-500, 1000];
    Table.Quantity(33).CondParams{iSess} = CondParams1;
    Table.Quantity(33).AnalParams{iSess} = AnalParams;
    CondParams1.Field = 'Go';
    Table.Quantity(34).CondParams{iSess} = CondParams1;
    Table.Quantity(34).AnalParams{iSess} = AnalParams;
    
    CondParams1 = CondParams;
    CondParams1(1).iPanel = 1; %Pref
    CondParams1(1).isubPanel = 2; %Go
    Table.Quantity(35).CondParams{iSess} = CondParams1; %'PrefSigCoh21'

    CondParams1 = CondParams;
    CondParams1(1).iPanel = 1; %Pref
    CondParams1(1).isubPanel = 2; %Go
    Table.Quantity(36).CondParams{iSess} = CondParams1; %'PrefSigCoh31'

    CondParams1 = CondParams;
    CondParams1(1).iPanel = 1; %Pref
    CondParams1(1).isubPanel = 2; %Go
    Table.Quantity(37).CondParams{iSess} = CondParams1; %'PrefSigCoh23'

    CondParams1 = CondParams;
    CondParams1(1).iPanel = 1; %Pref
    CondParams1(1).isubPanel = 2; %Go
    Table.Quantity(38).CondParams{iSess} = CondParams1; %'PrefSigPartialCoh'

    CondParams1 = CondParams;
    CondParams1(1).iPanel = 2; %Null
    CondParams1(1).isubPanel = 2; %Go
    Table.Quantity(39).CondParams{iSess} = CondParams1; %'NullSigCoh21'

    CondParams1 = CondParams;
    CondParams1(1).iPanel = 2; %Null
    CondParams1(1).isubPanel = 2; %Go
    Table.Quantity(40).CondParams{iSess} = CondParams1; %'NullSigCoh31'

    CondParams1 = CondParams;
    CondParams1(1).iPanel = 2; %Null
    CondParams1(1).isubPanel = 2; %Go
    Table.Quantity(41).CondParams{iSess} = CondParams1; %'NullSigCoh23'

    CondParams1 = CondParams;
    CondParams1(1).iPanel = 2; %Null
    CondParams1(1).isubPanel = 2; %Go
    Table.Quantity(42).CondParams{iSess} = CondParams1; %'NullSigPartialCoh'

    CondParams = [];
    CondParams.bn = [0 1/2];
    Table.Quantity(45).CondParams{iSess} = CondParams;
    Table.Quantity(45).AnalParams{iSess} = [];
end
















