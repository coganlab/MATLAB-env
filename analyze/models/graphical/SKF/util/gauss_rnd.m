function X = gauss_rnd(M,M2,S,N)
  if nargin < 4
    N = 1;
  end
  L = chol(S)';
  X = zeros(M,M2*N) + L*randn(M,M2*N);
  
