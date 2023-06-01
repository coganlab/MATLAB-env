% Coherence table panel
% Before calling, you need to set Session list, analysis ('LP')
% and a list of the Monkeyname

global MONKEYNAME MONKEYDIR

clear Table
Table.Data.Sessions = Session; %Must be 2-part, and in this case UF.
%Table.Data.Monkey = Monkey; %Must be 2-part, and in this case UF.
Table.Data.Values = [];
Table.CondParams.Name = [analysis '_UFCoherenceMem_add'];
Table.AnalParams = [];
NSess = length(Session);

% Set the names. There will be a calc function for each
Table.Quantity(1).Name = 'Monkey';
Table.Quantity(2).Name = 'SessNum1';
Table.Quantity(3).Name = 'SessNum2';
Table.Quantity(4).Name = 'MemPrefBaselineFR_All';
Table.Quantity(5).Name = 'MemPrefpostTOFR_All';
Table.Quantity(6).Name = 'MemPrefpostTO500FR_All';
Table.Quantity(7).Name = 'MemPrefpreGoFR_All';
Table.Quantity(8).Name = 'MemNullBaselineFR_All';
Table.Quantity(9).Name = 'MemNullpostTOFR_All';
Table.Quantity(10).Name = 'MemNullpostTO500FR_All';
Table.Quantity(11).Name = 'MemNullpreGoFR_All';
Table.Quantity(12).Name = 'MemPrefCoh_TO_All';
Table.Quantity(13).Name = 'MemPrefCoh_Go_All';
Table.Quantity(14).Name = 'MemNullCoh_TO_All';
Table.Quantity(15).Name = 'MemNullCoh_Go_All';
Table.Quantity(16).Name = 'MemPrefSpecTO_All';
Table.Quantity(17).Name = 'MemPrefSpecGo_All';
Table.Quantity(18).Name = 'MemNullSpecTO_All';
Table.Quantity(19).Name = 'MemNullSpecTO_All';

