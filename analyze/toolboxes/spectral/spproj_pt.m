function [proj, hf, f]=spproj_pt(dN, tapers, sampling, fk, pad)
%SPPROJ_DN  Spectral projection using the multitaper techniques
%
% [PROJ, F] = SP_PROJ_DN(dN, TAPERS, NF, FK) calculates the multitaper
% spectral projection of X using prolates specified in TAPERS.
%
% Note:  dN is a trial-time series array.

% Modification History: Written by Bijan Pesaran 3 July, 2000


ntr = size(dN, 1);
N = size(dN, 2);

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
if nargin < 4 fk = [0,sampling./2]; end
if length(fk) == 1
    fk = [0,fk];
end
if nargin < 5 pad = 2; end

%e = [sqrt(-1),1]; % e = e(2:-1:1);
%ph = exp(i*2*pi*[1:nf]./nf.*(N-1)/2);
nt = length(tapers(:,1));
if iscell(dN)
    dN = sp2ts(dN,[0,nt./sampling,sampling]);
end
ntr = size(dN,1);
K = length(tapers(1,:));
nf = max(256,pad*2.^(nextpow2(N+1)));
nfk = floor(fk./sampling.*nf);

% Determine outputs
f = linspace(fk(1),fk(2),diff(nfk));

ntapers = tapers.*sqrt(sampling);


%  Calculate the Slepian transforms.
H = fft(ntapers(:,1:K),nf)';

proj = zeros(ntr, K, diff(nfk));
for tr = 1:ntr,
    tmp = dN(tr,:)';
    dNk = fft(ntapers(:,1:K).*tmp(:,ones(1,K)),nf)'...
        - mean(tmp).*H;
    dNk = dNk(:,nfk(1)+1:nfk(2));
    rate(tr) = mean(sum((ntapers(:,1:K).*tmp(:,ones(1,K))).^2,1));
    proj(tr, :, :) = dNk;
end

proj = sq(proj);
