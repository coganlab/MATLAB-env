function L = gpb2_lhood(skf, Y)
%GPB2_LHOOD Likelihood of SKF given observations Y

%TODO: vectorize

T = size(Y,2);

L = zeros(1,5);

for i=1:skf.nmodels
mt = skf.model{i};
x = skf.smooth.X;

for t=1:T
    L(1) = L(1) + skf.M(i,t)*( (Y(:,t)-mt.H*x(:,t))'*pinv(mt.R)*(Y(:,t)-mt.H*x(:,t)));
    L(2) = L(2) + skf.M(i,t)*log(det(mt.R));
end
for t=2:T


    L(3) = L(3) + skf.M(i,t)*((skf.smooth.X(:,t)-mt.A*skf.smooth.X(:,t-1))'*pinv(mt.Q)*(skf.smooth.X(:,t)-mt.A*skf.smooth.X(:,t-1)));
    L(4) = L(4) + skf.M(i,t)*log(det(mt.Q));
    for f=1:skf.nmodels
	L(5) = L(5)+skf.Mt(f,i,t)*skf.Z(f,i);
    end
end
end
%keyboard
%disp(L);
L(1:4) = -1/2*L(1:4);
%L = -1/2*L(1)-1/2*L(2);
%disp(L);
L = sum(L);

%L = -1/2*L(1)-1/2*L(2)-1/2*L(3)+1/2*L(4);

