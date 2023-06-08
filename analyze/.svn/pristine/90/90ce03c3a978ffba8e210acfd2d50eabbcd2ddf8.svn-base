% Partial Coherence table panel
% Before calling, you need to set Session list, analysis ('LPL')
% and a list of the Monkeyname

global MONKEYNAME MONKEYDIR

clear Table
Table.Data.Sessions = Session; %Must be 3-part, and in this case UFF.
%Table.Data.Monkey = Monkey; %Must be 3-part, and in this case UFF.
Table.Data.Values = [];
Table.CondParams.Name = [analysis '_UFFPartialCoherence_nodiff'];
Table.AnalParams = [];
NSess = length(Session);

% Set the names. There will be a calc function for each
% Or should I set simple ones here? It seems silly to have a function for
% each SessNum
Table.Quantity(1).Name = 'Monkey';
Table.Quantity(2).Name = 'SessNum1';
Table.Quantity(3).Name = 'SessNum2';
Table.Quantity(4).Name = 'SessNum3';
Table.Quantity(5).Name = 'Area1';
Table.Quantity(6).Name = 'Area2';
Table.Quantity(7).Name = 'Area3';
Table.Quantity(8).Name = 'SingleUnit';
Table.Quantity(9).Name = 'SameElectrodeF1_Unit';
Table.Quantity(10).Name = 'SameElectrodeF2_Unit';
Table.Quantity(11).Name = 'PrefDir';
Table.Quantity(12).Name = 'NullDir';
Table.Quantity(13).Name = 'MRSBaselineFR';
Table.Quantity(14).Name = 'MRSpreGoFR';
Table.Quantity(15).Name = 'MRSTunedUnitpostTO';
Table.Quantity(16).Name = 'MRSTunedUnitpostTO500';
Table.Quantity(17).Name = 'MRSTunedUnitpreGo';
Table.Quantity(18).Name = 'MRSTunedField1postTO'; 
Table.Quantity(19).Name = 'MRSTunedField1postTO500'; 
Table.Quantity(20).Name = 'MRSTunedField1preGo'; 
Table.Quantity(21).Name = 'MRSTunedField2postTO'; 
Table.Quantity(22).Name = 'MRSTunedField2postTO500'; 
Table.Quantity(23).Name = 'MRSTunedField2preGo'; 
Table.Quantity(24).Name = 'MRSPrefNumTrials';
Table.Quantity(25).Name = 'MRSPrefCohF1_Unit';
Table.Quantity(26).Name = 'MRSPrefCohF2_Unit';
Table.Quantity(27).Name = 'MRSPrefCohF1_F2';
Table.Quantity(28).Name = 'MRSPrefPartialCoh';
Table.Quantity(29).Name = 'MRSNullNumTrials';
Table.Quantity(30).Name = 'MRSNullSigCohF1_Unit';
Table.Quantity(31).Name = 'MRSNullSigCohF2_Unit';
Table.Quantity(32).Name = 'MRSNullSigCohF1_F2';
Table.Quantity(33).Name = 'MRSNullSigPartialCoh';
Table.Quantity(34).Name = 'MRSPrefTargsOnPSTH';
Table.Quantity(35).Name = 'MRSPrefGoPSTH';
Table.Quantity(36).Name = 'MRSNullTargsOnPSTH';
Table.Quantity(37).Name = 'MRSNullGoPSTH';
Table.Quantity(38).Name = 'MRSPrefSigCoh21';
Table.Quantity(39).Name = 'MRSPrefSigCoh31';
Table.Quantity(40).Name = 'MRSPrefSigCoh23';
Table.Quantity(41).Name = 'MRSPrefSigPartialCoh';
Table.Quantity(42).Name = 'MRSNullSigCoh21';
Table.Quantity(43).Name = 'MRSNullSigCoh31';
Table.Quantity(44).Name = 'MRSNullSigCoh23';
Table.Quantity(45).Name = 'MRSNullSigPartialCoh';
%Table.Quantity(46).Name = 'MRSPrefSigDiffCoh21v31';
Table.Quantity(46).Name = 'Throwaway';
Table.Quantity(47).Name = 'SpikeWaveform_tophalf';
Table.Quantity(48).Name = 'WaveformSNR';

