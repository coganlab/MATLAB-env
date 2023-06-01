function PanelData = calcPanelData(Session, CondParams, AnalParams)
%
%  PanelData = calcPanelData(Session, CondParams, AnalParams)
%

M = size(CondParams,1);
N = size(CondParams,2);

SubM = size(AnalParams,1);
SubN = size(AnalParams,2);

if ~isfield(CondParams,'Session')
  if ~isstruct(Session{1})
    Session{1} = sessTrials(Session);
  end
  for iM = 1:M
    for iN = 1:N
      CondParams(iM,iN).Session = Session;
    end
  end
end

for iM = 1:M
    for iN = 1:N
        for iSubM = 1:SubM
            for iSubN = 1:SubN
                Type = AnalParams(iSubM,iSubN).Type;
                SubCondParams = CondParams(iM,iN);
                SubAnalParams = AnalParams(iSubM,iSubN);
                Session = CondParams(iM,iN).Session;
                eval(['SessData = sessPanel' Type '(Session,SubCondParams,SubAnalParams);']);
                PanelData(iM,iN).SubPanel(iSubM,iSubN).Data = SessData;
            end
        end
    end
end
