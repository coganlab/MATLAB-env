function ts = sp2ts(sp, bn, binwidth)
%  SP2TS Converts spike times to time series.
%
%  TS = SP2TS(SP, BN, BINWIDTH) returns a time series with bin
%  width, BINWIDTH, with boundaries, BN(1:2), when given a vector 
%  of spike times, SP.  
%       If omitted, BN defaults to [minmax(SP),1].
% Spike times are in ms and 

%  Author:  Bijan Pesaran

if nargin < 2; bn = [minmax(sp)',1]; end
if nargin < 3; binwidth = 1; end

if length(bn) < 3; bn(3) = 1e3; end

ts = [];
x = linspace(bn(1),bn(2),diff(bn(1:2)).*bn(3)./binwidth+1);

if iscell(sp)
	for tr = 1:length(sp)
		ts_tmp = hist(sp{tr}./bn(3),x);
		ts = [ts;[0 ts_tmp(2:end-1) 0]];
	end
else
	ts_tmp = hist(sp,x);
	ts = [0 ts_tmp(2:end-1) 0];
end
