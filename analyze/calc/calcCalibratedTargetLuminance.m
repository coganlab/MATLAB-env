function luminance = calcCalibratedTargetLuminance(brightness_calibration,target_size_degrees,brightness_values);

for i=1:length(brightness_calibration)
  if  brightness_calibration(i).target_size_degrees == target_size_degrees
   p = brightness_calibration(i).polynomial_fit_parameters;
   break;
  end
end

luminance = zeros(size(brightness_values));
for i=1:length(p)
  luminance = luminance + p(i).*brightness_values.^(length(p)-i); 
end
