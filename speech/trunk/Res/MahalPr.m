% MAHALPR: Asymptotic probabilities for Mahalanobis distances among groups,
%          based on a central F-distribution.
%
%     Syntax: prob = mahalpr(X,grps,D2)
%
%        X =         [n x p] data matrix (obs x vars).
%        grps =      row or column vector of group identifiers.
%        D2 =        [g x g] matrix of Mahalanobis distances.
%        ---------------------------------------------------------------------
%        prob =      [g x g] matrix of probabilities of H0:D2=0.
%

% SPSS 7.5 Statistical Algorithms, p 136.

% RE Strauss, 5/6/98
%   11/29/99 - changed calling sequence.
%   11/26/03 - replace nonpositive df2 values with NaNs;
%              enforce 1s on diagonal of prob matrix;
%              altered values for m and k based on 2 grps.

function prob = mahalpr(X,grps,D2)
  [index,N] = uniquef(grps);
  g = length(index);                % Number of groups
  [nobs,p] = size(X);               % Numbers of observations & variables

  n = (N*ones(1,g) + ones(g,1)*N'); % ni + nj
  c = (N*N')./n;                    % (ni*nj)/(ni+nj)
  m = n-p-1;
  k = p*(n-2);

  df1 = p;
  df2 = m;
  if (any(df2(:)<1))
    [i,j] = find(df2<1);
    for k = 1:length(i)
      df2(i(k),j(k)) = NaN;
    end;
  end;

  Fhat = D2.*m.*c./k;
  prob = 1 - fcdf(Fhat,df1,df2);
  prob = putdiag(prob,1);

  return;

