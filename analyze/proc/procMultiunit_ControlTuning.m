function procMultiunit_ControlTuning(day)
%
%  procMultiunit_ControlTuning(day)
%

Session = loadMultiunit_Database;
Days = sessDay(Session);
DayInd = find(strcmp(Days,day));

for iSess = 1:length(DayInd)
  updateMultiunit_ControlTuning(DayInd(iSess));
end
