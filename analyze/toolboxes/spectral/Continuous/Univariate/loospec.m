function [Err, Spec] = loospec(X, tapers, sampling, fk, pad);
%LOOSPEC  Leave-one-out spectrum estimate using multitaper techniques.
%
% [ERR, SPEC] = LOOSPEC(X, TAPERS, SAMPLING, FK, PAD) 
%
%  Inputs:  X		=  Time series array in [Space/Trials,Time] form.
%           TAPERS      =  Data tapers in [K,TIME], [N,P,K] or [N,W] form.
%                                   [N,W] Form:  N = duration of analysis window in s.
%                                W = bandwidth of frequency smoothing in Hz.
%               Defaults to [N,3,5] where N is NT/10
%                               and NT is duration of X. 
%	    SAMPLING 	=  Sampling rate of time series X in Hz. 
%				Defaults to 1.
%	    FK 	 	=  Frequency range to return in Hz in
%                               either [F1,F2] or [F2] form.  
%                               In [F2] form, F1 is set to 0.
%			   	Defaults to [0,SAMPLING/2]
%	    PAD		=  Padding factor for the FFT.  
%			      	i.e. For N = 500, if PAD = 2, we pad the FFT 
%			      	to 1024 points; if PAD = 4, we pad the FFT
%			      	to 2048 points.
%				Defaults to 2.
%
%  Outputs: SPEC	=  Spectrum of X in [Space/Trials, Time, Freq] form. 
%	    ERR 	=  Error bars in[Hi/Lo, Space, Time, Freq]  
%			   form given by the Jacknife-t interval for PVAL.
% 
%   See also DPSS, PSD, SPECGRAM.

%   Author: Bijan Pesaran, version date 15/10/98.

sX = size(X);
N = sX(2);              % calculate the number of points
nTr = sX(1);               % calculate the number of channels

if nargin < 3 sampling = 1.; end
if nargin < 2 tapers = [n,3,5]; end
if length(tapers) == 2
   n = tapers(1);
   w = tapers(2);
   p = n*w;
   k = floor(2*p-1);
   tapers = [n,p,k];
%   disp(['Using ' num2str(k) ' tapers.']);
end
if length(tapers) == 3
   tapers(1) = floor(tapers(1).*sampling);  
   tapers = single(dpsschk(tapers));
end
if nargin < 4 
  fk = [0,sampling./2.];
elseif length(fk) == 1
  fk = [0,fk];
end
if nargin < 5 pad = 2; end

nTr = single(nTr);
K = single(length(tapers(1,:))); 
N = length(tapers(:,1));

nf = max(256, pad*2^nextpow2(N+1)); 
nfk = floor(fk./sampling.*nf);
f = linspace(fk(1),fk(2),diff(nfk));
             % Here the optimized spectral loop starts.
tmp = detrend(X.','linear');
specAll = zeros(1,diff(nfk),'single');
for iTr = 1:nTr
  Xk = fft(tapers.*tmp(:,iTr*ones(1,K)),nf);
  Xk = Xk(nfk(1)+1:nfk(2),:);
  specAll = specAll + (sum(Xk.*conj(Xk),2)./(K)).';
end
specAll = specAll./nTr;

Spec = zeros(nTr,diff(nfk),'single');
for iTr = 1:nTr
    Xk = fft(tapers.*tmp(:,iTr*ones(1,K)),nf);
    Xk = Xk(nfk(1)+1:nfk(2),:);
    Spec(iTr,:) = (sum(Xk.*conj(Xk),2)./K)';
    specLoo = (1./(nTr-1)).*(nTr*specAll - Spec(iTr,:));
    Err(iTr) = mean((log(specLoo) - log((sum(Xk.*conj(Xk),2)./(K)).')).^2);
end
