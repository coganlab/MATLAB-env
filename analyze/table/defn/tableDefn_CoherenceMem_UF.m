% Partial Coherence table panel
% Before calling, you need to set Session list, analysis ('LP')
% and a list of the Monkeyname

global MONKEYNAME MONKEYDIR

clear Table
Table.Data.Sessions = Session; %Must be 2-part, and in this case UF.
%Table.Data.Monkey = Monkey; %Must be 2-part, and in this case UF.
Table.Data.Values = [];
Table.CondParams.Name = [analysis '_UFCoherenceMem'];
Table.AnalParams = [];
NSess = length(Session);

% Set the names. There will be a calc function for each
Table.Quantity(1).Name = 'Monkey';
Table.Quantity(2).Name = 'SessNum1';
Table.Quantity(3).Name = 'SessNum2';
Table.Quantity(4).Name = 'Area1';
Table.Quantity(5).Name = 'Area2';
Table.Quantity(6).Name = 'SingleUnit';
Table.Quantity(7).Name = 'SameElectrode';
Table.Quantity(8).Name = 'PrefDir';
Table.Quantity(9).Name = 'NullDir';
Table.Quantity(10).Name = 'SpikeWaveform_tophalf';
Table.Quantity(11).Name = 'WaveformSNR';
Table.Quantity(12).Name = 'MemTunedUnitpostTO';
Table.Quantity(13).Name = 'MemTunedUnitpostTO500';
Table.Quantity(14).Name = 'MemTunedUnitpreGo';
Table.Quantity(15).Name = 'MemTunedFieldpostTO'; 
Table.Quantity(16).Name = 'MemTunedFieldpostTO500'; 
Table.Quantity(17).Name = 'MemTunedFieldpreGo'; 
Table.Quantity(18).Name = 'MemBaselineFR';
Table.Quantity(19).Name = 'MempreGoFR';
Table.Quantity(20).Name = 'MemPrefNumTrialsUF';
Table.Quantity(21).Name = 'MemPrefCohF_Unit';
Table.Quantity(22).Name = 'MemNullNumTrialsUF';
Table.Quantity(23).Name = 'MemNullSigCohF_Unit';
Table.Quantity(24).Name = 'MemPrefTargsOnPSTH';
Table.Quantity(25).Name = 'MemPrefGoPSTH';
Table.Quantity(26).Name = 'MemNullTargsOnPSTH';
Table.Quantity(27).Name = 'MemNullGoPSTH';
Table.Quantity(28).Name = 'MemBaselineFR_All';
Table.Quantity(29).Name = 'MempostTOFR_All';
Table.Quantity(30).Name = 'MempostTO500FR_All';
Table.Quantity(31).Name = 'MempreGoFR_All';
Table.Quantity(32).Name = 'MemPrefSpecTO';
Table.Quantity(33).Name = 'MemPrefSpecGo';
Table.Quantity(34).Name = 'MemNullSpecTO';
Table.Quantity(35).Name = 'MemNullSpecTO';
Table.Quantity(36).Name = 'UnitClassification';
Table.Quantity(37).Name = 'Mem_SRT';
Table.Quantity(38).Name = 'Mem_RRT';
Table.Quantity(39).Name = 'MemTunedUnitpostGo';
Table.Quantity(40).Name = 'MemTunedFieldpostGo';