Table.Quantity(49).Name = 'MSTBaselineFR';
Table.Quantity(50).Name = 'MSTpreGoFR';
Table.Quantity(51).Name = 'MSTTunedUnitpostTO';
Table.Quantity(52).Name = 'MSTTunedUnitpostTO500';
Table.Quantity(53).Name = 'MSTTunedUnitpreGo';
Table.Quantity(54).Name = 'MSTTunedField1postTO'; 
Table.Quantity(55).Name = 'MSTTunedField1postTO500'; 
Table.Quantity(56).Name = 'MSTTunedField1preGo'; 
Table.Quantity(57).Name = 'MSTTunedField2postTO'; 
Table.Quantity(58).Name = 'MSTTunedField2postTO500'; 
Table.Quantity(59).Name = 'MSTTunedField2preGo'; 
Table.Quantity(60).Name = 'MSTPrefNumTrials';
Table.Quantity(61).Name = 'MSTPrefCohF1_Unit';
Table.Quantity(62).Name = 'MSTPrefCohF2_Unit';
Table.Quantity(63).Name = 'MSTPrefCohF1_F2';
Table.Quantity(64).Name = 'MSTPrefPartialCoh';
Table.Quantity(65).Name = 'MSTNullNumTrials';
Table.Quantity(66).Name = 'MSTNullSigCohF1_Unit';
Table.Quantity(67).Name = 'MSTNullSigCohF2_Unit';
Table.Quantity(68).Name = 'MSTNullSigCohF1_F2';
Table.Quantity(69).Name = 'MSTNullSigPartialCoh';
Table.Quantity(70).Name = 'MSTPrefTargsOnPSTH';
Table.Quantity(71).Name = 'MSTPrefGoPSTH';
Table.Quantity(72).Name = 'MSTNullTargsOnPSTH';
Table.Quantity(73).Name = 'MSTNullGoPSTH';
Table.Quantity(74).Name = 'MSTPrefSigCoh21';
Table.Quantity(75).Name = 'MSTPrefSigCoh31';
Table.Quantity(76).Name = 'MSTPrefSigCoh23';
Table.Quantity(77).Name = 'MSTPrefSigPartialCoh';
Table.Quantity(78).Name = 'MSTNullSigCoh21';
Table.Quantity(79).Name = 'MSTNullSigCoh31';
Table.Quantity(80).Name = 'MSTNullSigCoh23';
Table.Quantity(81).Name = 'MSTNullSigPartialCoh';
Table.Quantity(82).Name = 'MRSTunedUnitpostGo';
Table.Quantity(83).Name = 'MRSTunedField1postGo'; 
Table.Quantity(84).Name = 'MRSTunedField2postGo'; 
Table.Quantity(85).Name = 'MSTTunedUnitpostGo';
Table.Quantity(86).Name = 'MSTTunedField1postGo'; 
Table.Quantity(87).Name = 'MSTTunedField2postGo'; 

