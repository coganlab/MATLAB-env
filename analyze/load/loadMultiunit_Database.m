function Session = loadMultiunit_Database(MonkeyDir)
%
%  Session = loadMultiunit_Database(MonkeyDir)
%

global MONKEYDIR 

if nargin == 1 ProjectDir = MonkeyDir; else ProjectDir = MONKEYDIR; end

load([ProjectDir '/mat/Multiunit_Session.mat']);

%  Checks for legacy Sessions without MONKEYNAME or SESSIONTYPE
for iSess = 1:length(Session)
    if length(Session{iSess})==6
        Session{iSess}{7} = ProjectDir;
        Session{iSess}{8} = {'Multiunit'};
    elseif ~ismember(Session{iSess}{7},'/')
        Session{iSess}{7} = ProjectDir;
    end
end

