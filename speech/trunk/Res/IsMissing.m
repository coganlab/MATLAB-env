% IsMissing: Finds addresses (indices) of missing data, along with the total number and proportion.
%
%     Usage: [nmiss,pmiss,rowmiss,colmiss] = IsMissing(X)
%
%         X = [r x c] matrix.
%         ----------------------------------------------------------
%         nmiss = number of missing values.
%         pmiss = proportion of missing values.
%         rowmiss,colmiss = corresponding indices of missing values.
%

% RE Strauss, 2/25/04

function [nmiss,pmiss,rowmiss,colmiss] = IsMissing(X)
  [rowmiss,colmiss] = find(~isfinite(X));
  nmiss = length(rowmiss);
  pmiss = nmiss/prod(size(X));

  return;
  