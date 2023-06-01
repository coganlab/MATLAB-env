% CorrPairwise: Given a data matrix containing missing data, estimates means, variances and
%              correlations using elementwise deletion of missing values for all possible pairs
%              of variables.  Optionally tests whether the correlation matrix is positive
%              definite and, if not, adjusts it to be so.  If the adjustment is not
%              successful, returns a null correlation matrix.
%
%     Usage: [C,M,N] = corrpairwise(X,{makeposdef})
%
%         X =          [n x p] data matrix.
%         makeposdef = optional boolean flag indicating, if true, that correlation matrix is
%                        to be adjusted to be positive definite [default = 0].
%         ---------------------------------------------------------------------------------
%         C =          [p x p] correlation matrix.
%         M =          [1 x p] vector of means.
%         N =          [p x p] matrix of pairwise sample sizes.
%

% RE Strauss, 7/1/02
%   3/12/04 - find correlations directly rather than via covariances.

function [C,M,N] = corrpairwise(X,makeposdef)
  if (nargin < 2) makeposdef = []; end;
  
  if (isempty(makeposdef))
    makeposdef = 0;
  end;

  [n,p] = size(X);
  C = NaN*ones(p,p);                     
  M = zeros(1,p);
  N = zeros(p,p);
  nc = 0;
  sumc = 0;
  
  X = zscore(X);                      % Standardize data matrix
  
  for i = 1:p                         % For all variables,
    y = X(isfinite(X(:,i)),i);          % Eliminate missing values
    if (~isempty(y))
      M(i) =  mean(y);                    % Estimate means & variances
      C(i,i) = var(y);
      N(i,i) = length(y);
    else
      M(i) = NaN;
      C(i,i) = NaN;
    end;
  end;

  for ip = 1:(p-1)
    for jp = 2:p
      indx = find(isfinite(X(:,ip)) & isfinite(X(:,jp))); % Find pairwise available values
      if (length(indx)>1)
        C(ip,jp) = corr(X(indx,ip),X(indx,jp));
        C(jp,ip) = C(ip,jp);
      end;
    end;
  end;

%   for i = 1:(p-1)                     % For all pairs of variables,
%     for j = (i+1):p
%       indx = find(isfinite(X(:,i)) & isfinite(X(:,j))); % Find pairwise available values
%       if (length(indx)>1)
%         y = X(indx,[i j]);
%         y(:,1) = y(:,1) - M(i);           % Subtract respective means
%         y(:,2) = y(:,2) - M(j);
%         c = y'*y / (length(indx)-1);      % Adjusted correlation
%         sumc = sumc + c(1,2);
%         nc = nc + 1;
%         C(i,j) = c(1,2);
%         C(j,i) = c(1,2);
%         n = size(y,1);
%         N(i,j) = n;
%         N(j,i) = n;
%       end;
%     end;
%   end;

  [i,j] = find(~isfinite(C));           % If any correlations are still missing,
  if (~isempty(i))                      %   set to mean correlation
    meanc = sumc / nc;
    for k = 1:length(i)
      C(i(k),j(k)) = meanc;
    end;
  end;

  if (makeposdef)
      [C,isposdef] = posdef(C);         % Attempt to make positive definite if not so
  end;
  
  C = putdiag(C,1);                     % Enforce 1's on diagonal
    
  return;
