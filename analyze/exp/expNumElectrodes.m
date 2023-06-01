function numElectrodes = expNumElectrodes(experiment, tower)
%
%
%

numElectrodes = 0;
nTower = length(experiment.hardware.microdrive);
for iTower = 1:nTower
  if strcmp(experiment.hardware.microdrive(iTower).name,tower)
    numElectrodes = length(experiment.hardware.microdrive(iTower).electrodes);
  end
end
