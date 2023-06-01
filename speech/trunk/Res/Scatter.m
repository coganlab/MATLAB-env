% SCATTER: Simple unlabeled scatter plot of the first two columns of a matrix
%          ignoring missing data.
%
%     Usage: scatter(x,{y},{regr},{corrvals},{symbol})
%
%           x =         data vector (if y is provided) or matrix containing at 
%                         least two columns (if no other arguments are provided).
%           y =         optional corresponding vector.
%           regr =      optional flag indicating that a regression is to be 
%                         performed and plotted:
%                           0 = no regression [default];
%                           1 = predictive regression;
%                           2 = major-axis regression.
%           corrvals =  optional flag indicating that the correlation coefficient
%                         and p-value are to be printed in a corner of the plot:
%                           0 = no correlation [default if regr=0];
%                           1 = lower-right corner of plot [default if regr=1];
%                           2 = upper-right corner;
%                           3 = upper-left corner;
%                           4 = lower-left corner.
%           symbol =    optional symbol & color string for plot statement 
%                         [default = 'ok'].
%

% RE Strauss, 1/2/99
%   5/23/99 -  allow input matrix or two input vectors.
%   8/19/99 -  change plot colors for Matlab v5.
%   2/24/00 -  added optional regression.
%   3/19/00 -  fix plotting of a single point.
%   10/11/00 - convert input row vectors to col vectors.
%   10/30/03 - call putregrline() for regression line; 
%              add printing of correlation coefficient and p-value.
%   11/24/03 - remove missing data, and check for too few points.

function scatter(x,y,regr,corrvals,symbol)
  if (nargin < 2) y = []; end;
  if (nargin < 3) regr = []; end;
  if (nargin < 4) corrvals = []; end;
  if (nargin < 5) symbol = []; end;

  if (isscalar(y))                      % If y not passed, shift arguments right
    symbol = regr;
    regr = y;
    y = [];
  end;

  [isvect,ncells,iscol] = isvector(x);  % Convert row vectors to col vectors
  if (isvect & ~iscol)
    x = x';
  end;
  [isvect,ncells,iscol] = isvector(y);
  if (isvect & ~iscol)
    y = y';
  end;

  if (isempty(y))
    if (isvector(x) & length(x)>2)
      y = x(:);
      x = [1:length(x)]';
    else  
      y = x(:,2);
      x = x(:,1);
    end;
  else
    if (any(size(x)~=size(y)))
      error('  SCATTER: input vectors not compatible')
    end;
    x = x(:,1);
    y = y(:,1);
  end;

  if (isempty(symbol))
    symbol = 'ok';
  end;
  if (isempty(regr))
    regr = 0;
  end;
  if (isempty(corrvals))
    if (regr)
      corrvals = 1;
    else
      corrvals = 0;
    end;
  end;
  
  i = find(isfinite(x) & isfinite(y));
  x = x(i);
  y = y(i);
  if (length(x)<2)
    error('  SCATTER: too few points.');
  end;

  if (regr & size(x,1)<2)
    disp('  SCATTER warning: too few points for regression');
    regr = 0;
  end;

  figure;
  plot(x,y,symbol);
  putbnd(x,y);

  if (regr)
    putregrline(x,y,regr-1);
  end;
  
  if (corrvals)
    [r,pr] = corr(x,y);
    switch (corrvals)
      case 1,
        xpos = 0.76; ypos = 0.15;
      case 2,
        xpos = 0.76; ypos = 0.93;
      case 3,
        xpos = 0.05; ypos = 0.93;
      case 4,
        xpos = 0.05; ypos = 0.15;
      otherwise
        error('  Scatter: invalid ''corrvals'' flag.');
    end;
    puttext(xpos,ypos,sprintf('r = %5.3f',r));
    if (pr < 0.001)
      puttext(xpos,ypos-0.07,'p < 0.001');
    else
      puttext(xpos,ypos-0.07,sprintf('p = %5.3f',pr));
    end;
  end;

  return;