% Set up calc functions
Table.Quantity(1).Type = 'Monkey';
Table.Quantity(2).Type = 'SessNum1';
Table.Quantity(3).Type = 'SessNum2';
Table.Quantity(4).Type = 'SessNum3';
Table.Quantity(5).Type = 'AreaS1';
Table.Quantity(6).Type = 'AreaS2';
Table.Quantity(7).Type = 'AreaS3';
Table.Quantity(8).Type = 'SingleUnitS1';
Table.Quantity(9).Type = 'SameElectrodeS1S2';
Table.Quantity(10).Type = 'SameElectrodeS1S3';
Table.Quantity(11).Type = 'PrefDirection';
Table.Quantity(12).Type = 'NullDirection';
Table.Quantity(13).Type = 'FiringRateS1';
Table.Quantity(14).Type = 'FiringRateS1';
Table.Quantity(15).Type = 'TunedUnitS1';
Table.Quantity(16).Type = 'TunedUnitS1';
Table.Quantity(17).Type = 'TunedUnitS1';
Table.Quantity(18).Type = 'TunedFieldS2'; 
Table.Quantity(19).Type = 'TunedFieldS2'; 
Table.Quantity(20).Type = 'TunedFieldS2'; 
Table.Quantity(21).Type = 'TunedFieldS3'; 
Table.Quantity(22).Type = 'TunedFieldS3'; 
Table.Quantity(23).Type = 'TunedFieldS3'; 
Table.Quantity(24).Type = 'NumTrials';
Table.Quantity(25).Type = 'Coh21';
Table.Quantity(26).Type = 'Coh31';
Table.Quantity(27).Type = 'Coh23';
Table.Quantity(28).Type = 'PartialCoh';
Table.Quantity(29).Type = 'NumTrials';
Table.Quantity(30).Type = 'Coh21';
Table.Quantity(31).Type = 'Coh31';
Table.Quantity(32).Type = 'Coh23';
Table.Quantity(33).Type = 'PartialCoh';
Table.Quantity(34).Type = 'PSTHS1';
Table.Quantity(35).Type = 'PSTHS1';
Table.Quantity(36).Type = 'PSTHS1';
Table.Quantity(37).Type = 'PSTHS1';
Table.Quantity(38).Type = 'SigCoh21';
Table.Quantity(39).Type = 'SigCoh31';
Table.Quantity(40).Type = 'SigCoh23';
Table.Quantity(41).Type = 'SigPartialCoh';
Table.Quantity(42).Type = 'SigCoh21';
Table.Quantity(43).Type = 'SigCoh31';
Table.Quantity(44).Type = 'SigCoh23';
Table.Quantity(45).Type = 'SigPartialCoh';
%Table.Quantity(46).Type = 'PrefSigDiffCoh21v31';
Table.Quantity(46).Type = 'Monkey';
Table.Quantity(47).Type = 'SpikeWaveformS1';
Table.Quantity(48).Type = 'WaveformSNRS1';

