function [coh_ptx, S_X, S_dN, rate, f, coh_err, SX_err, SdN_err] = ...
   coherency_ptx(X, dN, tapers, sampling, fk, pad, pval, flag)
% COHERENCY_PTX calculates the coherency between a time series X and a
%	point process dN.
%
% [COH_PTX, S_X, S_dN, RATE, F, COH_ERR, SX_ERR, SdN_ERR] = ...
%	COHERENCY_PTX(X, dN, TAPERS, SAMPLING, FK, PAD, PVAL, FLAG)
%
%  Inputs:  X		=  Time series array in [Space/Trials,Time] form.  
%	    dN		=  Point process array in [Space/Trials,Time] form.
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
%	   PVAL		=  P-value to calculate error bars for.
%				Defaults to 0.05 i.e. 95% confidence.
%
%	   FLAG = 0:	calculate COH seperately for each channel/trial.
%	   FLAG = 1:	calculate COH by pooling across channels/trials. 
%	   FLAG = 11 	calcuation is done as for FLAG = 1 
%		but the error bars cannot be calculated to save memory.
%	   	Defaults to FLAG = 11.
%
%  Outputs: COH_PTX	=  Coherency between X and dN in [Space/Trials,Freq]. 
%	    S_X		=  Spectrum of X in [Space/Trials,Freq] form.  
%	    S_dN	=  Spectrum of dN in [Space/Trials, Freq] form.
%	    RATE	=  Mean rate of dN in Hz.
%	    F		=  Units of Frequency axis for COH.
%	    COH_ERR 	=  Error bars for COH in [Hi/Lo, Space, Freq]  
%			   form given by the Jacknife-t interval for PVAL.
% 	    SX_ERR 	=  Error bars for S_X.
% 	    SdN_ERR 	=  Error bars for S_dN.
%

% Written by:  	 Bijan Pesaran, Bell Labs
% Version Date:	 July 1999
%                April 2004:    Added cell array spike time inputs
%                October 2004:  Added floor on time-dimension inputs for tapers
%



sX = size(X);
nt1 = sX(2);
nch1 = sX(1);

if iscell(dN)
    dN = sp2ts(dN,[0,nt1./sampling,sampling]);
end
sN = size(dN);
nt2 = sN(2);
nch2 = sN(1);

% errorchk = 0;
% flag = 1;

if nt1 ~= nt2; error('Error: Time series are not the same length'); end 
if nch1 ~= nch2; error('Error: Time series are incompatible'); end 
nt = nt1;
nch = nch1;

if nargin < 4; sampling = 1; end 
nt = nt./sampling;
if nargin < 3; tapers = [nt,5,9]; end 
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
if nargin < 5; fk = [0,sampling./2]; end
if length(fk) == 1
    fk = [0,fk];
end
if nargin < 6; pad = 2; end
if nargin < 7; pval = 0.05;  end
if nargin < 8; flag = 11; end 

N = length(tapers(:,1));
if N ~= nt*sampling 
	error('Error: Tapers and time series are not the same length'); 
end

K = length(tapers(1,:));
nf = max(256,pad*2.^(nextpow2(N+1)));
nfk = floor(fk./sampling.*nf);

% Determine outputs
f = linspace(fk(1),fk(2),diff(nfk));
errorchk = 0;
if nargout > 4; errorchk = 1; end

ntapers = tapers.*sqrt(sampling);
H = fft(ntapers(:,1:K),nf)'; 

if ~flag		% No pooling across channels/trials
    rate = zeros(1,nch);
    for ch = 1:nch
        tmp1 = X(ch,:)'-sum(X(ch,:))./N;
        Xk = fft(tapers(:,1:K).*tmp1(:,ones(1,K)),nf)';
        Xk = Xk(:,nfk(1)+1:nfk(2));
        S_X(ch,:) = sum(Xk.*conj(Xk))./K;
        tmp2 = dN(ch,:)';
        dNk = fft(ntapers(:,1:K).*tmp2(:,ones(1,K)),nf)'...
            - mean(tmp2).*H;
        dNk = dNk(:,nfk(1)+1:nfk(2));
        S_dN(ch,:) = sum(dNk.*conj(dNk))./K;
        rate(ch) = mean(sum((ntapers(:,1:K).* ...
            tmp2(:,ones(1,K))).^2,1));
        coh_ptx(ch,:) = sum(Xk.*conj(dNk))./K./sqrt(S_dN(ch,:).*S_X(ch,:));

        if errorchk
            jSdN = zeros(K,size(dNj,2));  jSX = zeros(K,size(Xj,2)); 
            for j = 1:K
                indices = setdiff(1:K,j);
                dNj = dNk(indices,:);
                Xj = Xk(indices,:);
                jcoh(j,:)=sum(Xj.*conj(dNj))./...
                    sqrt(sum(Xj.*conj(Xj)).*sum(dNj.*conj(dNj)));
                jSdN(j,:) = log(sum(dNj.*conj(dNj))./K);
                jSX (j,:) = log(sum(Xj.*conj(Xj))./K);
            end
            %          lsigX = sqrt(K-1).*std(jXlsp,1);
            %          lsigY = sqrt(K-1).*std(jYlsp,1);
            %          lsigXY = sqrt(K-1).*std(jcoh,1);
            %          p = 		%   Determine the scaling factor
            %          coh_err(1,ch,:) = exp(log(coh(ch,:))+p.*lsigXY);
            %          coh_err(2,ch,:) = exp(log(coh(ch,:))-p.*lsigXY);
            %          SX_err(1,ch,:) = exp(log(S_X(ch,:))+p.*lsigX);
            %          SX_err(2,ch,:) = exp(log(S_X(ch,:))-p.*lsigX);
            %          SY_err(1,ch,:) = exp(log(S_Y(ch,:))+p.*lsigY);
            %          SY_err(2,ch,:) = exp(log(S_Y(ch,:))-p.*lsigY);
        end
    end
