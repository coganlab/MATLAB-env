function Session = loadFieldField_Database(MonkeyDir)
%
%  Session = loadFieldField_Database(MonkeyDir)
%

global MONKEYDIR 

if nargin == 1 ProjectDir = MonkeyDir; else ProjectDir = MONKEYDIR; end

load([ProjectDir '/mat/FieldField_Session.mat']);

%  Checks for legacy Sessions without MONKEYDIR or SESSIONTYPE
for iSess = 1:length(Session)
  if length(Session{iSess})==6
    Session{iSess}{7} = ProjectDir;
    Session{iSess}{8} = {'Field','Field'};
  end
end

