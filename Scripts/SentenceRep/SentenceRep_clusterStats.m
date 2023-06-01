[pvalsLSA_cluster pvalsLSA_elecs]=clusterStatsPval(

sigVal=0.05;
%ClusterSize=4;

pvalsLSA2=pvalsLSA;
ii=find(pvalsLSA2==0);
pvalsLSA2(ii)=0.0001;
ii=find(pvalsLSA2==1);
pvalsLSA2(ii)=.9999;
for iChan=1:size(pvalsLSA2,1)
    pvalsLSAZ(iChan,:)=norminv(1-pvalsLSA2(iChan,:));
end
iiS=find(pvalsLSAZ<1.6449);
pvalsLSAZ(iiS)=0;


for iChan=1:size(pvalsLSAZ,1);
    
    % actual
    clear ii2
    tmp=bwconncomp(sq(pvalsLSAZ(iChan,:)));
    if size(tmp.PixelIdxList,2)>0
        for ii=1:size(tmp.PixelIdxList,2);
            ii2(ii)=size(tmp.PixelIdxList{ii},1);
        end
        
        ii2B=find(ii2>=2);
        if length(ii2B)>0
            for ii=1:length(ii2B);
                pvalsLSA_elecs(iChan).Zvals{ii}=sum(pvalsLSAZ(iChan,tmp.PixelIdxList{ii2B(ii)}));
                pvalsLSA_elecs(iChan).Start{ii}=tmp.PixelIdxList{ii2B(ii)}(1);
                pvalsLSA_elecs(iChan).Size{ii}=length(tmp.PixelIdxList{ii2B(ii)});
            end
        end
        
        for iPerm=1:100
            % perm
            clear tmpS
            tmp1=shuffle(pvalsLSAZ(iChan,:));
            tmp=bwconncomp(tmp1);
            clear ii2
            if size(tmp.PixelIdxList,2)>0
                for ii=1:size(tmp.PixelIdxList,2);
                    ii2(ii)=size(tmp.PixelIdxList{ii},1);
                end
                
                ii2B=find(ii2>=2);
                if length(ii2B)>0
                    for ii=1:length(ii2B);
                        tmpS(ii)=sum(tmp1(tmp.PixelIdxList{ii2B(ii)}));
                    end
                    pvalsLSA_elecs(iChan).permvals(iPerm)=max(tmpS);
                else
                    pvalsLSA_elecs(iChan).permvals(iPerm)=0;
                end
            else
                pvalsLSA_elecs(iChan).permvals(iPerm)=0;
                
            end
        end
    end
    
    display(iChan)
end

pvalsLSA_cluster=zeros(size(pvalsLSAZ,1),size(pvalsLSAZ,2));
for iChan=1:length(pvalsLSA_elecs)
    if ~isempty(pvalsLSA_elecs(iChan).Zvals)
        iiSort=sort(pvalsLSA_elecs(iChan).permvals);
        iiThresh=iiSort(95);
        for iZ=1:length(pvalsLSA_elecs(iChan).Zvals)
            if pvalsLSA_elecs(iChan).Zvals{iZ}>iiThresh
                pvalsLSA_cluster(iChan,[pvalsLSA_elecs(iChan).Start{iZ}:pvalsLSA_elecs(iChan).Start{iZ}+pvalsLSA_elecs(iChan).Size{iZ}-1])=1;
            end
        end
    end
  
end
        
        
        