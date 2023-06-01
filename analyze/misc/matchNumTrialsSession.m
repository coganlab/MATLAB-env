function SessionNumTrials = matchNumTrialsSession(NumTrials,Session)
%
%  SessionNumTrials = matchNumTrialsSession(NumTrials,Session)
%
%  Inputs:  Session = One session cell array.
%

NumSess = length(Session{6});

NT_Sess = reshape([NumTrials.SessionNumber],NumSess,length(NumTrials));
SN = Session{6};

if NumSess == 1
  ind = find(NT_Sess==SN);
elseif NumSess == 2
  ind = find(NT_Sess(1,:)==SN(1) & NT_Sess(2,:)==SN(2));
end

SessionNumTrials = NumTrials(ind);

