% ISPOSDEF: Boolean function that determines whether a square symmetric matrix 
%           is positive-definite (all eigenvalues > zero).  If the matrix is not 
%           square-symmetric, returns 'false' and displays a warning message.
%           See posdef() to find a corresponding positive-definite matrix if 
%           this one is not such.
%
%     Usage: b = isposdef(S)
%
%         S = square symmetric matrix.
%         ----------------------------------
%         b = boolean response (true/false).
%

% RE Strauss, 11/2/01
%   11/5/03 -  use Cholesky decomposition rather than eigen decomposition (faster).
%   11/14/03 - reverted to use of eigenvalues.

function b = isposdef(S)
  b = 0;
  if (issqsym(S))
%     [R,p] = chol(S);
%     if (p==0)
%       b = 1;
%     end;
    e = eig(S);                       % Eigen decomposition
    if (all(diag(e)>eps))             % Matrix is pos def
      b = 1;
    end;
  else
    disp('  ISPOSDEF warning: matrix is not square-symmetric.');
  end;

  return;
