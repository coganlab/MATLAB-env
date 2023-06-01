function Session = loadSpikeMultiunitField_Database(MonkeyDir)
%
%  Session = loadSpikeMultiunitField_Database(MonkeyDir)
%

global MONKEYDIR

if nargin == 1 ProjectDir = MonkeyDir; else ProjectDir = MONKEYDIR; end

load([ProjectDir '/mat/SpikeMultiunitField_Session.mat']);
