% PCoA: Principal coordinates analysis of a distance matrix.  Eigenvector 
%       coefficients represent coordinates (scores) of objects.  Scores are
%       normalized to sum-of-squares = eigenvalue.  If the original data
%       matrix is passed, estimates correlations of variables with PCo axes
%       and returns them as 'loadings'.
%
%     Usage: [scores,percvar,loadings,totvar] = pcoa(D,{X})
%
%       D =        [n x n] square symmetric distance matrix.
%       X =        optional [n x p] data matrix from which D was calculated.
%       --------------------------------------------------------------------
%       scores =   [n x k] matrix of scores on k PCo axes.
%       percvar =  [k x 1] vector of percentages of variance accounted for
%                    the PCo axes.
%       loadings = [p x k] matrix of correlations of variables with PCo
%                    axes.
%       totvar =   sum of k positive eigenvalues (k <= n).

% Krzanowski and Marriott (1994), pp. 108-109.

% RE Strauss, 6/3/95
%   12/5/03 - explicitly return scores and loadings rather than just eigenvectors
%               and eigenvalues.

function [scores,percvar,loadings,totvar] = pcoa(D,X)
  if (nargin < 2) X = []; end;
  
  if (~isdist(D))
    error('  PCoA: distance matrix not of proper form.');
  end;
  
  tol = 1e6*eps;                      % Tolerance for identifying positive eigenvalues

  n = size(D,1);
  if (~isempty(X))
    [nx,p] = size(X);
    if (nx~=n)
      error('  PCoA: distance and data matrices are incompatible.');
    end;
  end;

  gamma = zeros(n);                   % Form gamma matrix
  for i=1:(n-1)
    for j=(i+1):n
      gamma(i,j) = -0.5 * D(i,j)^2;
      gamma(j,i) = gamma(i,j);
    end;
  end;

  mean_col = mean(gamma);             % Convert to phi matrix
  mean_gamma = mean(mean_col);
  phi = gamma;
  for i=1:n
    mean_row = mean(gamma(i,:));
    for j=1:n
      phi(i,j) = gamma(i,j) - mean_row - mean_col(j) + mean_gamma;
    end;
  end;

  [evects,evals] = eigen(phi);         % Eigenanalysis

  k = max(find(evals>tol));            % Number of positive eigenvalues
  evals = evals(1:k);                  % Adjust matrix sizes
  evects = evects(:,1:k);
  
  totvar = sum(evals);                 % Scale eigenvalues to percent variance accounted for
  percvar = 100*evals./totvar;             

  for i=1:k                            % Normalize eigenvectors
    f = evals(i)/sum(evects(:,i).^2);
    evects(:,i) = sqrt((evects(:,i).^2).*f).*sign(evects(:,i));
  end;  
  
  scores = evects;                     % Eigenvectors are coordinate scores
  
  loadings = [];
  if (~isempty(X))                     % Estimate correlations of vars with PCo axes
    loadings = corr(X,scores);
  end;

  return;