Table.Quantity(49).Type = 'FiringRateS1';
Table.Quantity(50).Type = 'FiringRateS1';
Table.Quantity(51).Type = 'TunedUnitS1';
Table.Quantity(52).Type = 'TunedUnitS1';
Table.Quantity(53).Type = 'TunedUnitS1';
Table.Quantity(54).Type = 'TunedFieldS2'; 
Table.Quantity(55).Type = 'TunedFieldS2'; 
Table.Quantity(56).Type = 'TunedFieldS2'; 
Table.Quantity(57).Type = 'TunedFieldS3'; 
Table.Quantity(58).Type = 'TunedFieldS3'; 
Table.Quantity(59).Type = 'TunedFieldS3'; 
Table.Quantity(60).Type = 'NumTrials';
Table.Quantity(61).Type = 'Coh21';
Table.Quantity(62).Type = 'Coh31';
Table.Quantity(63).Type = 'Coh23';
Table.Quantity(64).Type = 'PartialCoh';
Table.Quantity(65).Type = 'NumTrials';
Table.Quantity(66).Type = 'Coh21';
Table.Quantity(67).Type = 'Coh31';
Table.Quantity(68).Type = 'Coh23';
Table.Quantity(69).Type = 'PartialCoh';
Table.Quantity(70).Type = 'PSTHS1';
Table.Quantity(71).Type = 'PSTHS1';
Table.Quantity(72).Type = 'PSTHS1';
Table.Quantity(73).Type = 'PSTHS1';
Table.Quantity(74).Type = 'SigCoh21';
Table.Quantity(75).Type = 'SigCoh31';
Table.Quantity(76).Type = 'SigCoh23';
Table.Quantity(77).Type = 'SigPartialCoh';
Table.Quantity(78).Type = 'SigCoh21';
Table.Quantity(79).Type = 'SigCoh31';
Table.Quantity(80).Type = 'SigCoh23';
Table.Quantity(81).Type = 'SigPartialCoh';
Table.Quantity(82).Type = 'TunedUnitS1';
Table.Quantity(83).Type = 'TunedFieldS2'; 
Table.Quantity(84).Type = 'TunedFieldS3'; 
Table.Quantity(85).Type = 'TunedUnitS1';
Table.Quantity(86).Type = 'TunedFieldS2'; 
Table.Quantity(87).Type = 'TunedFieldS3'; 

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
    CondParams(1,1).timeind = 5;
    f = linspace(0,200,204);
    CondParams(1,1).freqind = find(f>15,1);
    
    for iQ = 1:48
        Table.Quantity(iQ).CondParams{iSess} = CondParams;
        Table.Quantity(iQ).AnalParams{iSess} = AnalParams;
    end
    
    CondParams1 = [];
    CondParams1.conds = {[Dir.Pref]};
    CondParams1.Field = 'TargsOn';
    CondParams1.Task = 'MemoryReachSaccade';
    CondParams1.bn = [-500, 0];
    AnalParams = [];
    Table.Quantity(13).CondParams{iSess} = CondParams1; %'MRSBaselineFR'
    Table.Quantity(13).AnalParams{iSess} = AnalParams;
    
    CondParams1 = [];
    CondParams1.conds = {[Dir.Pref]};
    CondParams1.Field = 'Go';
    CondParams1.Task = 'MemoryReachSaccade';
    CondParams1.bn = [-500, 0];
    AnalParams = [];
    Table.Quantity(14).CondParams{iSess} = CondParams1; %'MRSpreGoFR'
    Table.Quantity(14).AnalParams{iSess} = AnalParams;   
    
    clear CondParams1 AnalParams1
    CondParams1{1}.Field = 'TargsOn';
    CondParams1{1}.Task = 'MemoryReachSaccade';
    CondParams1{1}.bn = [0, 500];
    CondParams1{2} = CondParams1{1};
    CondParams1{1}.conds = {[Dir.Pref]};
    CondParams1{2}.conds = {[Dir.Null]};
    AnalParams1 = [];
    Table.Quantity(15).CondParams{iSess} = CondParams1; %'MRSTunedUnitpostTO'
    Table.Quantity(15).AnalParams{iSess} = AnalParams1;
    AnalParams1.Tapers = [.5,10];
    AnalParams1.fk = [10 20];
    Table.Quantity(18).CondParams{iSess} = CondParams1; %'MRSTunedField1postTO'
    Table.Quantity(18).AnalParams{iSess} = AnalParams1;
    Table.Quantity(21).CondParams{iSess} = CondParams1; %'MRSTunedField2postTO
    Table.Quantity(21).AnalParams{iSess} = AnalParams1;
    CondParams1{1}.bn = [500, 1000];
    CondParams1{2}.bn = [500, 1000];
    Table.Quantity(16).CondParams{iSess} = CondParams1; %'MRSTunedUnitpostTO500'
    Table.Quantity(16).AnalParams{iSess} = AnalParams1;
    Table.Quantity(19).CondParams{iSess} = CondParams1; %'MRSTunedField1postTO500'
    Table.Quantity(19).AnalParams{iSess} = AnalParams1;
    Table.Quantity(22).CondParams{iSess} = CondParams1; %'MRSTunedFieldpostTO500'
    Table.Quantity(22).AnalParams{iSess} = AnalParams1;
    CondParams1{1}.Field = 'Go';
    CondParams1{2}.Field = 'Go';
    CondParams1{1}.bn = [-500, 0];
    CondParams1{2}.bn = [-500, 0];
    Table.Quantity(17).CondParams{iSess} = CondParams1; %'MRSTunedUnitpreGo'
    Table.Quantity(17).AnalParams{iSess} = AnalParams1;
    Table.Quantity(20).CondParams{iSess} = CondParams1; %'MRSTunedField1preGo'
    Table.Quantity(20).AnalParams{iSess} = AnalParams1;
    Table.Quantity(23).CondParams{iSess} = CondParams1; %'MRSTunedFieldpreGo'
    Table.Quantity(23).AnalParams{iSess} = AnalParams1;
    CondParams1{1}.bn = [0, 500];
    CondParams1{2}.bn = [0, 500];
    Table.Quantity(82).CondParams{iSess} = CondParams1; %'MRSTunedUnitpostGo'
    Table.Quantity(82).AnalParams{iSess} = AnalParams1;
    Table.Quantity(83).CondParams{iSess} = CondParams1; %'MRSTunedField1postGo'
    Table.Quantity(83).AnalParams{iSess} = AnalParams1;
    Table.Quantity(84).CondParams{iSess} = CondParams1; %'MRSTunedFieldpostGo'
    Table.Quantity(84).AnalParams{iSess} = AnalParams1;
     
    CondParams1 = CondParams;
    CondParams1(1).iPanel = 1; %Pref
    CondParams1(1).isubPanel = 2; %Go
    Table.Quantity(24).CondParams{iSess} = CondParams1; %'MRSPrefNumTrials'

    CondParams1 = CondParams;
    CondParams1(1).iPanel = 1; %Pref
    CondParams1(1).isubPanel = 2; %Go
    Table.Quantity(25).CondParams{iSess} = CondParams1; %'MRSPrefCohF1_Unit'

    CondParams1 = CondParams;
    CondParams1(1).iPanel = 1; %Pref
    CondParams1(1).isubPanel = 2; %Go
    Table.Quantity(26).CondParams{iSess} = CondParams1; %'MRSPrefCohF2_Unit'

    CondParams1 = CondParams;
    CondParams1(1).iPanel = 1; %Pref
    CondParams1(1).isubPanel = 2; %Go
    Table.Quantity(27).CondParams{iSess} = CondParams1; %'MRSPrefCohF1_F2'

    CondParams1 = CondParams;
    CondParams1(1).iPanel = 1; %Pref
    CondParams1(1).isubPanel = 2; %Go
    Table.Quantity(28).CondParams{iSess} = CondParams1; %'MRSPrefPartialCoh'

    CondParams1 = CondParams;
    CondParams1(1).iPanel = 2; %Null
    CondParams1(1).isubPanel = 2; %Go
    Table.Quantity(29).CondParams{iSess} = CondParams1; %'MRSNullNumTrials'

    CondParams1 = CondParams;
    CondParams1(1).iPanel = 2; %Null
    CondParams1(1).isubPanel = 2; %Go
    Table.Quantity(30).CondParams{iSess} = CondParams1; %'MRSNullCohF1_Unit'

    CondParams1 = CondParams;
    CondParams1(1).iPanel = 2; %Null
    CondParams1(1).isubPanel = 2; %Go
    Table.Quantity(31).CondParams{iSess} = CondParams1; %'MRSNullCohF2_Unit'

    CondParams1 = CondParams;
    CondParams1(1).iPanel = 2; %Null
    CondParams1(1).isubPanel = 2; %Go
    Table.Quantity(32).CondParams{iSess} = CondParams1; %'MRSNullCohF1_F2'

    CondParams1 = CondParams;
    CondParams1(1).iPanel = 2; %Null
    CondParams1(1).isubPanel = 2; %Go
    Table.Quantity(33).CondParams{iSess} = CondParams1; %'MRSNullPartialCoh'
    
    CondParams1 = [];
    CondParams1.Task = CondParams(1).Task;
    CondParams1.Field = 'TargsOn';
    CondParams1.bn = [-500, 1000];
    Table.Quantity(34).CondParams{iSess} = CondParams1; %'MRSPrefTargsOnPSTH'
    Table.Quantity(34).AnalParams{iSess} = AnalParams;
    CondParams1.Field = 'Go';
    Table.Quantity(35).CondParams{iSess} = CondParams1; %'MRSPrefGoPSTH'
    Table.Quantity(35).AnalParams{iSess} = AnalParams;

    CondParams1 = [];
    CondParams1.Task = CondParams(1).Task;
    CondParams1.conds = {[Dir.Null]};
    CondParams1.Field = 'TargsOn';
    CondParams1.bn = [-500, 1000];
    Table.Quantity(36).CondParams{iSess} = CondParams1; %'MRSNullTargsOnPSTH'
    Table.Quantity(36).AnalParams{iSess} = AnalParams;
    CondParams1.Field = 'Go';
    Table.Quantity(37).CondParams{iSess} = CondParams1; %'MRSNullGoPSTH'
    Table.Quantity(37).AnalParams{iSess} = AnalParams;
   
    CondParams1 = CondParams;
    CondParams1(1).iPanel = 1; %Pref
    CondParams1(1).isubPanel = 2; %Go
    Table.Quantity(38).CondParams{iSess} = CondParams1; %'MRSPrefSigCoh21'

    CondParams1 = CondParams;
    CondParams1(1).iPanel = 1; %Pref
    CondParams1(1).isubPanel = 2; %Go
    Table.Quantity(39).CondParams{iSess} = CondParams1; %'MRSPrefSigCoh31'

    CondParams1 = CondParams;
    CondParams1(1).iPanel = 1; %Pref
    CondParams1(1).isubPanel = 2; %Go
    Table.Quantity(40).CondParams{iSess} = CondParams1; %'MRSPrefSigCoh23'

    CondParams1 = CondParams;
    CondParams1(1).iPanel = 1; %Pref
    CondParams1(1).isubPanel = 2; %Go
    Table.Quantity(41).CondParams{iSess} = CondParams1; %'MRSPrefSigPartialCoh'

    CondParams1 = CondParams;
    CondParams1(1).iPanel = 2; %Null
    CondParams1(1).isubPanel = 2; %Go
    Table.Quantity(42).CondParams{iSess} = CondParams1; %'MRSNullSigCoh21'

    CondParams1 = CondParams;
    CondParams1(1).iPanel = 2; %Null
    CondParams1(1).isubPanel = 2; %Go
    Table.Quantity(43).CondParams{iSess} = CondParams1; %'MRSNullSigCoh31'

    CondParams1 = CondParams;
    CondParams1(1).iPanel = 2; %Null
    CondParams1(1).isubPanel = 2; %Go
    Table.Quantity(44).CondParams{iSess} = CondParams1; %'MRSNullSigCoh23'

    CondParams1 = CondParams;
    CondParams1(1).iPanel = 2; %Null
    CondParams1(1).isubPanel = 2; %Go
    Table.Quantity(45).CondParams{iSess} = CondParams1; %'MRSNullSigPartialCoh'

