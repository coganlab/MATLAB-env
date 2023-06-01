function [Err, P] = cvspec(X, Ntrial, nIter, prange, sampling, fk, pad);
%CVSPEC  Cross-validated spectrum estimate using multitaper techniques.
%
% [ERR, P] = CVSPEC(X, NTRIAL, NITER, PRANGE, SAMPLING, FK, PAD) 
%
%  Inputs:  X		=  Time series array in [Space/Trials,Time] form.
%	    NTRIAL	=  Number of trials to average over.
%				Defaults to 1
%	    NITER	=  Number of iterations to run
%				Defaults to 1000
%	    PRANGE	=  Range of time-bandwidth product to test [plo,phi,np]
%               		Defaults to [1,5,10]
%				If only one element, plo = 1, np = 10;         
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

if nargin < 2 || isempty(Ntrial) Ntrial = 1; end
if nargin < 3 || isempty(nIter) nIter = 1e3; end
if nargin < 4 || isempty(prange) 
  prange = [1,5,10]; 
elseif length(prange)==1
  prange = [1,prange,10];
end
if nargin < 5 sampling = 1.; end
if nargin < 6 
  fk = [0,sampling./2.];
elseif length(fk) == 1
  fk = [0,fk];
end
if nargin < 7 pad = 2; end

P = linspace(prange(1),prange(2),prange(3));
nP = prange(3);
nTr = single(nTr);

nf = max(256, pad*2^nextpow2(N+1)); 
nfk = floor(fk./sampling.*nf);
f = linspace(fk(1),fk(2),diff(nfk));
for iP = 1:nP
  K = floor(2*P(iP)-1);
  tapers{iP} = single(dpsschk([N,P(iP),K]));
end
p = 1; K = floor(2*p-1);
basetapers = single(dpsschk([N,p,K]));
spec_tot = zeros(1,diff(nfk),'single'); 
             % Here the optimized spectral loop starts.
tmp = detrend(X.','linear');
spec = zeros(nTr,diff(nfk),'single');
for iTr = 1:nTr
  Xk = fft(basetapers.*tmp(:,iTr*ones(1,K)),nf);
  Xk = Xk(nfk(1)+1:nfk(2),:);
  spec(iTr,:) = (sum(Xk.*conj(Xk),2)./(K)).';
end
specAll = mean(spec);

Spec = zeros(nTr,nP,diff(nfk),'single');
for iTr = 1:nTr
%  specLoo = (1./(nTr-1)).*(nTr*specAll - spec(iTr,:));
  for iP = 1:nP
    K = size(tapers{iP},2);
    Xk = fft(tapers{iP}.*tmp(:,iTr*ones(1,K)),nf);
    Xk = Xk(nfk(1)+1:nfk(2),:);
    Spec(iTr,iP,:) = (sum(Xk.*conj(Xk),2)./K)';
%    Err(iTr,iP) = mean((log(specLoo) - log((sum(Xk.*conj(Xk),2)./(K)).')).^2);
  end
end

Err = zeros(nP,nIter);
for iP = 1:nP
%  SpecP = sq(mean(Spec(:,iP,:)));
  for iIter = 1:nIter
    Inds = ceil(nTr*rand(1,Ntrial));
    SpecBoot = sq(mean(Spec(Inds,iP,:)))';
    SpecOut = (nTr*specAll - sum(spec(Inds,:)))./(nTr-Ntrial);
    Err(iP,iIter) = mean((log(SpecOut)-log(SpecBoot)).^2);
  end
end
