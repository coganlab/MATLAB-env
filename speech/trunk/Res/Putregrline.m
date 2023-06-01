% PUTREGRLINE: Add a predictive or major-axis regression line to the current 
%              plot.
%
%     Usage: b = putregrline(x,y,{kind},{w})
%
%         x,y =   abscissa and ordinate values of current plot.
%         kind =  optional flag indicating kind of regression:
%                   0 = predictive regression [default];
%                   1 = major-axis regression.
%         w =     optional vector of weights for weighted predictive regression
%                   [default = null].
%         ---------------------------------------------------------------------
%         b =     regression coefficients.
%

% RE Strauss, 4/10/01
%   11/9/01 -  corrected error with implementation of 'kind' flag.
%   5/29/02 -  change function name from 'addregrline'.
%   11/26/02 - return the regression coefficients.
%   7/24/03 -  added option of weighted predictive regression.
%   10/30/03 - cut line off at range of data in both X and Y directions.

function b = putregrline(x,y,kind,w)
  if (nargin < 3) kind = []; end;
  if (nargin < 4) w = []; end;

  if (isempty(kind))
    kind = 0;
  end;
  
  xmin = min(x);
  xmax = max(x);
  ymin = min(y);
  ymax = max(y);
  xpred = linspace(xmin,xmax)';
  
  p1 = zeros(2,1);
  p2 = zeros(2,1);

  switch (kind)
    case 0,                               % Major-axis regression
      [b,stats,ypred] = linregr(x,y,w,xpred);

    case 1,                               % Predictive regression
      b = majaxis(x,y);
      b = [b(1,1);b(1,2)];
      ypred = [xpred,ones(size(xpred))]*b;
  end;

  if (ypred(1)>=ymin & ypred(1)<=ymax)
    p1 = [xmin ypred(1)];
  elseif (ypred(1)<ymin)
    [mindiff,i] = min(abs(ypred-ymin));
    p1 = [xpred(i),ymin];
  else
    [mindiff,i] = min(abs(ypred-ymax));
    p1 = [xpred(i),ymax];  
  end;
  
  if (ypred(end)>=ymin & ypred(end)<=ymax)
    p2 = [xmax ypred(end)];
  elseif (ypred(end)<ymin)
    [mindiff,i] = min(abs(ypred-ymin));
    p2 = [xpred(i),ymin];
  else
    [mindiff,i] = min(abs(ypred-ymax));
    p2 = [xpred(i),ymax];
  end;
  
  hold on;
  plot([p1(1),p2(1)],[p1(2),p2(2)],'k');
  hold off;

  return;
