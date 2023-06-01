function lfp = lfpfilter(data, sampling);
%   
%   lfp = lfpfilter(data, sampling);
%
%  sampling defaults to 2e4 (in Hz)
%

if nargin < 2; sampling = 2e4; end

lfp = (mtfilter(data,[round(0.01*sampling)./sampling,300],sampling,0));
%lfp = lfp(:,1:sampling./fs:end);
