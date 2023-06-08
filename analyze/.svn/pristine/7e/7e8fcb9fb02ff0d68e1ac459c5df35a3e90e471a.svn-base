function [observedStateEst] = parpredictKARMA(neuralDataTest,observedStateInitial,model)

NscaleMeans = model.params.observe_mean;
NscaleStds  = model.params.observe_std;
OscaleMeans = model.params.latent_mean;
OscaleStds  = model.params.latent_std;
s           = model.params.m;
r           = model.params.n;
models      = model.params.libsvm_models;

%% KARMA
% setup variables
Ntest=length(neuralDataTest);

xtest = neuralDataTest';
q = size(xtest,1); %dimensionality of neural data

d = length(OscaleMeans); %dimensionality of observed data

%scale inputs
for i = 1:q
    xtest(i,:) = (xtest(i,:)-NscaleMeans(i))/NscaleStds(i);
end
    
%%
observedStateEst = zeros(d,Ntest);

vXhat = repmat(xtest(:,1),s,1);
vYhat = repmat(observedStateInitial,r,1);

vhat = [vXhat;vYhat];
%keyboard
for i = 1:(Ntest) 
    disp(['decoding ' num2str(i) '/' num2str(Ntest)]);
    tic
    parfor j = 1:d
        observedStateEst_tmp(j,1) = svmpredict(0,vhat',models{j});
    end
    observedStateEst(:,i) = observedStateEst_tmp;
    if i<Ntest
        if s>0
            vXhat = [xtest(:,(i+1)); vXhat(1:end-q)]; 
        end
        if r>0
            vYhat = [observedStateEst(:,i); vYhat(1:end-d)];
        end
        vhat = [vXhat;vYhat];
    end
    toc;
end

for i = 1:d
    observedStateEst(i,:) = observedStateEst(i,:)*OscaleStds(i)+OscaleMeans(i);
end
