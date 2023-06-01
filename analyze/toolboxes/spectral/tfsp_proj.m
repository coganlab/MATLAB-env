function [tfproj, f] = tfsp_proj(X, tapers, sampling, dn, fk, pad)
%TFSP_PROJ  Spectral projection using the multitaper techniques
%
% [TFPROJ, F] = TFSP_PROJ(X, TAPERS, SAMPLING, DN, FK, PAD) 
%
% Note: This calls parfor if matlabpool('size') not zero

% Modification History: Written by Bijan Pesaran 3 July, 2000


ntr = size(X, 1);
nt = size(X, 2);

errorchk=0;

if nargin < 3 sampling = 1; end
nt = nt./sampling;
if nargin < 2 tapers = [nt,3,5]; end
if length(tapers) == 2
   n = tapers(1);
   w = tapers(2);
   p = n*w;
   k = floor(2*p-1);
   tapers = [n,p,k];
   %disp(['Using ' num2str(k) ' tapers.']);
end
if length(tapers) == 3 
   tapers(1) = tapers(1).*sampling; 
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

N = length(tapers(:,1));
nt = nt.*sampling;

K = length(tapers(1,:));
dn = floor(dn.*sampling);
nf = max(256,pad*2.^(nextpow2(N+1)));
nfk = floor(fk./sampling.*nf);  nfk1 = nfk(1); nfk2 = nfk(2);
nwin = single(floor((nt-N)./dn));           % calculate the number of windows

K = single(K);
ntr = single(ntr);
tapers = single(tapers);

% Determine outputs
f = linspace(fk(1),fk(2),diff(nfk));
tfproj = zeros(ntr, nwin, diff(nfk), K, 'single');
mX = sum(X)./ntr;
x = (X - mX(ones(1,ntr),:)).';
for iWin = 1:nwin
    start = dn*(iWin-1) + 1;
    stop = dn*(iWin-1) + N;
    par_x = x(start:stop,:);
    parfor iTr = 1:ntr
        Xk = fft(tapers.*par_x(:,iTr*ones(1,K)),nf);
        tfproj(iTr,iWin, :, :) = Xk(nfk1+1:nfk2,:);
    end
end

tfproj = permute(tfproj,[1, 2, 4, 3]);

%proj = sq(proj(:, :, nfk(1)+1:nfk(2)));
