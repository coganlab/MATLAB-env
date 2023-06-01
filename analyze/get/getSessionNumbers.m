function SessionNumbers = getSessionNumbers(Session)
%
%  SessionNumbers = getSessionNumbers(Session)
%

if iscell(Session{1})
  NumSess = length(Session);
  NumSessElem = length(Session{1}{6});
  SessionNumbers = zeros(NumSess,NumSessElem);
  
  for iSess = 1:NumSess
      if ~isempty(Session{iSess})
          SessionNumbers(iSess,:) = Session{iSess}{6};
      end
  end
else
  SessionNumbers = Session{6};
end
