% RANDMISS: Randomly fills a matrix with missing values, ensuring that no rows nor
%           columns have all missing values.  If the matrix already contains missing
%           values, new missing values are added only to non-missing cells.
%
%     [Y,toomany,rn,cn] = randmiss(X,nmiss,{grps},{grpmin},{rowmin},{colmin})
%
%           X =       arbitrary input matrix.
%           nmiss =   proportion (if <1) or number (if >=1) of missing values 
%                       to be dispersed.
%           grps =    optional grouping vector, to ensure that all groups are
%                       represented by a minimum number of complete observations.
%           grpmin =  optional minimum complete observations per group 
%                       [default = 2 if 'grps' is passed].
%           rowmin =  optional minimum number of non-missing values per row 
%                       [default = 1].
%           colmin =  optional minimum number of non-missing values per column 
%                       [default = rowmin].
%           ---------------------------------------------------------------------
%           Y =       resultant matrix.
%           toomany = boolean flag for too many missing data, given rowmin and
%                       colmin.
%           rn =      vector of rows of missing values.
%           cn =      matching vector of cols of missing values.
%

% RE Strauss, 12/18/98
%  3/17/99 -  added systematic attempt to correct for saturated rows or columns, 
%               with 'toomany' flag.
%  3/18/99 -  modified function to call randbinm() to find positions for missing 
%               data.
%  4/17/00 -  return indices to missing values.
%  11/13/00 - allow for number of missing values to be a proportion.
%  3/3/02 -   return a 'toomany' flag for too many missing data, rather than print
%               an error message.
%  9/19/03 -  allow for returning complete data for a subset of individuals per group.
%  3/10/04 -  allow input matrix to have pre-existing missing values.

function [X,toomany,rn,cn] = randmiss(X,nmiss,grps,grpmin,rowmin,colmin)
  if (nargin < 3) grps = []; end;
  if (nargin < 4) grpmin = []; end;
  if (nargin < 5) rowmin = []; end;
  if (nargin < 6) colmin = []; end;

  if (isempty(rowmin))                  % Default input parameters
    rowmin = 1;
  end;
  if (isempty(colmin))
    colmin = rowmin;
  end;
  if (~isempty(grps) & isempty(grpmin))
    grpmin = 2;
  end;

  [nrows,ncols] = size(X);
  ncells = nrows*ncols;
  
  if (~isempty(grps))
    if (length(grps) ~= nrows)
      error('  Randmiss: lengths of grouping vector and data matrix must agree.');
    end;
    
    obs = subsamplegrps(grps,grpmin);   % Random sample of 'grpmin' observations per group
    complX = X(obs,:);                  % Save observations 
    X(obs,:) = [];                      % Delete from input matrix
    obsid = [1:nrows]';                 % Vector of row subscripts
    obsid(obs) = [];                    % Delete subscripts
    [nrows,ncols] = size(X);            % Revised size of X
    ncells = nrows*ncols;
  end;

  if (nmiss < 1 )                       % Convert proportion to number
    nmiss = round(nmiss*ncells);
  end;
  
  rowcurmiss = rowsum(~isfinite(X));    % Number of currently missing values per row
  colcurmiss = sum(~isfinite(X));       % Number of currently missing values per column
  ncurmiss = sum(rowcurmiss);           % Total number of currently missing values

  ngood = ncells-nmiss-ncurmiss;        % Number of non-missing cells

  toomany = 0;                          % Return flag for too many missing data
  if (ngood<(nrows*rowmin) | ngood<(ncols*colmin))
    toomany = 1;
    X = [];
    rn = [];
    cn = [];
    return;
  end;
  
  if (ncurmiss>0)                       % If matrix currently contains missing data,
    Xgood = isfinite(X);
    rowgood = rowsum(Xgood);
    colgood = sum(Xgood);
    [rowposgood,colposgood] = find(Xgood);    % find indices of non-missing values
    i = randperm(sum(rowgood));
    rowposgood = rowposgood(i);               % Randomly permute indices
    colposgood = colposgood(i);
    
    rowtoadd = rowgood - rowmin;              % Numbers of missing values that can be added
    coltoadd = colgood - colmin;              %   to rows and cols
  
    ip = 1;
    for in = 1:nmiss                          % Add missing values to matrix
      while (~isfinite(rowposgood(ip)))
        ip = ip+1;
      end;
      r = rowposgood(ip);
      c = colposgood(ip);
      X(r,c) = NaN;
      
      rowtoadd(r) = rowtoadd(r)-1;
      coltoadd(c) = coltoadd(c)-1;
      
      if (rowtoadd(r)==0)
        i = find(rowposgood == rowtoadd(r));
        if (~isempty(i))
          rowposgood(i) = NaN*ones(length(i),1);
          colposgood(i) = NaN*ones(length(i),1);
        end;
      end;
      if (coltoadd(c)==0)
        i = find(colposgood == coltoadd(c));
        if (~isempty(i))
          rowposgood(i) = NaN*ones(length(i),1);
          colposgood(i) = NaN*ones(length(i),1);
        end;
      end;
      ip = ip+1;
    end;
    
  else                                  % Else if matrix is currently complete
    rowtot = ones(1,nrows)*rowmin;        % Row totals for good values
    ng = ngood - nrows*rowmin;
    if (ng>0)
      rg = makegrps(1:nrows,(ncols-rowmin)*ones(1,nrows));
      rg = rg(randperm(length(rg)));
      for i = 1:ng
        rowtot(rg(i)) = rowtot(rg(i))+1;
      end;
    end;

    coltot = ones(1,ncols)*colmin;        % Column totals for good values
    ng = ngood - ncols*colmin;
    if (ng>0)
      cg = makegrps(1:ncols,(nrows-colmin)*ones(1,ncols));
      cg = cg(randperm(length(cg)));
      for i=1:ng
        coltot(cg(i)) = coltot(cg(i))+1;
      end;
    end;

    randpos = randbinm(rowtot,coltot);    % Generate random binary matrix

    [rn,cn] = find(randpos==0);           % Substitute NaN's for zeros in binary matrix
    for i = 1:nmiss
      X(rn(i),cn(i)) = NaN;
    end;
  end;
  
  if (~isempty(grps))                   % Put complete observations back into matrix
    X = [X; complX];                      % Concatenate complete obs onto data matrix
    obs = [obsid; obs];                   % Concatenate corresponding indices
    [obs,X] = sortmat(obs,X);             % Sort complete obs into data matrix
  end;

  return;
