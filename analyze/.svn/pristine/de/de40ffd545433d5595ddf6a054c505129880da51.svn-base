function volume = calcCalibratedRewardVolume(solenoid_calibration,duration_values);


p = solenoid_calibration.polynomial_fit_parameters;

volume = zeros(size(duration_values));
for i=1:length(p)
  volume = volume + p(i).*duration_values.^(length(p)-i); 
end
