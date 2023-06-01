% PutSolidCircle: Plots a set of filled circles on an existing plot.  The plot
%                 dimensions and axis scales should be set before calling this function,
%                 otherwise the circles might plot as ellipses.  Plotted circles will
%                 not rescale the axes, so circles outside the range of the plot will not
%                 appear on the plot.
%
%
%     Usage: PutSolidCircle(x,y,{color},{circsize})
%                  OR
%            PutSolidCircle([x,y],{color},{circsize})
%
%         x,y =      matching vectors of point coordinates to be plotted.
%         color =    optional character specifying color of filled circles [default = 'k'].
%         circsize = optional multiplicative factor to reduce or enlarge circle
%                      [default = 1].
%

% RE Strauss, 11/5/03

function PutSolidCircle(x,y,color,circsize)
  if (nargin < 2) y = []; end;
  if (nargin < 3) color = []; end;
  if (nargin < 4) circsize = []; end;
  
  if (~isscalar(x))
    if (ismatrix(x) | (isvector(x) & length(x)==2 & length(y)~=2))
      if (nargin > 1 & isscalar(y))
        circsize = color;
        color = y;
      end;
      y = x(:,2);
      x = x(:,1);
    end;
  elseif (nargin < 2)
    error('  PutSolidCircle: missing y coordinate.');
  end;
  
  if (isempty(color)) color = 'k'; end;
  if (isempty(circsize))  circsize = 1; end;

  x = x(:);
  y = y(:);
  
  npts = length(x);
  if (length(y) ~= npts)
    error('  PutSolidCircle: x and y coordinate vectors not of equal length.');
  end;

  v = axis;
  xrange = v(2)-v(1);
  yrange = v(4)-v(3);
  
  circsize = 0.012 * circsize;
  a = circsize*xrange * 0.7;
  b = circsize*yrange;
  
  hold on;
  for i = 1:npts
    [ex,ey] = EllipseBound(a,b,x(i),y(i),0,50);
    fill(ex,ey,color);
  end;
  hold off;

  return;