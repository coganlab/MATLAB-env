% EIGEN: Returns the n largest sorted eigenvectors and eigenvalues of a square
%        matrix A.
%
%     Usage: [evects,evals] = eigen(A,{n})
%
%        A =      input matrix.
%        n =      optional number of eigenvectors & eigenvalues to be returned [default = all].
%        ---------------------------------------------------------------------------------
%        evects = matrix of eigenvectors (columns).
%        evals =  vector of eigenvalues in descending sequence.
%

% RE Strauss, 1/17/96
%   10/6/99 - allow for negative eigenvalues.
%   1/28/01 - convert complex values to real.
%   11/12/03 - add option to return subset of eigenvalues/vectors.

function [evects,evals] = eigen(A,n)
  if (nargin < 2) n = []; end;
  
  if (isempty(n)) n = size(A,1); end;

  [evects,D] = eig(A);                % Eigenanalysis
  D = diag(D);                        % Extract diagonal of eigenvalue matrix

  if (~isreal(D))                     % Convert complex values to real
    for i = 1:length(D)
      if (~isreal(D(i)))
        D(i) = abs(D(i));
      end;
    end;
  end;
  if (~isreal(evects))
    [r,c] = size(evects);
    for i = 1:r
      for j = 1:c
        if (~isreal(evects(i,j)))
          evects(i,j) = abs(evects(i,j));
        end;
      end;
    end;
  end;

  [evals,k] = sort(-D);               % Sort by descending eigenvalues
  evals = -evals;
  evects = evects(:,k);

  for j = 1:size(evects,2)            % Reverse negative-direction eigenvectors
    if (sum(evects(:,j))<0)
      evects(:,j) = -evects(:,j);
    end;
  end;
  
  evals = evals(1:n);
  evects = evects(:,1:n);

  return;
