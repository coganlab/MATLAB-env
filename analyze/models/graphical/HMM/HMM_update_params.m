function [new_c_bar, new_a_bar, new_mu_bar, new_U_bar] = HMM_update_params(HMM,gamma,theta, observ_matrix, length_seq)
%HMM_UPDATE_PARAMS Compute updated parameters for HMM
% 
% [new_c_bar, new_a_bar, new_mu_bar, new_U_bar] = HMM_update_params(HMM,gamma,theta, observ_matrix, length_seq)
% 
% Inputs:
%   HMM = HMM structure
%   gamma = mixture component probabilities
%   theta = 
%   observ_matrix = 
%   length_seq = 
% Outputs:
%   new_c_bar = updated mixture coefficients
%   new_a_bar = updated transition matrix
%   new_mu_bar = updated mixture means
%   new_U_bar = updated mixture covariances

    c_denominator = squeeze(sum(sum(gamma,2),3)); % Number of times in state j
    c_denominator_nofinal = squeeze(sum(sum(gamma(:,:,1:length_seq-1),2),3)); % Number of times in state j
    c_numerator = squeeze(sum(gamma,3)); % Number of times in state j with kth component
    new_c_bar = c_numerator./c_denominator(:,ones(1,HMM.feature_vectors));

    %  Formula 40b
    % a Transition Matrix
    gamma_i = squeeze(sum(theta,2));  % Formula 39a
    a_numerator = squeeze(sum(theta,3)); % Formula 39b Expected number of transitions from S_j to S_i
    a_denominator = squeeze(sum(gamma_i,2)); % Expected number of transitions from state i
    new_a_bar = a_numerator ./a_denominator(:,ones(1,HMM.states));


        % mu
    % Formula(53)
    sum_weighted_observations_vect= 0 ;
    new_mu_bar = zeros(HMM.states,HMM.feature_vectors,HMM.L);
    for j= 1: HMM.states
        sum_weighted_observations_vect= 0;
        for k = 1:HMM.feature_vectors
            sum_weighted_observations_vect =0;
            for t=1:length_seq % Time
                sum_weighted_observations_vect = sum_weighted_observations_vect + (gamma(j,k,t)*observ_matrix(t,:));
            end
            new_mu_bar(j,k,:) =sum_weighted_observations_vect/c_numerator(j,k);
        end
    end




     % Covariance Matrix: Decorrelated varialbes = Diagonal
    % Formula (54)
    sum_weighted_observations_matrix= 0 ;
    new_U_bar = zeros(HMM.states,HMM.feature_vectors,HMM.L,HMM.L);

    for j= 1: HMM.states
        sum_weighted_observations_matrix= 0;
        for k = 1:HMM.feature_vectors
            sum_weighted_observations_matrix =0;
            for t=1:length_seq % Time
                sum_weighted_observations_matrix= sum_weighted_observations_matrix + ...
                    gamma(j,k,t)*(((observ_matrix(t,:)-squeeze(HMM.mu_bar(j,k,:))'))'*(observ_matrix(t,:)-squeeze(HMM.mu_bar(j,k,:))'));
            end
            new_U_bar(j,k,:,:) =sum_weighted_observations_matrix/c_numerator(j,k);
            %
        end
    end

