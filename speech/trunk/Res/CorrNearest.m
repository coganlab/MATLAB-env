% CorrNearest: For an indefinite correlation matrix that is not positive-semidefinite,
%              estimates the nearest positive-definite correlation matrix using the
%              alternating-projections method of Lucas (2001) and Higham (2002).  
%              Added the default (and more stringent) convergence criterion of 
%              all positive and real eigenvalues for Rnear.  If the a-p method
%              doesn't converge, then estimates the nearest matrix using the "bending"
%              method of Hayes & Hill (1980).
%
%     Usage: [Rnear,converge,sse,iter] = CorrNearest(Rinit,{W},{convcrit},{maxiter})
%
%         Rinit =    [n x n] initial, approximate correlation matrix.
%         W =        optional vector (length n) of weights for variables
%                      [default = ones(1,n)].
%         convcrit = optional converge criterion:
%                      1 = all eigenvalues real and positive [default];
%                      2 = min Frobenius norm (Lucas' criterion).
%         maxiter =  optional maximum number of iterations [default = 100].
%         -------------------------------------------------------------------------
%         Rnear =    nearest proper correlation matrix to Cindef.
%         converge = Boolean flag indicating, if true, that solution has converged.
%         sse =      Frobenius norm (weighted sse).
%         iter =     number of iterations to convergence.
%

% Lucas, C. 2001. Computing nearest covariance and correlation matrices.
%   MS Thesis, University of Manchester, 68 p.
% Higham, NJ. 2002. Computing the nearest correlation matrix -- a problem
%   from finance.  IMA J. Numerical Analysis 22:329-343.
% Hayes, JF and WG Hill. 1980. A reparameterisation of a genetic selection index to 
%   locate its sampling properties.  Biometrics 36:237-248.

% RE Strauss, 12/13/03, modified function cor_weight() of Lucas (2001).

function [Rnear,converge,sse,iter] = CorrNearest(Rinit,W,convcrit,maxiter)
  if (nargin < 2) W = []; end;
  if (nargin < 3) convcrit = []; end;
  if (nargin < 4) maxiter = []; end;

  [m,n] = size(Rinit);
  [mw,nw] = size(W);
  
  if (isempty(W))        W = ones(1,n); end;
  if (isempty(convcrit)) convcrit = 1; end;
  if (isempty(maxiter))  maxiter = 100; end;
  
  W = W(:)';

  if (~issqsym(Rinit))
    error('  CorrNearest: input matrix must be square and symmetric.');
  end;
  if (length(W)~=n)
    error('  CorrNearest: Rinit and W must be conformable.');
  end;
  if (~isscalar(convcrit) | (any(~isin(convcrit,[1,2]))))
    error('  CorrNearest: invalid convergence criterion.');
  end;
  
  if (isposdef(Rinit))          % If already positive-definite, get out of here
    Rnear = Rinit;
    converge = NaN;
    sse = 0;
    iter = 0;
    return;
  end;

  conv_tol = 1.0e-5;
  eig_tol = 1.0e-4;

  U = zeros(n,n);
  Y = Rinit;
  
  W = W./min(W);                % Normalize weights to minimum of 1
  W = diag(W);
  Winv = inv(W);

%   [V,D] = eig(Y);
%   e = diag(D);

  iter=0;
  while (iter <= maxiter)       % Converge to solution
    T = Y-U;
    
    [Q,D] = eig(W*T*W);           % Project onto positive-semidefinite matrices
    e = diag(D);

    p = (e > eig_tol*max(e));     % Create binary mask from relative positive eigenvalues    
    Rnear = Winv*(Q(:,p)*D(p,p)*Q(:,p)')*Winv;  % use mask to only compute 'positive' part
    
    u = Rnear-T;                  % Update Dykstra's correction
    Y = putdiag(Rnear,1);         % Project onto unit diagonal matrices

    iter = iter + 1;
    switch (convcrit)
      case 1,
        e = eig(Rnear);
        if (all(e>eps) & all(isreal(e)) & sum(diag(Rnear))==n)
          break;
        end;
      case 2,
        if (norm(Y-Rnear,'inf')/norm(Y,'inf') <= conv_tol)   % Convergence test
          break;
        end;
    end;
  end;

  converge = 1;
  if (iter >= maxiter)                    % If didn't converge,
    converge = 0;                           % Adjust eigenvalues directly    
    [S,D] = eig(Rinit);
    e = diag(D);
    p = length(e);
    
    i = find(e < eps);
    e(i) = eig_tol*ones(length(i),1);
    for i = 1:p
      S(:,i) = S(:,i)*e(i);
    end;
    B = sumsqscale(S')';
    Rnear = B*B';
  end;
  
  sse = norm(Rinit-Rnear,'fro');
  
  return;

