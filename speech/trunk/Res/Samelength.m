% SAMELENGTH: Determines whether a series of matrices have the same number of 
%             rows.  Optionally expands scalars to column vectors and row 
%             vectors to matrices having the common number of rows before testing
%             this condition, based on whether each input argument is also requested
%             as an output argument.  Treats input row vectors as column vectors
%             if all input matrices are scalars or vectors.
%
%     Usage: [ok,x1,...,x9] = samelength(x1,{x2},...,{x9})
%
%         x1,{x2},...,{x9} = up to 9 matrices
%         ----------------------------------------------------------------------
%         ok =        boolean value indicating whether input matrices have the 
%                       same number of rows.  If any corresponding output 
%                       matrices are also requested, expands scalars to column 
%                       vectors and row vectors to matrices before making 
%                       this determination; otherwise only the sizes of the 
%                       input matrices are considered.
%         x1,...,x9 = output vectors corresponding to input matrices, with 
%                       scalars and row vectors expanded.  If b is false, 
%                       original matrices are returned.
%

% RE Strauss, 1/3/01
%   2/13/01 -  changed 'b' to 'ok'.
%   10/28/03 - major rewrite.

function [ok,x1,x2,x3,x4,x5,x6,x7,x8,x9] = samelength(x1,x2,x3,x4,x5,x6,x7,x8,x9)
  if (nargin < 1) x1 = []; end;
  if (nargin < 2) x2 = []; end;
  if (nargin < 3) x3 = []; end;
  if (nargin < 4) x4 = []; end;
  if (nargin < 5) x5 = []; end;
  if (nargin < 6) x6 = []; end;
  if (nargin < 7) x7 = []; end;
  if (nargin < 8) x8 = []; end;
  if (nargin < 9) x9 = []; end;

  len = zeros(1,9);
  isrowvect = zeros(1,9);
  isscalvect = [];
  isscalrowvect = [];
  
  % Determine whether all input matrices are scalars or vectors
  if (~isempty(x1)) isscalvect(1) = 0; if (isscalar(x1)|isvector(x1)) isscalvect(1) = 1; end; end;
  if (~isempty(x2)) isscalvect(2) = 0; if (isscalar(x2)|isvector(x2)) isscalvect(2) = 1; end; end;
  if (~isempty(x3)) isscalvect(3) = 0; if (isscalar(x3)|isvector(x3)) isscalvect(3) = 1; end; end;
  if (~isempty(x4)) isscalvect(4) = 0; if (isscalar(x4)|isvector(x4)) isscalvect(4) = 1; end; end;
  if (~isempty(x5)) isscalvect(5) = 0; if (isscalar(x5)|isvector(x5)) isscalvect(5) = 1; end; end;
  if (~isempty(x6)) isscalvect(6) = 0; if (isscalar(x6)|isvector(x6)) isscalvect(6) = 1; end; end;
  if (~isempty(x7)) isscalvect(7) = 0; if (isscalar(x7)|isvector(x7)) isscalvect(7) = 1; end; end;
  if (~isempty(x8)) isscalvect(8) = 0; if (isscalar(x8)|isvector(x8)) isscalvect(8) = 1; end; end;
  if (~isempty(x9)) isscalvect(9) = 0; if (isscalar(x9)|isvector(x9)) isscalvect(9) = 1; end; end;

  if (all(isscalvect))
    isscalvect = 1;
  else
    isscalvect = 0;
  end;
  
  if (~isempty(x1)) isscalrowvect(1) = 0; if (isscalar(x1)|isvector(x1,1)) isscalrowvect(1) = 1; end; end;
  if (~isempty(x2)) isscalrowvect(2) = 0; if (isscalar(x2)|isvector(x2,1)) isscalrowvect(2) = 1; end; end;
  if (~isempty(x3)) isscalrowvect(3) = 0; if (isscalar(x3)|isvector(x3,1)) isscalrowvect(3) = 1; end; end;
  if (~isempty(x4)) isscalrowvect(4) = 0; if (isscalar(x4)|isvector(x4,1)) isscalrowvect(4) = 1; end; end;
  if (~isempty(x5)) isscalrowvect(5) = 0; if (isscalar(x5)|isvector(x5,1)) isscalrowvect(5) = 1; end; end;
  if (~isempty(x6)) isscalrowvect(6) = 0; if (isscalar(x6)|isvector(x6,1)) isscalrowvect(6) = 1; end; end;
  if (~isempty(x7)) isscalrowvect(7) = 0; if (isscalar(x7)|isvector(x7,1)) isscalrowvect(7) = 1; end; end;
  if (~isempty(x8)) isscalrowvect(8) = 0; if (isscalar(x8)|isvector(x8,1)) isscalrowvect(8) = 1; end; end;
  if (~isempty(x9)) isscalrowvect(9) = 0; if (isscalar(x9)|isvector(x9,1)) isscalrowvect(9) = 1; end; end;

  if (all(isscalrowvect))
    isscalrowvect = 1;
  else
    isscalrowvect = 0;
  end;
  
  % If all input are scalars or vectors, convert row vectors to column vectors 
  if (isscalvect)
    if (isvector(x1,1)) x1 = x1(:); isrowvect(1) = 1; end;
    if (isvector(x2,1)) x2 = x2(:); isrowvect(2) = 1; end;
    if (isvector(x3,1)) x3 = x3(:); isrowvect(3) = 1; end;
    if (isvector(x4,1)) x4 = x4(:); isrowvect(4) = 1; end;
    if (isvector(x5,1)) x5 = x5(:); isrowvect(5) = 1; end;
    if (isvector(x6,1)) x6 = x6(:); isrowvect(6) = 1; end;
    if (isvector(x7,1)) x7 = x7(:); isrowvect(7) = 1; end;
    if (isvector(x8,1)) x8 = x8(:); isrowvect(8) = 1; end;
    if (isvector(x9,1)) x9 = x9(:); isrowvect(9) = 1; end;
  end;
  
  % Find number of rows of each matrix
  len(1) = size(x1,1);
  len(2) = size(x2,1);
  len(3) = size(x3,1);
  len(4) = size(x4,1);
  len(5) = size(x5,1);
  len(6) = size(x6,1);
  len(7) = size(x7,1);
  len(8) = size(x8,1);
  len(9) = size(x9,1);

  % If requested as output, expand scalars and vectors to max number of rows observed in any matrix
  maxlen = max(len);
  s = ones(maxlen,1);
  
  if (nargout>=1), if (len(1)==1) x1 = s*x1; len(1) = maxlen; if (isscalrowvect) isrowvect(1) = 1; end; end; end;
  if (nargout>=2), if (len(2)==1) x2 = s*x2; len(2) = maxlen; if (isscalrowvect) isrowvect(2) = 1; end; end; end;
  if (nargout>=3), if (len(3)==1) x3 = s*x3; len(3) = maxlen; if (isscalrowvect) isrowvect(3) = 1; end; end; end;
  if (nargout>=4), if (len(4)==1) x4 = s*x4; len(4) = maxlen; if (isscalrowvect) isrowvect(4) = 1; end; end; end;
  if (nargout>=5), if (len(5)==1) x5 = s*x5; len(5) = maxlen; if (isscalrowvect) isrowvect(5) = 1; end; end; end;
  if (nargout>=6), if (len(6)==1) x6 = s*x6; len(6) = maxlen; if (isscalrowvect) isrowvect(6) = 1; end; end; end;
  if (nargout>=7), if (len(7)==1) x7 = s*x7; len(7) = maxlen; if (isscalrowvect) isrowvect(7) = 1; end; end; end;
  if (nargout>=8), if (len(8)==1) x8 = s*x8; len(8) = maxlen; if (isscalrowvect) isrowvect(8) = 1; end; end; end;
  if (nargout>=9), if (len(9)==1) x9 = s*x9; len(9) = maxlen; if (isscalrowvect) isrowvect(9) = 1; end; end; end;

  % Determine whether all matrices have same number of rows
  ulen = uniquef(len,1);
  ulen = ulen(find(ulen>0));
  nulen = length(ulen);

  ok = 0;
  if (nulen == 1)
    ok = 1;
  end;
  
  % Convert column vectors back to row vectors
  if (any(isrowvect))
    if (isrowvect(1)) x1 = x1'; end;
    if (isrowvect(2)) x2 = x2'; end;
    if (isrowvect(3)) x3 = x3'; end;
    if (isrowvect(4)) x4 = x4'; end;
    if (isrowvect(5)) x5 = x5'; end;
    if (isrowvect(6)) x6 = x6'; end;
    if (isrowvect(7)) x7 = x7'; end;
    if (isrowvect(8)) x8 = x8'; end;
    if (isrowvect(9)) x9 = x9'; end;
  end;
  
  return;