% Set up calc functions
Table.Quantity(1).Type = 'Monkey';
Table.Quantity(2).Type = 'SessNum1';
Table.Quantity(3).Type = 'SessNum2';
Table.Quantity(4).Type = 'AreaS1';
Table.Quantity(5).Type = 'AreaS2';
Table.Quantity(6).Type = 'SingleUnitS1';
Table.Quantity(7).Type = 'SameElectrodeS1S2';
Table.Quantity(8).Type = 'PrefDirection';
Table.Quantity(9).Type = 'NullDirection';
Table.Quantity(10).Type = 'SpikeWaveformS1';
Table.Quantity(11).Type = 'WaveformSNRS1';
Table.Quantity(12).Type = 'TunedUnitS1';
Table.Quantity(13).Type = 'TunedUnitS1';
Table.Quantity(14).Type = 'TunedUnitS1';
Table.Quantity(15).Type = 'TunedFieldS2'; 
Table.Quantity(16).Type = 'TunedFieldS2'; 
Table.Quantity(17).Type = 'TunedFieldS2'; 
Table.Quantity(18).Type = 'FiringRateS1';
Table.Quantity(19).Type = 'FiringRateS1';
Table.Quantity(20).Type = 'NumTrials';
Table.Quantity(21).Type = 'CohUF';
Table.Quantity(22).Type = 'NumTrials';
Table.Quantity(23).Type = 'CohUF';
Table.Quantity(24).Type = 'PSTHS1';
Table.Quantity(25).Type = 'PSTHS1';
Table.Quantity(26).Type = 'PSTHS1';
Table.Quantity(27).Type = 'PSTHS1';
Table.Quantity(28).Type = 'AllFiringRatesS1';
Table.Quantity(29).Type = 'AllFiringRatesS1';
Table.Quantity(30).Type = 'AllFiringRatesS1';
Table.Quantity(31).Type = 'AllFiringRatesS1';
Table.Quantity(32).Type = 'SpectrumS2';
Table.Quantity(33).Type = 'SpectrumS2';
Table.Quantity(34).Type = 'SpectrumS2';
Table.Quantity(35).Type = 'SpectrumS2';
Table.Quantity(36).Type = 'UnitClassificationS1';
Table.Quantity(37).Type = 'SRTS1';
Table.Quantity(38).Type = 'RRTS1';
Table.Quantity(39).Type = 'TunedUnitS1';
Table.Quantity(40).Type = 'TunedFieldS2'; 


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
    task = 'Mem';
    Task = {'MemoryReachSaccade','MemorySaccadeTouch'};
    panelDefn_Coherogram
    CondParams(1,1).timeind = 5;
    f = linspace(0,200,204);
    CondParams(1,1).freqind = find(f>15,1);

    for iQ = 1:length(Table.Quantity)
        Table.Quantity(iQ).CondParams{iSess} = CondParams;
        Table.Quantity(iQ).AnalParams{iSess} = AnalParams;
    end

    clear CondParams1
    CondParams1.bn = [0 1/2];
    Table.Quantity(10).CondParams{iSess} = CondParams1; %'WaveformS1'
    Table.Quantity(10).AnalParams{iSess} = [];
    
    Table.Quantity(11).CondParams{iSess} = []; %'WaveformSNRS1'
    Table.Quantity(11).AnalParams{iSess} = [];
    
    clear CondParams1 AnalParams1
    CondParams1{1}.Field = 'TargsOn';
    CondParams1{1}.Task = Task;
    CondParams1{1}.bn = [0, 500];
    CondParams1{2} = CondParams1{1};
    CondParams1{1}.conds = {[Dir.Pref]};
    CondParams1{2}.conds = {[Dir.Null]};
    AnalParams1 = [];
    Table.Quantity(12).CondParams{iSess} = CondParams1; %'MemTunedUnitpostTO'
    Table.Quantity(12).AnalParams{iSess} = AnalParams1;
    AnalParams1.Tapers = [.5,10];
    AnalParams1.fk = [10 20];
    Table.Quantity(15).CondParams{iSess} = CondParams1; %'MemTunedFieldpostTO'
    Table.Quantity(15).AnalParams{iSess} = AnalParams1;
    CondParams1{1}.bn = [500, 1000];
    CondParams1{2}.bn = [500, 1000];
    Table.Quantity(13).CondParams{iSess} = CondParams1; %'MemTunedUnitpostTO500'
    Table.Quantity(13).AnalParams{iSess} = AnalParams1;
    Table.Quantity(16).CondParams{iSess} = CondParams1; %'MemTunedFieldpostTO500'
    Table.Quantity(16).AnalParams{iSess} = AnalParams1;
    CondParams1{1}.Field = 'Go';
    CondParams1{2}.Field = 'Go';
    CondParams1{1}.bn = [-500, 0];
    CondParams1{2}.bn = [-500, 0];
    Table.Quantity(14).CondParams{iSess} = CondParams1; %'MemTunedUnitpreGo'
    Table.Quantity(14).AnalParams{iSess} = AnalParams1;
    Table.Quantity(17).CondParams{iSess} = CondParams1; %'MemTunedFieldpreGo'
    Table.Quantity(17).AnalParams{iSess} = AnalParams1;
    CondParams1{1}.bn = [0, 500];
    CondParams1{2}.bn = [0, 500];
    Table.Quantity(39).CondParams{iSess} = CondParams1; %'MemTunedUnitpostGo'
    Table.Quantity(39).AnalParams{iSess} = AnalParams1;
    Table.Quantity(40).CondParams{iSess} = CondParams1; %'MemTunedFieldpostGo'
    Table.Quantity(40).AnalParams{iSess} = AnalParams1;

    CondParams1 = [];
    CondParams1.conds = {[Dir.Pref]};
    CondParams1.Field = 'TargsOn';
    CondParams1.Task = Task;
    CondParams1.bn = [-500, 0];
    AnalParams1 = [];
    Table.Quantity(18).CondParams{iSess} = CondParams1; %'MemBaselineFR'
    Table.Quantity(18).AnalParams{iSess} = AnalParams1;
    
    CondParams1 = [];
    CondParams1.conds = {[Dir.Pref]};
    CondParams1.Field = 'Go';
    CondParams1.Task = Task;
    CondParams1.bn = [-500, 0];
    AnalParams1 = [];
    Table.Quantity(19).CondParams{iSess} = CondParams1; %'MempreGoFR'
    Table.Quantity(19).AnalParams{iSess} = AnalParams1;    
    
    CondParams1 = CondParams;
    CondParams1(1).iPanel = 1; %Pref
    CondParams1(1).isubPanel = 2; %Go
    Table.Quantity(20).CondParams{iSess} = CondParams1; %'MemPrefNumTrials'

    CondParams1 = CondParams;
    CondParams1(1).iPanel = 1; %Pref
    CondParams1(1).isubPanel = 2; %Go
    Table.Quantity(21).CondParams{iSess} = CondParams1; %'MemPrefCohF_Unit'

    CondParams1 = CondParams;
    CondParams1(1).iPanel = 2; %Pref
    CondParams1(1).isubPanel = 2; %Go
    Table.Quantity(22).CondParams{iSess} = CondParams1; %'MemNullNumTrials'
    
    CondParams1 = CondParams;
    CondParams1(1).iPanel = 2; %Null
    CondParams1(1).isubPanel = 2; %Go
    Table.Quantity(23).CondParams{iSess} = CondParams1; %'MemNullCohF_Unit'

    CondParams1 = [];
    CondParams1.conds = {[Dir.Pref]};
    CondParams1.Task = Task;
    CondParams1.Field = 'TargsOn';
    CondParams1.bn = [-500, 1000];
    Table.Quantity(24).CondParams{iSess} = CondParams1; %'MemPrefTargsOnPSTH'
    Table.Quantity(24).AnalParams{iSess} = AnalParams;
    CondParams1.Field = 'Go';
    Table.Quantity(25).CondParams{iSess} = CondParams1; %'MemPrefGoPSTH'
    Table.Quantity(25).AnalParams{iSess} = AnalParams;

    CondParams1.conds = {[Dir.Null]};
    CondParams1.Field = 'TargsOn';
    CondParams1.bn = [-500, 1000];
    Table.Quantity(26).CondParams{iSess} = CondParams1; %'MemNullTargsOnPSTH'
    Table.Quantity(26).AnalParams{iSess} = AnalParams;
    CondParams1.Field = 'Go';
    Table.Quantity(27).CondParams{iSess} = CondParams1; %'MemNullGoPSTH'
    Table.Quantity(27).AnalParams{iSess} = AnalParams;
    
    CondParams1 = [];
    CondParams1.conds = {[Dir.Pref]};
    CondParams1.Field = 'TargsOn';
    CondParams1.Task = Task;
    CondParams1.bn = [-500, 0];
    AnalParams = [];
    Table.Quantity(28).CondParams{iSess} = CondParams1; %'MemBaselineFR_all'
    Table.Quantity(28).AnalParams{iSess} = AnalParams;
    
    CondParams1.Field = 'TargsOn';
    CondParams1.bn = [0, 500];
    Table.Quantity(29).CondParams{iSess} = CondParams1; %'MempostTOFR_All'
    Table.Quantity(29).AnalParams{iSess} = AnalParams;
    
    CondParams1.bn = [500, 1000];
    Table.Quantity(30).CondParams{iSess} = CondParams1; %'MempostTO500FR_All'
    Table.Quantity(30).AnalParams{iSess} = AnalParams;
    
    CondParams1.Field = 'Go';
    CondParams1.bn = [-500, 0];
    Table.Quantity(31).CondParams{iSess} = CondParams1; %'MempreGoFR_all'
    Table.Quantity(31).AnalParams{iSess} = AnalParams;
    
    AnalParams = struct([]);  CondParams1 = struct([]);
    AnalParams(1).bn = [-500, 1000];
    AnalParams(1).threshfac = 25;
    AnalParams(1).tapers = [.5,5];
    CondParams1(1).bn = [-500, 1000];
    CondParams1(1).conds = {[Dir.Pref]};
    CondParams1(1).Task = Task;
    CondParams1(1).Field = 'TargsOn';
    AnalParams(1).Field = 'TargsOn';
    Table.Quantity(32).CondParams{iSess} = CondParams1; %'MemPrefSpecTO'
    Table.Quantity(32).AnalParams{iSess} = AnalParams;
    
    CondParams1(1).Field = 'Go';
    AnalParams(1).Field = 'Go';
    Table.Quantity(33).CondParams{iSess} = CondParams1; %'MemPrefSpecGo'
    Table.Quantity(33).AnalParams{iSess} = AnalParams;

    CondParams1(1).conds = {[Dir.Null]};
    CondParams1(1).Field = 'TargsOn';
    AnalParams(1).Field = 'TargsOn';
    Table.Quantity(34).CondParams{iSess} = CondParams1; %'MemNullSpecTO'
    Table.Quantity(34).AnalParams{iSess} = AnalParams;
    
    CondParams1(1).Field = 'Go';
    AnalParams(1).Field = 'Go';
    Table.Quantity(35).CondParams{iSess} = CondParams1; %'MemNullSpecGo'
    Table.Quantity(35).AnalParams{iSess} = AnalParams;

    clear CondParams1
    CP1.Task = {'MemoryReachSaccade'};
    CP2.Task = {'MemorySaccadeTouch'};
    CP1.conds = {3,3,Dir.Pref};
    CP2.conds = {3,3,Dir.Pref};
    CP1.bn = [0,500];
    CP2.bn = [0,500];
    CP1.Field = 'TargsOn';
    CP2.Field = 'TargsOn';
    CondParams_tmp{1} = CP1;
    CondParams_tmp{2} = CP2;
    CondParams1{1} = CondParams_tmp;
    CP1.bn = [500,1000];
    CP2.bn = [500,1000];
    CondParams_tmp{1} = CP1;
    CondParams_tmp{2} = CP2;
    CondParams1{2} = CondParams_tmp;
    CP1.Field = 'SaccStart';
    CP2.Field = 'SaccStart';
    CP1.bn = [-500,0];
    CP2.bn = [-500,0];
    CondParams_tmp{1} = CP1;
    CondParams_tmp{2} = CP2;
    CondParams1{3} = CondParams_tmp;
    Table.Quantity(36).CondParams{iSess} = CondParams1; %'UnitClassification'
    Table.Quantity(36).AnalParams{iSess} = [];
    
    clear CondParams1
    CondParams1.Task = Task;
    Table.Quantity(37).CondParams{iSess} = CondParams1; %'Mem_SRT'
    Table.Quantity(37).AnalParams{iSess} = [];
    
    clear CondParams1
    CondParams1.Task = Task;
    Table.Quantity(38).CondParams{iSess} = CondParams1; %'Mem_RRT'
    Table.Quantity(38).AnalParams{iSess} = [];
    
end
















