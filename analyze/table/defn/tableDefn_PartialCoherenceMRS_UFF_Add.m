% Partial Coherence table panel
% Before calling, you need to set Session list, analysis ('LPL')
% and a list of the Monkeyname

global MONKEYNAME MONKEYDIR

clear Table
Table.Data.Sessions = Session; %Must be 3-part, and in this case UFF.
%Table.Data.Monkey = Monkey; %Must be 3-part, and in this case UFF.
Table.Data.Values = [];
Table.CondParams.Name = [analysis '_UFFPartialCoherenceMRS_add'];
Table.AnalParams = [];
NSess = length(Session);

% Set the names. There will be a calc function for each
% Or should I set simple ones here? It seems silly to have a function for
% each SessNum
Table.Quantity(1).Name = 'Monkey';
Table.Quantity(2).Name = 'SessNum1';
Table.Quantity(3).Name = 'SessNum2';
Table.Quantity(4).Name = 'SessNum3';
Table.Quantity(5).Name = 'MRSPrefBaselineFR_All';
Table.Quantity(6).Name = 'MRSPrefpostTOFR_All';
Table.Quantity(7).Name = 'MRSPrefpostTO500FR_All';
Table.Quantity(8).Name = 'MRSPrefpreGoFR_All';
Table.Quantity(9).Name = 'MRSNullBaselineFR_All';
Table.Quantity(10).Name = 'MRSNullpostTOFR_All';
Table.Quantity(11).Name = 'MRSNullpostTO500FR_All';
Table.Quantity(12).Name = 'MRSNullpreGoFR_All';
Table.Quantity(13).Name = 'MRSPrefCohF1_Unit_TO_All';
Table.Quantity(14).Name = 'MRSPrefCohF1_Unit1_Go_All';
Table.Quantity(15).Name = 'MRSPrefCohF2_Unit_TO_All';
Table.Quantity(16).Name = 'MRSPrefCohF2_Unit_Go_All';
Table.Quantity(17).Name = 'MRSPrefCohF1_F2_TO_All';
Table.Quantity(18).Name = 'MRSPrefCohF1_F2_Go_All';
Table.Quantity(19).Name = 'MRSPrefPartialCoh_TO_All';
Table.Quantity(20).Name = 'MRSPrefPartialCoh_Go_All';
Table.Quantity(21).Name = 'MRSNullCohF1_Unit_TO_All';
Table.Quantity(22).Name = 'MRSNullCohF1_Unit1_Go_All';
Table.Quantity(23).Name = 'MRSNullCohF2_Unit_TO_All';
Table.Quantity(24).Name = 'MRSNullCohF2_Unit_Go_All';
Table.Quantity(25).Name = 'MRSNullCohF1_F2_TO_All';
Table.Quantity(26).Name = 'MRSNullCohF1_F2_Go_All';
Table.Quantity(27).Name = 'MRSNullPartialCoh_TO_All';
Table.Quantity(28).Name = 'MRSNullPartialCoh_Go_All';
Table.Quantity(29).Name = 'MRSPrefF1SpecTO_All';
Table.Quantity(30).Name = 'MRSPrefF1SpecGo_All';
Table.Quantity(31).Name = 'MRSNullF1SpecTO_All';
Table.Quantity(32).Name = 'MRSNullF1SpecGo_All';
Table.Quantity(33).Name = 'MRSPrefF2SpecTO_All';
Table.Quantity(34).Name = 'MRSPrefF2SpecGo_All';
Table.Quantity(35).Name = 'MRSNullF2SpecTO_All';
Table.Quantity(36).Name = 'MRSNullF2SpecGo_All';
Table.Quantity(37).Name = 'PrefSigDiffCoh21v31_TO_All';
Table.Quantity(38).Name = 'PrefSigDiffCoh21v31_Go_All';


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
Table.Quantity(37).Type = 'PrefSigDiffCoh21v31';
Table.Quantity(38).Type = 'PrefSigDiffCoh21v31';


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
     
    task = 'MRS';
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
    Table.Quantity(5).CondParams{iSess} = CondParams1; %'MRSPrefBaselineFR_all'
    Table.Quantity(5).AnalParams{iSess} = AnalParams1;
    
    CondParams1.Field = 'TargsOn';
    CondParams1.bn = [0, 500];
    Table.Quantity(6).CondParams{iSess} = CondParams1; %'MRSPrefpostTOFR_All'
    Table.Quantity(6).AnalParams{iSess} = AnalParams1;
    
    CondParams1.bn = [500, 1000];
    Table.Quantity(7).CondParams{iSess} = CondParams1; %'MRSPrefpostTO500FR_All'
    Table.Quantity(7).AnalParams{iSess} = AnalParams1;
    
    CondParams1.Field = 'Go';
    CondParams1.bn = [-500, 0];
    Table.Quantity(8).CondParams{iSess} = CondParams1; %'MRSPrefpreGoFR_all'
    Table.Quantity(8).AnalParams{iSess} = AnalParams1;
    
    CondParams1.conds = {[Dir.Null]};
    CondParams1.Field = 'TargsOn';
    CondParams1.bn = [-500, 0];
    AnalParams1 = [];
    Table.Quantity(9).CondParams{iSess} = CondParams1; %'MRSNullBaselineFR_all'
    Table.Quantity(9).AnalParams{iSess} = AnalParams1;
    
    CondParams1.Field = 'TargsOn';
    CondParams1.bn = [0, 500];
    Table.Quantity(10).CondParams{iSess} = CondParams1; %'MRSNullpostTOFR_All'
    Table.Quantity(10).AnalParams{iSess} = AnalParams1;
    
    CondParams1.bn = [500, 1000];
    Table.Quantity(11).CondParams{iSess} = CondParams1; %'MRSNullpostTO500FR_All'
    Table.Quantity(11).AnalParams{iSess} = AnalParams;
    
    CondParams1.Field = 'Go';
    CondParams1.bn = [-500, 0];
    Table.Quantity(12).CondParams{iSess} = CondParams1; %'MRSNullpreGoFR_all'
    Table.Quantity(12).AnalParams{iSess} = AnalParams1;
    
    CondParams1 = CondParams;
    CondParams1(1).iPanel = 1; %Pref
    CondParams1(1).isubPanel = 1; %TargsOn
    Table.Quantity(13).CondParams{iSess} = CondParams1; %'MRSPrefCohF1_Unit_TO_All'

    CondParams1 = CondParams;
    CondParams1(1).iPanel = 1; %Pref
    CondParams1(1).isubPanel = 2; %Go
    Table.Quantity(14).CondParams{iSess} = CondParams1; %'MRSPrefCohF1_Unit1_Go_All'

    CondParams1 = CondParams;
    CondParams1(1).iPanel = 1; %Pref
    CondParams1(1).isubPanel = 1; %TargsOn
    Table.Quantity(15).CondParams{iSess} = CondParams1; %'MRSPrefCohF2_Unit_TO_All'

    CondParams1 = CondParams;
    CondParams1(1).iPanel = 1; %Pref
    CondParams1(1).isubPanel = 2; %Go
    Table.Quantity(16).CondParams{iSess} = CondParams1; %'MRSPrefCohF2_Unit1_Go_All'

    CondParams1 = CondParams;
    CondParams1(1).iPanel = 1; %Pref
    CondParams1(1).isubPanel = 1; %TargsOn
    Table.Quantity(17).CondParams{iSess} = CondParams1; %'MRSPrefCohF1_F2_TO_All'

    CondParams1 = CondParams;
    CondParams1(1).iPanel = 1; %Pref
    CondParams1(1).isubPanel = 2; %Go
    Table.Quantity(18).CondParams{iSess} = CondParams1; %'MRSPrefCohF1_F2_Go_All'

    CondParams1 = CondParams;
    CondParams1(1).iPanel = 1; %Pref
    CondParams1(1).isubPanel = 1; %TargsOn
    Table.Quantity(19).CondParams{iSess} = CondParams1; %'MRSPrefPartialCoh_TO_All'

    CondParams1 = CondParams;
    CondParams1(1).iPanel = 1; %Pref
    CondParams1(1).isubPanel = 2; %Go
    Table.Quantity(20).CondParams{iSess} = CondParams1; %'MRSPrefPartialCoh_Go_All'
    
    CondParams1 = CondParams;
    CondParams1(1).iPanel = 2; %Null
    CondParams1(1).isubPanel = 1; %TargsOn
    Table.Quantity(21).CondParams{iSess} = CondParams1; %'MRSNullCohF1_Unit_TO_All'

    CondParams1 = CondParams;
    CondParams1(1).iPanel = 2; %Null
    CondParams1(1).isubPanel = 2; %Go
    Table.Quantity(22).CondParams{iSess} = CondParams1; %'MRSNullCohF1_Unit1_Go_All'

    CondParams1 = CondParams;
    CondParams1(1).iPanel = 2; %Null
    CondParams1(1).isubPanel = 1; %TargsOn
    Table.Quantity(23).CondParams{iSess} = CondParams1; %'MRSNullCohF2_Unit_TO_All'

    CondParams1 = CondParams;
    CondParams1(1).iPanel = 2; %Null
    CondParams1(1).isubPanel = 2; %Go
    Table.Quantity(24).CondParams{iSess} = CondParams1; %'MRSNullCohF2_Unit1_Go_All'

    CondParams1 = CondParams;
    CondParams1(1).iPanel = 2; %Null
    CondParams1(1).isubPanel = 1; %TargsOn
    Table.Quantity(25).CondParams{iSess} = CondParams1; %'MRSNullCohF1_F2_TO_All'

    CondParams1 = CondParams;
    CondParams1(1).iPanel = 2; %Null
    CondParams1(1).isubPanel = 2; %Go
    Table.Quantity(26).CondParams{iSess} = CondParams1; %'MRSNullCohF1_F2_Go_All'

    CondParams1 = CondParams;
    CondParams1(1).iPanel = 2; %Null
    CondParams1(1).isubPanel = 1; %TargsOn
    Table.Quantity(27).CondParams{iSess} = CondParams1; %'MRSNullPartialCoh_TO_All'

    CondParams1 = CondParams(1);
    CondParams1(1).iPanel = 2; %Null
    CondParams1(1).isubPanel = 2; %Go
    Table.Quantity(28).CondParams{iSess} = CondParams1; %'MRSNullPartialCoh_Go_All'

    AnalParams1 = struct([]);  CondParams1 = struct([]);
    AnalParams1(1).bn = [-500, 1000];
    AnalParams1(1).threshfac = 25;
    AnalParams1(1).tapers = [.5,5];
    CondParams1(1).bn = [-500, 1000];
    CondParams1(1).conds = {[Dir.Pref]};
    CondParams1(1).Task = Task;
    CondParams1(1).Field = 'TargsOn';
    AnalParams1(1).Field = 'TargsOn';
    Table.Quantity(29).CondParams{iSess} = CondParams1; %'MRSPrefF1SpecTO'
    Table.Quantity(29).AnalParams{iSess} = AnalParams1;

    CondParams1(1).Field = 'Go';
    AnalParams1(1).Field = 'Go';
    Table.Quantity(30).CondParams{iSess} = CondParams1; %'MRSPrefF1SpecGo'
    Table.Quantity(30).AnalParams{iSess} = AnalParams1;

    CondParams1(1).conds = {[Dir.Null]};
    CondParams1(1).Field = 'TargsOn';
    AnalParams1(1).Field = 'TargsOn';
    Table.Quantity(31).CondParams{iSess} = CondParams1; %'MRSNullF1SpecTO'
    Table.Quantity(31).AnalParams{iSess} = AnalParams1;

    CondParams1(1).Field = 'Go';
    AnalParams1(1).Field = 'Go';
    Table.Quantity(32).CondParams{iSess} = CondParams1; %'MRSNullF1SpecGo'
    Table.Quantity(32).AnalParams{iSess} = AnalParams1;

    CondParams1(1).Field = 'TargsOn';
    AnalParams1(1).Field = 'TargsOn';
    Table.Quantity(33).CondParams{iSess} = CondParams1; %'MRSPrefF2SpecTO'
    Table.Quantity(33).AnalParams{iSess} = AnalParams1;

    CondParams1(1).Field = 'Go';
    AnalParams1(1).Field = 'Go';
    Table.Quantity(34).CondParams{iSess} = CondParams1; %'MRSPrefF2SpecGo'
    Table.Quantity(34).AnalParams{iSess} = AnalParams1;

    CondParams1(1).conds = {[Dir.Null]};
    CondParams1(1).Field = 'TargsOn';
    AnalParams1(1).Field = 'TargsOn';
    Table.Quantity(35).CondParams{iSess} = CondParams1; %'MRSNullF2SpecTO'
    Table.Quantity(35).AnalParams{iSess} = AnalParams1;

    CondParams1(1).Field = 'Go';
    AnalParams1(1).Field = 'Go';
    Table.Quantity(36).CondParams{iSess} = CondParams1; %'MRSNullF2SpecGo'
    Table.Quantity(36).AnalParams{iSess} = AnalParams1;

    panelDefn_DiffCohThreePartSess
    CondParams(1).iPanel = 1; %Pref
    CondParams(1).isubPanel = 1; %TargsOn
    CondParams(1,1).timeind = 1:30;
    CondParams(1,1).freqind = 1:204;
    Table.Quantity(37).CondParams{iSess} = CondParams;
    Table.Quantity(37).AnalParams{iSess} = AnalParams;

    CondParams(1).isubPanel = 2; %Go
    Table.Quantity(38).CondParams{iSess} = CondParams;
    Table.Quantity(38).AnalParams{iSess} = AnalParams;

end
















