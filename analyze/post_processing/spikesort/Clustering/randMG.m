function [Xo, fr] = randMG(N,pis,mu,Sigma)

 Xo =[];

 [D,L] = size(mu);
 fr_i = zeros(1,L);
 
 for a=1:L

  Xo = [Xo randvec(round(pis(a)*N),mu(:,a),Sigma(:,:,a))];
  fr(a) = round(pis(a)*N);
 end

%X1=Xo(:,1:N);