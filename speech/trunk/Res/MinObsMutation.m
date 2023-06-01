% MinObsMutation: Given a mutation rate, mu, for a base sequence of length X,
%     estimates the minimum number of observations required to be CL% certain 
%     of observing a point mutation.  Assumes that the number of mutations/generation
%     is Poisson-distributed with lambda=mu.  Returns NaN if mu <= 1e-5.
%
%     Usage: Nmin = MinObsMutation(mu,{CI})
%
%         mu = overall mutation rate for a base sequence of length X.
%         CI = optional confidence level [default = 95].
%         ----------------------------------------------------------------------
%         Nmin = estimated minimum number of observations to observe a mutation.
%

% RE Strauss, 11/21/03

function Nmin = MinObsMutation(mu,CI)
  if (nargin < 2) CI = []; end;
  
  if (isempty(CI)) CI = 95; end;
  if (CI < 1)
    CI = CI*100;
  end;
  
  P = 1 - poisscdf(0,mu)           % Probability of observing a mutation
  Nmin = MinObsProb(P,CI);
  
  return;
  