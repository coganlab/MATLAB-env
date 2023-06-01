function proc2TRMB(day)
%
%   proc2TRMB(day)
%

Trials = dbdatabase(day);

rmbData = [];

for t=1:length(Trials)
   if Trials(t).RewardTask==9
       
  targChoice = 1;
  circleLoc = Trials(t).T1T2Locations(1,:);
  choiceLoc = Trials(t).EyeChoiceContinuousLocation;
  try
  if sum(choiceLoc==circleLoc)==2 
    targChoice = 0;
  end
  
  rt = Trials(t).SaccStart - Trials(t).Go;

  rmbData = [ rmbData; ...
                           targChoice rt ...
                           Trials(t).RewardDist(1:4) Trials(t).BrightDist(1:4) ...
                           Trials(t).RewardDur(1:2) Trials(t).BrightVals(1:2) ];
  end
   end
end

minBlockTrials = 20;

block = [];
curBlockParams = zeros(1,8);
blockParams = [];
blockIndex = 1;
repeatIndex = 1;
curBlockData = [];
for t=1:size(rmbData,1)
  continueBlock = sum(rmbData(t,3:10)==curBlockParams)==8;
  if continueBlock
    curBlockData = [ curBlockData; rmbData(t,[1 2 11:14]) ];
  end
  
  if ~continueBlock | t==size(rmbData,1)
    if size(curBlockData,1)>=minBlockTrials
      block(blockIndex).params = curBlockParams;
      block(blockIndex).repeat(repeatIndex).rmbData = curBlockData; 
    end
    [tf,rows] = ismember(rmbData(t,3:10),blockParams,'rows');
    if tf
      blockIndex = rows(1);
      repeatIndex = 1;
      try
        repeatIndex = length(block(blockIndex).repeat) + 1;
      end
    else
      blockParams = [ blockParams; rmbData(t,3:10) ];
      blockIndex = size(blockParams,1);
      repeatIndex = 1;
    end
    curBlockParams = rmbData(t,3:10);
    curBlockData = [];
  end
    
end

remBlockIndexes = [];
for b=1:size(blockParams,1)
    try
  if length(block(b).repeat)==0
    remBlockIndexes = [ remBlockIndexes b ];
  end
    catch
      blockParams(end,:) = [];  
    end
end
block(remBlockIndexes) = [];
blockParams(remBlockIndexes,:) = [];

save TwoTargMagBrightData block blockParams;
