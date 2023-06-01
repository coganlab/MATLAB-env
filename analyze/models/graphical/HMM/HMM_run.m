function [HMM_P, HMM_SP] = HMM_run(HMM,observ_matrix)
%HMM_RUN Run the HMM on a set of observations
% 
% [HMM_P, HMM_SP] = HMM_run(HMM,observ_matrix,state_seq)
% 
% Inputs:
%   HMM = HMM structure
%   observ_matrix = observation matrix
%   state_seq = true state sequence
% Outputs:
%   HMM_P(t) = probability of rest model at time t given 1:t
%   HMM_SP(t) = probability of rest model at time t given 1:T

length_seq = size(observ_matrix,1);
init_state = 1; %assumes initially start in first state
init_matrix = observ_matrix(1,:);
b = HMM_b(HMM, observ_matrix);
[alpha,beta] = HMM_alpha_beta(HMM,b,length_seq, init_state);
gamma = HMM_gamma(HMM,alpha,beta,observ_matrix);
Q = squeeze(sum(gamma,2));
HMM_SP = Q(1,:);
HMM_P = alpha(1,:)./(alpha(1,:)+alpha(2,:));
