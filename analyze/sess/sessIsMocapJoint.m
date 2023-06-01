function out = sessIsMocapJoint(Session)

global MONKEYDIR

if iscell(Session)
  nSess = length(Session);
  for iSess = 1:nSess
    day = sessDay(Session{iSess});
    recs = sessRec(Session{iSess});
    nRec = length(recs);
    out_tmp = zeros(1,nRec);
    for iRec = 1:nRec
      rec = recs{iRec};
      if exist([MONKEYDIR '/' day '/' rec '/rec' rec '.Body.Joint.mat'],'file')
        out_tmp(iRec) = 1;
      else
 	out_tmp(iRec) = 0;
      end
    end
    out(iSess) = prod(out_tmp);
  end
end
