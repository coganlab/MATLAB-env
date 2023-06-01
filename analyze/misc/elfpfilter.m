function elfp = elfpfilter(data, sampling)
%   
%   elfp = elfpfilter(data, sampling);
%
%  sampling defaults to 2e4 (in Hz)
%
%  Outputs:  ELFP = Extended LFP data filtered at 3kHz. Sampled at 5kHz.
%

if nargin < 2; sampling = 2e4; end

elfp = (mtfilter(data,[0.01,2000],sampling,0));
elfp = elfp(:,1:sampling/5e3:end);
