% MahalCI: Asymptotic confidence interval for Mahalanobis distances among groups, 
%          based on non-central F distribution.
%
%     Syntax: CI = MahalCI(X,grps,D2,{CI_level})
%
%        X =         [n x p] data matrix (obs x vars).
%        grps =      row or column vector of group identifiers.
%        D2 =        [g x g] matrix of Mahalanobis distances.
%        CI_level =  percent width of confidence intervals [default=95].
%        ---------------------------------------------------------------------
%        CI =    [g x g] matrix of low (lower triangular matrix) and
%                  high (upper triangular matrix) confidence limits.
%

% RE Strauss, 5/6/98
%   11/29/99 - changed calling sequence.
%   11/26/03 - replace RES noncentral F-inv function by Matlab stat toolbox function.
%   11/29/03 - rewrite based on MahalPr().

function CI = MahalCI(X,grps,D2,CI_level)
  if (nargin < 4) CI_level = []; end;

  if (isempty(CI_level))            % If CI-level not passed, set to default
    CI_level = 0.95;
  else
    if (CI_level > 1)               % Convert to interval [0,1]
      CI_level = 0.01*CI_level;
    end;
  end;
  intlow = (1-CI_level)/2;
  inthigh = 1 - intlow;

  [index,N] = uniquef(grps);        % Vector of within-group sample sizes
  g = length(index);                % Number of groups
  [nobs,p] = size(X);               % Numbers of observations & variables
  CI = NaN*ones(g,g);               % Allocate output matrix of confidence intervals
  CI = putdiag(CI,0);

  n = (N*ones(1,g) + ones(g,1)*N'); % ni + nj
  c = (N*N')./n;                    % (ni*nj)/(ni+nj)
  m = n-p-1;
  k = p*(n-2);
  lambda = c;

  df1 = p;
  df2 = m;
  df2_save = df2;

  [ok,intlow,inthigh,df1,df2,lambda] = samelength(intlow,inthigh,df1,df2(:),lambda(:));

  [i,j] = find(df2_save>0);               % Find CI for df2>0
  D2low = ncfinv(intlow,df1,df2,lambda);
  D2high = ncfinv(inthigh,df1,df2,lambda);
  
  for k = 1:length(i)
    ik = i(k);
    jk = j(k);
    if (ik < jk)
      CI(ik,jk) = D2high(k);
    elseif (ik > jk)
      CI(ik,jk) = D2low(k);
    end;
  end;
  
  return;

