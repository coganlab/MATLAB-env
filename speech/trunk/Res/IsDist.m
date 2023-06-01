% IsDist: Returns 1 if the input matrix is in the form of a distance matrix, 
%         and 0 if not.  Doesn't check for missing data.
%
%     Usage: b = IsDist(D)
%

% RE Strauss, 2/8/00

function b = IsDist(D)
  [r,p] = size(D);
  b = 1;
  tol = 1e6*eps;

  if (r~=p)
    b = 0;
    return;
  end;

  if (trace(D) > tol)
    b = 0;
  end;
  if (sum(trilow(D)-trilow(D')) > tol*r*(r-1))
    b = 0;
  end;

  return;
