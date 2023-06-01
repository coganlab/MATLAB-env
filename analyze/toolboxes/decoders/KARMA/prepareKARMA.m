% PREPAREKARMA   Generate a KARMA training set from raw data.
%  Mean centers and scales X and Y, and creates lag-stacked training
%  vectors from matrices or cell arrays of matrices for use with support
%  vector regression.
%
%  X is MxN with M observations and N features  (neural data)
%  Y is MxN with M observations and N output variables (joint angles)
%  s is how many neural lags to include
%  r is how many joint lags to include
%
%  X and Y may be cell arrays, but N must be equal in all cells.
%  max(s,r) is deleted from the start of the training set in order
%  to not include any examples with no data for all lags.
%
% Output is a structure with the following fields:
%
% karma.X is MxN with M examples and N training features
% karma.Y is MxN with M values and N output variables
% karma.NscaleMeans is 1xN with N means for scaling X
% karma.NscaleStds is 1xN with N stds for scaling X
% karma.OscaleMeans is 1xN with N means for scaling Y
% karma.OscaleStds is 1xN with N means for scaling Y
%
% Example:
% karma = prepareKARMA(neuralData, observedState, 10, 10)
% 
% for i = 1:size(karma.Y,2)
%    models{i} = svmtrain(karma.Y(:,i)', karma.X,...
% end
% 
% Caution: Do not change the format of the structure this command returns, 
% the real-time C decoder depends on it.
%
function karma = prepareKARMA(neuralData, observedState, s,r, skipScale)
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
    skipScale = 0;
end

% allow single matrix inputs
if ~iscell(neuralData)
    neuralData = {neuralData};
end

if ~iscell(observedState)
    observedState = {observedState};
end

% verify dims
if range(cellfun(@(x)(size(x,2)),neuralData)) ~= 0
    error('input neural dimensions must agree for all input cells');
end

% verify dims
if range(cellfun(@(x)(size(x,2)),observedState)) ~= 0
    error('input observedState dimensions must agree for all input cells');
end

start = max(s,r) + 1;
Ntrain = sum(cellfun(@(x)(length(x) - start + 1), neuralData));
Ntrain = max(0, Ntrain);
q = size(neuralData{1},2);
d = size(observedState{1},2);

fprintf('\nKARMA\n');
fprintf('  %d neural lags\n', s);
fprintf('  %d joint lags\n', r);
fprintf('  %d groups\n', length(neuralData));
fprintf('  %d start lags deleted per group\n', start - 1);
fprintf('  %d total training examples\n\n', Ntrain);


%
% calculate means and stds
NscaleMeans = mean(vertcat(neuralData{:}));
NscaleStds = std(vertcat(neuralData{:}));
OscaleMeans = mean(vertcat(observedState{:}));
OscaleStds = std(vertcat(observedState{:}));

%
% mean center and scale
function scaled=scaleData(A, means, stds)
    if (skipScale)
        scaled = A;
        return;
    end
    centered = bsxfun(@minus, A, means);
    scaled = bsxfun(@rdivide, centered, stds);
end

neuralDataScaled = cellfun(@(x)(scaleData(x,NscaleMeans, NscaleStds)),...
                           neuralData, 'uni', 0);

observedStateScaled = cellfun(@(x)(scaleData(x,OscaleMeans, OscaleStds)),...
                           observedState, 'uni', 0);
      
function k=karmafy(neural, observed, s, r, q, d, start)
    Nelem = size(neural,1);
    vXtrain = zeros(Nelem, s*q);
    vYtrain = zeros(Nelem, r*d);

    for i = 1:s
        vXtrain(:,(i*q-q+1):(i*q)) = [zeros((i-1),q); neural(1:(end+1-i),:)];
    end     
    for i = 1:r
        vYtrain(:,(i*d-d+1):(i*d)) = [zeros(i,d); observed(1:(end-i),:)];
    end
    k = [vXtrain(start:end, :) vYtrain(start:end, :)];
end

vtrain = cellfun(@(x,y)(karmafy(x, y, s, r, q, d, start)),...
                 neuralDataScaled, observedStateScaled, 'uni', 0);


vtrain = vertcat(vtrain{:});
ytrain = cellfun(@(x)(x(start:end,:)),observedStateScaled,'uni',0);
ytrain = vertcat(ytrain{:});

%% fit KARMA
% tic
% parfor i = 1:size(Ytrain,1)
%    models{i} = svmtrain(Ytrain(i,:)', vtrain,['-s 3 -t 2 -h 0 -g ' num2str(gamma) ' -p .1 -c ' num2str(C)]);
% end
% toc

% wts = model1.sv_coef'*model1.SVs;
% figure;plot(wts,'.')

karma.params.n             = r;
karma.params.N             = d;
karma.params.m             = s;
karma.params.M             = q;
karma.params.latent_mean   = OscaleMeans;
karma.params.latent_std    = OscaleStds;
karma.params.observe_mean  = NscaleMeans;
karma.params.observe_std   = NscaleStds;
karma.hyperparams.m        = karma.params.m;
karma.hyperparams.n        = karma.params.n;
karma.X                    = vtrain;
karma.Y                    = ytrain;

end
