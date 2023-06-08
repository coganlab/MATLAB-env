function [mu,Sigma,pibar,Scaling] = mixmodel(data,N_components,flag)

% flag = 1; % Normalization of the covariance matrix and scaling of the data

[centers clustered_data Sigmabar scaling_vals] = findkmeans(data,N_components,25,flag); % 25 iterations
pibar_init = (1/N_components)*ones(1,N_components);
[mu, Sigma, pibar,Scaling] = EM_MixModel(data,centers,Sigmabar,pibar_init,scaling_vals,flag);

return


