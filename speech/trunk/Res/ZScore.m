% ZSCORE: Standardizes the columns of an [n,p] matrix X.  Ignores missing data.
%
%     Usage: z = zscore(X)
%
%         X = [n x p] data matrix.
%         ----------------------------------------
%         z = [n x p] matrix of standardized data.
%

% RE Strauss, 10/14/97
%    6/22/00 - allow for columns of constants; allow for missing data.
%   11/14/03 - simplify code by separately operating on columns.

function z = zscore(X)
  if (nargin < 1) help zscore; return; end;
  
  [n,p] = size(X);
  z = NaN*ones(size(X));
  
  for ip = 1:p
    x = X(:,ip);
    i = find(isfinite(x));
    m = mean(x(i));
    s = std(x(i));
    if (s > eps)
      x(i) = (x(i)-m)./s;
    else
      x(i) = zeros(size(i));
    end;
    z(:,ip) = x;
  end;

  return;
