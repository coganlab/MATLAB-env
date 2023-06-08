function Directions = loadSessionDirections(Session)
%
%  Directions = loadSessionDirections(Session)
%
%  loads Preferred and Null directions for Session in 
%   MONKEYDIR/mat/SESSTYPE/SESSTYPE_Directions.SESSNUM.mat

MonkeyDir = sessMonkeyDir(Session);

SessionType = sessType(Session);
SessionNumberString = getSessionNumberString(Session);
Filename = [MonkeyDir '/mat/' SessionType '/' SessionType '_Directions.' SessionNumberString '.mat'];
if exist(Filename,'file')
  load(Filename)
else
    disp([Filename ' does not exist']);
    Directions.Pref = nan;  Directions.Null =nan;
    Directions.Dirs = [nan,nan];
    Directions.ReachSaccade.p = nan;
end