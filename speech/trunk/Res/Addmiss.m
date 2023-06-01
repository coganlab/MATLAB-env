% ADDMISS:  Add observations and variables with missing data via a stepwise 
%           procedure so as maintain maximum matrix condition.  Estimates 
%           missing data using the EM algorithm.  If the total proportion of missing
%           data in the matrix is <= maxmiss, all observations and variables are used.
%
%     Usage: [Y,obs,vars,propmiss,initsize,initcond,item_added,miss_added,cond_added] = ...
%             addmiss(X,maxmiss,{addchar},{condtype},{varlist},{minvar),{minobs},{usecorr},{doplot})
%
%         X =         [n x p] data matrix having missing data.
%         maxmiss =   maximum proportion of missing data to be estimated.
%         addchar =   optional boolean flag indicating, if true, that variables 
%                       are to be added as well as observations [default = 0].
%         condtype =  optional type of condition factor to be used:
%                         1 = condition factor, which measures stability of the 
%                             eigensolution: log((eigenvalue 1)/(eigenvalue 2));
%                         0 = difference between condition factor of submatrix and
%                             original matrix [default];
%                        -1 = reciprocal condition factor, which measures 
%                             stability under matrix inversion:
%                             log((eigenvalue 2)/(eigenvalue 1)).
%         varlist =   optional list of variables to use as starting subset (perhaps
%                       a biologically informative list) [default = null].
%         minvar =    optional minimum number of non-missing variables required for an
%                       observation to be included [default = 3].
%         minobs =    optional minimum number of non-missing observations required for a
%                       variable to be included [default = 3].
%         usecorr =   optional boolean flag indicating, if true, that correlation 
%                       matrix is to be used rather than covariance matrix 
%                       [default = 0].
%         doplot =    optional boolean flag indicating, if true, that a plot of condition
%                       vs number of items added is to be produced [default = 0].
%         -------------------------------------------------------------------------------
%         Y =           [m x q] matrix, a subset X for which at most 'maxmiss' data 
%                         have been estimated.
%         obs =         [m x 1] vector of indices of observations in Y.
%         vars =        [q x 1] vector of indices of variables in Y.
%         propmiss =    proportion of missing data estimated.
%         initsize =    [1 x 2] vector of size of initial complete submatrix.
%         initcond =    scalar indicating the condition of the initial submatrix.
%         item_added =  2-col matrix indicating the index of the item added to 
%                         the initial submatrix; col 1 indicates variables, 
%                         col 2 indicates observations.
%         miss_added =  matching vector indicating the proportion of missing 
%                         data after the item was added to the submatrix.
%         cond_added =  matching vector indicating the matrix condition (rcond)
%                         after the item was added.
%

% RE Strauss, 11/11/00
%   12/18/00 - added optional type of condition factor.
%   6/21/02 -  added option for matching original condition factor.
%   1/24/04 -  return if propmiss < maxmiss;
%              corrected problems with 'matchorig'.

