% Initrand: Initialize the states of the rand() and randn() random-number generators with
%           seeds based on the current clock value.
%
%     Usage: initrand
%

% RE Strauss, 11/14/03

function initrand
  randn('state',sum(100*clock));
  rand('state',sum(100*clock));
  return;
  