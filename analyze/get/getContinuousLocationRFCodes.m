function [rfCodes_chosen,rfCodes_unchosen] = getContinuousLocationRFCodes(rfAngle, nonrfAngle, Trials);

% Determine if chosen target is in RF (1), nonRF (2), or excluded region (3)

critDist = 2*pi/100;

rfCodes_chosen = zeros(size(Trials));
rfCodes_unchosen = zeros(size(Trials));
for t=1:length(Trials)
  continuous_target = Trials(t).SaccadeChoiceContinuousLocation;
  continuous_target_unchosen = Trials(t).UnchosenTargetContinuousLocation; 
  
  phi = atan2(continuous_target(2),continuous_target(1));
  phi(phi<0) = phi(phi<0)+2*pi; %   phi(phi > 15*pi./8) = phi(phi > 15*pi./8) - 2*pi;
  rfDist = min(abs(phi-rfAngle));
  nonrfDist = min(abs(phi-nonrfAngle));
  if rfDist<=critDist
    rfCodes_chosen(t) = 1;
  elseif nonrfDist<=critDist
     rfCodes_chosen(t) = 2;
  else
    rfCodes_chosen(t) = 3; 
  end
  
  phi = atan2(continuous_target_unchosen(2),continuous_target_unchosen(1));
  phi(phi<0) = phi(phi<0)+2*pi; %   phi(phi > 15*pi./8) = phi(phi > 15*pi./8) - 2*pi;
  rfDist = min(abs(phi-rfAngle));
  nonrfDist = min(abs(phi-nonrfAngle));
  if rfDist<=critDist
    rfCodes_unchosen(t) = 1;
  elseif nonrfDist<=critDist
     rfCodes_unchosen(t) = 2;
  else
    rfCodesun_chosen(t) = 3; 
  end
  
end






