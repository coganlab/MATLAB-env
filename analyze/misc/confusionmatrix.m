function p = confusionmatrix(Pred, Actual)
%
%   p = confusionmatrix(Pred, Actual)
%

uCat = unique(Actual);
nCat = length(uCat);
p = zeros(nCat,nCat);
for iActual = 1:nCat
  CatInd = find(Actual==uCat(iActual));
  nCatInd = length(CatInd);
  for iPred = 1:nCat
    p(iActual,iPred) = length(find(Pred(CatInd)==uCat(iPred)))./nCatInd;
  end
end
