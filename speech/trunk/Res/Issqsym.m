% ISSQSYM: Determines whether a matrix is square-symmetric (within tolerance).
%
%     Usage: b = issqsym(X,{tol})
%
%         X =   input matrix.
%         tol = optional tolerance for test of symmetry (max difference between 
%                 corresponding upper- and lower-triangular values) 
%                 [default = 10*eps].
%         ---------------------------------------------------------------------
%         b =   boolean value: true if X is square-symmetric, false otherwise.
%

% RE Strauss, 10/3/00
%   11/30/03 - increased tolerance from 2*eps to 1e6*eps.

function b = issqsym(X,tol)
  if (nargin < 2) tol = []; end;

  if (isempty(tol))
    tol = eps*1e6;
  end;

  b = 1;

  [r,c] = size(X);
  if (r==c)
    d = max(trilow(X-X'));
    if (d > tol)
      b = 0;
    end;
  else
    b = 0;
  end;

  return;
