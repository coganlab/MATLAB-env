function [tfproj, hf, f]=tfspproj_pt(dN, tapers, sampling, dn, fk, pad)
%TFSPPROJ_DN  Spectral projection using the multitaper techniques
%
% [TFPROJ, F] = TFSPPROJ_PT(dN, TAPERS, SAMPLING, DN, FK, PAD) calculates the multitaper
% spectral projection of X using prolates specified in TAPERS.
%
% Note:  dN is a trial-time series array.
% Note:  This code uses parfor if matlabpool('size') is not zero

% Modification History: Written by Bijan Pesaran 3 July, 2000


ntr = size(dN, 1);
nt = size(dN, 2);

errorchk=0;

if nargin < 3 sampling = 1; end 
if length(tapers) == 2
   n = tapers(1); 
   w = tapers(2);
   p = n*w;
   k = floor(2*p-1);
   if k < 1 error('Must choose N and W so that K > 1'); end
   if k < 3 disp('Warning:  Less than three tapers being used'); end
   tapers = [n,p,k];
end
if length(tapers) == 3  
   tapers(1) = floor(tapers(1).*sampling);  
   tapers = dpsschk(tapers); 
end
if nargin < 4 || isempty(dn)
    dn = n./10; 
end
if nargin < 5 || isempty(fk); fk = [0,sampling./2]; end
if length(fk) == 1
    fk = [0,fk];
end
if nargin < 6 || isempty(pad); pad = 2; end

%e = [sqrt(-1),1]; % e = e(2:-1:1);
%ph = exp(i*2*pi*[1:nf]./nf.*(N-1)/2);
N = length(tapers(:,1));
if iscell(dN)
    dN = sp2ts(dN,[0,nt./sampling,sampling]);
end

dn = dn*sampling;
ntr = size(dN,1);
K = length(tapers(1,:));
nf = max(256,pad*2.^(nextpow2(N+1)));
nfk = floor(fk./sampling.*nf);
nWin = single(floor((nt-N)./dn));           % calculate the number of windows

% Determine outputs
f = linspace(fk(1),fk(2),diff(nfk));

ntapers = tapers.*sqrt(sampling);

%  Calculate the Slepian transforms.
H = fft(ntapers(:,1:K),nf);

tfproj = zeros(ntr, nWin, diff(nfk), K);

nfk1 = nfk(1); nfk2 = nfk(2);
dN = dN';
for iWin = 1:nWin
    start = dn*(iWin-1) + 1;
    stop = dn*(iWin-1) + N;
    par_dN = dN(start:stop,:);
    parfor iTr = 1:ntr
        dNk = fft(ntapers.*par_dN(:,iTr*ones(1,K)),nf) - mean(par_dN(:,iTr)).*H;
        tfproj(iTr,iWin, :, :) = dNk(nfk1+1:nfk2,:);
           % rate(tr) = mean(sum((ntapers(:,1:K).*tmp(:,ones(1,K))).^2,1));
    end
end

tfproj = permute(tfproj,[1, 2, 4, 3]);
