function isSpiking = sessIsSpiking(Session)
%
%  isSpiking = sessIsSpiking(Session)
%

% global MONKEYDIR
if iscell(Session{1})
  nSess = length(Session);
else
  nSess = 1;
  Session = {Session};
end

olddir = pwd;

isSpiking = zeros(1,nSess);

for iSess = 1:nSess
    monkeyDir = sessMonkeyDir(Session{iSess});
    day = sessDay(Session{iSess});
    tower = sessTower(Session{iSess});
    channel = sessElectrode(Session{iSess});
    cd([monkeyDir '/m/depth/']); 
    eval(['Movement_' tower{1} '_' day]);
    isSpiking(iSess) = endSP(channel);
end
cd(olddir);
