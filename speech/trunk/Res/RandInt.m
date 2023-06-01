% RandInt: Produces a matrix of uniformly distributed pseudorandom integers between the 
%          specified bounds, inclusive.
%
%     Usage: r = randint(bounds,{matsize})
%
%         bounds =  2-element vector specifying the lower and upper bounds for the random integers:
%                     [lower,upper].  If a scalar, it is assumed to present the upper bound, with
%                     lower=1.
%         matsize = optional 2-element vector specifying the output matrix size: [#rows,#cols].  
%                     If a scalar, it is assumed to represent #rows with #cols=1.  If null, output
%                     is a scalar.
%         -----------------------------------------------------------------------------------------
%         r =       matrix of pseudorandom integers.
%

% RE Strauss, 9/23/03

function r = randint(bounds,matsize)
  if (nargin < 2) matsize = []; end;

  bounds = round(bounds(:));

  if (isempty(matsize))
    rows = 1;
    cols = 1;
  elseif (isscalar(matsize))
    rows = matsize;
    cols = 1;
  else
    matsize = round(matsize(:));
    rows = matsize(1);
    cols = matsize(2);
  end;
  
  if (isscalar(bounds))
    lower = 1;
    upper = bounds;
  else
    lower = bounds(1);
    upper = bounds(2);
  end;
  
  if (upper <= lower)
    error('  RandInt: invalid bounds');
  end;
  
  r = round(rand(rows,cols)*(upper-lower+1) + lower - 0.5);

  return;
  
 