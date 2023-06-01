function [X,P,Pc] = kf_smooth(skf, j, k, t)

mj = skf.model{j};
mk = skf.model{k};

Xf = mk.A*mj.X(:,t);
Pf = mk.A*mj.P(:,:,t)*mk.A'+mk.Q;
J = mj.P(:,:,t) *mk.A'/Pf;


X = mj.X(:,t) + J*(mk.smooth.X(:,t+1) - Xf);
P = mj.P(:,:,t) + J*(mk.smooth.P(:,:,t+1)-Pf)*J';
if(any(isnan(P(:))))
    dbstack;
    keyboard
end

%if sum(sum(skf.Pcij(:,:,j,k,t+1)))==0
%    dbstack,keyboard
%end
%if sum(sum(mk.smooth.P(:,:,t+1)))==0
%    dbstack,keyboard
%end
%if sum(sum(mk.P(:,:,t+1)))==0
%    dbstack,keyboard
%end
Pc = skf.Pcij(:,:,j,k,t+1)+(mk.smooth.P(:,:,t+1)-mk.P(:,:,t+1))/(mk.P(:,:,t+1))*skf.Pcij(:,:,j,k,t+1);
%Pc = skf.Pcij(:,:,j,k,t+1)+(mk.smooth.P(:,:,t+1)-mk.P(:,:,t+1))*inv(mk.P(:,:,t+1))*skf.Pcij(:,:,j,k,t+1);
