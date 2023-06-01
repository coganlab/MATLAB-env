function [model] = fitKARMA(neuralData, observedState, s, r, epsilon, C)
% Fits a KARMA model of sort implemented in:
% "Kernel-ARMA for Hand Tracking and Brain-Machine Interfacing During 3D
% Motor Control" by Lavi Shpigelman et al.
% s is how many lagged neural states to fit
% r is how many lagged observed states to fit.
% Data is scaled to be mean variance normalized - this is undone when
% predictions are made.

if nargin<3
    s = 2;
    r = 2;
end
if nargin<5
    epsilon = .001;
    C = 1;
end
%% KARMA
% setup variables
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

vtrain = [vXtrain;vYtrain];

%% fit KARMA
for i = 1:size(Ytrain,1)
    tic;models{i} = svmtrain(Ytrain(i,1:end)',vtrain(:,1:end)',['-s 3 -t 2 -h 0 -p ' num2str(epsilon) ' -c ' num2str(C)]);toc % -s was set to 3, should be setting epsilon (p)! by Rabadi 12/12/2014. 
end
% wts = model1.sv_coef'*model1.SVs;
% figure;plot(wts,'.')

model.params.n             = r;
model.params.N             = d;
model.params.m             = s;
model.params.M             = q;
model.params.latent_mean   = OscaleMeans;
model.params.latent_std    = OscaleStds;
model.params.observe_mean  = NscaleMeans;
model.params.observe_std   = NscaleStds;
model.params.libsvm_models = models;
model.hyperparams.m        = model.params.m;
model.hyperparams.n        = model.params.n;


