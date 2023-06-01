inpIdx=pvalsDRAM;
nPerm=1000;
for iPerm=1:nPerm
   sInpIdx=shuffle(reshape(inpIdx,size(inpIdx,1)*size(inpIdx,2),1));
   pvalsS=reshape(sInpIdx,size(inpIdx,1),size(inpIdx,2));
   
for iChan=1:size(pvalsS,1);

    tmp=bwconncomp(sq(pvalsS(iChan,:)));
    if size(tmp.PixelIdxList,2)>0
    for ii=1:size(tmp.PixelIdxList,2);
        ii2(ii)=size(tmp.PixelIdxList{ii},1);
    end
    
   
    
    SigClusterSizeS(iChan)=max(ii2);
    else
        SigClusterSizeS(iChan)=0;
    end
    clear ii2
end
pvalsShuff(iPerm)=max(SigClusterSizeS);
display(iPerm);
end


