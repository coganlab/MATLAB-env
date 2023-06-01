function [HMM HIP]= HMM_train(AParams,feats,GMM)
%HMM_TRAIN Train HMM using initial estimates from GMM
% 
% [HMM HIP] = HMM_TRAIN(FEATS,GMM)
%
% Inputs:	FEATS = Observations
%		GMM = Trained GMM for initial estimates of parameters
%
% Outputs:	HMM = Trained HMM
%		(HIP) = Intermediate gamma values


%%%%%%%%%%%%%%%%%
% INITIALIZE HMMM 
%%%%%%%%%%%%%%%%%
MAX_ITER = 3;

HMM.L = AParams.modes;
HMM.states = 2;
HMM.feature_vectors = AParams.comps;

testHMM.mu = zeros(HMM.states,HMM.feature_vectors,HMM.L);
testHMM.mu(1,:,:) = GMM.ModelParams.mu_Rest;
testHMM.mu(2,:,:) = GMM.ModelParams.mu_Move;

U = zeros(HMM.states, HMM.feature_vectors, HMM.L, HMM.L);
U(1,:,:,:) = GMM.HMMParams.Sigma_Rest;
U(2,:,:,:) = GMM.HMMParams.Sigma_Move;

testHMM.U = U;

testHMM.L = HMM.L;
testHMM.pi = ones(1,HMM.states)/HMM.states;
testHMM.states = 2;
testHMM.feature_vectors = HMM.feature_vectors;

HMM.pi = testHMM.pi;

HIP = [];



%%%%%%%%%%%%%%%%%%
% COMPUTE FEATURES
%%%%%%%%%%%%%%%%%%
state_seq = feats.state_seq;
observ_matrix = feats.feats;
length_seq = length(observ_matrix);
init_state = state_seq(1); 



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% COMPUTE INITIAL ESTIMATES FOR HMM PARAMETERS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[HMM.c_bar HMM.a_bar HMM.mu_bar HMM.U_bar] = HMM_init_est(HMM.L,HMM.states, HMM.feature_vectors, observ_matrix, testHMM.mu, testHMM.U);

HMM.c_bar = [GMM.ModelParams.pibar_Rest; GMM.ModelParams.pibar_Move];



orig_c_bar = HMM.c_bar;
orig_a_bar = HMM.a_bar;
orig_mu_bar = HMM.mu_bar;
orig_U_bar = HMM.U_bar;

%%%%%%%%%%%%%%
% TRAIN HMM
%%%%%%%%%%%%%%
for iter = 1:MAX_ITER
    tic;fprintf('***Iteration %d/%d***\n', iter, MAX_ITER);

    % Compute probabilities (E step)
    b = HMM_b(HMM, observ_matrix);
    [alpha,beta] = HMM_alpha_beta(HMM,b,length_seq, init_state);
    gamma = HMM_gamma(HMM,alpha,beta,observ_matrix);
    theta = HMM_theta(HMM.states, length_seq, alpha, beta, HMM.a_bar, b); 

    % Update model parameters (M step)
    [c_bar, a_bar, mu_bar, U_bar] =  HMM_update_params(HMM,gamma,theta,observ_matrix,length_seq);
    HMM.c_bar = c_bar;
    HMM.a_bar = a_bar;
    HMM.mu_bar = mu_bar;
    HMM.U_bar = U_bar;
    fprintf('Completed in %f seconds\n', toc);
    FOO = squeeze(sum(gamma,2));
    HIP(:,iter) = FOO(1,:);
    
end

HMM.pi = testHMM.pi;
