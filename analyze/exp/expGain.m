function gain = expGain(experiment, tower, electrode, contact)
%
%  gain = expGain(experiment, tower, electrode, contact)
%

AD_neural_gain = experiment.hardware.acquisition(1).AD_neural_gain;
nTower = length(experiment.hardware.microdrive);
for iMicrodrive = 1:nTower
  if strcmp(experiment.hardware.microdrive(iMicrodrive).name,tower)
    electrode_gain = experiment.hardware.microdrive(iMicrodrive).electrodes(electrode).gain;
  end
end

gain = AD_neural_gain./electrode_gain * 1e6;
