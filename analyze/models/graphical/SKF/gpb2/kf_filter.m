function [X,P,Pc,L] = kf_filter(skf,m1i,m2i,t,y)

m = skf.model{m1i};
m2 = skf.model{m2i};
% Predict forward
if t == 1
    prevx = skf.X_0;
    prevP = skf.P_0;
    Xf = prevx;
    Pf = prevP;
else
    prevx = m.X(:,t-1);
    prevP = m.P(:,:,t-1);
    Xf = m2.A*prevx;
    Pf = m2.A*prevP*m2.A' + m2.Q;
end

e = y - m2.H * Xf;
S = m2.H*Pf*m2.H'+ m2.R;
K = Pf*m2.H'*inv(S);

L = min(max(gauss_pdf(e,0,S),eps), 1-eps);

if not(isreal(L))
    dbstack
    keyboard
end

X = Xf + K*e;
%P = Pf-K*S*K';
P = (eye(m.xdims) - K*m2.H)*Pf*(eye(m.xdims)-K*m2.H)' + K*m2.R*K';
%if m1i == m2i
    %ccheck(P);
%end
%P = (P + P')/2;

Pc = (eye(m.xdims) - K*m2.H)*m2.A*prevP;
