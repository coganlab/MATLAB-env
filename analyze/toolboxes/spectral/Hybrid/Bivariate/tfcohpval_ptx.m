function [coh_ptx, pval_ptx, tfsp_X, tfsp_dN, rate, f] = ...
    tfcohpval_ptx(X, dN, tapers, sampling, dn, fk, pad)
%TFCOHPVAL_PTX  Moving window time-frequency hybrid process coherency.
%
%  [COH_PTX, PVAL_PTX, TFSP_X, TFSP_DN, RATE, F] = ...
%		TFCOHPVAL_PTX(X, dN, TAPERS, SAMPLING, DN, FK, PAD)
%
%  Inputs:  X		=  Time series array in [Space/Trials,Time] form.
%	    dN		=  Point process array in [Space/Trials,Time] form.
%	    TAPERS 	=  Data tapers in [K,TIME], [N,P,K] or [N, W] form.
%			   	Defaults to [N,5,9] where N is the duration
%				of X and Y.
%	    SAMPLING 	=  Sampling rate of time series X, in Hz.
%				Defaults to 1.
%	    DN		=  Overlap in time between neighbouring windows.
%			       	Defaults to N./10;
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
%  Outputs: COH	        =  Coherency between X and Y in [Space/Trials,Freq].
%	    S_X		=  Spectrum of X in [Space/Trials, Freq] form.
%	    S_Y		=  Spectrum of Y in [Space/Trials, Freq] form.
%	    F		=  Units of Frequency axis for COH.
%

%  Written by:  Bijan Pesaran Caltech 1998
%

sX = size(X);
nt1 = sX(2);
nch1 = sX(1);

sdN = size(dN);
nt2 = sdN(2);
nch2 = sdN(1);

nt = nt1;
nch = nch1;

if nargin < 4; sampling = 1; end
t = nt./sampling;
if nargin < 3; tapers = [t,5,9]; end
if length(tapers) == 2
    n = tapers(1);
    w = tapers(2);
    p = n*w;
    k = floor(2*p-1);
    tapers = [n,p,k];
    %    disp(['Using ' num2str(k) ' tapers.']);
end
if length(tapers) == 3
    tapers(1) = floor(tapers(1).*sampling);
    tapers = dpsschk(tapers);
end
if nargin < 5; dn = n./10; end
if nargin < 6; fk = [0,sampling./2]; end
if length(fk) == 1
    fk = [0,fk];
end
if nargin < 7; pad = 2; end
if nargin < 8; pval = 0.05;  end
if nargin < 9; flag = 1; end

K = length(tapers(1,:));
N = length(tapers(:,1));
if N > nt; error('Error: Tapers are longer than time series'); end

n = floor(n.*sampling);
dn = floor(dn.*sampling);
nf = max(256, pad*2^nextpow2(N+1));
nfk = floor(fk./sampling.*nf);
nwin = floor((nt-N)./dn);           % calculate the number of windows
f = linspace(fk(1),fk(2),diff(nfk));

ntapers = tapers.*sqrt(sampling);
H = fft(ntapers(:,1:K),nf).';

coh_ptx = zeros(nwin,diff(nfk),'single');
pval_ptx = zeros(nwin,nch,diff(nfk),'single');
tfsp_X = zeros(nwin,nch,diff(nfk),'single');
tfsp_dN = zeros(nwin,nch,diff(nfk),'single');
rate = zeros(nch,nwin,'single');
mX = sum(X)./nch;  X = (X - mX(ones(1,nch),:)).';
if iscell(dN)
    dN = sp2ts(dN,[1,length(mX),1]);
end
dN = dN';
for win = 1:nwin
    X_tmp = X((win-1)*dn+1:(win-1)*dn+n,:);
    dN_tmp = dN((win-1)*dn+1:(win-1)*dn+n,:);
    Xk = zeros(nch,diff(nfk),K,'single');
    dNk = zeros(nch,diff(nfk),K,'single');
    C = zeros(1,diff(nfk),'single');
    pVal = zeros(nch,diff(nfk),'single');
    rate_tmp = zeros(1,nch);
    for ch = 1:nch
        Xk_tmp = fft(tapers.*X_tmp(:,ch*ones(1,K)),nf);
        Xk(ch,:,:) = Xk_tmp(nfk(1)+1:nfk(2),:);
        
        dNk_tmp = (fft(ntapers.*dN_tmp(:,ch*ones(1,K)),nf)...
            - sum(dN_tmp(:,ch))./n.*H.');
        dNk(ch,:,:) = dNk_tmp(nfk(1)+1:nfk(2),:);
        
        rate_tmp(ch) = mean(sum((ntapers(:,1:K).* ...
            dN_tmp(:,ch*ones(1,K))).^2,1));
    end
    SXdN = Xk.*conj(dNk);
    SX = Xk.*conj(Xk);
    SdN = dNk.*conj(dNk);
    
    SXdN_ch = squeeze(sum(SXdN,3))./K;
    SX_ch = squeeze(sum(SX,3))./K;
    SdN_ch = squeeze(sum(SdN,3))./K;
    
    SXdN_all = sum(SXdN_ch,1)./nch;
    SdN_all = sum(SdN_ch,1)./nch;
    SX_all = sum(SX_ch,1)./nch;
    
    C = SXdN_all./sqrt(SX_all.*SdN_all);
    magC = sqrt(C*conj(C));
    for ch = 1:nch
        ch_ind = setdiff(1:nch,ch);
        SXdN_loo = sum(SXdN_ch(ch_ind,:),1)./(nch-1);
        SX_loo = sum(SX_ch(ch_ind,:),1)./(nch-1);
        SdN_loo = sum(SdN_ch(ch_ind,:),1)./(nch-1);
        pVal(ch,:) = nch*magC - (nch-1)*sqrt(SXdN_loo.*conj(SXdN_loo))./sqrt(SX_loo.*SdN_loo);
    end
    
    coh_ptx(win,:) = C;
    pval_ptx(win,:,:) = pVal;
    tfsp_X(win,:,:) = SX_ch;
    tfsp_dN(win,:,:) = SdN_ch;
    rate(:,win) = rate_tmp';
end
tfsp_X = permute(tfsp_X,[2,1,3]);
tfsp_dN = permute(tfsp_dN,[2,1,3]);
pval_ptx = permute(pval_ptx,[2,1,3]);


