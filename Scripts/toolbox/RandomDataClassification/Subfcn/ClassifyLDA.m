function [DA] = ClassifyLDA(x,y,cross_type,cross_nb,rep)
%--------------------------------------------------------------------------
% This function is used in order to classify samples using the Linear
% Discriminant Analysis (LDA) classifier.
% -> INPUT VARIABLES:
% - x: observations vector
% - y: label vector
% - cross_type: 'k' for a k-fold cross-validation and 'leaveout' for a 
% leave-one-out  
% - cross_nb: number of folds for the k-fold cross-validation
% - rep: number of repetitions in order to increase reliability the result of
% the decoding accuracy
% -> OUTPUT VARIABLES:
% - DA: decoding accuracy

% Example: DA = ClassifyLDA(x,y,'k',10,10) performs a 10 times 10-fold
% cross-validation and return the mean DA, which is the mean of the 10 repetitions
%
% by:
% Etienne Combrisson (1,2) [PhD student] / Contact: etienne.combrisson@inserm.fr 
% Karim Jerbi (1,3) [PhD, Assistant Professor] 
% 1 DYCOG Lab, Lyon Neuroscience Research Center, INSERM U1028, UMR 5292, University Lyon I, Lyon, France
% 2 Center of Research and Innovation in Sport, Mental Processes and Motor Performance, University of Lyon I, Lyon, France
% 3 Psychology Department, University of Montreal, QC, Canada
%
% Version 1.0
% Created: 21/10/2014
% Latest update: - 23/10/14
%
%--------------------------------------------------------------------------

% Variables definition:
rng(4000,'twister'); % for reproducibility
y = grp2idx(y);
NbEpochTot = length(y);
NbClass = length(unique(y));

%% - Cross-validation elements:

if (strcmp(cross_type,'leaveout') == 1)
    cross_nb = 1;
    rep = 1;
end

%% - Create a model of classification:

classfMCR = @(XTRAIN,ytrain,XTEST)(classify(XTEST,XTRAIN,ytrain));

%% - Run classification:

percent = zeros(rep,1);
cfM = zeros(NbClass,NbClass,rep);
for z=1:rep
    % -> Create a stratified cross-validation:
    cp = cvpartition(y,cross_type,cross_nb); 
    NbSubsets = cp.NumTestSets;
    predictedlabel = zeros(NbEpochTot,1);
    AllTestSet = zeros(NbEpochTot,1);
    LastIdx = 0;
    for k=1:NbSubsets
        % -> Index:
        TestSize = cp.TestSize(k);
        trainIdx = cp.training(k);
        testIdx = cp.test(k);
        % -> Training and test sets:
        trainingset = x(trainIdx,:);
        testset = x(testIdx,:);
        % -> Labels:
        traininglabel = y(trainIdx,1);
        testlabel = y(testIdx,1);
        % -> Classification:
        predictedlabelTemp = classfMCR(trainingset,traininglabel,testset);
        predictedlabel(LastIdx+1:LastIdx+TestSize,1) = predictedlabelTemp;
        AllTestSet(LastIdx+1:LastIdx+TestSize,1) = testlabel;
        LastIdx = sum(cp.TestSize(1:k));
    end
    percent(z,1) = 100*sum(double(AllTestSet == predictedlabel))/NbEpochTot;
    cfM(:,:,z) = confusionmat(AllTestSet,predictedlabel);
end
% Get Mean decoding accuracy of the "rep" repetition:
DA = mean(percent,1);
% Dev = std(percent);