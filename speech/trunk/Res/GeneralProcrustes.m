% GeneralProcrustes: General least-squares Procrustes alignment of a set of point
%                    configurations using Gower's (1975) procedure, as modified by
%                    Rohlf & Slice (1990).
%
%     Usage: [maps,consensus,extramaps,sqdev] = GeneralProcrustes(forms,{extrapts},{noscale})
%
%         forms =     [n x p x k] matrix of k p-dimensional point configurations
%                       of n points each.
%         extrapts =  optional [m x p x k] matrix of auxiliary points to be mapped
%                       onto forms.
%         noscale =   optional boolean flag indicating that forms are not be be scaled
%                       [default = 0].
%         ------------------------------------------------------------------------------
%         maps =      [n x p x k] matrix of k translated, scaled and rotated
%                       configurations.
%         consensus = [n x p] matrix of coordinates of the consensus object.
%         extramaps = [m x p x k] matrix of mapped auxiliary points, if provided.
%         sqdev =     [n x k] matrix of squared deviations of points of k objects from
%                       the consensus.
%

% RE Strauss, Feb 2004

% Rohlf, FJ & D Slice.  1990.  Extensions of the Procrustes method for the optimal
%   superimposition of landmarks.  Syst. Zool. 39:40-59.
% Gower, JC.  1975.  Generalized Procrustes analysis.  Psychometrika 40:33-51.

function [maps,consensus,extramaps,sqdev] = GeneralProcrustes(forms,extrapts,noscale)
  if (nargin < 1) help GeneralProcrustes; return; end;
    
  if (nargin < 2) extrapts = []; end;
  if (nargin < 3) noscale = []; end;
  
  if (isempty(noscale)) noscale = 0; end;
  isextra = 0;
  if (~isempty(extrapts))
    isextra = 1;
    size_extra = size(extra);
  end;
  
  size_forms = size(forms);
  nforms = size_forms(3);
  npts = size_forms(1);
  
  if (isextra)
    if (any(size_forms(2:3)~=size_extra(2:3)))
      error('  GeneralProcrustes: sizes of forms and extra-forms matrices not compatible.');
    end;
  end;
  
  meancrds = mean(forms);             % Mean point coordinates, by form  
  for fi = 1:nforms                   % Center and optionally scale individual forms
    f = forms(:,:,fi);                  % Isolate current form
    mc = meancrds(:,:,fi);              % Mean crds for form
    f = f - ones(npts,1)*mc;            % Center crds on zero
    if (isextra)
      e = extrapts(:,:,fi);
      e = e - ones(npts,1)*mc;
    end;
    
    s = 1./sqrt(trace(f*f'));              % Multiplicative scaling factor
    f = f*s;
    if (isextra)
      e = e*s;
    end;
  end;

  return;
  