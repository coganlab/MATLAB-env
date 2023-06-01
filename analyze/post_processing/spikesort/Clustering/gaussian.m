function gauss_value = gaussian(mu,cov,x_n,dim)

gauss_value=1/((2*pi)^(dim/2)*sqrt(det(cov)))...
   *exp(-0.5*(x_n-mu)'*inv(cov)*(x_n-mu));
