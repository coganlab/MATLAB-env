function GMM_P = GMM_run(GMM, feats)
%GMM_RUN Compute probability of rest given a GMM and observations
%
%  GMM_P = GMM_run(GMM, feats)
%
% Inputs:
%   GMM = Trained GMM
%   feats = projected neural data (observations)
% Outputs:
%   GMM_P(t) = P(S_t=rest|GMM,O_t)

MP = GMM.ModelParams;
idx = 1;
for pi_r=0:.05:1
    pi_m = 1 - pi_r;
    for t=1:size(feats,1)
	pR_R(t) = prob_mixmodel(feats(t,:), MP.mu_Rest,MP.Sigma_Rest,MP.pibar_Rest);
	pM_R(t) = 1 - pR_R(t);
	pM_M(t) = prob_mixmodel(feats(t,:), MP.mu_Move,MP.Sigma_Move,MP.pibar_Move);
	pR_M(t) = 1 - pM_M(t);
	pR(t) = pR_R(t)*pi_r/(pR_R(t)*pi_r + pM_M(t)*pi_m);
    end
    GMM_P(:,idx) = pR;
    idx = idx + 1;
end

