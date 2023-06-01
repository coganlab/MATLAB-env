function highReward = calcHighReward(trials,comparator)
%
%  highReward = calcHighReward(trials,comparator)
%

if  nargin < 2
    comparator = -1;
end


highReward = getHighReward(trials);

if(comparator > -1)
   highReward = (highReward == comparator);
end