function [p,D,PD,C1,C2] = ptestCohDiff(X1,X2,Y1,Y2,tapers,sampling,fk)
%;Task,Field,bn,conds,tapers,dn,delay)
%
%   [p,D,PD,C1,C2] = ptestCohDiff(X1,X2,Y1,Y2,tapers,sampling,fk)
%
%   X1
%   X2
%   Y1
%   Y2
%   tapers  =   [N,W].  Defaults to [.5,10]
%   fk      =   Vector.  Select frequency band to test in Hz.
%
%   Outputs:  P	 = p-Value
%		D = Test statistic
%	        PD = Null-distribution of test statistic

if nargin < 3 || isempty(tapers); tapers = [.5,10]; end
if nargin < 4 || isempty(sampling); sampling = 1e3; end
if nargin < 5 || isempty(fk); fk = [0,200]; end

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

Xk1 = zeros(ntr1, K, diff(nfk));
Xk2 = zeros(ntr2, K, diff(nfk));
mX1 = sum(X1)./ntr1; mX2 = sum(X2)./ntr2;
X1 = X1 - mX1(ones(1,ntr1),:);
X2 = X2 - mX2(ones(1,ntr2),:);
Yk1 = zeros(ntr1, K, diff(nfk));
Yk2 = zeros(ntr2, K, diff(nfk));
mY1 = sum(Y1)./ntr1; mY2 = sum(Y2)./ntr2;
Y1 = Y1 - mY1(ones(1,ntr1),:);
Y2 = Y2 - mY2(ones(1,ntr2),:);


for tr = 1:ntr1
    tmp1 = X1(tr,:)';
    xk = fft(tapers(:,1:K).*tmp1(:,ones(1,K)),nf)';
    Xk1(tr,:,:) = xk(:,nfk(1)+1:nfk(2));
    tmp1 = Y1(tr,:)';
    yk = fft(tapers(:,1:K).*tmp1(:,ones(1,K)),nf)';
    Yk1(tr,:,:) = yk(:,nfk(1)+1:nfk(2));
end
for tr = 1:ntr2
    tmp2 = X2(tr,:)';
    xk = fft(tapers(:,1:K).*tmp2(:,ones(1,K)),nf)';
    Xk2(tr,:,:) = xk(:,nfk(1)+1:nfk(2));
    tmp2 = Y2(tr,:)';
    yk = fft(tapers(:,1:K).*tmp2(:,ones(1,K)),nf)';
    Yk2(tr,:,:) = yk(:,nfk(1)+1:nfk(2));
end
Xk1 = reshape(Xk1,[ntr1*K,diff(nfk)]);
Xk2 = reshape(Xk2,[ntr2*K,diff(nfk)]);
Yk1 = reshape(Yk1,[ntr1*K,diff(nfk)]);
Yk2 = reshape(Yk2,[ntr2*K,diff(nfk)]);

S_X1 = sum(Xk1.*conj(Xk1))./(ntr1*K);
S_X2 = sum(Xk2.*conj(Xk2))./(ntr2*K);
S_Y1 = sum(Yk1.*conj(Yk1))./(ntr1*K);
S_Y2 = sum(Yk2.*conj(Yk2))./(ntr2*K);
C1 = sum(Xk1.*conj(Yk1))./sqrt(S_X1.*S_Y1)./(ntr1*K);  %def'n of coherence
C2 = sum(Xk2.*conj(Yk2))./sqrt(S_X2.*S_Y2)./(ntr2*K);  %def'n of coherence
D = (sum(abs(C1))-sum(abs(C2)))./(nfk(2)-nfk(1));
GX = [Xk1;Xk2]; GY = [Yk1;Yk2]; PD = zeros(1,5e3);
aGX = GX.*conj(GX); aGY = GY.*conj(GY); aGXY = GX.*conj(GY);

parfor iPerm = 1:5000
    NP = randperm((ntr1+ntr2)*K);
    N1 = NP(1:ntr1*K);
    N2 = NP(ntr1*K+1:end);
    PS_X1 = sum(aGX(N1,:))./(ntr1.*K);
    PS_X2 = sum(aGX(N2,:))./(ntr2.*K);
    PS_Y1 = sum(aGY(N1,:))./(ntr1.*K);
    PS_Y2 = sum(aGY(N2,:))./(ntr2.*K);
    Pcoh1 = sum(aGXY(N1,:))./sqrt(PS_X1.*PS_Y1)./(ntr1.*K);
    Pcoh2 = sum(aGXY(N2,:))./sqrt(PS_X2.*PS_Y2)./(ntr2.*K);
    PD(iPerm) = sum(abs(Pcoh1)-abs(Pcoh2))./(nfk(2)-nfk(1));
end
p = length(find(abs(PD)>abs(D)))./5e3;

