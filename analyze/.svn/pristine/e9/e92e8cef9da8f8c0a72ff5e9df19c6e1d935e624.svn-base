function Model = makemodel(SVDParams, ModelParams)
%MAKEMODEL Create a GMM structure with the specified SVDParams and ModelParams
%  Model = makemodel(SVDParams, ModelParams)
% 
% Inputs:
%   SVDParams
%   ModelParams
% Output:
%   Model

Model = [];
Model.SVDParams = SVDParams;

% Sigma in ModelParams is (:,:,state)
% HMM requires Sigma in (state,:,:) form
old_sigma_rest = ModelParams.Sigma_Rest;
old_sigma_move = ModelParams.Sigma_Move;
HMM.Sigma_Rest = zeros(size(old_sigma_rest,3),size(old_sigma_rest,1),size(old_sigma_rest,2));
HMM.Sigma_Move = HMM.Sigma_Rest;
for i=1:size(old_sigma_rest,3)
    HMM.Sigma_Rest(i,:,:) = old_sigma_rest(:,:,i);
    HMM.Sigma_Move(i,:,:) = old_sigma_move(:,:,i);
end
Model.ModelParams = ModelParams;
Model.HMMParams = HMM;
Model.NumModes = 3;
Model.tapers_time = 0.3;
Model.Fs = 1e3;
Model.maxfreq = 250;
Model.winwidth = 300;
