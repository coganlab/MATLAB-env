function [c_mat,f,s_mat,c_err,s_err] = ...
    tfcohmat(X,tapers,sampling,dn,fk,pad,pval,flag,contflag) 
%  TFCOHMAT Moving window time-frequency coherency matrix.
%
% [C_MAT, F, S_MAT, C_ERR, S_ERR] = ...
%	TFCOHMAT(X, TAPERS, SAMPLING, DN, FK, PAD, PVAL, FLAG, CONTFLAG)
%
%  Inputs:  X		=  Time series array in [Space,Trials,Time] form.
%	    TAPERS 	=  Data tapers in [K,TIME], [N,P,K] or [N, W] form.
%			   	Defaults to [N,5,9] where N is the duration 
%				of X and Y.
%	    SAMPLING 	=  Sampling rate of time series X, in Hz. 
%				Defaults to 1.
%	    DN		=  Overlap in time between neighbouring windows.
%			       	Defaults to N./10;
%	    FK 	 	=  Frequency range [F1,F2] to return in Hz.  
%			   	Defaults to [0,SAMPLING/2]
%	    PAD		=  Padding factor for the FFT.  
%			      	i.e. For N = 500, if PAD = 2, we pad the FFT 
%			      	to 1024 points; if PAD = 4, we pad the FFT
%			      	to 2048 points.
%				Defaults to 2.
%	   PVAL		=  P-value to calculate error bars for.
%				Defaults to 0.05 i.e. 95% confidence.
%
%	   FLAG = 0:	calculate C_MAT seperately for each channel/trial.
%	   FLAG = 1:	calculate C_MAT by pooling across channels/trials. 
%	   FLAG = 11 	calcuation is done as for FLAG = 1 
%		but the error bars cannot be calculated to save memory.
%      CONTFLAG = 1; There is only a single continuous signal coming in.
%               Defaults to 0.
%
%
%  Outputs:C_MAT	=  Coherency in [Space,Trials,Freq].  
%	   S_MAT	=  Spectrum of X in [Space,Trials, Freq] form.
%	   F		=  Units of Frequency axis for COH. 
%	   COH_ERR 	=  Error bars for COH in [Hi/Lo, Space, Freq]  
%	 	   	   form given by the Jacknife-t interval for PVAL. 
% 	   S_ERR 	=  Error bars for S_MAT.

%  Written by:  Bijan Pesaran Caltech 1998
%

sX = size(X);
nt = sX(2);
nch = sX(1);

if nargin < 4 sampling = 1; end 
n = nt./sampling;
if nargin < 3 tapers = [n,5,9]; end 
if length(tapers) == 2
   n = tapers(1);
   w = tapers(2);
   p = n*w;
   k = floor(2*p-1);
   tapers = [n,p,k];
end
if length(tapers) == 3  
   tapers(1) = tapers(1).*sampling;  
   tapers = dpsschk(tapers); 
end
if nargin < 5 || isempty(dn); dn = n./10; end
if nargin < 6 || isempty(fk); fk = [0,sampling./2]; end
if nargin < 7 || isempty(pad); pad = 2; end
if nargin < 8 || isempty(pval); pval = 0.05;  end
if nargin < 9 || isempty(flag); flag = 0; end 
if nargin < 10 || isempty(contflag);  contflag = 0; end

K = length(tapers(1,:)); 
N = length(tapers(:,1));
if N > nt error('Error: Tapers are longer than time series'); end

% Determine outputs
errorchk = 0;
if nargout > 3 errorchk = 1; end

dn = dn.*sampling;
nf = max(256, pad*2^nextpow2(N+1)); 
nfk = floor(fk./sampling.*nf);
nwin = floor((nt-N)./dn);           % calculate the number of windows
f = linspace(fk(1),fk(2),diff(nfk));

for win = 1:nwin
   tmp = X(:,dn*win:dn*win+N-1);
   [tmp_coh,f,tS] = cohmat(tmp,tapers,sampling,fk,pad,pval,flag,contflag);
   if flag == 0 
        c_mat(win,:,:,:,:)=tmp_coh; 
        s_mat(win,:,:,:,:)=tS;
   end
   if flag > 0 
       c_mat(win,:,:,:)=tmp_coh; 
       s_mat(win,:,:,:)=tS;
   end
end
