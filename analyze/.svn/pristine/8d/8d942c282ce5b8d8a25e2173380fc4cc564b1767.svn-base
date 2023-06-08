function [state prediction] = decode( state, params, neural_data )
% output:
% state - struct containing the updated state after one time step, passed to "decode" again at next time step
% prediction - double array containing the decoded joint angles for that time step
% input:
% state - struct containing current state of the decoder (e.g. mean and covariance for Kalman filter)
% params - struct containing all the parameters of the model
% neural_data - double array containing neural data for that time step (i.e. count of threshold crossings for each electrode)
% note: neural_data is 1 timestep by number of channels (i.e. a row vector)

%% KARMA
% setup variables
xtest = neural_data;
q = size(xtest,1); %dimensionality of neural data

d = length(params.OscaleMeans); %dimensionality of observed data

%scale neural inputs to be mean and variance normalized
% for i = 1:q
%     xtest(i) = (xtest(i)-params.NscaleMeans(i))/params.NscaleStds(i);
% end
xtest = (xtest-params.NscaleMeans)./params.NscaleStds;
    
%%
prediction = zeros(d,1);

if params.s>0
    state.vXhat = [state.vXhat(q+1:end); xtest]; 
end

vhat = [state.vXhat;state.vYhat];

for j = 1:d
    prediction(j) = svmpredict(0,vhat',params.models{j});
end

if params.r>0
    state.vYhat = [state.vYhat(d+1:end); prediction];
end

% for i = 1:d
%     prediction(i) = prediction(i)*params.OscaleStds(i)+params.OscaleMeans(i);
% end
prediction = prediction.*params.OscaleStds+params.OscaleMeans;
