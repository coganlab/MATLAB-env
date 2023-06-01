function [c, d] = bin_cvr( cvr, dt )
% Given spike times and covariates with time stamps, aligns and bins the
% data such that it can be easily passed to some decoding algorithm such as
% a Kalman filter.  While the analyze framework probably already has
% scripts to do this, I'm still learning my way around analyze and will use
% this for the time being.
%
% spikes - cell array of spike times for each unit
% dt - bin width
% cvr - optional cell array of covariates, first column is times, second 
%       column values
% s - binned spike times
% c - binned covariates
% d - binned derivatives of covariates
%
% David Pfau, 2011-2012

c = [];
T0 = min( cellfun( @(x) min( x(~isinf(x(:,1)),1) ), cvr ) );
T1 = max( cellfun( @(x) max( x(~isinf(x(:,1)),1) ), cvr ) );

edges = T0:dt:T1+dt;

if exist('fast_avg','file') == 3
   [c,d] = fast_avg( edges, cvr );
elseif exist('fast_avg.c','file') == 2
   mex fast_avg.c
   [c,d] = fast_avg( edges, cvr );
else
    error( 'Missing mex file for fast_avg!' );
end
