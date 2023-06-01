% Partial Coherence table panel
% Before calling, you need to set Session list, analysis ('LPL')
% and a list of the Monkeyname

global MONKEYNAME MONKEYDIR

clear Table
Table.Data.Sessions = Session; %Must be 3-part, and in this case UFF.
%Table.Data.Monkey = Monkey; %Must be 3-part, and in this case UFF.
Table.Data.Values = [];
Table.CondParams.Name = [analysis '_UFFPartialCoherence_add'];
Table.AnalParams = [];
NSess = length(Session);

% Set the names. There will be a calc function for each
% Or should I set simple ones here? It seems silly to have a function for
% each SessNum
Table.Quantity(1).Name = 'Monkey';
Table.Quantity(2).Name = 'SessNum1';
Table.Quantity(3).Name = 'SessNum2';
Table.Quantity(4).Name = 'SessNum3';
Table.Quantity(5).Name = 'MRSBaselineFR_All';
Table.Quantity(6).Name = 'MRSpostTOFR_All';
Table.Quantity(7).Name = 'MRSpostTO500FR_All';
Table.Quantity(8).Name = 'MRSpreGoFR_All';
Table.Quantity(9).Name = 'MSTBaselineFR_All';
Table.Quantity(10).Name = 'MSTpostTOFR_All';
Table.Quantity(11).Name = 'MSTpostTO500FR_All';
Table.Quantity(12).Name = 'MSTpreGoFR_All';

% Set up calc functions
Table.Quantity(1).Type = 'Monkey';
Table.Quantity(2).Type = 'SessNum1';
Table.Quantity(3).Type = 'SessNum2';
Table.Quantity(4).Type = 'SessNum3';
Table.Quantity(5).Type = 'AllFiringRatesS1'
Table.Quantity(6).Type = 'AllFiringRatesS1'
Table.Quantity(7).Type = 'AllFiringRatesS1'
Table.Quantity(8).Type = 'AllFiringRatesS1'
Table.Quantity(9).Type = 'AllFiringRatesS1'
Table.Quantity(10).Type = 'AllFiringRatesS1'
Table.Quantity(11).Type = 'AllFiringRatesS1'
Table.Quantity(12).Type = 'AllFiringRatesS1'

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
        
    CondParams = [];
    CondParams.conds = {[Dir.Pref]};
    CondParams.Field = 'TargsOn';
    CondParams.Task = 'MemoryReachSaccade';
    CondParams.bn = [-500, 0];
    AnalParams = [];
    Table.Quantity(5).CondParams{iSess} = CondParams; %'MRSBaselineFR_all'
    Table.Quantity(5).AnalParams{iSess} = AnalParams;
    
    CondParams.Field = 'TargsOn';
    CondParams.bn = [0, 500];
    Table.Quantity(6).CondParams{iSess} = CondParams; %'MRSpostTOFR_All'
    Table.Quantity(6).AnalParams{iSess} = AnalParams;
    
    CondParams.bn = [500, 1000];
    Table.Quantity(7).CondParams{iSess} = CondParams; %'MRSpostTO500FR_All'
    Table.Quantity(7).AnalParams{iSess} = AnalParams;
    
    CondParams.Field = 'Go';
    CondParams.bn = [-500, 0];
    Table.Quantity(8).CondParams{iSess} = CondParams; %'MRSpreGoFR_all'
    Table.Quantity(8).AnalParams{iSess} = AnalParams;
    
    CondParams.Field = 'TargsOn';
    CondParams.Task = 'MemorySaccadeTouch';
    CondParams.bn = [-500, 0];
    AnalParams = [];
    Table.Quantity(9).CondParams{iSess} = CondParams; %'MSTBaselineFR_all'
    Table.Quantity(9).AnalParams{iSess} = AnalParams;
    
    CondParams.Field = 'TargsOn';
    CondParams.bn = [0, 500];
    Table.Quantity(10).CondParams{iSess} = CondParams; %'MSTpostTOFR_All'
    Table.Quantity(10).AnalParams{iSess} = AnalParams;
    
    CondParams.bn = [500, 1000];
    Table.Quantity(11).CondParams{iSess} = CondParams; %'MSTpostTO500FR_All'
    Table.Quantity(11).AnalParams{iSess} = AnalParams;
    
    CondParams.Field = 'Go';
    CondParams.bn = [-500, 0];
    Table.Quantity(12).CondParams{iSess} = CondParams; %'MSTpreGoFR_all'
    Table.Quantity(12).AnalParams{iSess} = AnalParams;
    

    
end
















