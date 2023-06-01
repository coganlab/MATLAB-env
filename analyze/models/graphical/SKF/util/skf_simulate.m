function [X,Y,S] = skf_simulate(skf,T)

X = zeros(skf.xdims, T);
Y = zeros(skf.ydims, T);
S = zeros(1,T);


X(:,1) = skf.X_0;
S(1) = 1;

%%%%%%%%%%%%%%%%%%%%%
% GENERATE STATE SEQ
%%%%%%%%%%%%%%%%%%%%%
SIM = 1;
if SIM && skf.nmodels > 1
for t=2:T
    r = rand();
    for j = skf.nmodels-1
	if r < skf.Z(S(t-1),j)
	    S(t) = j;
	end
    end
    if S(t) == 0
	S(t) = skf.nmodels;
    end
end

end


%T1 = 1:250:T;
%S = ones(size(S));
%for t=T1
%    S(t:t+125) = 2;
%end
%%S(1:T-500) = 2;
%%S(T-500:end) = 1;
%
%S(1:T/4) = 1;
%S(T/4:T/2) = 2;
%S(T/2:3*T/4)= 3;
%S(3*T/4:end)=4;
%
if skf.nmodels == 1
    S = ones(1,T);
end

m = skf.model{S(1)};
ynoise = gauss_rnd(skf.ydims,1,m.R);
Y(:,1) = m.H*X(m.ind,1)+ynoise;

for t=2:T
    m = skf.model{S(t)};
    xnoise = gauss_rnd(m.xdims,1,m.Q);
    ynoise = gauss_rnd(m.ydims,1,m.R);
    X(m.ind,t) = m.A*X(m.ind,t-1) + xnoise;
    Y(:,t) = m.H*X(m.ind,t) + ynoise;
    
end





