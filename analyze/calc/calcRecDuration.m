function recDuration = calcRecDuration(day, rec)
%  Returns length on recording
%
% recDuration = calcRecDuration(Trials)

global experiment MONKEYDIR

if isfield(experiment,'acquire')
    STATEFILE = [MONKEYDIR '/' day '/' rec '/rec' rec '.state.dat'];
    d = dir(STATEFILE);
    recDuration = d.bytes;
else MONKEYDIR(end-4:end) == 'Laser'
    RECFILE = [MONKEYDIR '/' day '/' rec '/rec' rec '.LaserV.raw.dat'];
    d = dir(RECFILE);
    recDuration = d.bytes;
end