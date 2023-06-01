function [coh_ptx, tfsp_X, tfsp_dN, rate, f] = ...
   ptfcoh_ptx(X, dN, tapers, sampling, dn, fk, pad, pval, flag)
%PTFCOH_PTX  Moving window time-frequency hybrid process coherency using
%parfor
%
%  [COH_PTX, TFSP_X, TFSP_DN, RATE, F] = ...
%		PTFCOH_PTX(X, dN, TAPERS, SAMPLING, DN, FK, PAD, PVAL, FLAG) 
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
%	   PVAL		=  P-value to calculate error bars for.
%				Defaults to 0.05 i.e. 95% confidence.
%
%	   FLAG = 0:	calculate COH seperately for each channel/trial.
%	   FLAG = 1:	calculate COH by pooling across channels/trials. 
%               Defaults to 1
%
%  Outputs: COH	        =  Coherency between X and Y in [Space/Trials,Freq].
%	    S_X		=  Spectrum of X in [Space/Trials, Freq] form. 
%	    S_Y		=  Spectrum of Y in [Space/Trials, Freq] form. 
%	    F		=  Units of Frequency axis for COH.
%

%  Written by:  Bijan Pesaran NYU 2010
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

if ~flag			%  No pooling across trials
    coh_ptx = zeros(nwin,nch,diff(nfk)); 
    tfsp_X = zeros(nwin,nch,diff(nfk));  
    tfsp_dN = zeros(nwin,nch,diff(nfk));
    for win = 1:nwin
        X_tmp = X(:,(win-1)*dn+1:(win-1)*dn+n);
        if iscell(dN)
            dN_tmp = sp2ts(dN,[(win-1)*dn+1,(win-1)*dn+n,1]);
        else
            dN_tmp = dN(:,(win-1)*dn+1:(win-1)*dn+n);
        end
        
        % 	dN_tmp = dN(:,win*dn+1:win*dn+n); 
        [coh_tmp, S_X, S_dN, rate_tmp] = coherency_ptx(X_tmp, dN_tmp,...
            tapers, sampling, fk, pad, pval, flag);    
        coh_ptx(win,:,:) = coh_tmp;     
        tfsp_X(win,:,:) = S_X; 
        tfsp_dN(win,:,:) = S_dN;
        rate(:,win) = rate_tmp';
    end
    tfsp_X = permute(tfsp_X,[2,1,3]);
    tfsp_dN = permute(tfsp_dN,[2,1,3]);
    coh_ptx = permute(coh_ptx,[2,1,3]);
end

if flag			%  Pooling across trials
    coh_ptx = zeros(nwin,diff(nfk),'single');
    tfsp_X = zeros(nwin,diff(nfk),'single');  
    tfsp_dN = zeros(nwin,diff(nfk),'single');
    rate = zeros(1,nwin,'single');
    mX = sum(X)./nch;  X = (X - mX(ones(1,nch),:)).';
    if iscell(dN)
        dN = sp2ts(dN,[1,length(mX),1]);
    end
    dN = dN';
    parfor win = 1:nwin
        %fprintf('%d ',win);
        X_tmp = X((win-1)*dn+1:(win-1)*dn+n,:);
        dN_tmp = dN((win-1)*dn+1:(win-1)*dn+n,:);
        c = zeros(diff(nfk),1,'single') + 1i*zeros(diff(nfk),1,'single');
        SX = zeros(diff(nfk),1,'single');
        SdN = zeros(diff(nfk),1,'single');
        rate_tmp = 0;
        for ch = 1:nch
            Xk = fft(tapers.*X_tmp(:,ch*ones(1,K)),nf);
            Xk = Xk(nfk(1)+1:nfk(2),:);
            A = sum(Xk.*conj(Xk),2)./(K.*nch);
            SX = SX + A;
            dNk = (fft(ntapers.*dN_tmp(:,ch*ones(1,K)),nf)...
                - sum(dN_tmp(:,ch))./n.*H.');
            dNk = dNk(nfk(1)+1:nfk(2),:);
            A = sum(dNk.*conj(dNk),2)./(K.*nch);
            SdN = SdN + A;
            B = sum(Xk.*conj(dNk),2)./(K.*nch);
            c = c + B;
            rate_tmp = rate_tmp+mean(sum((ntapers(:,1:K).* ...
              dN_tmp(:,ch*ones(1,K))).^2,1));    
        end
        coh_ptx(win,:) = (c./(sqrt(SX.*SdN))).';
        tfsp_X(win,:) = SX.';
        tfsp_dN(win,:) = SdN.';        
        rate(win) = rate_tmp;
    end
end
%fprintf('\n');
