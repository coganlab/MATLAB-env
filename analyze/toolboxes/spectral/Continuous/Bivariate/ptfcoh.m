function [coh,f,S_X,S_Y] = ...
    ptfcoh(X,Y,tapers,sampling,dn,fk,pad,pval,flag) 
%  PTFCOH Moving window time-frequency coherency between two time series using parfor.
%
% [COH, F, S_X, S_Y] = ...
%	PTFCOH(X, Y, TAPERS, SAMPLING, DN, FK, PAD, PVAL, FLAG)
%
%  Inputs:  X		=  Time series array in [Space/Trials,Time] form.
%	    Y		=  Time series array in [Space/Trials,Time] form.
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
%	   FLAG = 0:	calculate COH seperately for each channel/trial.
%	   FLAG = 1:	calculate COH by pooling across channels/trials. 
%      FLAG = 11:   calculate COH by pooling across channels/trials without
%      error bars
%                       Defaults to 11, for which the code is optimized.
% 
%  Outputs: COH	        =  Coherency between X and Y in [Space/Trials,Freq].
%	    F		=  Units of Frequency axis for COH.
%	    S_X		=  Spectrum of X in [Space/Trials, Freq] form. 
%	    S_Y		=  Spectrum of Y in [Space/Trials, Freq] form. 
%

%  Written by:  Bijan Pesaran Caltech 1998
%                   Optimized when not computing error bars and pooling
%                   across trials
%


sX = size(X);
nt1 = sX(2);
nch1 = sX(1);

sY = size(Y);
nt2 = sY(2);
nch2 = sY(1);

if nt1 ~= nt2; error('Error: Time series are not the same length'); end
if nch1 ~= nch2; error('Error: Time series are incompatible'); end
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
    %disp(['Using ' num2str(k) ' tapers.']);
end
if length(tapers) == 3
    tapers(1) = floor(tapers(1).*sampling);
    tapers = single(dpsschk(tapers));
end
if nargin < 5; dn = n./10; end
if nargin < 6; fk = [0,sampling./2]; end
if length(fk) == 1
     fk = [0,fk];
end
if nargin < 7; pad = 2; end
if nargin < 8; pval = 0.05;  end
if nargin < 9; flag = 11; end

K = length(tapers(1,:));
N = length(tapers(:,1));
if N > nt; error('Error: Tapers are longer than time series'); end

% Determine outputs
if nargout > 3; errorchk = 1; else errorchk = 0; end

dn = floor(dn.*sampling);
nf = max(256, pad*2^nextpow2(N+1));
nfk = floor(fk./sampling.*nf);
nwin = floor((nt-N)./dn);           % calculate the number of windows
f = linspace(fk(1),fk(2),diff(nfk));
K = single(K);
nch = single(nch);
if flag ~= 11   % This is not optimized
    for win = 1:nwin
        tmp1 = X(:,dn*win:dn*win+N-1);
        tmp2 = Y(:,dn*win:dn*win+N-1);
        [tmp_coh,f,tS1,tS2] = coherency(tmp1,tmp2,tapers,sampling,fk,pad,pval,flag);
        if flag == 0
            Coh(win,:,:)=tmp_coh;
            S_X(win,:,:)=tS1;
            S_Y(win,:,:)=tS2;
        end
        if flag > 0
            Coh(win,:)=tmp_coh;
            S_X(win,:)=tS1;
            S_Y(win,:)=tS2;
        end
    end
elseif flag == 11
    %  This is optimized
    %disp(['Flag is ' num2str(flag)]);

    S_X = zeros(nwin,diff(nfk),'single');
    S_Y = zeros(nwin,diff(nfk),'single');
    coh = zeros(nwin,diff(nfk),'single') + 1i*zeros(nwin,diff(nfk),'single');
    mX = sum(X)./nch; mY = sum(Y)./nch;
    X = (X - mX(ones(1,nch),:)).';
    Y = (Y - mY(ones(1,nch),:)).';
    parfor win=1:nwin
        tmp1 = X(dn*(win-1)+1:dn*(win-1)+N,:);
        tmp2 = Y(dn*(win-1)+1:dn*(win-1)+N,:);
        c = zeros(diff(nfk),1,'single') + 1i*zeros(diff(nfk),1,'single');
        SX = zeros(diff(nfk),1,'single');
        SY = zeros(diff(nfk),1,'single');
        for ch = 1:nch
            Xk = fft(tapers.*tmp1(:,ch*ones(1,K)),nf);
            Xk = Xk(nfk(1)+1:nfk(2),:);
            A = sum(Xk.*conj(Xk),2)./(K.*nch);
            SX = SX + A;
            Yk = fft(tapers.*tmp2(:,ch*ones(1,K)),nf);
            Yk = Yk(nfk(1)+1:nfk(2),:);
            A = sum(Yk.*conj(Yk),2)./(K.*nch);
            SY = SY + A;
            B = sum(Xk.*conj(Yk),2)./(K.*nch);
            c = c + B;
        end
        coh(win,:) = (c./(sqrt(SX.*SY))).';
        S_X(win,:) = SX.'; S_Y(win,:) = SY.';
    end
end

if flag == 0
    coh = permute(coh,[2,1,3]);
end
