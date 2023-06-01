function experiment = loadExperiment(Subject)
%
%  experiment = loadExperiment(Subject)
%

global DUKEDIR
[DUKEDIR '/' Subject '/mat/experiment.mat']
load([DUKEDIR '/' Subject '/mat/experiment.mat'])
