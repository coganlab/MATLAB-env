function [params hyperparams] = train( arm_data, neural_data, hyperparams )
% output:
% params - struct containing all the parameters of the model
% input:
% arm_data - double array of arm kinematics (i.e. joint angles) over time
% neural_data - double array of neural data (i.e. threshold crossing counts) over time
% hyperparams - struct of hyperparameters (e.g. slack parameter for KARMA)
% hyperparams must have fields hyperparams.s, hyperparams.r,
% hyperparams.gamma, and hyperparams.C
% s and r are the number of lags to use for neural and arm states
% respectively.
% gamma and C are SVR hyperparameters respectively corresponding to the width of the RBF kernel and the tradeoff
% between the fit/accuracy and weight norm.

if nargin == 2
    hyperparams = struct('s',2,'r',2,'gamma',.001,'C',1);
end
[models, NscaleMeans, NscaleStds, OscaleMeans, OscaleStds,s,r] = fitKARMA(neural_data', arm_data', hyperparams.s,hyperparams.r, hyperparams.gamma, hyperparams.C);

params = struct('models',{models},'NscaleMeans',NscaleMeans,'NscaleStds',NscaleStds,'OscaleMeans',OscaleMeans,'OscaleStds',OscaleStds,'s',s,'r',r);