% Set up calc functions
Table.Quantity(1).Type = 'Monkey';
Table.Quantity(2).Type = 'SessNum1';
Table.Quantity(3).Type = 'SessNum2';
Table.Quantity(4).Type = 'AllFiringRatesS1';
Table.Quantity(5).Type = 'AllFiringRatesS1';
Table.Quantity(6).Type = 'AllFiringRatesS1';
Table.Quantity(7).Type = 'AllFiringRatesS1';
Table.Quantity(8).Type = 'AllFiringRatesS1';
Table.Quantity(9).Type = 'AllFiringRatesS1';
Table.Quantity(10).Type = 'AllFiringRatesS1';
Table.Quantity(11).Type = 'AllFiringRatesS1';
Table.Quantity(12).Type = 'CohUF';
Table.Quantity(13).Type = 'CohUF';
Table.Quantity(14).Type = 'CohUF';
Table.Quantity(15).Type = 'CohUF';
Table.Quantity(16).Type = 'SpectrumS2';
Table.Quantity(17).Type = 'SpectrumS2';
Table.Quantity(18).Type = 'SpectrumS2';
Table.Quantity(19).Type = 'SpectrumS2';


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
    panelDefn_Coherogram
    CondParams(1,1).timeind = 1:30;
    CondParams(1,1).freqind = 1:204;
    
    for iQ = 1:length(Table.Quantity)
        Table.Quantity(iQ).CondParams{iSess} = CondParams;
        Table.Quantity(iQ).AnalParams{iSess} = AnalParams;
    end    
    
    CondParams1 = [];
    CondParams1.conds = {[Dir.Pref]};
    CondParams1.Field = 'TargsOn';
    CondParams1.Task = '';
    CondParams1.bn = [-500, 0];
    AnalParams1 = [];
    Table.Quantity(4).CondParams{iSess} = CondParams1; %'MemPrefBaselineFR_all'
    Table.Quantity(4).AnalParams{iSess} = AnalParams1;
    
    CondParams1.Field = 'TargsOn';
    CondParams1.bn = [0, 500];
    Table.Quantity(5).CondParams{iSess} = CondParams1; %'MemPrefpostTOFR_All'
    Table.Quantity(5).AnalParams{iSess} = AnalParams1;
    
    CondParams1.bn = [500, 1000];
    Table.Quantity(6).CondParams{iSess} = CondParams1; %'MemPrefpostTO500FR_All'
    Table.Quantity(6).AnalParams{iSess} = AnalParams1;
    
    CondParams1.Field = 'Go';
    CondParams1.bn = [-500, 0];
    Table.Quantity(7).CondParams{iSess} = CondParams1; %'MemPrefpreGoFR_all'
    Table.Quantity(7).AnalParams{iSess} = AnalParams1;
    
    CondParams1.conds = {[Dir.Null]};
    CondParams1.Field = 'TargsOn';
    CondParams1.bn = [-500, 0];
    AnalParams1 = [];
    Table.Quantity(8).CondParams{iSess} = CondParams1; %'MemNullBaselineFR_all'
    Table.Quantity(8).AnalParams{iSess} = AnalParams1;
    
    CondParams1.Field = 'TargsOn';
    CondParams1.bn = [0, 500];
    Table.Quantity(9).CondParams{iSess} = CondParams1; %'MemNullpostTOFR_All'
    Table.Quantity(9).AnalParams{iSess} = AnalParams1;
    
    CondParams1.bn = [500, 1000];
    Table.Quantity(10).CondParams{iSess} = CondParams1; %'MemNullpostTO500FR_All'
    Table.Quantity(10).AnalParams{iSess} = AnalParams;
    
    CondParams1.Field = 'Go';
    CondParams1.bn = [-500, 0];
    Table.Quantity(11).CondParams{iSess} = CondParams1; %'MemNullpreGoFR_all'
    Table.Quantity(11).AnalParams{iSess} = AnalParams1;
    
    CondParams1 = CondParams;
    CondParams1(1).iPanel = 1; %Pref
    CondParams1(1).isubPanel = 1; %TargsOn
    Table.Quantity(12).CondParams{iSess} = CondParams1; %'MemPrefCoh_TO_All'

    CondParams1 = CondParams;
    CondParams1(1).iPanel = 1; %Pref
    CondParams1(1).isubPanel = 2; %Go
    Table.Quantity(13).CondParams{iSess} = CondParams1; %'MemPrefCoh_Go_All'

    CondParams1 = CondParams;
    CondParams1(1).iPanel = 2; %Null
    CondParams1(1).isubPanel = 1; %TargsOn
    Table.Quantity(14).CondParams{iSess} = CondParams1; %'MemNullCoh_TO_All'

    CondParams1 = CondParams;
    CondParams1(1).iPanel = 2; %Null
    CondParams1(1).isubPanel = 2; %Go
    Table.Quantity(15).CondParams{iSess} = CondParams1; %'MemNullCoh_Go_All'

    AnalParams1 = struct([]);  CondParams1 = struct([]);
    AnalParams1(1).bn = [-500, 1000];
    AnalParams1(1).threshfac = 25;
    AnalParams1(1).tapers = [.5,5];
    CondParams1(1).bn = [-500, 1000];
    CondParams1(1).conds = {[Dir.Pref]};
    CondParams1(1).Task = Task;
    CondParams1(1).Field = 'TargsOn';
    AnalParams1(1).Field = 'TargsOn';
    Table.Quantity(16).CondParams{iSess} = CondParams1; %'MemPrefSpecTO'
    Table.Quantity(16).AnalParams{iSess} = AnalParams1;

    CondParams1(1).Field = 'Go';
    AnalParams1(1).Field = 'Go';
    Table.Quantity(17).CondParams{iSess} = CondParams1; %'MemPrefSpecGo'
    Table.Quantity(17).AnalParams{iSess} = AnalParams1;

    CondParams1(1).conds = {[Dir.Null]};
    CondParams1(1).Field = 'TargsOn';
    AnalParams1(1).Field = 'TargsOn';
    Table.Quantity(18).CondParams{iSess} = CondParams1; %'MemNullSpecTO'
    Table.Quantity(18).AnalParams{iSess} = AnalParams1;

    CondParams1(1).Field = 'Go';
    AnalParams1(1).Field = 'Go';
    Table.Quantity(19).CondParams{iSess} = CondParams1; %'MemNullSpecGo'
    Table.Quantity(19).AnalParams{iSess} = AnalParams1;

end
















