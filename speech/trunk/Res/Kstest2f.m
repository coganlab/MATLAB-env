% KSTEST2F: Objective function for KSTEST2, called by BOOTSTRP.
%
%     Syntax: solution = kstest2f(X,grps,nu1,nu2,stat)
%
%         X =       [n x 1] vector of data scores.
%         grps =    [n x 1] vector of group membership (0,1).
%         nu1,nu2 = variables passed by BOOTSTRP but unused.
%         stat  =   flag indicating the statistic to be calculated:
%                     0 = KS statistic [default],
%                     1 = MSE statistic.
%         ---------------------------------------------------------
%         solution = test-statistic value.
%

% RE Strauss, 9/26/96
%   1/25/00 - renamed and changed usage of unique().

function solution = kstest2f(X,grps,nu1,nu2,stat)
  KS = 0; MSE = 1;

  X1 = X(find(grps==0));                % Separate data by group
  X2 = X(find(grps==1));
  n1 = length(X1);
  n2 = length(X2);

  dist = uniquef([X1;X2],1);            % Create common abscissa
  nx = length(dist);
  dist = [dist, zeros(nx,2)];           % Add 2 cols for cum distribs

  incr = 1./n1;
  for i = 1:n1                          % Put cum distrib 1 on common abscissa
    j = find(dist(:,1)==X1(i));
    dist(j,2) = dist(j,2)+incr;
  end;

  incr = 1./n2;
  for i = 1:n2                          % Put cum distrib 2 on common abscissa
    j = find(dist(:,1)==X2(i));
    dist(j,3) = dist(j,3)+incr;
  end;

  dist(:,2) = cumsum(dist(:,2));        % Convert to cum distribs
  dist(:,3) = cumsum(dist(:,3));
%dist
%diff = abs(dist(:,2)-dist(:,3))
%close all;
%plot(dist(:,1),dist(:,2),'k');
%hold on;
%plot([dist(1,1) dist(1,1)],[0 dist(1,2)],'k');
%plot([dist(1,1) dist(1,1)],[0 dist(1,3)],'k');
%plot(dist(:,1),dist(:,3),'k');
%hold off;
%xmin = floor(min(dist(:,1)));
%xmax = ceil(max(dist(:,1)));
%axis([xmin xmax -0.05 1.05]);
%putxlab('X');
%putylab('Cumulative relative frequency');


  diff = dist(:,2)-dist(:,3);           % Difference between distribs
  if (stat==KS)                           % Calc KS statistic
    solution = max(abs(diff));
  elseif (stat==MSE)                      % Calc MSE statistic
    solution = mean(diff.*diff);
  end;

  return;


