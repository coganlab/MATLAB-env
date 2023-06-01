% AccruCurve: Given a vector of object identifiers for a set of samples, produces 
%             an average accrument curve by randomizing the sequence of samples.
%             Typical uses: samples are localities and objects are species; sample
%             are genotypes and objects are alleles.
%
%     Usage: [asym,obs,perm,pred] = accrucurve(x,{iter},{noplot})
%
%         x =       vector (length N) of object identifiers.
%         iter =    optional number of permutation iterations [default = 1000].
%         noplot =  optional boolean flag indicating, if true, that plot is to be
%                     suppressed [default = 0].
%         -----------------------------------------------------------------------
%         asym =    asymptote predicted by negative-exponential fit to the
%                     observed accrument curve.
%         obs =     [1 x N+1] vector of observed accumulations, from 0-N.
%         perm =    [1 x N+1] vector of mean accumulation-curve values, for randomly
%                     permuted collection sequences.
%

% RE Strauss, 2/28/02
%   11/17/03 - added 'noplot' option;
%              added output of function values.

function [asym,obs,perm] = accrucurve(x,iter,noplot)
  if (nargin < 2) iter = []; end;
  if (nargin < 3) noplot = []; end;
  
  if (isempty(iter)) iter = 1000; end;
  if (isempty(noplot)) noplot = 0; end;
  
  if (iter < 1) iter = 1; end;

  n = length(x);
  c = ones(iter,n);
  
  for i = 2:n
    if (isin(x(i),x(1:(i-1))))
      c(1,i) = c(1,i-1);
    else
      c(1,i) = c(1,i-1)+1;
    end;
  end;

  if (iter > 1)
    for it = 2:iter
      xp = x(randperm(n));
      for i = 2:n
        if (isin(xp(i),xp(1:(i-1))))
          c(it,i) = c(it,i-1);
        else
          c(it,i) = c(it,i-1)+1;
        end;
      end;
    end;
    cmean = mean(c);
    [P,pS,tp,r,curve] = vonbert([0:n],[0,cmean]);
    asym = P(7);
  else
    [P,pS,tp,r,curve] = vonbert([0:n],[0,c(1,:)]);
    asym = P(7);    
  end;
  
  if (~noplot)
    plot([0:n],[0,c(1,:)],'k.',[0:n],[0,cmean],'k',linspace(0,n)',curve,'k:');
    legend('Observed','Randomly permuted','Predicted',2);
    hold on;
    plot([0:n],[0,c(1,:)],'k');
    hold off;
    putxlab('Number of samples');
    putylab('Cumulative number of unique objects');
  end;
  
  obs = [0,c(1,:)];
  perm = [0,cmean];

  return;
  