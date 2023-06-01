function y = trigmoment(Angles, Values)
%
%  y = trigmoment(Angles, Values)
%

y = sum(exp(i*Angles).*Values)./length(Values);
