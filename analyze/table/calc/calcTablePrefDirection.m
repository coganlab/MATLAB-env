function Value = calcPrefDirection(Session,CondParams,AnalParams)
%
%  Value = calcPrefDirection(Session,CondParams,AnalParams)

Dir = loadSessionDirections(Session);

Value = Dir.Pref;

