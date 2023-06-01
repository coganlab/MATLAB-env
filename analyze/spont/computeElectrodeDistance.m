function dist = computeElectrodeDistance(posX, posY)

% dist = computeElectrodeDistance(posX, posY)
%
%calculates pairwise distance of electrodes with positions given by posX,
%posY
%
%INPUT: posX - vector (nE x 1 or 1 x nE) of x-position of electrodes
%       posY - vector (nE x 1 or 1 x nE) of y-position of electrodes
%
%OUTPUT: dist - (nE x nE) matrix of pairwise distances of electrodes. e.g.
%dist(i,j) = dist(j,i) = distance between electrodes i and j. 
%

nE = length(posX(:));
if length(posY(:)) ~= nE
    error('posX and posY must have the same dimensions')
end

%make sure a row vector
posX = posX(:);
posY = posY(:);


%col-replicate X,y
posX_colMat = repmat(posX, 1, nE);
posY_colMat = repmat(posY, 1, nE);


%row-replicate x,y
posX_rowMat = repmat(posX', nE, 1);
posY_rowMat = repmat(posY', nE, 1);


%compute distance
dist = sqrt( (posX_colMat - posX_rowMat).^2 + (posY_colMat - posY_rowMat).^2);
