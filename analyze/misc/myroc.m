function [p,se] = myroc(data1,data2,flag)
%
%   [p,se] = myroc(data1,data2,flag)
%
%	data1 = Vector of values for condition 1 for each sample
%	data2 = Vector of values for condition 2 for each sample
%   flag = 0/1 order data
%	p = Choice probability

if nargin < 3 flag = 0; end
group = [ones(1,length(data1)) zeros(1,length(data2))];
data = [data1 data2];
c1 = 1; c2 = 0;
[myd,myg] = setup_roc(data',group',c1,c2,flag);
[p,se] = roc(myd,myg,'nofigure');
