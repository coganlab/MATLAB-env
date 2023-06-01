function [p, Levels] = characterize_level(EventAccLLR, NullAccLLR)
%[p, Level] = characterize_level(EventAccLLR, NullAccLLR);
%
% This code is used to set the level for onset time detection. 
%
% Input :       EventAccLLR: Accumulated log-likelihood ratios for the
%                           event distribution
%               NullAccLLR: Accumulated log-likelihood ratios for the null
%                       distribution
%
% Outputs:   Levels: The range of levels that were tested
%       p(:,1) = Prob of correct event detections for each level
%       p(:,2) = Prob of false alarm null detections for each level
%                Level: The chosen level
%                  ind: index of chosen level in LevelsAll which can be
%                       used to get the false alarm rates

NumLevels = 200;
Levels = linspace(max([EventAccLLR(:); NullAccLLR(:)])./200,...
    max([EventAccLLR(:); NullAccLLR(:)]),NumLevels);
% LevelsAll = linspace(max(AccLLR(:))./2,max(AccLLR(:)),100);

p = ones(NumLevels,2,3);
for iLevel = 1:NumLevels
    pEvent = DetectAccLLR(EventAccLLR, Levels(iLevel), -Levels(iLevel));
    pNull = DetectAccLLR(NullAccLLR, Levels(iLevel), -Levels(iLevel));
    p(iLevel,1,:) = pEvent;
    p(iLevel,2,:) = pNull;
end
