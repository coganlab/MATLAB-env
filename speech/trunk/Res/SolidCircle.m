% SolidCircle: plots a set of filled circles on an existing plot.
%
%     Usage: SolidCircle(x,y)
%

function SolidCircle(x,y)
  x = x(:);
  y = y(:);
  
  npts = length(x);
  
  hold on;
  for i = 1:npts
    a = 0.013*range(x);
    b = 0.013*range(y);
    [ex,ey] = ellips(0.8*a,b,x(i),y(i),0,50);
    fill(ex,ey,'k');
  end;
  hold off;

  return;