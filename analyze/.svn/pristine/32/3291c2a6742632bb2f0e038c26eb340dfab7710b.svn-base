% Partial Coherence table panel
% Before calling, you need to set Session list, analysis ('LPL')
% and a list of the Monkeyname

global MONKEYNAME MONKEYDIR

clear Table
Table.Data.Sessions = Session; %Must be 3-part, and in this case UFF.
%Table.Data.Monkey = Monkey; %Must be 3-part, and in this case UFF.
Table.Data.Values = [];
Table.CondParams.Name = [analysis '_UFFPartialCoherenceMem_add'];
Table.AnalParams = [];
NSess = length(Session);

% Set the names. There will be a calc function for each
% Or should I set simple ones here? It seems silly to have a function for
% each SessNum
Table.Quantity(1).Name = 'Monkey';
Table.Quantity(2).Name = 'SessNum1';
Table.Quantity(3).Name = 'SessNum2';
Table.Quantity(4).Name = 'SessNum3';
Table.Quantity(5).Name = 'BothPrefBaselineFR_All';
Table.Quantity(6).Name = 'BothPrefpostTOFR_All';
Table.Quantity(7).Name = 'BothPrefpostTO500FR_All';
Table.Quantity(8).Name = 'BothPrefpreGoFR_All';
Table.Quantity(9).Name = 'BothNullBaselineFR_All';
Table.Quantity(10).Name = 'BothNullpostTOFR_All';
Table.Quantity(11).Name = 'BothNullpostTO500FR_All';
Table.Quantity(12).Name = 'BothNullpreGoFR_All';
Table.Quantity(13).Name = 'BothPrefCohF1_Unit_TO_All';
Table.Quantity(14).Name = 'BothPrefCohF1_Unit1_Go_All';
Table.Quantity(15).Name = 'BothPrefCohF2_Unit_TO_All';
Table.Quantity(16).Name = 'BothPrefCohF2_Unit_Go_All';
Table.Quantity(17).Name = 'BothPrefCohF1_F2_TO_All';
Table.Quantity(18).Name = 'BothPrefCohF1_F2_Go_All';
Table.Quantity(19).Name = 'BothPrefPartialCoh_TO_All';
Table.Quantity(20).Name = 'BothPrefPartialCoh_Go_All';
Table.Quantity(21).Name = 'BothNullCohF1_Unit_TO_All';
Table.Quantity(22).Name = 'BothNullCohF1_Unit1_Go_All';
Table.Quantity(23).Name = 'BothNullCohF2_Unit_TO_All';
Table.Quantity(24).Name = 'BothNullCohF2_Unit_Go_All';
Table.Quantity(25).Name = 'BothNullCohF1_F2_TO_All';
Table.Quantity(26).Name = 'BothNullCohF1_F2_Go_All';
Table.Quantity(27).Name = 'BothNullPartialCoh_TO_All';
Table.Quantity(28).Name = 'BothNullPartialCoh_Go_All';
Table.Quantity(29).Name = 'BothPrefF1SpecTO';
Table.Quantity(30).Name = 'BothPrefF1SpecGo';
Table.Quantity(31).Name = 'BothNullF1SpecTO';
Table.Quantity(32).Name = 'BothNullF1SpecTO';
Table.Quantity(33).Name = 'BothPrefF2SpecTO';
Table.Quantity(34).Name = 'BothPrefF2SpecGo';
Table.Quantity(35).Name = 'BothNullF2SpecTO';
Table.Quantity(36).Name = 'BothNullF2SpecTO';


