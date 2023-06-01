% IsBooleanSubset: For two boolean vectors of equal length, determines whether the first 
%                  is a subset of the second.  E.g., [0 1 0 1] is a subset of [0 1 1 1],
%                  but [1 1 0 0] is not a subset of [0 1 1 1].
%
%   Usage: b = IsBooleanSubset(b1,b2)
%
%         b1 = putative subset; either a vector or a [r1 x c1] matrix of row vectors 
%                to be tested.
%         b2 = set against which b1 is to be compared; either a vector or a [r2 x c2]
%                matrix of row vectors.
%         --------------------------------------------------------------------------
%         b =  scalar or [r1 x r2] matrix of boolean responses: 0 if false, 1 if true.
%

% RE Strauss, 10/15/03

function b = IsBooleanSubset(b1,b2)
  if (isvector(b1))
    b1 = b1(:)';
  end;
  if (isvector(b2))
    b2 = b2(:)';
  end;
  
  [r1,c1] = size(b1);
  [r2,c2] = size(b2);
  
  if (c1~=c2)
    error('  IsBooleanSubset: input matrices not compatible.');
  end;

  b = zeros(r1,r2);
  for i = 1:r1
    for j = 1:r2
      b(i,j) = all(b2(j,:)-b1(i,:) >= 0);
    end;
  end;

  return;
  