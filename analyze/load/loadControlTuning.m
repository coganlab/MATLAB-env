function ControlTuning = loadControlTuning(SessType, SessNum, Task, Epoch)
%
%  ControlTuning = loadControlTuning(SessType, SessNum, Task, Epoch)
%
%  Inputs:  SessType = String.  'Spike' or 'Field'
%           SessNum  = Scalar.  Session number
%           Task     = String.  Task name.  (Optional)
%           Epoch    = String.  Epoch name (Optional) 
%


global MONKEYDIR

load(fullfile(MONKEYDIR, 'mat', SessType, [SessType '_ControlTuning.' num2str(SessNum) '.mat']));

if nargin > 2 ControlTuning = ControlTuning.(Task); end
if nargin > 3 ControlTuning  = ControlTuning.(Epoch); end

