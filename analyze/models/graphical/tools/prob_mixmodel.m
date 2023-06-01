function [p,p_j] = prob_mixmodel(data,mu,sigma,pibar)
%  PROB_MIXMODEL calculates the probability of a sample for a given mixture
%  model
%
%  [prob,p_weightedcomponents] =
%    prob_mixmodel(data,mu,Sigma,pibar)
%
%  Inputs:
%
%  Outputs:
%



Dim = size(data,2);
K = length(pibar);

p_j = zeros(1,K);
for j = 1:K  % Number of mixture components
    x = (data - mu(j,:))';
    A = (2*pi)^(-Dim/2);
    dum = (sigma(:,:,j));
    B = 1./(det(dum)^0.5);
    C = pinv(dum);
    % p weighted with pi_bar
    p_j(j) = A*B*exp(-0.5*(x'*C*x))*pibar(j);
end
p = sum(p_j);
