function depth = sessSemiChronicDepth(Session, Ref)
%
%  depth = sessSemiChronicDepth(Session, Ref)
%
%	Ref = Reference position. 'TOP' or 'BOTTOM'
%		Defaults to 'TOP'

if ~exist('Ref','var')
  Ref = 'TOP';
end

SN = getSessionNumbers(Session);
if size(SN,1)==1
  Session = {Session};
end

nSess = length(Session);
depth = zeros(1,nSess);
for iSess = 1:nSess
 SessDay = sessDay(Session{iSess}); 
 SessTower = sessTower(Session{iSess}); SessRec = sessRec(Session{iSess});
 SessChannel = sessChannel(Session{iSess});
 mSession = {{SessDay,[],SessTower,[1:32]}};
 [cDepth,cDay,cRec] = getSemiChronicChannelDepth(Session(iSess),Ref);
 
 dayLocs = find(ismember(cDay,SessDay));
 recLoc = find(ismember(cRec(dayLocs),SessRec{end}));
 depth(iSess) = cDepth(dayLocs(recLoc),SessChannel);
end
