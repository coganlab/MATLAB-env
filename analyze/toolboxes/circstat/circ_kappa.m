function kappa = circ_kappa(alpha,w)
%
% kappa = circ_kappa(alpha,[w])
%   Computes an approximation to the ML estimate of the concentration 
%   parameter kappa of the von Mises distribution.
%
%   Input:
%     alpha   angles in radians OR alpha is length resultant
%     [w      number of incidences in case of binned angle data]
%
%   Output:
%     kappa   estimated value of kappa
%
%   References:
%     Statistical analysis of circular data, Fisher, equation p. 88
%
% Circular Statistics Toolbox for Matlab

% By Philipp Berens, 2009
% berens@tuebingen.mpg.de - www.kyb.mpg.de/~berens/circStat.html


% alpha = alpha(:); % commented out by D.A. Markowitz on 120612 to enable handling of 2D matrices

if nargin<2
  % if no specific weighting has been specified
  % assume no binning has taken place
	w = ones(size(alpha));
else
  if size(w,2) > size(w,1)
    w = w';
  end 
end

N = length(alpha);

% commented out due to incompatibility with 2D data matrices (D.A. Markowitz, 120612)
% if N>1
%   R = circ_r(alpha,w);
% else
  R = alpha;
% end

% added support for multidimensional R (D.A. Markowitz, 120612)
kappa = zeros(size(R));
for k=1:numel(R)
  if R(k) < 0.53
    kappa(k) = 2*R(k) + R(k).^3 + 5*R(k).^5/6;
  elseif R(k)>=0.53 & R(k)<0.85
    kappa(k) = -.4 + 1.39*R(k) + 0.43/(1-R(k));
  else
    kappa(k) = 1./(R(k).^3 - 4*R(k).^2 + 3*R(k));
  end
end

if N<15 && N>1
  if kappa < 2
    kappa = max(kappa-2*(N*kappa)^-1,0);    
  else
    kappa = (N-1)^3*kappa/(N^3+N);
  end
end
