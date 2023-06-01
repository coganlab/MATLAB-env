  % CovNearest: For an indefinite covariance matrix that is not positive-semidefinite,
%             estimates the nearest positive-definite covariance matrix by scaling
%             the matrix to an indefinite correlation matrix, using the
%             alternating-projections method to estimate the nearest correlation matrix 
%             (see CorrNearest), and rescaling to a covariance matrix.  Returns a null
%             covariance matrix if the adjustment fails to converge.
%
%     Usage: [Cnear,converge,sse,iter] = CovNearest(Cinit,{W},{convcrit},{maxiter})
%
%         Cinit =    [n x n] initial, approximate correlation matrix.
%         W =        optional vector (length n) of weights for variables
%                      [default = ones(1,n)].
%         convcrit = optional converge criterion for correlation matrix:
%                      1 = all eigenvalues real and positive [default];
%                      2 = min Frobenius norm (Lucas' criterion).
%         maxiter =  optional maximum number of iterations [default = 100].
%         -----------------------------------------------------------------
%         Cnear =    nearest proper correlation matrix to Cindef.
%         converge = Boolean flag indicating, if true, that solution has converged.
%         sse =      Frobenius norm (weighted sse).
%         iter =     number of iterations to convergence.
%

% RE Strauss, 12/13/03

function [Cnear,converge,sse,iter] = CovNearest(Cinit,W,convcrit,maxiter)
  if (nargin < 2) W = []; end;
  if (nargin < 3) convcrit = []; end;
  if (nargin < 4) maxiter = []; end;
  
  [Rinit,S] = covcorr(Cinit);
  [Rnear,converge,sse,iter] = CorrNearest(Rinit,W,convcrit,maxiter);
Rnear  
  Cnear = covcorr(Rnear,S);

  return;

