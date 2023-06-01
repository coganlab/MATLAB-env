function gamma = HMM_gamma(HMM, alpha, beta, observ_matrix)
%HMM_GAMMA Compute gamma values for an HMM
%
% gamma = HMM_gamma(HMM, alpha, beta, observ_matrix)
%
% Inputs:
%   HMM = HMM structure
%   alpha = forward probablities
%   beta = backward probabilities
%   observ_matrix = observations
% Outputs:
%   gamma(j,k,t) = probability of being in state j at time t with the 
%		   kth mixture component accouting for O_t


length_seq = size(observ_matrix,1);
gamma = zeros(HMM.states, HMM.feature_vectors, length_seq);
sum_b_over_mix_comp = 0;
sum_alpha_beta = squeeze(sum(alpha.*beta,1)); % Collapsing across rows or hidden states j
for t = 1: length_seq % Time
	current_vis_state = observ_matrix(t,:);
	for j= 1: HMM.states
	    for k = 1:HMM.feature_vectors
		gamma(j,k,t) = alpha(j,t)*beta(j,t) * HMM.c_bar(j,k).*((1/(((2*pi)^(HMM.L/2))*(det(squeeze(HMM.U_bar(j,k,:,:))))^(1/2)))*...
		exp(-0.5*(current_vis_state-squeeze(HMM.mu_bar(j,k,:))')...
		*pinv(squeeze(HMM.U_bar(j,k,:,:)))*(current_vis_state-squeeze(HMM.mu_bar(j,k,:))')'));

		sum_b_over_mix_comp = sum_b_over_mix_comp + HMM.c_bar(j,k)*((1/(((2*pi)^(HMM.L/2))*(det(squeeze(HMM.U_bar(j,k,:,:))))^(1/2)))*...
		exp(-0.5*(current_vis_state-squeeze(HMM.mu_bar(j,k,:))')...
		*pinv(squeeze(HMM.U_bar(j,k,:,:)))*(current_vis_state-squeeze(HMM.mu_bar(j,k,:))')'));
		if(any(isnan(gamma(:))))
		    disp('uh oh');
		    keyboard
		end

	    end
	    denom = sum_b_over_mix_comp * sum_alpha_beta(t);
	    denom = denom + (denom == 0);
	    gamma(j,1:HMM.feature_vectors,t) = gamma(j,1:HMM.feature_vectors,t)/denom;
	    sum_b_over_mix_comp = 0; % Reset
	end
	sum_b_over_mix_comp = 0; % Reset
    end
