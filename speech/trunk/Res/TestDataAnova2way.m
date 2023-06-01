% TestDataAnova2way: Generates simulated pseudodata for a 2-way factorial design, with interaction.
%
%     Usage: [X,A,B] = TestDataAnova2way({N},{totmean},{residvar},{Aeffects},{Beffects},{ABeffects})
%
%         N = [a x b] matrix of cell sample sizes (replicates), where a and b
%               are the numbers of levels of factors A and B, respectively.
%               [Default = [10,10; 10,10].
%         totmean = grand mean of the data [default = 50].
%         residvar = scalar or [a x b] matrix of residual variances.  If a scalar
%               is passed, the residual variance is identical for all cells (as assumed
%               by the anova model.  [Default = 5].
%         Aeffects = vector (length a) of effects of levels of factor A [default = [10,-10]].
%         Beffects = vector (length b) of effects of levels of factor B [default = [15,-15]].
%         ABeffects = optional [a x b] matrix of interaction effects [default = 0].
%         ------------------------------------------------------------------------------
%         X = [totN x 1] vector of pseudodata values.
%         A = corresponding classification variable for factor A.
%         B = corresponding classification variable for factor B.
%

% RE Strauss, 4/1/04

function [X,A,B] = TestDataAnova2way(N,totmean,residvar,Aeffects,Beffects,ABeffects) 
  if (nargin < 1) N = []; end;
  if (nargin < 2) totmean = []; end;
  if (nargin < 3) residvar = []; end;
  if (nargin < 4) Aeffects = []; end;
  if (nargin < 5) Beffects = []; end;
  if (nargin < 6) ABeffects = []; end;
  
  if (isempty(N))         N = [10,10; 10,10]; end;
  if (isempty(totmean))   totmean = 50; end;
  if (isempty(residvar))  residvar = 5; end;
  if (isempty(Aeffects))  Aeffects = [10,-10]; end;
  if (isempty(Beffects))  Beffects = [15,-15]; end;
  if (isempty(ABeffects)) ABeffects = 0; end;

  [a,b] = size(N);                        % Sample sizes
  Ntot =  sum(sum(N));
a_b_Ntot = [a b Ntot]  
  
  if (isscalar(residvar)) residvar = residvar * ones(a,b); end;   % Expand scalars into matrices
  if (isscalar(ABeffects)) ABeffects = ABeffects * ones(a,b); end;
  
  Aeffects = Aeffects - sum(Aeffects);      % Adjust effects to sum to zero
  Beffects = Beffects - sum(Beffects);
% How to scale ABeffects?  
  
N
totmean
residvar
Aeffects
Beffects
ABeffects

  X = zeros(Ntot,1);                         % Allocate output arguments
  A = zeros(Ntot,1);
  B = zeros(Ntot,1);
  ee = 0;
  
  for ia = 1:a
    for ib = 1:b
      n = N(ia,ib);
      bb = ee + 1;
      ee = ee + n;
      A(bb:ee) = ia*ones(n,1);
      B(bb:ee) = ib*ones(n,1);
      X(bb:ee) = totmean + Aeffects(ia) + Beffects(ib) + ABeffects(ia,ib) + residvar(ia,ib)*randn(n,1);
    end;
  end;

  return;
  