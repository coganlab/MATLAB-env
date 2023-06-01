function saveSessionDirections(Session, PrefDir, NullDir)
%
%  saveSessionDirections(Session, PrefDir, NullDir)
%
%  Saves Preferred and Null directions for Session in 
%   MONKEYDIR/mat/SESSTYPE/SESSTYPE_Directions.SESSNUM.mat

global MONKEYDIR

SessionType = sessType(Session);
SessionNumberString = getSessionNumberString(Session);
Directions.Pref = PrefDir;
Directions.Null = NullDir;
Filename = [MONKEYDIR '/mat/' SessionType '/' SessionType '_Directions.' SessionNumberString '.mat'];
save(Filename,'Directions')