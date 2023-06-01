function ST = DetectProb(p, Level, Num, binwidth)
%
% ST = DetectProb(p, Level, Num, binwidth)
%

if nargin < 4; binwidth = 1; end

nTr = size(p,1);
nT = size(p,2);

ST = nan(1,nTr);
for iTr = 1:nTr
  ind = ones(1,nT-Num);
  chk = 0;
  while chk < Num
    ind = ind.*(p(iTr,chk+1:end-Num+chk)<Level);
    chk = chk+1;
  end
  if find(ind,1)
    ST(iTr) = find(ind,1)*binwidth;
  end
end
