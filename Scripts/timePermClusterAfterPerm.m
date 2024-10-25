function [zValsRawAct, pValsRaw, actClust] = timePermClusterAfterPerm(testSignal, permSignals, numTails, zThresh)
% timePermClusterAfterPerm - Compute time-based permutation clustering analysis.
% 
% Inputs:
%   testSignal: Signal to test against for statistic (1 x time).
%   permSignals: Permuted signals (permutations x time).
%   numTails: Number of tails for the test (1 or 2), defaults to 1.
%   zThresh: Cluster threshold (Z score).
% 
% Outputs:
%   zValsRawAct: Z-scores for the actual data.
%   pValsRaw: Raw p-values for the actual data.
%   actClust: Cluster information.
%
% Reference: https://www.sciencedirect.com/science/article/pii/S0165027007001707

% Check for the minimum number of input arguments
if nargin < 2
    error('Not enough inputs');
end

% Set the default value for numTails if not provided
if nargin < 3 || isempty(numTails)
    numTails = 1;
end

% Check if the testSignal and permSignals have the same time length
if size(testSignal, 2) ~= size(permSignals, 2)
    error('Signals have different time lengths');
end

% Get the number of permutations and the number of time points
nPerm = size(permSignals, 1);
nSignal = size(permSignals, 2);

% Compute actual difference, shuffle, and compute p-values

% Compute p-values for one-tailed test
pValsRawOne = sum(permSignals > testSignal) / nPerm;

% Compute p-values for two-tailed test
pValsRawTwo = sum(abs(permSignals) > abs(testSignal)) / nPerm;

% Adjust extreme p-values to avoid 0 and 1
ii = pValsRawOne == 1;
pValsRawOne(ii) = 1 - 1 / nPerm;
ii = pValsRawOne == 0;
pValsRawOne(ii) = 1 / nPerm;

ii = pValsRawTwo == 1;
pValsRawTwo(ii) = 1 - 1 / nPerm;
ii = pValsRawTwo == 0;
pValsRawTwo(ii) = 1 / nPerm;

% Calculate Z-scores for the actual data
zValsRawActOne = norminv(1 - pValsRawOne);
zValsRawActTwo = norminv(1 - pValsRawTwo);

% Initialize arrays to store permuted data p-values
pValsRawPermTOne = zeros(nPerm, nSignal);
pValsRawPermTTwo = zeros(nPerm, nSignal);

% Calculate p-values for permuted data
for iPerm = 1:nPerm
    idx1 = setdiff(1:size(permSignals, 1), iPerm);
    actDiffT = permSignals(iPerm, :);
    permvalsT = permSignals(idx1, :);

    % Compute p-values for one-tailed test
    pValsRawPermTOne(iPerm, :) = sum(permvalsT > actDiffT) / (nPerm - 1);

    % Compute p-values for two-tailed test
    pValsRawPermTTwo(iPerm, :) = sum(abs(permvalsT) > abs(actDiffT)) / (nPerm - 1);
end

% Adjust extreme p-values for permuted data
ii = find(pValsRawPermTOne == 1);
pValsRawPermTOne(ii) = 1 - 1 / nPerm;
ii = find(pValsRawPermTOne == 0);
pValsRawPermTOne(ii) = 1 / nPerm;

ii = find(pValsRawPermTTwo == 1);
pValsRawPermTTwo(ii) = 1 - 1 / nPerm;
ii = find(pValsRawPermTTwo == 0);
pValsRawPermTTwo(ii) = 1 / nPerm;

% Calculate Z-scores for permuted data
zValsRawPermOne = norminv(1 - pValsRawPermTOne);
zValsRawPermTwo = norminv(1 - pValsRawPermTTwo);

% Initialize the cluster information structure
actClust = [];
tmpA = zeros(1, length(zValsRawActOne));

% Find clusters in the actual data
if numTails == 1
    iActual = find(zValsRawActOne > zThresh);
elseif numTails == 2
    iActual = find(zValsRawActTwo > zThresh);
end

tmpA(iActual) = 1;
tmp = bwconncomp(tmpA);

if size(tmp.PixelIdxList, 2) > 0
    for ii = 1:size(tmp.PixelIdxList, 2)
        ii2(ii) = size(tmp.PixelIdxList{ii}, 1);
        actClust.Start{ii} = tmp.PixelIdxList{ii}(1);
        actClust.Size{ii} = length(tmp.PixelIdxList{ii});

        % Calculate cluster Z-scores
        if numTails == 1
            actClust.Z{ii} = sum(zValsRawActOne(tmp.PixelIdxList{ii}));
        elseif numTails == 2
            actClust.Z{ii} = sum(zValsRawActTwo(tmp.PixelIdxList{ii}));
        end
    end
else
    actClust.Start = {NaN};
    actClust.Size = {NaN};
    actClust.Z = {NaN};
end

actClust.maxPermClust = zeros(nPerm, 1);

% Find clusters in permuted data
for iPerm = 1:nPerm
    tmpA = zeros(size(zValsRawPermOne, 1), size(zValsRawPermOne, 2));
    if numTails == 1
        tmpB = sq(zValsRawPermOne(iPerm, :, :));
        ii = find(sq(zValsRawPermOne(iPerm, :, :)) > zThresh);
    elseif numTails == 2
        tmpB = sq(zValsRawPermTwo(iPerm, :, :));
        ii = find(sq(zValsRawPermTwo(iPerm, :, :)) > zThresh);
    end
    tmpA(ii) = 1;
    tmp = bwconncomp(tmpA);

    if size(tmp.PixelIdxList, 2) > 0
        for ii = 1:size(tmp.PixelIdxList, 2)
            ii2(ii) = size(tmp.PixelIdxList{ii}, 1);
            ii3(ii) = sum(tmpB(tmp.PixelIdxList{ii}));
        end
    else
        ii2 = 0;
        ii3 = 0;
    end

    % Store the maximum cluster sizes and Z-scores for permuted data
    actClust.maxPermClust(iPerm) = max(ii2);
    actClust.maxPermZ(iPerm) = max(ii3);
end

% Sort the maximum cluster sizes and calculate percentile values
actClust.maxPermClust = sort(actClust.maxPermClust);
actClust.perm95 = actClust.maxPermClust(round(0.95 * nPerm));
actClust.perm99 = actClust.maxPermClust(round(0.99 * nPerm));
actClust.maxPermZ = sort(actClust.maxPermZ);
actClust.permZ95 = actClust.maxPermZ(round(0.95 * nPerm));
actClust.permZ99 = actClust.maxPermZ(round(0.99 * nPerm));

% Return Z-scores and p-values based on the number of tails
if numTails == 1
    zValsRawAct = zValsRawActOne;
    pValsRaw = pValsRawOne;
elseif numTails == 2
    zValsRawAct = zValsRawActTwo;
    pValsRaw = pValsRawTwo;
end
