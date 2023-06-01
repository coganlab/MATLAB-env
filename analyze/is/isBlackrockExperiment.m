function out = isBlackrockExperiment(experiment)
%  Returns whether plexon data is available in this experiment
%
%  out = 1 if plexon
%
%  INPUTS: EXPERIMENT = Data structure.  Experiment data structure
%
%  OUTPUTS: OUT = 0/1 scalar.

if isfield(experiment.hardware.acquisition(1), 'type') % Preferred
    if strcmp(experiment.hardware.acquisition(1).type,'Blackrock')
        out = 1;
    else
        out = 0;
    end
else
    out = 0;
end