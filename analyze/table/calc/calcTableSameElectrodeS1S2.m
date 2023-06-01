function Value = calcSameElectrodeS1S2(Session,CondParams,AnalParams)
%
%  Value = calcSameElectrodeS1S2(Session,CondParams,AnalParams)


Sys = sessTower(Session);
Sys1 = Sys{1};
if iscell(Sys1); Sys1 = Sys1{1}; end
Sys2 = Sys{2};
if iscell(Sys2); Sys2 = Sys2{1}; end

Electrode = sessElectrode(Session);
E1 = Electrode(1);
E2 = Electrode(2);

Value = strcmp(Sys1,Sys2) & E1 == E2;