%     panelDefn_DiffCohThreePartSess
%     CondParams(1,1).timeind = 5;
%     CondParams(1,1).freqind = 16;
%     Table.Quantity(46).CondParams{iSess} = CondParams; %'MRSPrefSigDiffCoh21v31'
%     Table.Quantity(46).AnalParams{iSess} = AnalParams;   
    
    CondParams1 = [];
    CondParams1.bn = [0 1/2];
    Table.Quantity(47).CondParams{iSess} = CondParams1; %'WaveformS1'
    Table.Quantity(47).AnalParams{iSess} = [];
    
    Table.Quantity(48).CondParams{iSess} = []; %'WaveformSNRS1'
    Table.Quantity(48).AnalParams{iSess} = [];
    
    %-----------------------------
    %Set up MST
    
    task = 'MST';
    panelDefn_PartialCoh
    CondParams(1,1).timeind = 5;
    CondParams(1,1).freqind = find(f>15,1);
    
    for iQ = 49:81 %length(Table.Quantity)
        Table.Quantity(iQ).CondParams{iSess} = CondParams;
        Table.Quantity(iQ).AnalParams{iSess} = AnalParams;
    end
    
    CondParams1 = [];
    CondParams1.Task = CondParams(1).Task;
    CondParams1.conds = {[Dir.Pref]};
    CondParams1.Field = 'TargsOn';
    CondParams1.Task = 'MemoryReachSaccade';
    CondParams1.bn = [-500, 0];
    AnalParams = [];
    Table.Quantity(49).CondParams{iSess} = CondParams1; %'MSTBaselineFR'
    Table.Quantity(49).AnalParams{iSess} = AnalParams;
    
    CondParams1 = [];
    CondParams1.Task = CondParams(1).Task;
    CondParams1.conds = {[Dir.Pref]};
    CondParams1.Field = 'Go';
    CondParams1.Task = 'MemoryReachSaccade';
    CondParams1.bn = [-500, 0];
    AnalParams = [];
    Table.Quantity(50).CondParams{iSess} = CondParams1; %'MSTpreGoFR'
    Table.Quantity(50).AnalParams{iSess} = AnalParams;
        
    clear CondParams1 AnalParams1
    CondParams1{1}.Field = 'TargsOn';
    CondParams1{1}.Task = 'MemorySaccadeTouch';
    CondParams1{1}.bn = [0, 500];
    CondParams1{2} = CondParams1{1};
    CondParams1{1}.conds = {[Dir.Pref]};
    CondParams1{2}.conds = {[Dir.Null]};
    AnalParams1 = [];
    Table.Quantity(51).CondParams{iSess} = CondParams1; %'MSTTunedUnitpostTO'
    Table.Quantity(51).AnalParams{iSess} = AnalParams1;
    AnalParams1.Tapers = [.5,10];
    AnalParams1.fk = [10 20];
    Table.Quantity(54).CondParams{iSess} = CondParams1; %'MSTTunedField1postTO'
    Table.Quantity(54).AnalParams{iSess} = AnalParams1;
    Table.Quantity(57).CondParams{iSess} = CondParams1; %'MSTTunedField2postTO
    Table.Quantity(57).AnalParams{iSess} = AnalParams1;
    CondParams1{1}.bn = [500, 1000];
    CondParams1{2}.bn = [500, 1000];
    Table.Quantity(52).CondParams{iSess} = CondParams1; %'MSTTunedUnitpostTO500'
    Table.Quantity(52).AnalParams{iSess} = AnalParams1;
    Table.Quantity(55).CondParams{iSess} = CondParams1; %'MSTTunedField1postTO500'
    Table.Quantity(55).AnalParams{iSess} = AnalParams1;
    Table.Quantity(58).CondParams{iSess} = CondParams1; %'MSTTunedField2postTO500'
    Table.Quantity(58).AnalParams{iSess} = AnalParams1;
    CondParams1{1}.Field = 'Go';
    CondParams1{2}.Field = 'Go';
    CondParams1{1}.bn = [-500, 0];
    CondParams1{2}.bn = [-500, 0];
    Table.Quantity(53).CondParams{iSess} = CondParams1; %'MSTTunedUnitpreGo'
    Table.Quantity(53).AnalParams{iSess} = AnalParams1;
    Table.Quantity(56).CondParams{iSess} = CondParams1; %'MSTTunedField1preGo'
    Table.Quantity(56).AnalParams{iSess} = AnalParams1;
    Table.Quantity(59).CondParams{iSess} = CondParams1; %'MSTTunedFieldpreGo'
    Table.Quantity(59).AnalParams{iSess} = AnalParams1;
    CondParams1{1}.bn = [0, 500];
    CondParams1{2}.bn = [0, 500];
    Table.Quantity(85).CondParams{iSess} = CondParams1; %'MSTTunedUnitpostGo'
    Table.Quantity(85).AnalParams{iSess} = AnalParams1;
    Table.Quantity(86).CondParams{iSess} = CondParams1; %'MSTTunedField1postGo'
    Table.Quantity(86).AnalParams{iSess} = AnalParams1;
    Table.Quantity(87).CondParams{iSess} = CondParams1; %'MSTTunedFieldpostGo'
    Table.Quantity(87).AnalParams{iSess} = AnalParams1;
        
    CondParams1 = CondParams;
    CondParams1(1).iPanel = 1; %Pref
    CondParams1(1).isubPanel = 2; %Go
    Table.Quantity(60).CondParams{iSess} = CondParams1; %'MSTPrefNumTrials'

    CondParams1 = CondParams;
    CondParams1(1).iPanel = 1; %Pref
    CondParams1(1).isubPanel = 2; %Go
    Table.Quantity(61).CondParams{iSess} = CondParams1; %'MSTPrefCohF1_Unit'

    CondParams1 = CondParams;
    CondParams1(1).iPanel = 1; %Pref
    CondParams1(1).isubPanel = 2; %Go
    Table.Quantity(62).CondParams{iSess} = CondParams1; %'MSTPrefCohF2_Unit'

    CondParams1 = CondParams;
    CondParams1(1).iPanel = 1; %Pref
    CondParams1(1).isubPanel = 2; %Go
    Table.Quantity(63).CondParams{iSess} = CondParams1; %'MSTPrefCohF1_F2'

    CondParams1 = CondParams;
    CondParams1(1).iPanel = 1; %Pref
    CondParams1(1).isubPanel = 2; %Go
    Table.Quantity(64).CondParams{iSess} = CondParams1; %'MSTPrefPartialCoh'

    CondParams1 = CondParams;
    CondParams1(1).iPanel = 2; %Null
    CondParams1(1).isubPanel = 2; %Go
    Table.Quantity(65).CondParams{iSess} = CondParams1; %'MSTNullNumTrials'

    CondParams1 = CondParams;
    CondParams1(1).iPanel = 2; %Null
    CondParams1(1).isubPanel = 2; %Go
    Table.Quantity(66).CondParams{iSess} = CondParams1; %'MSTNullCohF1_Unit'

    CondParams1 = CondParams;
    CondParams1(1).iPanel = 2; %Null
    CondParams1(1).isubPanel = 2; %Go
    Table.Quantity(67).CondParams{iSess} = CondParams1; %'MSTNullCohF2_Unit'

    CondParams1 = CondParams;
    CondParams1(1).iPanel = 2; %Null
    CondParams1(1).isubPanel = 2; %Go
    Table.Quantity(68).CondParams{iSess} = CondParams1; %'MSTNullCohF1_F2'

    CondParams1 = CondParams;
    CondParams1(1).iPanel = 2; %Null
    CondParams1(1).isubPanel = 2; %Go
    Table.Quantity(69).CondParams{iSess} = CondParams1; %'MSTNullPartialCoh'
    
    CondParams1 = [];
    CondParams1.Task = CondParams(1).Task;
    CondParams1.Field = 'TargsOn';
    CondParams1.bn = [-500, 1000];
    Table.Quantity(70).CondParams{iSess} = CondParams1; %'MSTPrefTargsOnPSTH'
    Table.Quantity(70).AnalParams{iSess} = AnalParams1;
    CondParams1.Field = 'Go';
    Table.Quantity(71).CondParams{iSess} = CondParams1; %'MSTPrefGoPSTH'
    Table.Quantity(71).AnalParams{iSess} = AnalParams;

    CondParams1.conds = {[Dir.Null]};
    CondParams1.Field = 'TargsOn';
    CondParams1.bn = [-500, 1000];
    Table.Quantity(72).CondParams{iSess} = CondParams1; %'MSTNullTargsOnPSTH'
    Table.Quantity(72).AnalParams{iSess} = AnalParams;
    CondParams1.Field = 'Go';
    Table.Quantity(73).CondParams{iSess} = CondParams1; %'MSTNullGoPSTH'
    Table.Quantity(73).AnalParams{iSess} = AnalParams;
    
    CondParams1 = CondParams;
    CondParams1(1).iPanel = 1; %Pref
    CondParams1(1).isubPanel = 2; %Go
    Table.Quantity(74).CondParams{iSess} = CondParams1; %'MSTPrefSigCoh21'

    CondParams1 = CondParams;
    CondParams1(1).iPanel = 1; %Pref
    CondParams1(1).isubPanel = 2; %Go
    Table.Quantity(75).CondParams{iSess} = CondParams1; %'MSTPrefSigCoh31'

    CondParams1 = CondParams;
    CondParams1(1).iPanel = 1; %Pref
    CondParams1(1).isubPanel = 2; %Go
    Table.Quantity(76).CondParams{iSess} = CondParams1; %'MSTPrefSigCoh23'

    CondParams1 = CondParams;
    CondParams1(1).iPanel = 1; %Pref
    CondParams1(1).isubPanel = 2; %Go
    Table.Quantity(77).CondParams{iSess} = CondParams1; %'MSTPrefSigPartialCoh'

    CondParams1 = CondParams;
    CondParams1(1).iPanel = 2; %Null
    CondParams1(1).isubPanel = 2; %Go
    Table.Quantity(78).CondParams{iSess} = CondParams1; %'MSTNullSigCoh21'

    CondParams1 = CondParams;
    CondParams1(1).iPanel = 2; %Null
    CondParams1(1).isubPanel = 2; %Go
    Table.Quantity(79).CondParams{iSess} = CondParams1; %'MSTNullSigCoh31'

    CondParams1 = CondParams;
    CondParams1(1).iPanel = 2; %Null
    CondParams1(1).isubPanel = 2; %Go
    Table.Quantity(80).CondParams{iSess} = CondParams1; %'MSTNullSigCoh23'

    CondParams1 = CondParams;
    CondParams1(1).iPanel = 2; %Null
    CondParams1(1).isubPanel = 2; %Go
    Table.Quantity(81).CondParams{iSess} = CondParams1; %'MSTNullSigPartialCoh'
    
end
















