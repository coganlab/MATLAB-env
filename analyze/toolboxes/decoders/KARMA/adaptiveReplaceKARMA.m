% ADAPTIVEREPLACEKARMA Adds new data to an existing KARMA train set.
%  Generates a new KARMA training set from an existing one and a new
%  set of neural and joint data.  Unscales the existing model, randomly
%  evicts enough training points to make room for the new data and rescales
%  the entire training set based on all of the data.
%
%  ADAPTIVEREPLACEKARMA(OrigKARMA, X, Y, MAXTRAINPTS)
%
%  Mean centers and scales X and Y, and creates lag-stacked training
%  vectors from matrices or cell arrays of matrices along with an existing
%  KARMA training set for use with support vector regression.
%
%  OrigKARMA is an existing karma structure (as per prepareKARMA or
%  ADAPTIVEREPLACEKARMA) for which old training points will be replaced.
%  X is MxN with M observations and N features  (neural data)
%  Y is MxN with M observations and N output variables (joint angles)
%  MAXTRAINPTS is the maximum size of the training set
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
% new_karma = adaptiveReplaceKARMA(karma, newNeuralData, newObservedState,
% 3000);
% 
% for i = 1:size(karma.Y,2)
%    models{i} = svmtrain(new_karma.Y(:,i)', new_karma.X,...
% end
% 
% Caution: Do not change the format of the structure this command returns, 
% the real-time C decoder depends on it.
%
% This function also unscales and rescales the data, there is some
% precision loss that inevitably results from this, but in empirical
% testing it was found to be less than 10e-16 for >1e6 iterations.
%
% However it should be noted that prepareKARMA computes the scaling
% factors and scales the data prior to lag deletion, therefore on the first
% call to adaptiveReplaceKARMA, if the same data is used and no data is
% added, the scale factors will change as they are computed on the data
% after lag deletion.
function karma = adaptiveReplaceKARMA(orig_karma, neuralData, observedState, maxtrainpts)

fprintf('\nAdaptive Replacement KARMA\n\n');

%
% unscale vectors (this was empircally stable to 10e-14 at 1e7 iterations)
scale = [repmat(orig_karma.params.observe_std, 1, orig_karma.params.m) ...
         repmat(orig_karma.params.latent_std,  1, orig_karma.params.n)];

orig_X_unscaled = bsxfun(@times, scale, orig_karma.X);
orig_Y_unscaled = bsxfun(@times, orig_karma.params.latent_std, orig_karma.Y);

offset = [repmat(orig_karma.params.observe_mean, 1, orig_karma.params.m) ...
          repmat(orig_karma.params.latent_mean,  1, orig_karma.params.n)];

orig_X_uncentered = bsxfun(@plus, offset, orig_X_unscaled);
orig_Y_uncentered = bsxfun(@plus, orig_karma.params.latent_mean, orig_Y_unscaled);

fprintf('-> prepareKARMA on new data\n');
%
% karmafy the new data, but do not scale it
new_data = prepareKARMA(neuralData, observedState, orig_karma.params.n,...
                        orig_karma.params.m, 1);

fprintf('-> prepareKARMA on new data done.\n\n');

%
% randomly evict enough training points to make room for new data
evict_n = max((length(orig_X_uncentered) + size(new_data.X, 1)) - maxtrainpts, 0);
evict = randperm(length(orig_X_uncentered), evict_n);
keep = setdiff(1:length(orig_X_uncentered), evict);

fprintf('  %d original training points\n', length(orig_X_uncentered));
fprintf('  %d new training points\n', size(new_data.X, 1));
fprintf('  %d random evictions\n', evict_n);

new_X = orig_X_uncentered(keep,:);
new_Y = orig_Y_uncentered(keep,:);

%
% concatenate the new data the the old data
new_X = [new_X; new_data.X];
new_Y = [new_Y; new_data.Y];

fprintf('  %d total new train set size\n\n', size(new_X,1));

%
% calculate new means and stds (we'll just look at the first lag)

NscaleMeans = mean(new_X(:,1:orig_karma.params.M));
NscaleStds  = std(new_X(:,1:orig_karma.params.M));

% observed state comes after m lags of length M
obs_start = (orig_karma.params.M.*orig_karma.params.m)+1;
obs_ind   = obs_start:obs_start+(orig_karma.params.N-1);
OscaleMeans = mean(new_X(:,obs_ind));
OscaleStds = std(new_X(:,obs_ind));

%
% rescale the data
new_offset = [repmat(NscaleMeans, 1, orig_karma.params.m) ...
              repmat(OscaleMeans, 1, orig_karma.params.n)];

new_X_centered = bsxfun(@minus, new_X, new_offset);
new_Y_centered = bsxfun(@minus, new_Y, OscaleMeans);

new_scale = [repmat(NscaleStds, 1, orig_karma.params.m) ...
             repmat(OscaleStds, 1, orig_karma.params.n)];

new_X_scaled = bsxfun(@rdivide, new_X_centered, new_scale);
new_Y_scaled = bsxfun(@rdivide, new_Y_centered, OscaleStds);

%
% package it back up in the karma data structure and we're done

karma.params.n             = orig_karma.params.n;
karma.params.N             = orig_karma.params.N;
karma.params.m             = orig_karma.params.m;
karma.params.M             = orig_karma.params.M;
karma.params.latent_mean   = OscaleMeans;
karma.params.latent_std    = OscaleStds;
karma.params.observe_mean  = NscaleMeans;
karma.params.observe_std   = NscaleStds;
karma.hyperparams.m        = karma.params.m;
karma.hyperparams.n        = karma.params.n;
karma.X                    = new_X_scaled;
karma.Y                    = new_Y_scaled;






