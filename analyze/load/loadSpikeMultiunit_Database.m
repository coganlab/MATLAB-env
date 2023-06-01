function Session = loadSpikeMultiunit_Database(MonkeyDir)
%
%  Session = loadSpikeMultiunit_Database(MonkeyDir)
%

global MONKEYDIR 

if nargin == 1 ProjDir = MonkeyDir; else ProjDir = MONKEYDIR; end

load([ProjDir '/mat/SpikeMultiunit_Session.mat']);

%  Checks for legacy Sessions without MONKEYDIR or SESSIONTYPE
for iSess = 1:length(Session)
  if length(Session{iSess})==6
    Session{iSess}{7} = ProjDir;
    Session{iSess}{8} = {'Spike','Multiunit'};
  end
end

