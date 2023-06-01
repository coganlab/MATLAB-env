function GMM = GMM_train(AParams, rest_features, move_features, SVDParams)
%GMM_TRAIN This function trains a pair of Mixture models from two sets of spectra
%  with NumModes SVD modes and NumComponents mixture components
%  Returns Mixture Model parameters in ModelParams and the SVD mode
%  subspace in SVDParams.  Check whether modes up to MaxMode are
%  informative
%  
% [ModelParams, SVDParams] = TrainTwoMixtureModels(Restspec_Training, Movespec_Training, NumModes, NumComponents, MaxMode)


NORMALIZE_FLAG = 0;

[ModelParams.mu_Rest,ModelParams.Sigma_Rest,ModelParams.pibar_Rest,ModelParams.S_Rest] = mixmodel(rest_features,AParams.comps,NORMALIZE_FLAG);
[ModelParams.mu_Move,ModelParams.Sigma_Move,ModelParams.pibar_Move,ModelParams.S_Move] = mixmodel(move_features,AParams.comps,NORMALIZE_FLAG);

GMM = makemodel(SVDParams,ModelParams);
