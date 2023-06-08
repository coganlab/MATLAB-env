function Session = loadSpike_Database(MonkeyDir)
%
%  Session = loadSpike_Database(MonkeyDir)
%
%	If MonkeyDir input is not defined, defaults to global MONKEYDIR

global MONKEYDIR 

if nargin == 1 ProjDir = MonkeyDir; else ProjDir = MONKEYDIR; end

if exist([ProjDir '/mat/Spike_Session.mat'])
    disp('Spike_Session.mat exists')
    load([ProjDir '/mat/Spike_Session.mat']);
else
    Session = Spike_Database;
end

%  Checks for legacy Sessions without MONKEYDIR or SESSIONTYPE
for iSess = 1:length(Session)
    if length(Session{iSess})==6
        Session{iSess}{7} = ProjDir;
        Session{iSess}{8} = {'Spike'};
    elseif ~ismember(Session{iSess}{7},'/')
        Session{iSess}{7} = ProjDir;
    end
end

