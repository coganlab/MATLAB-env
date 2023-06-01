% Partial Coherence table panel
% Before calling, you need to set Session list, analysis ('LPL')
% and a list of the Monkeyname

global MONKEYNAME MONKEYDIR

clear Table
Table.Data.Sessions = Session; %Must be 3-part, and in this case UFF.
%Table.Data.Monkey = Monkey; %Must be 3-part, and in this case UFF.
Table.Data.Values = [];
Table.CondParams.Name = [analysis '_UFFPartialCoherenceMST_add'];
Table.AnalParams = [];
NSess = length(Session);

% Set the names. There will be a calc function for each
% Or should I set simple ones here? It seems silly to have a function for
% each SessNum
Table.Quantity(1).Name = 'Monkey';
Table.Quantity(2).Name = 'SessNum1';
Table.Quantity(3).Name = 'SessNum2';
Table.Quantity(4).Name = 'SessNum3';
Table.Quantity(5).Name = 'MSTPrefBaselineFR_All';
Table.Quantity(6).Name = 'MSTPrefpostTOFR_All';
Table.Quantity(7).Name = 'MSTPrefpostTO500FR_All';
Table.Quantity(8).Name = 'MSTPrefpreGoFR_All';
Table.Quantity(9).Name = 'MSTNullBaselineFR_All';
Table.Quantity(10).Name = 'MSTNullpostTOFR_All';
Table.Quantity(11).Name = 'MSTNullpostTO500FR_All';
Table.Quantity(12).Name = 'MSTNullpreGoFR_All';
Table.Quantity(13).Name = 'MSTPrefCohF1_Unit_TO_All';
Table.Quantity(14).Name = 'MSTPrefCohF1_Unit1_Go_All';
Table.Quantity(15).Name = 'MSTPrefCohF2_Unit_TO_All';
Table.Quantity(16).Name = 'MSTPrefCohF2_Unit_Go_All';
Table.Quantity(17).Name = 'MSTPrefCohF1_F2_TO_All';
Table.Quantity(18).Name = 'MSTPrefCohF1_F2_Go_All';
Table.Quantity(19).Name = 'MSTPrefPartialCoh_TO_All';
Table.Quantity(20).Name = 'MSTPrefPartialCoh_Go_All';
Table.Quantity(21).Name = 'MSTNullCohF1_Unit_TO_All';
Table.Quantity(22).Name = 'MSTNullCohF1_Unit1_Go_All';
Table.Quantity(23).Name = 'MSTNullCohF2_Unit_TO_All';
Table.Quantity(24).Name = 'MSTNullCohF2_Unit_Go_All';
Table.Quantity(25).Name = 'MSTNullCohF1_F2_TO_All';
Table.Quantity(26).Name = 'MSTNullCohF1_F2_Go_All';
Table.Quantity(27).Name = 'MSTNullPartialCoh_TO_All';
Table.Quantity(28).Name = 'MSTNullPartialCoh_Go_All';
Table.Quantity(29).Name = 'MSTPrefF1SpecTO_All';
Table.Quantity(30).Name = 'MSTPrefF1SpecGo_All';
Table.Quantity(31).Name = 'MSTNullF1SpecTO_All';
Table.Quantity(32).Name = 'MSTNullF1SpecGo_All';
Table.Quantity(33).Name = 'MSTPrefF2SpecTO_All';
Table.Quantity(34).Name = 'MSTPrefF2SpecGo_All';
Table.Quantity(35).Name = 'MSTNullF2SpecTO_All';
Table.Quantity(36).Name = 'MSTNullF2SpecGo_All';

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
     
    task = 'MST';
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
    Table.Quantity(5).CondParams{iSess} = CondParams1; %'MSTPrefBaselineFR_all'
    Table.Quantity(5).AnalParams{iSess} = AnalParams1;
    
    CondParams1.Field = 'TargsOn';
    CondParams1.bn = [0, 500];
    Table.Quantity(6).CondParams{iSess} = CondParams1; %'MSTPrefpostTOFR_All'
    Table.Quantity(6).AnalParams{iSess} = AnalParams1;
    
    CondParams1.bn = [500, 1000];
    Table.Quantity(7).CondParams{iSess} = CondParams1; %'MSTPrefpostTO500FR_All'
    Table.Quantity(7).AnalParams{iSess} = AnalParams1;
    
    CondParams1.Field = 'Go';
    CondParams1.bn = [-500, 0];
    Table.Quantity(8).CondParams{iSess} = CondParams1; %'MSTPrefpreGoFR_all'
    Table.Quantity(8).AnalParams{iSess} = AnalParams1;
    
    CondParams1.conds = {[Dir.Null]};
    CondParams1.Field = 'TargsOn';
    CondParams1.bn = [-500, 0];
    AnalParams1 = [];
    Table.Quantity(9).CondParams{iSess} = CondParams1; %'MSTNullBaselineFR_all'
    Table.Quantity(9).AnalParams{iSess} = AnalParams1;
    
    CondParams1.Field = 'TargsOn';
    CondParams1.bn = [0, 500];
    Table.Quantity(10).CondParams{iSess} = CondParams1; %'MSTNullpostTOFR_All'
    Table.Quantity(10).AnalParams{iSess} = AnalParams1;
    
    CondParams1.bn = [500, 1000];
    Table.Quantity(11).CondParams{iSess} = CondParams1; %'MSTNullpostTO500FR_All'
    Table.Quantity(11).AnalParams{iSess} = AnalParams;
    
    CondParams1.Field = 'Go';
    CondParams1.bn = [-500, 0];
    Table.Quantity(12).CondParams{iSess} = CondParams1; %'MSTNullpreGoFR_all'
    Table.Quantity(12).AnalParams{iSess} = AnalParams1;
    
    CondParams1 = CondParams;
    CondParams1(1).iPanel = 1; %Pref
    CondParams1(1).isubPanel = 1; %TargsOn
    Table.Quantity(13).CondParams{iSess} = CondParams1; %'MSTPrefCohF1_Unit_TO_All'

    CondParams1 = CondParams;
    CondParams1(1).iPanel = 1; %Pref
    CondParams1(1).isubPanel = 2; %Go
    Table.Quantity(14).CondParams{iSess} = CondParams1; %'MSTPrefCohF1_Unit1_Go_All'

    CondParams1 = CondParams;
    CondParams1(1).iPanel = 1; %Pref
    CondParams1(1).isubPanel = 1; %TargsOn
    Table.Quantity(15).CondParams{iSess} = CondParams1; %'MSTPrefCohF2_Unit_TO_All'

    CondParams1 = CondParams;
    CondParams1(1).iPanel = 1; %Pref
    CondParams1(1).isubPanel = 2; %Go
    Table.Quantity(16).CondParams{iSess} = CondParams1; %'MSTPrefCohF2_Unit1_Go_All'

    CondParams1 = CondParams;
    CondParams1(1).iPanel = 1; %Pref
    CondParams1(1).isubPanel = 1; %TargsOn
    Table.Quantity(17).CondParams{iSess} = CondParams1; %'MSTPrefCohF1_F2_TO_All'

    CondParams1 = CondParams;
    CondParams1(1).iPanel = 1; %Pref
    CondParams1(1).isubPanel = 2; %Go
    Table.Quantity(18).CondParams{iSess} = CondParams1; %'MSTPrefCohF1_F2_Go_All'

    CondParams1 = CondParams;
    CondParams1(1).iPanel = 1; %Pref
    CondParams1(1).isubPanel = 1; %TargsOn
    Table.Quantity(19).CondParams{iSess} = CondParams1; %'MSTPrefPartialCoh_TO_All'

    CondParams1 = CondParams;
    CondParams1(1).iPanel = 1; %Pref
    CondParams1(1).isubPanel = 2; %Go
    Table.Quantity(20).CondParams{iSess} = CondParams1; %'MSTPrefPartialCoh_Go_All'
    
    CondParams1 = CondParams;
    CondParams1(1).iPanel = 2; %Null
    CondParams1(1).isubPanel = 1; %TargsOn
    Table.Quantity(21).CondParams{iSess} = CondParams1; %'MSTNullCohF1_Unit_TO_All'

    CondParams1 = CondParams;
    CondParams1(1).iPanel = 2; %Null
    CondParams1(1).isubPanel = 2; %Go
    Table.Quantity(22).CondParams{iSess} = CondParams1; %'MSTNullCohF1_Unit1_Go_All'

    CondParams1 = CondParams;
    CondParams1(1).iPanel = 2; %Null
    CondParams1(1).isubPanel = 1; %TargsOn
    Table.Quantity(23).CondParams{iSess} = CondParams1; %'MSTNullCohF2_Unit_TO_All'

    CondParams1 = CondParams;
    CondParams1(1).iPanel = 2; %Null
    CondParams1(1).isubPanel = 2; %Go
    Table.Quantity(24).CondParams{iSess} = CondParams1; %'MSTNullCohF2_Unit1_Go_All'

    CondParams1 = CondParams;
    CondParams1(1).iPanel = 2; %Null
    CondParams1(1).isubPanel = 1; %TargsOn
    Table.Quantity(25).CondParams{iSess} = CondParams1; %'MSTNullCohF1_F2_TO_All'

    CondParams1 = CondParams;
    CondParams1(1).iPanel = 2; %Null
    CondParams1(1).isubPanel = 2; %Go
    Table.Quantity(26).CondParams{iSess} = CondParams1; %'MSTNullCohF1_F2_Go_All'

    CondParams1 = CondParams;
    CondParams1(1).iPanel = 2; %Null
    CondParams1(1).isubPanel = 1; %TargsOn
    Table.Quantity(27).CondParams{iSess} = CondParams1; %'MSTNullPartialCoh_TO_All'

    CondParams1 = CondParams(1);
    CondParams1(1).iPanel = 2; %Null
    CondParams1(1).isubPanel = 2; %Go
    Table.Quantity(28).CondParams{iSess} = CondParams1; %'MSTNullPartialCoh_Go_All'

    
    
    
    AnalParams1 = struct([]);  CondParams1 = struct([]);
    AnalParams1(1).bn = [-500, 1000];
    AnalParams1(1).threshfac = 25;
    AnalParams1(1).tapers = [.5,5];
    CondParams1(1).bn = [-500, 1000];
    CondParams1(1).conds = {[Dir.Pref]};
    CondParams1(1).Task = Task;
    CondParams1(1).Field = 'TargsOn';
    AnalParams1(1).Field = 'TargsOn';
    Table.Quantity(29).CondParams{iSess} = CondParams1; %'MSTPrefF1SpecTO'
    Table.Quantity(29).AnalParams{iSess} = AnalParams1;

    CondParams1(1).Field = 'Go';
    AnalParams1(1).Field = 'Go';
    Table.Quantity(30).CondParams{iSess} = CondParams1; %'MSTPrefF1SpecGo'
    Table.Quantity(30).AnalParams{iSess} = AnalParams1;

    CondParams1(1).conds = {[Dir.Null]};
    CondParams1(1).Field = 'TargsOn';
    AnalParams1(1).Field = 'TargsOn';
    Table.Quantity(31).CondParams{iSess} = CondParams1; %'MSTNullF1SpecTO'
    Table.Quantity(31).AnalParams{iSess} = AnalParams1;

    CondParams1(1).Field = 'Go';
    AnalParams1(1).Field = 'Go';
    Table.Quantity(32).CondParams{iSess} = CondParams1; %'MSTNullF1SpecGo'
    Table.Quantity(32).AnalParams{iSess} = AnalParams1;

    CondParams1(1).Field = 'TargsOn';
    AnalParams1(1).Field = 'TargsOn';
    Table.Quantity(33).CondParams{iSess} = CondParams1; %'MSTPrefF2SpecTO'
    Table.Quantity(33).AnalParams{iSess} = AnalParams1;

    CondParams1(1).Field = 'Go';
    AnalParams1(1).Field = 'Go';
    Table.Quantity(34).CondParams{iSess} = CondParams1; %'MSTPrefF2SpecGo'
    Table.Quantity(34).AnalParams{iSess} = AnalParams1;

    CondParams1(1).conds = {[Dir.Null]};
    CondParams1(1).Field = 'TargsOn';
    AnalParams1(1).Field = 'TargsOn';
    Table.Quantity(35).CondParams{iSess} = CondParams1; %'MSTNullF2SpecTO'
    Table.Quantity(35).AnalParams{iSess} = AnalParams1;

    CondParams1(1).Field = 'Go';
    AnalParams1(1).Field = 'Go';
    Table.Quantity(36).CondParams{iSess} = CondParams1; %'MSTNullF2SpecGo'
    Table.Quantity(36).AnalParams{iSess} = AnalParams1;
    
end
















