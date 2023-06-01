% Partial Coherence table panel
% Before calling, you need to set Session list, analysis ('LP')
% and a list of the Monkeyname

global MONKEYNAME MONKEYDIR

clear Table
Table.Data.Sessions = Session; %Must be 2-part, and in this case UF.
%Table.Data.Monkey = Monkey; %Must be 2-part, and in this case UF.
Table.Data.Values = [];
Table.CondParams.Name = [analysis '_UFCoherenceMST'];
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
Table.Quantity(12).Name = 'MSTTunedUnitpostTO';
Table.Quantity(13).Name = 'MSTTunedUnitpostTO500';
Table.Quantity(14).Name = 'MSTTunedUnitpreGo';
Table.Quantity(15).Name = 'MSTTunedFieldpostTO'; 
Table.Quantity(16).Name = 'MSTTunedFieldpostTO500'; 
Table.Quantity(17).Name = 'MSTTunedFieldpreGo'; 
Table.Quantity(18).Name = 'MSTBaselineFR';
Table.Quantity(19).Name = 'MSTpreGoFR';
Table.Quantity(20).Name = 'MSTPrefNumTrialsUF';
Table.Quantity(21).Name = 'MSTPrefCohF_Unit';
Table.Quantity(22).Name = 'MSTNullNumTrialsUF';
Table.Quantity(23).Name = 'MSTNullCohF_Unit';
Table.Quantity(24).Name = 'MSTPrefTargsOnPSTH';
Table.Quantity(25).Name = 'MSTPrefGoPSTH';
Table.Quantity(26).Name = 'MSTNullTargsOnPSTH';
Table.Quantity(27).Name = 'MSTNullGoPSTH';
Table.Quantity(28).Name = 'MSTBaselineFR_All';
Table.Quantity(29).Name = 'MSTpostTOFR_All';
Table.Quantity(30).Name = 'MSTpostTO500FR_All';
Table.Quantity(31).Name = 'MSTpreGoFR_All';
Table.Quantity(32).Name = 'MSTPrefSpecTO';
Table.Quantity(33).Name = 'MSTPrefSpecGo';
Table.Quantity(34).Name = 'MSTNullSpecTO';
Table.Quantity(35).Name = 'MSTNullSpecGo';
Table.Quantity(36).Name = 'UnitClassification';
Table.Quantity(37).Name = 'MST_SRT';
Table.Quantity(38).Name = 'MST_RRT';
Table.Quantity(39).Name = 'MSTPrefSigCohF_Unit';
Table.Quantity(40).Name = 'MSTNullSigCohF_Unit';
Table.Quantity(41).Name = 'MSTTunedUnitpostGo';
Table.Quantity(42).Name = 'MSTTunedFieldpostGo';

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
Table.Quantity(39).Type = 'SigCohUF';
Table.Quantity(40).Type = 'SigCohUF';
Table.Quantity(41).Type = 'TunedUnitS1';
Table.Quantity(42).Type = 'TunedFieldS2'; 


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
    Task = {'MemorySaccadeTouch'};
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
    Table.Quantity(12).CondParams{iSess} = CondParams1; %'MSTTunedUnitpostTO'
    Table.Quantity(12).AnalParams{iSess} = AnalParams1;
    AnalParams1.Tapers = [.5,10];
    AnalParams1.fk = [10 20];
    Table.Quantity(15).CondParams{iSess} = CondParams1; %'MSTTunedFieldpostTO'
    Table.Quantity(15).AnalParams{iSess} = AnalParams1;
    CondParams1{1}.bn = [500, 1000];
    CondParams1{2}.bn = [500, 1000];
    Table.Quantity(13).CondParams{iSess} = CondParams1; %'MSTTunedUnitpostTO500'
    Table.Quantity(13).AnalParams{iSess} = AnalParams1;
    Table.Quantity(16).CondParams{iSess} = CondParams1; %'MSTTunedFieldpostTO500'
    Table.Quantity(16).AnalParams{iSess} = AnalParams1;
    CondParams1{1}.Field = 'Go';
    CondParams1{2}.Field = 'Go';
    CondParams1{1}.bn = [-500, 0];
    CondParams1{2}.bn = [-500, 0];
    Table.Quantity(14).CondParams{iSess} = CondParams1; %'MSTTunedUnitpreGo'
    Table.Quantity(14).AnalParams{iSess} = AnalParams1;
    Table.Quantity(17).CondParams{iSess} = CondParams1; %'MSTTunedFieldpreGo'
    Table.Quantity(17).AnalParams{iSess} = AnalParams1;
    CondParams1{1}.bn = [0, 500];
    CondParams1{2}.bn = [0, 500];
    Table.Quantity(41).CondParams{iSess} = CondParams1; %'MSTTunedUnitpostGo'
    Table.Quantity(41).AnalParams{iSess} = AnalParams1;
    Table.Quantity(42).CondParams{iSess} = CondParams1; %'MSTTunedFieldpostGo'
    Table.Quantity(42).AnalParams{iSess} = AnalParams1;

    CondParams1 = [];
    CondParams1.conds = {[Dir.Pref]};
    CondParams1.Field = 'TargsOn';
    CondParams1.Task = Task;
    CondParams1.bn = [-500, 0];
    AnalParams1 = [];
    Table.Quantity(18).CondParams{iSess} = CondParams1; %'MSTBaselineFR'
    Table.Quantity(18).AnalParams{iSess} = AnalParams1;
    
    CondParams1 = [];
    CondParams1.conds = {[Dir.Pref]};
    CondParams1.Field = 'Go';
    CondParams1.Task = Task;
    CondParams1.bn = [-500, 0];
    AnalParams1 = [];
    Table.Quantity(19).CondParams{iSess} = CondParams1; %'MSTpreGoFR'
    Table.Quantity(19).AnalParams{iSess} = AnalParams1;    
    
    CondParams1 = CondParams;
    CondParams1(1).iPanel = 1; %Pref
    CondParams1(1).isubPanel = 2; %Go
    Table.Quantity(20).CondParams{iSess} = CondParams1; %'MSTPrefNumTrials'

    CondParams1 = CondParams;
    CondParams1(1).iPanel = 1; %Pref
    CondParams1(1).isubPanel = 2; %Go
    Table.Quantity(21).CondParams{iSess} = CondParams1; %'MSTPrefCohF_Unit'

    CondParams1 = CondParams;
    CondParams1(1).iPanel = 2; %Pref
    CondParams1(1).isubPanel = 2; %Go
    Table.Quantity(22).CondParams{iSess} = CondParams1; %'MSTNullNumTrials'
    
    CondParams1 = CondParams;
    CondParams1(1).iPanel = 2; %Null
    CondParams1(1).isubPanel = 2; %Go
    Table.Quantity(23).CondParams{iSess} = CondParams1; %'MSTNullCohF_Unit'

    CondParams1 = [];
    CondParams1.conds = {[Dir.Pref]};
    CondParams1.Task = Task;
    CondParams1.Field = 'TargsOn';
    CondParams1.bn = [-500, 1000];
    Table.Quantity(24).CondParams{iSess} = CondParams1; %'MSTPrefTargsOnPSTH'
    Table.Quantity(24).AnalParams{iSess} = AnalParams;
    CondParams1.Field = 'Go';
    Table.Quantity(25).CondParams{iSess} = CondParams1; %'MSTPrefGoPSTH'
    Table.Quantity(25).AnalParams{iSess} = AnalParams;

    CondParams1.conds = {[Dir.Null]};
    CondParams1.Field = 'TargsOn';
    CondParams1.bn = [-500, 1000];
    Table.Quantity(26).CondParams{iSess} = CondParams1; %'MSTNullTargsOnPSTH'
    Table.Quantity(26).AnalParams{iSess} = AnalParams;
    CondParams1.Field = 'Go';
    Table.Quantity(27).CondParams{iSess} = CondParams1; %'MSTNullGoPSTH'
    Table.Quantity(27).AnalParams{iSess} = AnalParams;
    
    CondParams1 = [];
    CondParams1.conds = {[Dir.Pref]};
    CondParams1.Field = 'TargsOn';
    CondParams1.Task = Task;
    CondParams1.bn = [-500, 0];
    AnalParams = [];
    Table.Quantity(28).CondParams{iSess} = CondParams1; %'MSTBaselineFR_all'
    Table.Quantity(28).AnalParams{iSess} = AnalParams;
    
    CondParams1.Field = 'TargsOn';
    CondParams1.bn = [0, 500];
    Table.Quantity(29).CondParams{iSess} = CondParams1; %'MSTpostTOFR_All'
    Table.Quantity(29).AnalParams{iSess} = AnalParams;
    
    CondParams1.bn = [500, 1000];
    Table.Quantity(30).CondParams{iSess} = CondParams1; %'MSTpostTO500FR_All'
    Table.Quantity(30).AnalParams{iSess} = AnalParams;
    
    CondParams1.Field = 'Go';
    CondParams1.bn = [-500, 0];
    Table.Quantity(31).CondParams{iSess} = CondParams1; %'MSTpreGoFR_all'
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
    Table.Quantity(32).CondParams{iSess} = CondParams1; %'MSTPrefSpecTO'
    Table.Quantity(32).AnalParams{iSess} = AnalParams;
    
    CondParams1(1).Field = 'Go';
    AnalParams(1).Field = 'Go';
    Table.Quantity(33).CondParams{iSess} = CondParams1; %'MSTPrefSpecGo'
    Table.Quantity(33).AnalParams{iSess} = AnalParams;

    CondParams1(1).conds = {[Dir.Null]};
    CondParams1(1).Field = 'TargsOn';
    AnalParams(1).Field = 'TargsOn';
    Table.Quantity(34).CondParams{iSess} = CondParams1; %'MSTNullSpecTO'
    Table.Quantity(34).AnalParams{iSess} = AnalParams;
    
    CondParams1(1).Field = 'Go';
    AnalParams(1).Field = 'Go';
    Table.Quantity(35).CondParams{iSess} = CondParams1; %'MSTNullSpecGo'
    Table.Quantity(35).AnalParams{iSess} = AnalParams;

    clear CondParams1
    CP1.Task = {'MemorySaccadeTouch'};
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
    Table.Quantity(37).CondParams{iSess} = CondParams1; %'MST_SRT'
    Table.Quantity(37).AnalParams{iSess} = [];
    
    clear CondParams1
    CondParams1.Task = Task;
    Table.Quantity(38).CondParams{iSess} = CondParams1; %'MST_RRT'
    Table.Quantity(38).AnalParams{iSess} = [];
 
    CondParams1 = CondParams;
    CondParams1(1).iPanel = 1; %Pref
    CondParams1(1).isubPanel = 2; %Go
    Table.Quantity(39).CondParams{iSess} = CondParams1; %'MSTPrefCohF_Unit'

    CondParams1 = CondParams;
    CondParams1(1).iPanel = 2; %Null
    CondParams1(1).isubPanel = 2; %Go
    Table.Quantity(40).CondParams{iSess} = CondParams1; %'MSTPrefCohF_Unit'

end
















