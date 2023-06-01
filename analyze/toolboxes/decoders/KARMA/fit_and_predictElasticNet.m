function [model, pred] = fit_and_predictElasticNet(NeuralTrain, JointTrain, NeuralTest, neural_lag, observed_lag, alpha, lambda, Neural_RBF_sigma, Joint_RBF_sigma, RBF_alpha)
%
% file overview
%load data - MUST DO THIS FIRST
%create kernel matrix (Gramian)
%use elasticnet regression on the kernel matrix
%predict with it
%compare it to KARMA (on same data)

%% Setup variables and compute kernel matrix
%tt = 2500; %specify here the timesbins for training data (tt:end) will be used for testing
neuralData = NeuralTrain;
observedState = JointTrain;
s = neural_lag;
r = observed_lag;
if nargin < 8
	Neural_RBF_sigma = 0.001;
end
if nargin < 9
	Joint_RBF_sigma = 0.1;
end
if nargin < 10 
	RBF_alpha = 0.5; 
end

rbfScale = [Neural_RBF_sigma Joint_RBF_sigma RBF_alpha]; %sigmas of neural and observed and mixing coefficient

Ntrain=length(observedState);

xtrain = neuralData';
q = size(xtrain,1);

Ytrain = observedState';
d = size(Ytrain,1);

%scale inputs
NscaleMeans = mean(xtrain,2);
NscaleStds = std(xtrain,0,2);
OscaleMeans = mean(Ytrain,2);
OscaleStds = std(Ytrain,0,2);
for i = 1:q
    xtrain(i,:) = (xtrain(i,:)-NscaleMeans(i))/NscaleStds(i);
end
for i = 1:d
    Ytrain(i,:) = (Ytrain(i,:)-OscaleMeans(i))/OscaleStds(i);
end
    
%each column of this is an input vector
vXtrain = zeros(s*q,Ntrain);
vYtrain = zeros(r*d,Ntrain);

%set up lag vectors
for i = 1:s
    vXtrain((i*q-q+1):(i*q),:) = [zeros(q,(i-1)) xtrain(:,1:(end+1-i))];
end     
for i = 1:r
    vYtrain((i*d-d+1):(i*d),:) = [zeros(d,i) Ytrain(:,1:(end-i))];
end

% compute kernel
nInstances = length(vXtrain(1,:));
vXtrain = [ones(nInstances,1) vXtrain'];
vYtrain = [ones(nInstances,1) vYtrain'];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CREATE KERNEL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
Krbf = customKernel2(vXtrain,vXtrain,vYtrain,vYtrain,rbfScale(1),rbfScale(2), rbfScale(3));
toc

%% Use kernel with elastic net regression (via glmnet)
tic
if nargin < 7
	lambda = 1e-2;
end
if nargin < 6
	alpha = 0.2;
end
options = glmnetSet;
options.alpha = alpha;
options.lambda = lambda;
weights = cell(1,d);
parfor i = 1:size(Ytrain,1)
    tic
    fit1=glmnet(Krbf,Ytrain(i,1:end)','gaussian',options);
    toc
    weights{i} = glmnetCoef(fit1);
end

%% prepare to predict on second half of data
neuralDataTest = NeuralTest;
observedStateInitial = OscaleMeans;

% setup variables
Ntest=length(neuralDataTest);

xtest = neuralDataTest';
q = size(xtest,1); %dimensionality of neural data


%scale inputs
for i = 1:q
    xtest(i,:) = (xtest(i,:)-NscaleMeans(i))/NscaleStds(i);
end
    
%% predict Elastnet
observedStateEst2 = zeros(d,Ntest);

vXhat = repmat(xtest(:,1),s,1);
vYhat = repmat(observedStateInitial,r,1);

% vhat = [vXhat;vYhat];
for i = 1:(Ntest) 
    %tic
    thisVector = customKernel2([1 vXhat'],vXtrain, [1 vYhat'],vYtrain, rbfScale(1),rbfScale(2), rbfScale(3));
    for j = 1:d
        observedStateEst2(j,i) = weights{j}(1) + thisVector*weights{j}(2:end);
    end
    if i<Ntest
        if s>0
            vXhat = [xtest(:,(i+1)); vXhat(1:end-q)]; 
        end
        if r>0
            vYhat = [observedStateEst2(:,i); vYhat(1:end-d)];
        end
%         vhat = [vXhat;vYhat];
    end
   % toc
end

for i = 1:d
    observedStateEst2(i,:) = observedStateEst2(i,:)*OscaleStds(i)+OscaleMeans(i);
end

model = weights;
pred = observedStateEst2;

%% Get correlation coefficients on testing data 
%ccso = zeros(1,size(jointPos,2));
%for i = 1:size(jointPos,2)
%    figure;plot(jointPos((tt+1):end,i));hold on;plot(observedStateEst2(i,:),'r');hold off
%    a = corrcoef(jointPos((tt+1):end,i),observedStateEst2(i,:));
%    ccso(i) = a(2);
%    title(['(on training) cc: ' num2str(a(2))])
%     pause
%end

%correlation coefficients on selected joint angles from 120114/012:
%0.8427    0.7293    0.5042    0.7208    0.7862    0.5881    0.3979

