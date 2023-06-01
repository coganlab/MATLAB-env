% TTestOne: Weighted 1-sample t-test, by column.  Ignores missing data.
%
%     Usage: [t,pr,df] = TTestOne(X,{mu0},{tail},{W})
%
%         X =    [n x k] vector of data for n observations and k groups.
%         mu0 =  optional scalar or [1 x k] vector of null-hypothesis values for 
%                  the true mean [default = 0].
%         tail = optional [1 x k] vector of indicators of direction of each test:
%                  -1 = one-tailed test of mean <  mu0
%                   0 = two-tailed test of mean ~= mu0 [default]
%                  +1 = one-tailed test of mean >  mu0
%         W =    optional [n x k] matrix of weights [default = matrix of ones],
%                  or [n x 1] vector of weights to be applied to all columns.
%         ---------------------------------------------------------------------
%         t =    [1 x k] vector of t-statistic values.
%         pr =   corresponding vector of significance levels.
%         df =   corresponding vector of degrees-of-freedom.
%

% RE Strauss, 12/4/03

function [t,pr,df] = TTestOne(X,mu0,tail,W)
  if (nargin < 2) mu0 = []; end;
  if (nargin < 3) tail = []; end;
  if (nargin < 4) W = []; end;
  
  if (isvector(X))
    X = X(:);
  end;
  
  [n,k] = size(X);
   
  if (isempty(mu0)) mu0 = zeros(1,k); end;
  if (isempty(tail)) tail = zeros(1,k); end;
  if (isempty(W)) W = ones(size(X)); end;
  
  if (isvector(W))                % Expand vector of weights into matrix matching X
    W = W(:)*ones(1,k);
  end;
  if (isscalar(mu0))              % Expand scalars into vectors
    mu0 = mu0*ones(1,k);
  end;
  if (isscalar(tail))
    tail = tail*ones(1,k);
  end;
  
  if (~isequal(size(X),size(W)))
    error('  TTestOne: data and weigh matrices are incompatible.');
  end;
  
  for ik = 1:k                    % Cycle thru columns
    x = X(:,ik);                    % Extract current data and weights
    w = W(:,ik);
    
    i = find(isfinite(x) & isfinite(w));  % Omit missing data
    x = x(i);
    w = w(i);
  
    w = w./mean(w);                 % Sum of weights equals sample size
    n = length(x);
    df(ik) = n-1;
  
    if (length(w)~=n)
      error('  TTestOne: data and weighing vectors are incompatible.');
    end;
  
    [m,v] = meanwt(x,w);            % Weighted mean and variance
  
    t(ik) = (m-mu0(ik))/sqrt(v/n);
    switch (tail(ik))
      case -1,
        pr = tcdf(t,df);
      case 0,
        pr = 2*(1-tcdf(abs(t),df));
      case 1,
        pr = 1-tcdf(t,df);
    end;
  end;
  
  return;