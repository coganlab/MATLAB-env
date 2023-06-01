function [model] = parfitKARMA(neuralData, observedState, Neural_lag, Joint_lag, gamma, C, Shrinking)
% Fits a KARMA model of sort implemented in:
% "Kernel-ARMA for Hand Tracking and Brain-Machine Interfacing During 3D
% Motor Control" by Lavi Shpigelman et al.
% neural_lag is how many lagged neural states to fit
% joint_lag is how many lagged observed states to fit.
% Data is scaled to be mean variance normalized - this is undone when
% predictions are made.

if nargin < 3
    Neural_lag = 2;
    Joint_lag = 2;
end
if nargin < 5
    gamma = .001;
    C = 0.1;
end
% KARMA
% setup variables
Ntrain=length(observedState);

Neural_train = neuralData';
Neural_dim = size(Neural_train,1);

Joint_train = observedState';
Joint_dim = size(Joint_train,1);

%scale inputs
NscaleMeans = mean(Neural_train,2);
NscaleStds = std(Neural_train,0,2);
OscaleMeans = mean(Joint_train,2);
OscaleStds = std(Joint_train,0,2);
for i = 1:Neural_dim
    Neural_train(i,:) = (Neural_train(i,:)-NscaleMeans(i))/NscaleStds(i);
end
for i = 1:Joint_dim
    Joint_train(i,:) = (Joint_train(i,:)-OscaleMeans(i))/OscaleStds(i);
end
    
%each column of this is an input vector
vNeural_train = zeros(Neural_lag*Neural_dim,Ntrain);
vJoint_train = zeros(Joint_lag*Joint_dim,Ntrain);

%set up lag vectors
for i = 1:Neural_lag
    vNeural_train((i*Neural_dim-Neural_dim+1):(i*Neural_dim),:) = [zeros(Neural_dim,(i-1)) Neural_train(:,1:(end+1-i))];
end     
for i = 1:Joint_lag
    vJoint_train((i*Joint_dim-Joint_dim+1):(i*Joint_dim),:) = [zeros(Joint_dim,i) Joint_train(:,1:(end-i))];
end

vtrain = [vNeural_train; vJoint_train];

%% fit KARMA
tic
for i = 1:size(Joint_train,1)
    models{i} = svmtrain(Joint_train(i,1:end)', vtrain(:,1:end)',['-s 3 -t 2 -h ' num2str(Shrinking) ' -g ' num2str(gamma) ' -p .1 -c ' num2str(C)]);
end
toc

% wts = model1.sv_coef'*model1.SVs;
% figure;plot(wts,'.')

model.params.n             = Joint_lag;
model.params.N             = Joint_dim;
model.params.m             = Neural_lag;
model.params.M             = Neural_dim;
model.params.latent_mean   = OscaleMeans;
model.params.latent_std    = OscaleStds;
model.params.observe_mean  = NscaleMeans;
model.params.observe_std   = NscaleStds;
model.params.libsvm_models = models;
model.hyperparams.m        = model.params.m;
model.hyperparams.n        = model.params.n;