end


if flag	== 1		% Pooling across trials
    coh_ptx = zeros(1, diff(nfk));
    S_X = zeros(1, diff(nfk));
    S_dN = zeros(1, diff(nfk));

    coh_err = zeros(2, diff(nfk));
    SX_err = zeros(2, diff(nfk));
    SdN_err = zeros(2, diff(nfk));

    Xk = zeros(nch*K, diff(nfk));
    dNk = zeros(nch*K, diff(nfk));
    rate = zeros(1,nch);
    
    mX = sum(X)./nch; 
    X = (X - mX(ones(1,nch),:)).';
    for ch = 1:nch
        tmp1 = X(:,ch);
        Xk_tmp = fft(tapers(:,1:K).*tmp1(:,ones(1,K)),nf)';
        Xk((ch-1)*K+1:ch*K,:) = Xk_tmp(:,nfk(1)+1:nfk(2));
        tmp2 = dN(ch,:)';
        dNk_tmp = fft(ntapers(:,1:K).*tmp2(:,ones(1,K)),nf)'...
            - mean(tmp2).*H;
        dNk((ch-1)*K+1:ch*K,:) = dNk_tmp(:,nfk(1)+1:nfk(2));
        rate(ch) = mean(sum((ntapers(:,1:K).* ...
            tmp2(:,ones(1,K))).^2,1));
    end
    rate = mean(rate);
    S_X = sum(Xk.*conj(Xk),1)./(K.*nch);
    S_dN = sum(dNk.*conj(dNk),1)./(K.*nch);
    coh_ptx = sum(Xk.*conj(dNk))./(K.*nch)./sqrt(S_X.*S_dN);
    if errorchk			%  Estimate error bars using Jacknife
        jXlsp = zeros(nch*K,size(Xj,2));  jdNlsp = zeros(nch*K,size(dNj,2));
        for ik = 1:nch*K
            indices = setdiff(1:nch*K,ik);
            Xj = Xk(indices,:);
            dNj = dNk(indices,:);
            jcoh(ik,:)=sum(Xj.*conj(dNj))./sqrt(sum(Xj.*conj(Xj)).*sum(dNk.*conj(dNk)));
            jXlsp(ik,:) = log(sum(Xj.*conj(Xj))./(nch*K-1));
            jdNlsp(ik,:) = log(sum(dNj.*conj(dNj))./(nch*K-1));
        end
        %          lsigX = sqrt(nch*K-1).*std(jXlsp,1);
        %          lsigY = sqrt(nch*K-1).*std(jYlsp,1);
        %          lsigXY = sqrt(nch*K-1).*std(jcoh,1);
        %          p = 		%   Determine the scaling factor
        %          coh_err(1,:) = exp(log(coh)+p.*lsigXY);
        %          coh_err(2,:) = exp(log(coh)-p.*lsigXY);
        %          SX_err(1,:) = exp(log(S_X)+p.*lsigX);
        %          SX_err(2,:) = exp(log(S_X)-p.*lsigX);
        %          SY_err(1,:) = exp(log(S_Y)+p.*lsigY);
        %          SY_err(2,:) = exp(log(S_Y)-p.*lsigY);
    end
end


if flag == 11	%  Pooling across trials saving memory (no error bars)
   S_X = zeros(1,diff(nfk));  
   S_dN = zeros(1,diff(nfk));
   coh_ptx = zeros(1,diff(nfk))+i.*zeros(1,diff(nfk));
   rate = 0;
    mX = sum(X)./nch; 
    X = (X - mX(ones(1,nch),:)).';

   for ch = 1:nch
      tmp1 = X(:,ch);
      tmp2 = dN(ch,:)';
      Xk = fft(tapers(:,1:K).*tmp1(:,ones(1,K)),nf)';
      Xk = Xk(:,nfk(1)+1:nfk(2));
      S_X = S_X + sum(Xk.*conj(Xk))./(nch.*K);
      dNk = fft(ntapers(:,1:K).*tmp2(:,ones(1,K)),nf)'...
		- mean(tmp2).*H;
      dNk = dNk(:,nfk(1)+1:nfk(2));
      S_dN = S_dN + sum(dNk.*conj(dNk))./(nch.*K);
      rate = rate + sum(sum((ntapers(:,1:K).* ...
		tmp2(:,ones(1,K))).^2,1))./(nch.*K);
      coh_ptx = coh_ptx + sum(Xk.*conj(dNk))./(K.*nch);
   end
   coh_ptx = coh_ptx./sqrt(S_X.*S_dN);
end


