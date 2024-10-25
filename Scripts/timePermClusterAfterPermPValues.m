function [pValsRaw, actClust] = timePermClusterAfterPermPValues(testP, permP, pThresh)
% timePermClusterAfterPerm - Compute time-based permutation clustering analysis.
% 
% Inputs:
%   testSignal: Signal to test against for statistic (1 x time).
%   permSignals: Permuted signals (permutations x time).
%   numTails: Number of tails for the test (1 or 2), defaults to 2.
%   zThresh: Cluster threshold (Z score).
% 
% Outputs:
%   zValsRawAct: Z-scores for the actual data.
%   pValsRaw: Raw p-values for the actual data.
%   actClust: Cluster information.
%
% Reference: https://www.sciencedirect.com/science/article/pii/S0165027007001707


% Check if the testSignal and permSignals have the same time length
if size(testP, 2) ~= size(permP, 2)
    error('Signals have different time lengths');
end

% Get the number of permutations and the number of time points
nPerm = size(permP, 1);
nSignal = size(permP, 2);

% Compute actual difference, shuffle, and compute p-values

% Compute p-values for one-tailed test
pValsRawOne = testP;



% Adjust extreme p-values to avoid 0 and 1
% ii = pValsRawOne == 1;
% pValsRawOne(ii) = 1 - 1 / nPerm;
% ii = pValsRawOne == 0;
% pValsRawOne(ii) = 1 / nPerm;





pValsRawPermTOne = permP;



% Adjust extreme p-values for permuted data
% ii = find(pValsRawPermTOne == 1);
% pValsRawPermTOne(ii) = 1 - 1 / nPerm;
% ii = find(pValsRawPermTOne == 0);
% pValsRawPermTOne(ii) = 1 / nPerm;



% Initialize the cluster information structure
actClust = [];


% Find clusters in the actual data

    tmpA = double(pValsRawOne < pThresh);



tmp = bwconncomp(tmpA);

if size(tmp.PixelIdxList, 2) > 0
    for ii = 1:size(tmp.PixelIdxList, 2)
        ii2(ii) = size(tmp.PixelIdxList{ii}, 1);
        actClust.Start{ii} = tmp.PixelIdxList{ii}(1);
        actClust.Size{ii} = size(tmp.PixelIdxList{ii},1);

        % Calculate cluster Z-scores
%         if numTails == 1
%             actClust.Z{ii} = sum(zValsRawActOne(tmp.PixelIdxList{ii}));
%         elseif numTails == 2
%             actClust.Z{ii} = sum(zValsRawActTwo(tmp.PixelIdxList{ii}));
%         end
    end
else
     actClust.Start={NaN};
    actClust.Size={NaN};
    
end

%actClust.maxPermClust = zeros(nPerm, 1);

% Find clusters in permuted data
for iPerm = 1:nPerm
    %tmpA = zeros(size(pValsRawPermTOne, 1), size(pValsRawPermTOne, 2));
   
        %tmpB = sq(pValsRawPermTOne(iPerm, :, :));
       % ii = find(sq(pValsRawPermTOne(iPerm, :, :)) < pThresh);
    tmpA = double(pValsRawPermTOne(iPerm, :) < pThresh);
    %tmpA(ii) = 1;
    tmp = bwconncomp(tmpA);

    if size(tmp.PixelIdxList, 2) > 0
        for ii = 1:size(tmp.PixelIdxList, 2)
            ii2(ii) = size(tmp.PixelIdxList{ii}, 1);
           
        end
    else
        ii2 = 0;
        
    end

    % Store the maximum cluster sizes and Z-scores for permuted data
    actClust.maxPermClust(iPerm) = max(ii2);
    
end

% Sort the maximum cluster sizes and calculate percentile values
actClust.maxPermClust = sort(actClust.maxPermClust);
actClust.perm95 = actClust.maxPermClust(round(0.95 * nPerm));
actClust.perm99 = actClust.maxPermClust(round(0.99 * nPerm));


% Return Z-scores and p-values based on the number of tails

    
    pValsRaw = pValsRawOne;

