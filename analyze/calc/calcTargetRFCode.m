function [rfCode, targetAngle] = calcTargetRFCode(Tuning,location,Params);

%  rfCode = calcTargetRFCode(TUNING,RFPARAMS,LOCATION)
% 
%  Determines if the specified target location lies within the response
%  field of a tuned unit. Note: This code returns rfCodes regardless of
%  the tuning p-value. It is assumed that the calling function applies
%  a significance criterion beforehand.
%  
%  TUNING = Tuning data structure
%  LOCATION = Target location(s)
%  PARAMS = Specifies now to determine response field from Tuning data.

rfCode = -1*size(location,1); % 0 = nonRF, 1 = RF, -1= untuned/excluded

vonMises = isfield(Tuning,'Kappa') & isfield(Tuning,'ThetaHat');

if ~vonMises
  % First trigonometric moment - assume location is a 1-8 target index
  phi = Tuning.Phi; % assume phi=0 corresponds to target 1 (middle target in right-hemifield)
  negLocs = find(phi<0); % bottom-hemifield
  phi(negLocs) = 2*pi+phi(negLocs);
  rfLoc = round(phi/(pi/4))+1;
  rfLoc(find(rfLoc==9)) = 1;
  nonrfLoc = rfLoc-4; % * NON-RF LOC IS DIRECTLY OPPOSITE RF CENTER! *
  negLocs = find(nonrfLoc<=0);
  nonrfLoc(negLocs) = 8+nonrfLoc(negLocs);
  rfCode = zeros(numel(rfLoc),numel(location),'single');
  for k=1:numel(rfLoc)
    rfCode(k,:) = single(location==rfLoc(k));
    zLocs = find(rfCode(k,:)==0);
    if length(zLocs)>0
      rfCode(k,zLocs) = (location(zLocs)==nonrfLoc(k))-1;
    end
  end
  targetAngle = (location-1)*pi/4;
else
  % Von Mises distribution - assume location is a cartesian coordinate
  highThreshPct = Params.HighThreshPct;
  lowThreshPct = Params.LowThreshPct;
  thetahat = Tuning.ThetaHat;
  kappa = Tuning.Kappa;
  [maxPDF thetahat] = circ_vmpdf(thetahat,thetahat,kappa); % find max PDF

  % Find threshold crossing points
  locDim = 100;
  pdfCenters = [0:locDim-1]*2*pi/locDim;
  [p_test thetahat_test] = circ_vmpdf(pdfCenters,thetahat,kappa);
  minPDF = min(p_test);

  targetAngle = angle([location(:,1)+location(:,2)*i]);
  negLocs = find(targetAngle<0);
  targetAngle(negLocs) = 2*pi+targetAngle(negLocs);  
  locationIndex = ceil(targetAngle/(2*pi/locDim)+eps);
  
  highThreshPDF = highThreshPct*(maxPDF-minPDF)+minPDF;
  highThreshLocs = find(p_test>=highThreshPDF);
  lowThreshPDF = lowThreshPct*(maxPDF-minPDF)+minPDF;
  lowThreshLocs = find(p_test<=lowThreshPDF);
%   [ length(highThreshLocs) length(lowThreshLocs) ]

  rfCode = single(ismember(locationIndex,highThreshLocs));
  zLocs = find(rfCode==0);
  rfCode(zLocs) = -1+ismember(locationIndex(zLocs),lowThreshLocs);
end
    