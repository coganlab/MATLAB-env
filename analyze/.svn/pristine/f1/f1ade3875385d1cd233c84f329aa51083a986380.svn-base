function Value = calcSameElectrodeS2S3(Session,CondParams,AnalParams)
%
%  Value = calcSameElectrodeS2S3(Session,CondParams,AnalParams)


Sys = sessTower(Session);
Sys2 = Sys{2};
if iscell(Sys2); Sys2 = Sys2{1}; end
Sys3 = Sys{3};
if iscell(Sys3); Sys3 = Sys3{1}; end

Electrode = sessElectrode(Session);
E2 = Electrode(2);
E3 = Electrode(3);

Value = strcmp(Sys2,Sys3) & E2 == E3;


