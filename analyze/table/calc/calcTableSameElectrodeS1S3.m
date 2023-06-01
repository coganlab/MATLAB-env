function Value = calcSameElectrodeS1S3(Session,CondParams,AnalParams)
%
%  Value = calcSameElectrodeS1S3(Session,CondParams,AnalParams)


Sys = sessTower(Session);
Sys1 = Sys{1};
if iscell(Sys1); Sys1 = Sys1{1}; end
Sys3 = Sys{3};
if iscell(Sys3); Sys3 = Sys3{1}; end

Electrode = sessElectrode(Session);
E1 = Electrode(1);
E3 = Electrode(3);

Value = strcmp(Sys1,Sys3) & E1 == E3;

