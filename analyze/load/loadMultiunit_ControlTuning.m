function CT = loadMultiunit_ControlTuning(Session, TaskName, EpochName)
%
%  
%

if iscell(Session)
  SessNum = getSessionNumbers(Session);
else
  SessNum = Session;
end

global MONKEYDIR

for iSess = 1:length(SessNum)
  load([MONKEYDIR '/mat/Multiunit/Multiunit_ControlTuning.' num2str(SessNum(iSess)) '.mat']);

  if nargin < 2 || isempty(TaskName)
  else
    ControlTuning = ControlTuning.(TaskName);
    if nargin < 3 || isempty(EpochName)
    else
      ControlTuning = ControlTuning.(EpochName);
    end
  end
  CT(iSess) = ControlTuning;
end


