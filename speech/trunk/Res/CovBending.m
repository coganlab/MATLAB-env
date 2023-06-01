% CovBending: Weighted "bending" (variance shrinkage) of an approximate, non-positive 
%             definite covariance matrix to find a corresponding positive-definite 
%             covariance matrix, using the method of Jorjani et al. (2003).
%
%     Usage: [Cadj,e_init,e_adj] = CovBending(Cinit,{w},{emin})
%
%         Cinit = approximate [p x p] covariance matrix.
%         w =     optional vector (length p) of weighting factors for variables
%                   [default = vector of 1s];
%                       OR
%                 optional [p x p] matrix of weights corresponding to elements of
%                   Cinit.
%         emin =  optional smallest desired value for eigenvalues [default = 1e-4].
%         -------------------------------------------------------------------------
%         Cadj = corresponding positive-definite covariance matrix.
%         e_init = [p x 1] vector of initial eigenvalues.
%         e_adj =  [p x 1] vector of adjusted eigenvalues.
%

% Jorjani, H, L Klei, and U Emanuelson. 2003. A simple method for weighted bending of genetic
%   (co)variance matrices.  Journal of Dairy Science 86:677-679.

% RE Strauss, 11/19/03

function [Cadj,e_init,e_adj] = CovBending(Cinit,w,emin)
  if (nargin < 2) w = []; end;
  if (nargin < 3) emin = []; end;
  
  [p,q] = size(Cinit);
  if (~iscov(Cinit))
    error('  CovBending: intput matrix must be square symmetric.');
  end;
  
  if (isempty(w)) w = ones(p,1); end;
  if (isempty(emin)) emin = 1e-4; end;
  
  if (isvector(w))
    if (length(w)~=p)
      error('  CovBending: weights vector not conformable with covariance matrix.');
    end;
    W = w*w';                     % Expand into weights for elements of covar matrix
  else
    W = w;
    if (size(W)~=size(Cinit))
      error('  CovBending: weights matrix must be same size as covariance matrix.');
    end;
  end;
%   W = 0.1*W./mean(mean(W));         % Adjust to mean weight = 0.5

  Cadj = Cinit;
  [U,D] = eig(Cinit);
  eval = diag(D);
  i = find(eval < emin);
  if (isempty(i))                 % Matrix already meets criterion
    return;
  end;
  
  [U,D] = eig(Cinit);
  eval = diag(D);
  while (any(eval<emin))      % Iterate till all eigenvalues >= emin
    i = find(eval<emin);
    eval(i) = emin*ones(length(i),1);
    Delta = diag(eval);
    Cadj = Cadj - (Cadj-U*Delta*U').*W;
    [U,D] = eig(Cadj);
    eval = diag(D);
  end;
  
  e_init = -sort(-eig(Cinit));
  e_adj =  -sort(-eig(Cadj)); 

  return;
  