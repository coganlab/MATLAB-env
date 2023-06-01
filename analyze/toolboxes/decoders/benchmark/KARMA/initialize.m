function state = initialize( params )
% output:
% state - struct containing initial state of the decoder (i.e. mean and covariance for Kalman filter)
% input:
% params - struct containing all the parameters of the model

d = length(params.OscaleMeans);
q = length(params.NscaleMeans);

vXhat = repmat(zeros(q,1),params.s,1);
vYhat = repmat(zeros(d,1),params.r,1);

state = struct('vXhat',vXhat,'vYhat',vYhat);