% MinObsProb: Given the probability of occurrence of an event and a desired level
%             of confidence CL, predicts the minimum number of observations needed 
%             to be CL% confident of observing the event.
%               The probability of observing an event in a sample of N observations
%             is P = 1-(1-p)^N, where p is the probability.  Set P = CL and solve 
%             for N.
%               
%     Usage: Nmin = MinObsProb(P,{CL})
%
%         P =    [r x c] matrix of probabilties.
%         CL =   optional scalar confidence level, specified as proportion or 
%                percentage, or [r x c] matrix of confidence levels corresponding 
%                  to P [default = 95%].
%         -----------------------------------------------------------------------
%         Nmin = [r x c] matrix of corresponding minimum sample sizes.
%

% RE Strauss, 11/24/03
%   12/1/03 - simplifed based on an analytical solution.

function Nmin = MinObsProb(P,CL)
  if (nargin < 2) CL = []; end;
  
  if (isempty(CL)) CL = 0.95; end;
  if (any(CL > 1))
    CL = CL/100; 
  end;
  
  if (~isscalar(CL))
    if (size(P)~=size(CL))
    error('  MinObsProb: input matrices not conformable.');
    end;
  end;
  
  Nmin = ceil(log(1-CL)./log(1-P));
  
  return;
  