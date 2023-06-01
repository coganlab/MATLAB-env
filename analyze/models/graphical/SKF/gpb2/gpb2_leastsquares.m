function skf = skf_leastsquares(skf,Y,X,T,S)
seg = segment(S,25);
% Compute Z
%
skf.Z(1,2) = sum(diff(S)==1);
skf.Z(2,1) = sum(diff(S)==-1);
skf.Z(1,1) = sum([diff(S) 0]==0 & S == 1);
skf.Z(2,2) = sum([diff(S) 0]==0 & S == 2);
skf.Z(1,:) = skf.Z(1,:)/sum(skf.Z(1,:));
skf.Z(2,:) = skf.Z(2,:)/sum(skf.Z(2,:));

for m=1:skf.nmodels
    skf.model{m}.A = 0;
    skf.model{m}.Q = 0;
    skf.model{m}.R = 0;
    skf.model{m}.H = 0;

    nsegs = length(seg{m});
    Xs = [];
    Z = [];
    X1 = [];
    X2 = [];
    for s=1:nsegs
	Xt  = X(:,seg{m}{s});
	Zt = Y(:,seg{m}{s});
	X1t = Xt(:,1:end-1);
	X2t = Xt(:,2:end);

	Xs = [Xs Xt];
	Z = [Z Zt];
	X1 =[X1 X1t];
	X2 = [X2 X2t];
    end
	M = size(Xs,2);
%	X1 = Xs(:,1:end-1);
%	X2 = Xs(:,2:end);
	A = X2*X1'*pinv(X1*X1');
	H = Z*Xs'*pinv(Xs*Xs');
	Q =(X2-A*X1)*(X2-A*X1)'/(M-1);
	R = (Z-H*Xs)*(Z-H*Xs)'/M;
	%keyboard
	%skf.model{m}.A = skf.model{m}.A + A;
	%skf.model{m}.H = skf.model{m}.H + H;
%	skf.model{m}.Q = skf.model{m}.Q + Q; %keyboard
    %end
    skf.model{m}.A = A;
    skf.model{m}.Q = Q;
    skf.model{m}.R = R;
    skf.model{m}.H = H;


end

end

function fseg = segment(S, minL)
dS = diff(S);
dseg{1} = find(dS == -1);
dseg{2} = find(dS == 1);

segs = min(length(dseg{1}),length(dseg{2}));

sidx = S(1);
off = 0;
seg = {};
if sidx == 1
    seg{2}{1} = dseg{2}(1):dseg{1}(1);
    dseg{2} = dseg{2}(2:end);
    off = 1;
end

for s=1:segs
    try
    seg{1}{s+off} = dseg{1}(s):dseg{2}(s);
    seg{2}{s+off} = dseg{2}(s):dseg{1}(s+1);
    catch
	;
    end

end


s1i = 1;
s2i = 1;
fseg = {};
for s=1:segs
    if length(seg{1}{s}) > minL
	fseg{1}{s1i} = seg{1}{s};
	s1i = s1i+1;
    end
    if length(seg{2}{s}) > minL
	fseg{2}{s2i} = seg{2}{s};
	s2i = s2i+1;
    end

end

end
