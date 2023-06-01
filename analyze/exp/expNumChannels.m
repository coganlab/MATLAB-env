function numChannels = expNumChannels(experiment, tower)
%
%   numChannels = expNumChannels(experiment, tower)
%

numChannels = 0;
nTower = length(experiment.hardware.microdrive);
for iTower = 1:nTower
  if strcmp(experiment.hardware.microdrive(iTower).name,tower)
    nElectrode = length(experiment.hardware.microdrive(iTower).electrodes);
    for iElectrode = 1:nElectrode
      numChannels = numChannels + experiment.hardware.microdrive(iTower).electrodes(iElectrode).numContacts;
    end
  end
end
