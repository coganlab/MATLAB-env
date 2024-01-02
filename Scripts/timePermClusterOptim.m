function [zValsRawAct, pValsRaw, actClust] = timePermClusterOptim(aSig, bSig, nPerm, numTails, zThresh)
    if nargin < 3 || isempty(nPerm)
        nPerm = 1000;
    end
    
    if nargin < 4 || isempty(numTails)
        numTails = 1;
    end
    
    if size(aSig, 2) ~= size(bSig, 2)
        error('Signals have different time lengths');
    end
    
    actdiff = mean(aSig) - mean(bSig);
    combval = cat(1, aSig, bSig);
    permval2 = zeros(nPerm, size(combval, 1), size(combval, 2));
    pValsRawOne = zeros(size(aSig, 2), 1);
    pValsRawTwo = zeros(size(aSig, 2), 1);
    idx1 = 1:size(aSig, 1);
    idx2 = size(aSig, 1) + 1:size(combval, 1);
    
    for iPerm = 1:nPerm
        sIdx = randperm(size(combval, 1));
        permval = mean(combval(sIdx(idx1), :), 1) - mean(combval(sIdx(idx2), :), 1);
        permval2(iPerm, :, :) = combval(sIdx, :);
        
        if numTails == 1
            pValsRawOne = pValsRawOne + (permval > actdiff)';
        elseif numTails == 2
            pValsRawTwo = pValsRawTwo + (abs(permval) > abs(actdiff))';
        end
    end
    
    pValsRawOne = pValsRawOne / nPerm;
    pValsRawTwo = pValsRawTwo / nPerm;
    zValsRawActOne = norminv(1 - pValsRawOne);
    zValsRawActTwo = norminv(1 - pValsRawTwo);
    
    pValsRaw = pValsRawOne;
    zValsRawAct = zValsRawActOne;
    if numTails == 2
        pValsRaw = pValsRawTwo;
        zValsRawAct = zValsRawActTwo;
    end
    
    actClust = computeClusterStatistics(zValsRawAct, permval2, numTails, nPerm, zThresh);
end

function actClust = computeClusterStatistics(zValsRawAct, permval2, numTails, nPerm, zThresh)
    actClust = struct();
    tmpA = zeros(1, length(zValsRawAct));
    
    if numTails == 1
        ii = zValsRawAct > zThresh;
    elseif numTails == 2
        ii = zValsRawAct > zThresh;
    end
    
    tmpA(ii) = 1;
    tmp = bwconncomp(tmpA);
    
    if size(tmp.PixelIdxList, 2) > 0
        actClust.Start = cell(1, size(tmp.PixelIdxList, 2));
        actClust.Size = cell(1, size(tmp.PixelIdxList, 2));
        actClust.Z = cell(1, size(tmp.PixelIdxList, 2));
        
        for ii = 1:size(tmp.PixelIdxList, 2)
            actClust.Start{ii} = tmp.PixelIdxList{ii}(1);
            actClust.Size{ii} = length(tmp.PixelIdxList{ii});
            
            if numTails == 1
                actClust.Z{ii} = sum(zValsRawAct(tmp.PixelIdxList{ii}));
            elseif numTails == 2
                actClust.Z{ii} = sum(zValsRawAct(tmp.PixelIdxList{ii}));
            end
        end
    else
        actClust.Start = {NaN};
        actClust.Size = {NaN};
        actClust.Z = {NaN};
    end

    % Compute cluster-based permutation statistics
    actClust.maxPermClust = zeros(nPerm, 1);
    
    for iPerm = 1:nPerm
        tmpA = zeros(size(zValsRawAct));
        permval = permval2(iPerm, :, :);
        
        if numTails == 1
            ii = permval > zThresh;
        elseif numTails == 2
            ii = permval > zThresh;
        end
        
        tmpA(ii) = 1;
        tmp = bwconncomp(tmpA);
        
        if size(tmp.PixelIdxList, 2) > 0
            maxClusterSize = zeros(1, size(tmp.PixelIdxList, 2));
            
            for ii = 1:size(tmp.PixelIdxList, 2)
                maxClusterSize(ii) = length(tmp.PixelIdxList{ii});
            end

            actClust.maxPermClust(iPerm) = max(maxClusterSize);
        else
            actClust.maxPermClust(iPerm) = 0;
        end
    end

    actClust.maxPermClust = sort(actClust.maxPermClust);
    actClust.perm95 = actClust.maxPermClust(round(0.95 * nPerm));
    actClust.perm99 = actClust.maxPermClust(round(0.99 * nPerm));
end