function [Y,obs,vars,propmiss,initsize,initcond,item_added,miss_added,cond_added] = ...
              addmiss(X,maxmiss,addchar,condtype,varlist,minvar,minobs,usecorr,doplot)
  if (nargin < 3) addchar = []; end;
  if (nargin < 4) condtype = []; end;
  if (nargin < 5) varlist = []; end;
  if (nargin < 6) minvar = []; end;
  if (nargin < 7) minobs = []; end;
  if (nargin < 8) usecorr = []; end;
  if (nargin < 9) doplot = []; end;

  if (isempty(addchar))  addchar = 0; end;
  if (isempty(condtype)) condtype = 0; end;
  if (isempty(minvar))   minvar = 3; end;
  if (isempty(minobs))   minobs = 3; end;
  if (isempty(usecorr))  usecorr = 0; end;
  if (isempty(doplot))   doplot = 0; end;
  
  switch (condtype)             % Expand condtype argument
    case -1,
      matchorig = 0;
      condtype = 0;
    case 0,
      matchorig = 1;
      condtype = 1;
    case 1,
      matchorig = 0;
      condtype = 1;
    otherwise
      error('  AddMiss: invalid condition type.');
  end;

  if (maxmiss > 1)                        % Convert percentage to proportion
    maxmiss = maxmiss/100;
  end;

  item_added = [];                        % Allocate output matrices
  miss_added = [];
  cond_added = [];
  
  [n,p] = size(X);
  obs = [1:n]';
  vars = [1:p]';
  initsize = [n,p];

  % If observed proportion less than max, estimate and return
  propmiss = sum(sum(~isfinite(X)))/(n*p);  % Observed proportion of missing data in X
  if (propmiss < eps)                         % No missing data
    if (usecorr)                            
      C = corrcoef(X);
    else
      C = cov(X);
    end;
    initcond = condfactor(C,condtype);      
    return;
  elseif (propmiss <= maxmiss)                % Some missing data, but < max allowed
    Y = missem(X);
    if (usecorr)                            
      C = corrcoef(Y);
    else
      C = cov(Y);
    end;
    initcond = condfactor(C,condtype);      
    return;
  end;

  % Get best subset of complete data
  [nobs,nmiss,combvars,combobs,condfact,toomany,C] = varcomb(X,condtype,[],[],usecorr);
  if (toomany | isempty(combvars))
    error('  ADDMISS: no subset of complete data found.');
  end;

  % Begin with specified list of variables
  if (~isempty(varlist))                
    c = [combvars; padcols(varlist,combvars)];
    rc = rowtoval(c);
    combpos = find(rc==rc(length(rc)));
    combpos = combpos(1);
    if (isempty(combpos))
      error('  ADDMISS: variable list not found in matrix of combinations.');
    end;
  else
    combpos = 1;
  end;
  
  % Initial sets of observations and variables
  obs = combobs(combpos,find(combobs(combpos,:)>0))';       
  vars = combvars(combpos,find(combvars(combpos,:)>0))';

  nvars = length(vars);
  nobs = length(obs);

  Y = X(obs,vars);                        % Reduce data to complete subset
  initsize = size(Y);
  
  if (usecorr)                            % Get cov/corr matrix of complete submatrix
    C = corrcoef(Y);
  else
    C = cov(Y);
  end;
  initcond = condfactor(C,condtype);      % Stash initial cond factor

  nonmissperobs = rowsum(isfinite(X));    % Number of non-missing values per observation
  nonmisspervar = sum(isfinite(X));       % Number of non-missing values per variable

  % Add only observations, holding number of variables constant
  
  propmiss = 0;
  totnmiss = 0;
  lowval = -1e6;

  if (~addchar)                         
    while (propmiss<=maxmiss & nobs<n)    % Continue till reach max prop missing data
      toadd = 1:n;                          % List of obs to be added
      toadd(obs) = [];
      igm = find(nonmissperobs >= minvar);  % Check for min non-missing number of variables
      i = find(isin(toadd,igm));
      toadd = toadd(i);
      
      ntoadd = length(toadd);
      obscond = lowval*ones(ntoadd,1);
      nmiss = zeros(ntoadd,1);
      Xobs = zeros(ntoadd,nvars);

      for i = 1:ntoadd                      % Cycle thru obs to be added
        Xi = X(toadd(i),vars);                % Get current obs
        if (any(isfinite(Xi)))                % If not all missing,
          Yi = [Y; Xi];                         % Append to subset
          Yi = missem(Yi);                      % Estimate missing values
          if (usecorr)                          % Get cov/corr matrix of complete matrix with current obs
            C = corrcoef(Yi);
          else
            C = cov(Yi);
          end;
          obscond(i) = condfactor(C,condtype);  % Stash cond factor for current obs
          Xobs(i,:) = Yi(nobs+1,:);             % Stash complete values for current obs
          nmiss(i) = sum(~isfinite(Xi));        % Stash amount of missing data for current obs
        end;
      end;

      if (matchorig)                            % Find obs giving best condition
        [max_obscond,iobs] = max(-abs(obscond-initcond));
        max_obscond = obscond(iobs);
      else
        [max_obscond,iobs] = max(obscond);      
      end;
      
      if (max_obscond > lowval)                 % Add the observation
        nobs = nobs+1;                          
        totnmiss = totnmiss + nmiss(iobs);        % Tally total amount of missing data with new obs
        propmiss = totnmiss/(nvars*nobs);
      else
        propmiss = maxmiss+1;                     % All obs with missing data have been added
      end;

      if (propmiss <= maxmiss)                  % If under missing-data treshhold,
        obs = [obs; toadd(iobs)];                  % Add obs to list
        Y = [Y; Xobs(iobs,:)];                     % Append its data to Y
        item_added = [item_added; 0 toadd(iobs)];
        miss_added = [miss_added; propmiss];
        cond_added = [cond_added; max_obscond];
      end;
    end;  % while

    obs = sort(obs);                        % Sort list of obs & vars
    vars = sort(vars);
    Y = X(obs,vars);                        % Restore missing data
    propmiss = sum(sum(~isfinite(Y)))/prod(size(Y)); % Proportion of missing data
    Y = missem(Y);                          % Predict missing values as a set
  end; % if (~addchar)

  % Add variables and observations

  if (addchar)
    while (propmiss <= maxmiss & nobs<n & nvars<p) % Continue till reach max prop missing data
      vartoadd = 1:p;                       % List of vars to be added
      vartoadd(vars) = [];
      igm = find(nonmisspervar >= minobs);   % Check for min non-missing number of variables
      i = find(isin(vartoadd,igm));
      vartoadd = vartoadd(i);

      ptoadd = length(vartoadd);
      varcond = lowval*ones(ptoadd,1);
      nmiss = zeros(ptoadd,1);
      Xvar = zeros(nobs,ptoadd);

      for ip = 1:ptoadd                     % Cycle thru vars to be added
        Xi = X(obs,vartoadd(ip));            % Get current var
        if (any(isfinite(Xi)))                % If not all missing,
          Yi = [Y Xi];                          % Append to subset
          Yi = missem(Yi);                      % Estimate missing values
          if (usecorr)
            C = corrcoef(Yi);
          else
            C = cov(Yi);
          end;
          varcond(ip) = condfactor(C,condtype); % Stash cond factor for current obs
          Xvar(:,ip) = Yi(:,nvars+1);           % And its complete values
          nmiss(ip) = sum(~isfinite(Xi));       % Stash amount of missing data
        end;
      end;

      if (matchorig)
        [max_varcond,ivar] = max(-abs(varcond));
        max_varcond = varcond(ivar);
      else
        [max_varcond,ivar] = max(varcond);      % Find obs giving max condition
      end;
      
      if (max_varcond > lowval)
        nvars = nvars+1;
        totnmiss = totnmiss + nmiss(ivar);      % Tally total amount of missing data with new obs
        propmiss = totnmiss/(nvars*nobs);
      else
        propmiss = maxmiss+1;
      end;

      if (propmiss <= maxmiss)
        vars = [vars; vartoadd(ivar)];          % Add var to list
        Y = [Y Xvar(:,ivar)];                   % Append to Y

        item_added = [item_added; vartoadd(ivar) 0];
        miss_added = [miss_added; propmiss];
        cond_added = [cond_added; max_varcond];
      end;

      rca = size(cond_added,1);
      if (rca > 1)
        last_cond = cond_added(rca-1);
      else
        last_cond = initcond;
      end;

      addobs = 0;
      if (propmiss < maxmiss)
        addobs = 1;
      end;
      nadded = 0;

      while (addobs)                        % Add observations to compensate
        toadd = 1:n;                          % List of obs to be added
        toadd(obs) = [];
        igm = find(nonmissperobs >= minvar);   % Check for min non-missing number of variables
        i = find(isin(toadd,igm));
        toadd = toadd(i);

        ntoadd = length(toadd);
        obscond = lowval*ones(ntoadd,1);
        nmiss = zeros(ntoadd,1);
        Xobs = zeros(ntoadd,nvars);

        for i = 1:ntoadd                      % Cycle thru obs to be added
          Xi = X(toadd(i),vars);                % Get current obs
          if (any(isfinite(Xi)))                % If not all missing,
            Yi = [Y; Xi];                         % Append to subset
            Yi = missem(Yi);                      % Estimate missing values
            if (usecorr)
              C = corrcoef(Yi);
            else
              C = cov(Yi);
            end;
            obscond(i) = condfactor(C,condtype);  % Stash cond factor for current obs
            Xobs(i,:) = Yi(end,:);                % And its complete values
            nmiss(i) = sum(~isfinite(Xi));        % Stash amount of missing data
          end;
        end;

        if (matchorig)
          [max_obscond,iobs] = max(-abs(obscond));
          max_obscond = obscond(iobs);
        else
          [max_obscond,iobs] = max(obscond);      % Find obs giving max condition
        end;
      
        if (max_obscond > lowval)
          nobs = nobs+1;
          totnmiss = totnmiss + nmiss(iobs);      % Tally total amount of missing data with new obs
          propmiss = totnmiss/(nvars*nobs);
        else
          propmiss = maxmiss+1;
          addobs = 0;
        end;

        if (propmiss <= maxmiss)
          obs = [obs; toadd(iobs)];               % Add obs to list
          Y = [Y; Xobs(iobs,:)];                  % Append to Y
          nadded = nadded+1;

          item_added = [item_added; 0 toadd(iobs)];
          miss_added = [miss_added; propmiss];
          cond_added = [cond_added; max_obscond];

          if (nadded >= ceil(n/p) | (max_obscond >= last_cond))
            addobs = 0;
          end;
        else
          addobs = 0;
        end;
      end; % while
    end; % while

    vars = sort(vars);                      % Sort lists of vars and observations
    obs = sort(obs);                    
    Y = X(obs,vars);                        % Restore missing data
    propmiss = sum(sum(~isfinite(Y)))/(nvars*nobs); % Proportion of missing data
    Y = missem(Y);                          % Predict missing values as a set
  end; % if (addchar)
  
  if (doplot)
    x = 0:length(cond_added);
    y = [initcond; cond_added];

    scatter(x,y);
    hold on;
    plot(x,y,'k');
    if (~addchar)
      putxlab('Number of observations added');
    else
      putxlab('Number of items added');
      i = find(item_added(:,1));
      putsolidcircle(i,y(i+1));
    end;
    if (condtype == 1)
      if (matchorig)
        putylab('ln(C'') matching');
      else
        putylab('ln(C'')');
      end;
    else
      putylab('ln(C_r'')');
    end;
    if (max(x)<10)
      puttick(0:max(x));
    end;
    hold off;
    drawnow;
  end;

  return;
