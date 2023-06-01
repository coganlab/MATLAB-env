function [c_bar a_bar mu_bar U_bar] = HMM_init_est(L, num_hidd_states, num_feature_vectors, observ_matrix, mu, U)
%HMM_INIT_EST Compute initial estimates for HMM
% 
% [c_bar a_bar mu_bar U_bar] = HMM_init_est(L, num_hidd_states, num_feature_vectors, observ_matrix, mu, U)
%
% Inputs:
%   L = dimensions of feature vectors
%   num_hidd_states = number of hidden states in HMM
%   num_feature_vectors = number of feature vectors
%   observ_matrix = observations
%   mu = initial mean estimate
%   U = initial covariance estimate
% Outputs:
%   c_bar = mixture coefficients
%   a_bar = transition matrix
%   mu_bar = mixture means
%   U_bar = mixture covariances


% Each row of c represents coefficients to mixture components
% Uniform distribution of each row
%c_prob = 1/size(c,2);
c_bar = 1/num_feature_vectors .* ones(num_hidd_states, num_feature_vectors);

%a_bar = ones(num_hidd_states, num_hidd_states)/num_hidd_states;
% it's not uniform...lets give it a push in the right direction
a_bar = [0.95 0.05 ;0.05 0.95];

%mu_noise = repmat(randn(num_hidd_states,num_feature_vectors), [1 1 L]);
%grand_av_mu(1,:,:) = mean(observ_matrix,1);
%grand_av_mu = repmat(grand_av_mu, [L L 1]);
%mu_bar = (1 + 0.1.*mu_noise).*mu;
mu_bar = mu;
%mu_bar = (1 + 0.01.*mu_noise).*grand_av_mu;

U_noise = repmat(randn(num_hidd_states, num_feature_vectors), [1 1 L L]);
%grand_av_U(1,1,:,:) = cov(observ_matrix, 1);
%grand_av_U = repmat(grand_av_U, [num_hidd_states num_feature_vectors 1 1]);
%U_bar = (1 + 0.1.*U_noise).*U;
U_bar = U;
%U_bar = (1+ 0.01.*U_noise).*grand_av_U;
%U_bar = U_noise;

%mu_bar = randn(size(mu));
%U_bar = randn(size(U));
