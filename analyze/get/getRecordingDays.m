function Dir = getRecordingDays
%
% Returns the recording day information
%
global MONKEYDIR


Dir1 = dir([MONKEYDIR '/0*']);
Dir2 = dir([MONKEYDIR '/1*']);

% Just incase we are still using this in 2020
Dir3 = dir([MONKEYDIR '/2*']);

Dir = [Dir1;Dir2;Dir3];