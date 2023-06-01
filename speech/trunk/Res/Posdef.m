% POSDEF: If a correlation or covariance matrix is positive definite, returns 
%         the same matrix and a flag value of 1.  If not, returns a corresponding 
%         matrix that is positive definite by rescaling negative eigenvalues to a
%         value of 0, holding constant the total variance.  Finds the corresponding 
%         matrix by adjusting to be positive and then reconstructing matrix.  If the 
%         input matrix is not square-symmetric or cannot be made positive-definite, 
%         returns a flag of 0 and a null matrix.
%
%     Usage: [Cpd,ispdef] = posdef(C)
%
%         C =      correlation or covariance matrix.
%         ------------------------------------------------------------------------
%         Cpd =    corresponding positive-definite correlation or covariance 
%                       matrix.
%         ispdef = flag: 1 = input matrix is positive definite
%                        0 = input matrix is not positive definite
%                       -1 = input matrix is not positive definite and                           
%                              cannot be adjusted to be positive definite.
%         converge = the 'converge' flag from CovNearest().
%

% RE Strauss, 11/20/99
%   11/2/01 - use issqsym() to determine whether is square-symmetric.
%   5/14/02 - replaced nonpos evals with 10*eps (applied repeatedly) rather than eps.
%   5/17/02 - use while loop to ensure that all final eigenvalues are positive.
%   5/30/02 - added condition for (ispdef == -1).
%  11/13/03 - replace previous method for adjusting to be pos-def with CovNearest();
%               use isposdef() to check for state of being positive-definite;
%               use iscov() to check whether form of input matrix is correct.
%  11/14/03 - added check for converge.
%  11/19/03 - return the converge flag from CovNearest().
%  11/26/03 - replace CovNearest() with CovBending().

function [C,ispdef,converge] = posdef(C)
  converge = NaN;
  if (~iscov(C))                          % Check whether is square-symmetric
    C = [];
    ispdef = 0;
    return;
  end;

  ispdef = isposdef(C);                   % Check whether matrix is positive-definite.
  if (~ispdef)
%     [C,converge] = CovNearest(C);
    C = CovBending(C);
  end;

  return;
