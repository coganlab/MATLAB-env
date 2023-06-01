function out = isMocapExperiment(experiment)
%  Returns whether mocap data is available in this experiment
%
%  out = isMocapExperiment(experiment)
%
%  INPUTS: EXPERIMENT = Data structure.  Experiment data structure 
%
%  OUTPUTS: OUT = 0/1 scalar.

if isfield(experiment.software.behavior,'mocap') % Preferred
  out = experiment.software.behavior.mocap.available;
elseif isfield(experiment.software,'markerset')  % Legacy
    out = 1;
else
  out = 0;
end
