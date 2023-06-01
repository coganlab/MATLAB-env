function Session = loadLaminar_Database(MonkeyDir)
%
%  Session = loadLaminar_Database(MonkeyDir)
%

global MONKEYDIR

if nargin == 1 ProjectDir = MonkeyDir; else ProjectDir = MONKEYDIR; end


load([ProjectDir '/mat/Laminar_Session.mat']);
