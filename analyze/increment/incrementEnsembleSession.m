function Ensemble = incrementEnsembleSession(Ensemble, ComponentSession)
%
%  Ensemble = incrementEnsembleSession(Ensemble, ComponentSession)
%
% Initialize your Ensemble with the first session by entering an empty cell/array for the Ensemble:
%  Ensemble = incrementEnsembleSession({},ComponentSession);


Rec = sessRec(ComponentSession);
Tower = sessTower(ComponentSession);
Electrode = sessElectrode(ComponentSession);
Contact = sessContact(ComponentSession);

if length(Ensemble)
  MonkeyName1 = sessMonkeyName(Ensemble);
  MonkeyName2 = sessMonkeyName(ComponentSession);
  if ~strcmp(MonkeyName1,MonkeyName2)
    error('Sessions must be from the same MonkeyName');
  end
  nComponent = length(Ensemble(3));
  EnsembleRec = sessRec(Ensemble);
  Ensemble{2} = intersect(EnsembleRec,Rec);
  Ensemble{3}{nComponent+1} = Tower;
  Ensemble{4}{nComponent+1} = {Electrode,Contact};
  Ensemble{6}(nComponent+1) = sessNumber(ComponentSession);
  Type = sessType(ComponentSession);
  Ensemble{8}{nComponent+1} = Type;
  switch Type
    case 'Spike'
      Ensemble{5}{nComponent+1} = {sessCell(ComponentSession)};
    case 'Multiunit'
      Ensemble{5}{nComponent+1} = {[sessDepth(ComponentSession),sessRange(ComponentSession),sessPeak(ComponentSession)]};
  end
else
  Ensemble{1} = sessDay(ComponentSession);
  Ensemble{2} = sessRec(ComponentSession);
  Ensemble{3}{1} = sessTower(ComponentSession);
  Ensemble{4}{1} = {sessElectrode(ComponentSession),sessContact(ComponentSession)};
  Ensemble{6}(1) = sessNumber(ComponentSession);
  Ensemble{7} = sessMonkeyName(ComponentSession);
  Ensemble{8}{1} = sessType(ComponentSession);
  switch Ensemble{8}{1}
    case 'Spike'
      Ensemble{5}{1} = {sessCell(ComponentSession)};
    case 'Multiunit'
      Ensemble{5}{1} = {[sessDepth(ComponentSession),sessRange(ComponentSession),sessPeak(ComponentSession)]};
  end
end
