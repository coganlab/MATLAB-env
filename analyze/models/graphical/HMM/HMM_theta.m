function theta = HMM_theta(num_hidd_states, length_seq, alpha, beta, a, b)
%HMM_THETA Compute theta for HMM
% 
% theta = HMM_theta(num_hidd_states, length_seq, alpha, beta, a, b)
%
% Inputs:
%   num_hidd_states = number of hidden states in HMM
%   length_seq = length of observation sequence
%   alpha = forward probabilities
%   beta = backward probabilities
%   a = transition probabilities
%   b = observation probabilities
%
% Outputs:
%   theta(i,j,t) = Probabilitiy of being in state S_i at time t and state 
%		   S_j at time t+1 given the model and observation sequence

theta_numerator = [];
for t = 1:length_seq-1
	for i = 1:num_hidd_states % Hidden State at time t
	    for j = 1:num_hidd_states % Hidden State at time t+1
		theta_numerator(i,j,t)=alpha(i,t)*a(i,j)*b(j,t+1)*beta(j,t+1);
	    end
	end
    end

theta_denominator = squeeze(sum(sum(theta_numerator,1),2))';
theta = theta_numerator./reshape(repmat(theta_denominator,[size(theta_numerator,1).*size(theta_numerator,2),1]),...
    [size(theta_numerator,1),size(theta_numerator,2),size(theta_numerator,3)]);
