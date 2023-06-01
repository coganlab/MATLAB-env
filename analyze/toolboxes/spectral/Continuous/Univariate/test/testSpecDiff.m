function [p,D,PD,S_X1,S_X2] = testSpecDiff(X1,X2,tapers,sampling,fk,nPerms)
%;Task,Field,bn,conds,tapers,dn,delay)
%
%   [p,D,PD,S_X1,S_X2] = testSpecDiff(X1,X2,tapers,sampling,fk)
%
%   X1 - raw data
%   X2 - raw data
%   tapers  =   [N,W].  Defaults to [.5,10]
%   fk      =   Vector.  Select frequency band to test in Hz.
%   nPerms - # of permutations, defaults to 5e3
%
%   Outputs:  P	 = p-Value
%		D = Test statistic
%	        PD = Null-distribution of test statistic 

if nargin < 3 || isempty(tapers); tapers = [.5,10]; end
if nargin < 4 || isempty(sampling); sampling = 1e3; end
if nargin < 5 || isempty(fk); fk = [0,200]; end
if nargin < 6 || isempty(nPerms); nPerms = 5e3; end

N = tapers(1);
if length(tapers)==3
    W = tapers(2)./tapers(1);
else
    W = tapers(2);
end
p = N*W;
k = floor(2*p-1);
tapers = [N,p,k];
tapers(1) = floor(tapers(1).*sampling);
tapers = dpsschk(tapers);
K = length(tapers(1,:));
n = length(tapers(:,1));
pad = 2;
nf = max(256,pad*2.^(nextpow2(n+1)));
nfk = floor(fk./sampling.*nf);
ntr1 = size(X1,1);
ntr2 = size(X2,1);

if ntr1 < 2 || ntr2 < 2
    p = nan; D = nan; PD = nan;S_X1 = nan; S_X2 = nan;
    error(['Not enough trials ' num2str(ntr1) ':' num2str(ntr2)])
end

Xk1 = zeros(ntr1*K, diff(nfk));
Xk2 = zeros(ntr2*K, diff(nfk));
mX1 = sum(X1)./ntr1; mX2 = sum(X2)./ntr2;
X1 = X1 - mX1(ones(1,ntr1),:);
X2 = X2 - mX2(ones(1,ntr2),:);

for tr = 1:ntr1
    tmp1 = X1(tr,:)';
    xk = fft(tapers(:,1:K).*tmp1(:,ones(1,K)),nf)';
    Xk1((tr-1)*K+1:tr*K,:) = xk(:,nfk(1)+1:nfk(2));
end
for tr = 1:ntr2
    tmp2 = X2(tr,:)';
    xk = fft(tapers(:,1:K).*tmp2(:,ones(1,K)),nf)';
    Xk2((tr-1)*K+1:tr*K,:) = xk(:,nfk(1)+1:nfk(2));
end
S_X1 = sum(Xk1.*conj(Xk1))./(ntr1*K);
S_X2 = sum(Xk2.*conj(Xk2))./(ntr2*K);
D = sum(log(S_X1) - log(S_X2))./diff(nfk);
GX = [Xk1;Xk2];
aGX = GX.*conj(GX);
for iPerm = 1:nPerms
    NP = randperm(size(GX,1));
    N1 = NP(1:size(Xk1,1));
    N2 = NP(size(Xk1,1)+1:end);
    PS_X1 = sum(aGX(N1,:))./(ntr1.*K);
    PS_X2 = sum(aGX(N2,:))./(ntr2.*K);
    PD(iPerm) = sum(log(PS_X1)-log(PS_X2))./diff(nfk);
end
p = length(find(abs(PD)>abs(D)))./nPerms;

