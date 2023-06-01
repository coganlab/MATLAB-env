function y = calcContinuous(Trials)
%
%  y = calcContinuous(Trials)
%
%   Returns 1 for trials with target locations on a continuous spatial axis
%           0 otherwise
%

y = zeros(1,length(Trials));

eyetarg_tmp = [Trials.EyeTargetLocation];

if isnan(sum(eyetarg_tmp)) 
    eyetarg_tmp = ones(1,length([Trials.EyeTargetLocation])); 
end

eyetarg = reshape([eyetarg_tmp],2,length(Trials));
eyeones = [ones(size(eyetarg))];
continuous_tmp = (rem(eyetarg,eyeones) == 0);
continuous = continuous_tmp(1,:)+continuous_tmp(2,:);
%%%%%% Variable Name
y(find(continuous ~= 2)) = 1;