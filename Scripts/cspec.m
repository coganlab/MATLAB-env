function cmap = cspec(color1,color2,nCol)

for iR=1:3;
cmap(:,iR)=linspace(color1(iR),color2(iR),nCol);
end
