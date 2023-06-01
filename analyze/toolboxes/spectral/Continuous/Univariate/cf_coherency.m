function [cf_coh,f,S,coh_err,S_err]=...
	cf_coherency(X, tapers, sampling, fk, pad)  
% COHERENCY calculates the coherency between two time series, X and Y 
%
% [CF_COH, F, S, COH_ERR, S_ERR] = ...
%	CF_COHERENCY(X, TAPERS, SAMPLING, FK, PAD)
%
%  Inputs:  X		=  Time series array in [Space/Trials,Time] form.
%	    TAPERS 	=  Data tapers in [K,TIME], [N,P,K] or [N, W] form.
%			   	Defaults to [N,5,9] where N is the duration 
%				of X and Y.
%	    SAMPLING 	=  Sampling rate of time series X, in Hz. 
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
%	    FLAG = 1:	calculate CF_COH by pooling across channels/trials. 
%	    FLAG = 11 	calculation is done as for FLAG = 1 
%		but the error bars cannot be calculated to save memory.
%	   	Defaults to FLAG = 11.
%
%  Outputs: CF_COH		=  Cross-frequency Coherency for X [Freq,Freq].
%                  F    =  Units of Frequency axis for COH
%	    S		=  Spectrum of X in [Space/Trials, Freq] form.
%	    COH_ERR 	=  Error bars for COH in [Hi/Lo, Space, Freq]
%			   form given by the Jacknife-t interval for PVAL.
% 	    S_ERR 	=  Error bars for S.
%


sX = size(X);
nt = sX(2);
nch = sX(1);

if nargin < 4; sampling = 1; end 
nt = nt./sampling;
if nargin < 3; tapers = [nt, 5, 9]; end 
if length(tapers) == 2
   n = tapers(1);
   w = tapers(2);
   p = n*w;
   k = floor(2*p-1);
   tapers = [n,p,k];
   disp(['Using ' num2str(k) ' tapers.']);
end
if length(tapers) == 3  
   tapers(1) = floor(tapers(1).*sampling);  
   tapers = dpsschk(tapers); 
end
if nargin < 5 || isempty(fk); fk = [0,sampling./2]; end
if length(fk) == 1;  fk = [0,fk]; end
if nargin < 6 || isempty(pad); pad = 2; end

N = length(tapers(:,1));
if N ~= nt*sampling 
	error('Error: Tapers and time series are not the same length'); 
end

K = length(tapers(1,:));
nf = max(256,pad*2.^(nextpow2(N+1)));
nfk = floor(fk./sampling.*nf);
Nf = diff(nfk);
% Determine outputs
f = linspace(fk(1),fk(2),Nf);
errorchk = 0;
if nargout > 4; errorchk = 1; end


if 1 %flag == 11	%  Pooling across trials saving memory
    S = zeros(Nf,1,'single');  
    cf_coh = zeros(Nf,Nf,'single');
    mX = sum(X)./nch;
    X = (X - mX(ones(1,nch),:)).';
    
    for ch = 1:nch
        tmp = X(:,ch);
        Xk = fft(tapers(:,1:K).*tmp(:,ones(1,K)),nf);
        S = S + sum(Xk(nfk(1)+1:nfk(2),:).*conj(Xk(nfk(1)+1:nfk(2),:)),2)./K./nch;
        cf_coh = cf_coh + Xk(nfk(1)+1:nfk(2),:)*Xk(nfk(1)+1:nfk(2),:)'./K./nch;
    end
    cf_coh = cf_coh./(sqrt(S)*sqrt(S'));
end
