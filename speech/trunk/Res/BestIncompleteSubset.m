% BestIncompleteSubset: For for all possible combinations of pmin,...,pmax variables, finds, 
%           for each subset, the mean estimated covariance and proportion of missing data,
%           and calculates an "optimality" scores by equally weighting the two values.
%           Ranks and outputs the subsets by decreasing optimality score.
%           Does not assume that input data matrix has been log-transformed.  Practical for 
%           up to 19 variables; if >19 variables are given, only the 19 most complete variables 
%           are used.  
%
%     Usage: [combvars,meancov,pmiss] = ...
%                         BestIncompleteSubset(X,{pmin},{pmax},{ncomb},{wt},{usecorr},{doplot})
%
%         X =        [n x p] data matrix.
%         pmin =     optional smallest number of variables in subset [default = 3].
%         pmax =     optional largest number of variables in subset [default = p-pmin, max 19].
%         ncomb =    optional number of optimal variable combinations to be returned
%                      [default = 50], or 'all'.
%         wt =       optional vector of weights for [meancov, pmiss, nvars] (mean covariance,
%                      proportion of missing data, and number of variables) used to give each
%                      subset a relative score for ranking purposes [default = [1 1 0.5].
%         usecorr =  optional boolean flag indicating that correlations are to be used
%                      rather than covariances [default = 0].
%         doplot =   optional boolean flag indicating that a plot of the first 'ncomb' values
%                      of 'meancov' and 'pmiss' are to be plotted.
%         -----------------------------------------------------------------------------------
%         combvars = [ncomb x <=pmax] list of variables in subset, from best subset to worst.
%         meancov =  corresponding mean estimated levels of covariance in subset.
%         pmiss =    corresponding proportions of missing data in subsets.
%

% RE Strauss, 2/27/04

function [combvars,meancov,pmiss] = BestIncompleteSubset(X,pmin,pmax,ncomb,wt,usecorr,doplot)
  if (nargin < 2) pmin = []; end;
  if (nargin < 3) pmax = []; end;
  if (nargin < 4) ncomb = []; end;
  if (nargin < 5) wt = []; end;
  if (nargin < 6) usecorr = []; end;
  if (nargin < 7) doplot = []; end;
  
  [n,p] = size(X);
  
  if (isempty(pmin))    pmin = 3; end;
  if (isempty(pmax))    pmax = max([p-3,pmin]); end;
  if (isempty(ncomb))   ncomb = 50; end;
  if (isempty(usecorr)) usecorr = 0; end;
  if (isempty(wt))      wt = [1 1 1]; end;
  if (isempty(doplot))  doplot = 0; end;
  
  if (ischar(ncomb))
    if (~isequal(ncomb,'all'))
      error('  BestIncompleteSubset: invalid number of combinations to be returned.');
    end;
  end;
  
  varlist = [1:p]';             % List of variable identifiers
  
  if (p >= 19)                  % If too many variables,
    m = sum(~isfinite(X))';       % omit variables with most missing values
    [m,varlist] = sortmat(m,varlist);
    varlist = sort(varlist(1:19));
    X = X(:,varlist);
    pmax = min([pmax,19]);
  end;
        
  C = covpairwise(X,1);         % Estimate covariance structure of original matrix
  if (usecorr)                  % Optionally convert covariances to correlations
    C = covcorr(C);
  end;
  
  combvars = [];
  meancov = [];
  pmiss = [];
  
  for np = pmin:pmax            % Cycle thru number of variables per subset
    c = combvals(p,np);           % List of combinations of variables
    for ic = 1:size(c,1)          % Cycle thru list
      cc = c(ic,:);               % Current subset of variables
      x = X(:,cc);                % Extract vars
      [nmiss,pm] = IsMissing(x);  % Proportion of missing values for this combination
      mc = mean(mean(C(cc,cc)));
      pmiss = [pmiss; pm];
      meancov = [meancov; mc];
      cv = zeros(1,pmax);
      cv(1:length(cc)) = varlist(cc);
      combvars = [combvars; cv];
    end;
  end;
  
  nvars = rowsum(combvars>0);   % Number of variables per combination
  
  zmeancov = zscores(meancov);    % Standardize the weighting 'factors'
  zpmiss = zscores(pmiss);
  znvars = zscores(nvars);
  
  sumwt = sum(wt);
  wt_meancov = wt(1)/sumwt;
  wt_pmiss = wt(2)/sumwt;
  wt_nvars = wt(3)/sumwt;
 
  % Sort scores high to low
  scores = wt_meancov*zmeancov - wt_pmiss*zpmiss + wt_nvars*znvars;
  [scores,pmiss,meancov,combvars,nvars] = sortmat(-scores,pmiss,meancov,combvars,nvars);

  if (~ischar(ncomb) & ncomb>0 & ncomb<length(pmiss))   % Reduce lists to be returned
    pmiss = pmiss(1:ncomb);
    meancov = meancov(1:ncomb);
    combvars = combvars(1:ncomb,:);
    nvars = nvars(1:ncomb);
  end;
  
  s = sum(combvars>0);          % Delete empty columns of combvars
  i = find(s>0);
  combvars = combvars(:,i);
  
  if (doplot)
    if (range(nvars)>0)
      figure;
      lollipop(meancov,pmiss,nvars);
      putzlab('Number of variables');
    else
      scatter(meancov,pmiss);
      puttitle(sprintf('Number of variables = %d',nvars(1)));
    end;
    putxlab('Mean covariance');
    putylab('Proportion of missing data');
  end;
  
  return;
  