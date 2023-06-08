function ts=sp2ts(sp, bn)
%  SP2TS Converts spike times to time series.
%
%  TS = SP2TS(SP, BN) returns a time series with sampling
%  rate, RATE, with boundaries, BN, when given a vector of spike times, 
%  SP.  If omitted, BN defaults to [minmax(SP),1].
%

%  Author:  Bijan Pesaran

if (nargin < 2) bn=[minmax(sp)',1]; end

ts = [];

if iscell(sp)
	for tr = 1:length(sp)
		ts_tmp=hist(sp{tr},bn(1):1./bn(3):bn(2));
		ts = [ts;ts_tmp(2:end-1) 0];
	end
else
	ts_tmp=hist(sp,bn(1):1./bn(3):bn(2));
	ts = [ts_tmp(2:end-1) 0];
end
