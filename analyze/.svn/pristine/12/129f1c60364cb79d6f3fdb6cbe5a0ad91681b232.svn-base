function SVDParams = TrainTwoMixtureModels(Restspec_Training, Movespec_Training, NumModes, NumComponents, MaxMode)
%TRAINTWOMIXTUREMODELS This function trains a pair of Mixture models from two sets of spectra
%  with NumModes SVD modes and NumComponents mixture components
%  Returns Mixture Model parameters in ModelParams and the SVD mode
%  subspace in SVDParams.  Check whether modes up to MaxMode are
%  informative
%  
% [ModelParams, SVDParams] = TrainTwoMixtureModels(Restspec_Training, Movespec_Training, NumModes, NumComponents, MaxMode)
%


NORMALIZE_FLAG = 0;

RestMovespec_Training = log([Restspec_Training;Movespec_Training]); % Always Take log of spectra
%keyboard
Num_TrainingTrials = floor(size(RestMovespec_Training,1)/2); 

MAX_SV = 20;

% SVD of the Training Set
%%%%%%%%%%%%%%%%%%%%%%%%%
[U_comb S_comb V_comb] = svds(RestMovespec_Training,MAX_SV);
%[U_comb S_comb V_comb] = svd(RestMovespec_Training);
SVDParams.U = U_comb;
SVDParams.S = S_comb;
SVDParams.V = V_comb;
%keyboard

% Normalizing U_comb for both Rest & Move together
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
SVDParams.Norm_factor = std(SVDParams.U);
for iMode = 1:size(SVDParams.U,2)
    SVDParams.NormU(:,iMode) = (SVDParams.U(:,iMode)-mean(SVDParams.U(:,iMode)))/SVDParams.Norm_factor(iMode);
end

p_class = zeros(1,MaxMode);
for iMode = 1:MaxMode
    p_class(iMode) = myroc(SVDParams.NormU(1:Num_TrainingTrials,iMode)',SVDParams.NormU(Num_TrainingTrials+1:end,iMode)');
end
SVDParams.p_class = p_class;
%keyboard

% Sorting p_class
%%%%%%%%%%%%%%%%%
class_threshold = 0.50;
ind_full = find(p_class > class_threshold);
p_class_nonsorted = p_class(ind_full);
[p_class_sorted index_p] = sort(p_class_nonsorted);
ind_full_flipped = ind_full(index_p);
ind_full = fliplr(ind_full_flipped);
SVDParams.ModeInd = ind_full(1:NumModes);
