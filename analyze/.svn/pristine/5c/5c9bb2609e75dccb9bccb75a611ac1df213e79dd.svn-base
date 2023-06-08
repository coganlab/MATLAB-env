function [alpha, beta] = HMM_alpha_beta(HMM,b, length_seq, init_state)
%HMM_ALPHA_BETA Compute alpha and beta
% 
% [alpha, beta] = HMM_alpha_beta(HMM, b, length_seq, init_state)
%
% Inputs:
%   HMM = HMM being trained
%   b	= observation probabilities
%   length_seq = length of observation sequence
%   init_state = initial state
% Outputs:
%   alpha(j,t) = P(O_{1...t}, q_t = j) 
%   beta(j,t) = P(O_{t+1..T} | q_t = j)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
% Alpha: Forward Computation (Formula 20)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
alpha(1:HMM.states,1:length_seq) = 0;
alpha(init_state,1) = 1;

% 1) Initialization
alpha = zeros(HMM.states, length_seq);
alpha(:,1) = HMM.pi.*b(:,1)';	

% 2) Induction
for t = 2:length_seq
    normalization_factor = 0;
    for j=1:HMM.states
	alpha(j,t) = sum(alpha(:,t-1).*HMM.a_bar(:,j)) * b(j,t);
	normalization_factor = normalization_factor + alpha(j,t);
    end
    scaling = 1/(normalization_factor + 10^(-200));
    alpha(:,t) = scaling * alpha(:,t);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Beta: Backward Computation (Formula 24-25)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 1) Initialization (24)
beta = zeros(HMM.states, length_seq);
beta(:,length_seq) = 1;
% 2) Induction (25)
for t = length_seq-1:-1:1
    normalization_factor = 0;
    for i = 1:HMM.states
	beta(i,t) = sum(HMM.a_bar(i,:)'.*b(:,t+1).*beta(:,t+1));
	normalization_factor = normalization_factor + beta(i,t);
    end
    scaling = 1/(normalization_factor+10^(-200));
    beta(:,t) = scaling * beta(:,t);
end