% Set up calc functions
Table.Quantity(1).Type = 'Monkey';
Table.Quantity(2).Type = 'SessNum1';
Table.Quantity(3).Type = 'SessNum2';
Table.Quantity(4).Type = 'SessNum3';
Table.Quantity(5).Type = 'AllFiringRatesS1';
Table.Quantity(6).Type = 'AllFiringRatesS1';
Table.Quantity(7).Type = 'AllFiringRatesS1';
Table.Quantity(8).Type = 'AllFiringRatesS1';
Table.Quantity(9).Type = 'AllFiringRatesS1';
Table.Quantity(10).Type = 'AllFiringRatesS1';
Table.Quantity(11).Type = 'AllFiringRatesS1';
Table.Quantity(12).Type = 'AllFiringRatesS1';
Table.Quantity(13).Type = 'Coh21';
Table.Quantity(14).Type = 'Coh21';
Table.Quantity(15).Type = 'Coh31';
Table.Quantity(16).Type = 'Coh31';
Table.Quantity(17).Type = 'Coh23';
Table.Quantity(18).Type = 'Coh23';
Table.Quantity(19).Type = 'PartialCoh';
Table.Quantity(20).Type = 'PartialCoh';
Table.Quantity(21).Type = 'Coh21';
Table.Quantity(22).Type = 'Coh21';
Table.Quantity(23).Type = 'Coh31';
Table.Quantity(24).Type = 'Coh31';
Table.Quantity(25).Type = 'Coh23';
Table.Quantity(26).Type = 'Coh23';
Table.Quantity(27).Type = 'PartialCoh';
Table.Quantity(28).Type = 'PartialCoh';
Table.Quantity(29).Type = 'SpectrumS2';
Table.Quantity(30).Type = 'SpectrumS2';
Table.Quantity(31).Type = 'SpectrumS2';
Table.Quantity(32).Type = 'SpectrumS2';
Table.Quantity(33).Type = 'SpectrumS3';
Table.Quantity(34).Type = 'SpectrumS3';
Table.Quantity(35).Type = 'SpectrumS3';
Table.Quantity(36).Type = 'SpectrumS3';


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
    Dir = loadSessionDirections(Sess);
     
    task = '';
    panelDefn_PartialCoh
    CondParams(1,1).timeind = 1:30;
    CondParams(1,1).freqind = 1:204;
    
    for iQ = 1:length(Table.Quantity)
        Table.Quantity(iQ).CondParams{iSess} = CondParams;
        Table.Quantity(iQ).AnalParams{iSess} = AnalParams;
    end    
    
    CondParams1 = [];
    CondParams1.conds = {[Dir.Pref]};
    CondParams1.Field = 'TargsOn';
    CondParams1.Task = 'MemoryReachSaccade';
    CondParams1.bn = [-500, 0];
    AnalParams1 = [];
    Table.Quantity(5).CondParams{iSess} = CondParams1; %'PrefBaselineFR_all'
    Table.Quantity(5).AnalParams{iSess} = AnalParams1;
    
    CondParams1.Field = 'TargsOn';
    CondParams1.bn = [0, 500];
    Table.Quantity(6).CondParams{iSess} = CondParams1; %'PrefpostTOFR_All'
    Table.Quantity(6).AnalParams{iSess} = AnalParams1;
    
    CondParams1.bn = [500, 1000];
    Table.Quantity(7).CondParams{iSess} = CondParams1; %'PrefpostTO500FR_All'
    Table.Quantity(7).AnalParams{iSess} = AnalParams1;
    
    CondParams1.Field = 'Go';
    CondParams1.bn = [-500, 0];
    Table.Quantity(8).CondParams{iSess} = CondParams1; %'PrefpreGoFR_all'
    Table.Quantity(8).AnalParams{iSess} = AnalParams1;
    
    CondParams1.conds = {[Dir.Null]};
    CondParams1.Field = 'TargsOn';
    CondParams1.bn = [-500, 0];
    AnalParams1 = [];
    Table.Quantity(9).CondParams{iSess} = CondParams1; %'NullBaselineFR_all'
    Table.Quantity(9).AnalParams{iSess} = AnalParams1;
    
    CondParams1.Field = 'TargsOn';
    CondParams1.bn = [0, 500];
    Table.Quantity(10).CondParams{iSess} = CondParams1; %'NullpostTOFR_All'
    Table.Quantity(10).AnalParams{iSess} = AnalParams1;
    
    CondParams1.bn = [500, 1000];
    Table.Quantity(11).CondParams{iSess} = CondParams1; %'NullpostTO500FR_All'
    Table.Quantity(11).AnalParams{iSess} = AnalParams;
    
    CondParams1.Field = 'Go';
    CondParams1.bn = [-500, 0];
    Table.Quantity(12).CondParams{iSess} = CondParams1; %'NullpreGoFR_all'
    Table.Quantity(12).AnalParams{iSess} = AnalParams1;
    
    CondParams1 = CondParams;
    CondParams1(1).iPanel = 1; %Pref
    CondParams1(1).isubPanel = 1; %TargsOn
    Table.Quantity(13).CondParams{iSess} = CondParams1; %'PrefCohF1_Unit_TO_All'

    CondParams1 = CondParams;
    CondParams1(1).iPanel = 1; %Pref
    CondParams1(1).isubPanel = 2; %Go
    Table.Quantity(14).CondParams{iSess} = CondParams1; %'PrefCohF1_Unit1_Go_All'

    CondParams1 = CondParams;
    CondParams1(1).iPanel = 1; %Pref
    CondParams1(1).isubPanel = 1; %TargsOn
    Table.Quantity(15).CondParams{iSess} = CondParams1; %'PrefCohF2_Unit_TO_All'

    CondParams1 = CondParams;
    CondParams1(1).iPanel = 1; %Pref
    CondParams1(1).isubPanel = 2; %Go
    Table.Quantity(16).CondParams{iSess} = CondParams1; %'PrefCohF2_Unit1_Go_All'

    CondParams1 = CondParams;
    CondParams1(1).iPanel = 1; %Pref
    CondParams1(1).isubPanel = 1; %TargsOn
    Table.Quantity(17).CondParams{iSess} = CondParams1; %'PrefCohF1_F2_TO_All'

    CondParams1 = CondParams;
    CondParams1(1).iPanel = 1; %Pref
    CondParams1(1).isubPanel = 2; %Go
    Table.Quantity(18).CondParams{iSess} = CondParams1; %'PrefCohF1_F2_Go_All'

    CondParams1 = CondParams;
    CondParams1(1).iPanel = 1; %Pref
    CondParams1(1).isubPanel = 1; %TargsOn
    Table.Quantity(19).CondParams{iSess} = CondParams1; %'PrefPartialCoh_TO_All'

    CondParams1 = CondParams;
    CondParams1(1).iPanel = 1; %Pref
    CondParams1(1).isubPanel = 2; %Go
    Table.Quantity(20).CondParams{iSess} = CondParams1; %'PrefPartialCoh_Go_All'
    
    CondParams1 = CondParams;
    CondParams1(1).iPanel = 2; %Null
    CondParams1(1).isubPanel = 1; %TargsOn
    Table.Quantity(21).CondParams{iSess} = CondParams1; %'NullCohF1_Unit_TO_All'

    CondParams1 = CondParams;
    CondParams1(1).iPanel = 2; %Null
    CondParams1(1).isubPanel = 2; %Go
    Table.Quantity(22).CondParams{iSess} = CondParams1; %'NullCohF1_Unit1_Go_All'

    CondParams1 = CondParams;
    CondParams1(1).iPanel = 2; %Null
    CondParams1(1).isubPanel = 1; %TargsOn
    Table.Quantity(23).CondParams{iSess} = CondParams1; %'NullCohF2_Unit_TO_All'

    CondParams1 = CondParams;
    CondParams1(1).iPanel = 2; %Null
    CondParams1(1).isubPanel = 2; %Go
    Table.Quantity(24).CondParams{iSess} = CondParams1; %'NullCohF2_Unit1_Go_All'

    CondParams1 = CondParams;
    CondParams1(1).iPanel = 2; %Null
    CondParams1(1).isubPanel = 1; %TargsOn
    Table.Quantity(25).CondParams{iSess} = CondParams1; %'NullCohF1_F2_TO_All'

    CondParams1 = CondParams;
    CondParams1(1).iPanel = 2; %Null
    CondParams1(1).isubPanel = 2; %Go
    Table.Quantity(26).CondParams{iSess} = CondParams1; %'NullCohF1_F2_Go_All'

    CondParams1 = CondParams;
    CondParams1(1).iPanel = 2; %Null
    CondParams1(1).isubPanel = 1; %TargsOn
    Table.Quantity(27).CondParams{iSess} = CondParams1; %'NullPartialCoh_TO_All'

    CondParams1 = CondParams(1);
    CondParams1(1).iPanel = 2; %Null
    CondParams1(1).isubPanel = 2; %Go
    Table.Quantity(28).CondParams{iSess} = CondParams1; %'NullPartialCoh_Go_All'

    AnalParams1 = struct([]);  CondParams1 = struct([]);
    AnalParams1(1).bn = [-500, 1000];
    AnalParams1(1).threshfac = 25;
    AnalParams1(1).tapers = [.5,5];
    CondParams1(1).bn = [-500, 1000];
    CondParams1(1).conds = {[Dir.Pref]};
    CondParams1(1).Task = Task;
    CondParams1(1).Field = 'TargsOn';
    AnalParams1(1).Field = 'TargsOn';
    Table.Quantity(29).CondParams{iSess} = CondParams1; %'PrefF1SpecTO'
    Table.Quantity(29).AnalParams{iSess} = AnalParams1;

    CondParams1(1).Field = 'Go';
    AnalParams1(1).Field = 'Go';
    Table.Quantity(30).CondParams{iSess} = CondParams1; %'PrefF1SpecGo'
    Table.Quantity(30).AnalParams{iSess} = AnalParams1;

    CondParams1(1).conds = {[Dir.Null]};
    CondParams1(1).Field = 'TargsOn';
    AnalParams1(1).Field = 'TargsOn';
    Table.Quantity(31).CondParams{iSess} = CondParams1; %'NullF1SpecTO'
    Table.Quantity(31).AnalParams{iSess} = AnalParams1;

    CondParams1(1).Field = 'Go';
    AnalParams1(1).Field = 'Go';
    Table.Quantity(32).CondParams{iSess} = CondParams1; %'NullF1SpecGo'
    Table.Quantity(32).AnalParams{iSess} = AnalParams1;

    CondParams1(1).Field = 'TargsOn';
    AnalParams1(1).Field = 'TargsOn';
    Table.Quantity(33).CondParams{iSess} = CondParams1; %'PrefF2SpecTO'
    Table.Quantity(33).AnalParams{iSess} = AnalParams1;

    CondParams1(1).Field = 'Go';
    AnalParams1(1).Field = 'Go';
    Table.Quantity(34).CondParams{iSess} = CondParams1; %'PrefF2SpecGo'
    Table.Quantity(34).AnalParams{iSess} = AnalParams1;

    CondParams1(1).conds = {[Dir.Null]};
    CondParams1(1).Field = 'TargsOn';
    AnalParams1(1).Field = 'TargsOn';
    Table.Quantity(35).CondParams{iSess} = CondParams1; %'NullF2SpecTO'
    Table.Quantity(35).AnalParams{iSess} = AnalParams1;

    CondParams1(1).Field = 'Go';
    AnalParams1(1).Field = 'Go';
    Table.Quantity(36).CondParams{iSess} = CondParams1; %'NullF2SpecGo'
    Table.Quantity(36).AnalParams{iSess} = AnalParams1;

end
















