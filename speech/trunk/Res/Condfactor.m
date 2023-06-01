% CONDFACTOR: Returns a modified version of the matrix condition number, given the 
%             corr/cov matrix.  Returns NaN if the input corr/cov matrix is not and 
%             cannot be made positive-definite.
%
%     Usage: [cf,evals] = condfactor(C,{condtype})
%
%         C =         correlation or covariance matrix.
%         condtype =  optional type of condition factor to be used:
%                       1 = condition factor, which measures stability of the 
%                           eigensolution, and is greatest when the ratio 
%                           (eigenvalue 1)/(eigenvalue 2) is large [default];
%                       0 = reciprocal condition factor, which measures 
%                           stability under matrix inversion, and is greatest 
%                           when the ratio (eigenvalue 1)/(eigenvalue 2) is  
%                           small.
%         -------------------------------------------------------------------
%         cf =        condition factor.
%         evals =     sorted eigenvalues.
%

% RE Strauss, 6/21/02
%   7/1/02 -   fix problem with sorting eigenvalues from large to small.
%   9/23/02 -  return eigenvalues.
%   9/24/03 -  return the raw eigenvalues rather than log eigenvalues.
%   10/29/03 - added error message for null input matrix.
%   1/24/04 -  remove check for positive-definite cov/corr matrix.

function [cf,evals] = condfactor(C,condtype)
  if (nargin < 2) condtype = []; end;
  
  if (isempty(condtype)) condtype = 1; end;

  if (condtype~=0 & condtype~=1)
    error('  CondFactor: invalid type of condition factor.');
  end;
  
  if (isempty(C))
    error('  CondFactor: input correlation/covariance matrix is empty.');
  end;

  Ciscorr = 0;                            % Check if C is a correlation matrix
  if (iscorr(C))
    Ciscorr = 1;
  end;
  if (~Ciscorr)
    if (~iscov(C))
      error('  CondFactor: invalid input correlation/covariance matrix.');
    end;
  end;

%   [C,isposdf] = posdef(C);                % Make positive definite if not so
%   if (Ciscorr)                            % Optionally rescale to corr matrix              
%     C = covcorr(C);
%   end;
  
  evals = -sort(-eig(C));                 % Find characteristic roots
  logevals = log(evals);

%   if (isposdf < 0)                       % If matrix isn't positive definite,
%     evals = [NaN NaN];                    %   standard condition factor is undefined
%   end;
  
  if (condtype)       
%    cf = log(cond(C));         % Condition factor
    cf = logevals(1)-logevals(2);         % Modified: log(e1)-log(e2) = log(e1/e2)
  else
%    cf = log(rcond(C));        % Reciprocal condition factor
    cf = logevals(2)-logevals(1);         % Modified: log(e2)-log(e1) = log(e2/e1)
  end;

  return;
  

