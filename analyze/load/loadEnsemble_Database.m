function Session = loadEnsemble_Database(MonkeyDir)
%
%  Session = loadEnsemble_Database(MonkeyDir)
%

global MONKEYDIR

if nargin == 1 ProjectDir = MonkeyDir; else ProjectDir = MONKEYDIR; end


load([ProjectDir '/mat/Ensemble_Session.mat']);
