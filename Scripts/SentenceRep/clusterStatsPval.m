function [pvalsLSA_cluster,pvalsLSA_elecs]=clusterStatsPval(pvalsLSA,sigVal)

%sigVal=0.05;
%ClusterSize=4;

pvalsLSA2=pvalsLSA;
ii=find(pvalsLSA2==0);
pvalsLSA2(ii)=0.001;
ii=find(pvalsLSA2==1);
pvalsLSA2(ii)=.999;
for iChan=1:size(pvalsLSA2,1)
    pvalsLSAZ(iChan,:)=norminv(1-pvalsLSA2(iChan,:));
end
% iiS=find(pvalsLSAZ<sigVal); % sigval=1.6449;
% pvalsLSAZ(iiS)=0;


for iChan=1:size(pvalsLSAZ,1);
    
    % actual
    clear ii2
    tmpA=zeros(1,size(pvalsLSAZ,2));
    iiP=find(pvalsLSAZ(iChan,:)>sigVal);
    iiN=find(pvalsLSAZ(iChan,:)<=sigVal);
    tmpA(iiP)=1;
    tmpA(iiN)=0;
    
    
    tmp=bwconncomp(tmpA);
    if size(tmp.PixelIdxList,2)>0
        for ii=1:size(tmp.PixelIdxList,2);
            ii2(ii)=size(tmp.PixelIdxList{ii},1);
        end
        
        ii2B=find(ii2>=2); % 2? 3?
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
                        tmpS2(ii)=length(tmp.PixelIdxList{ii2B(ii)});
                    end
                    pvalsLSA_elecs(iChan).permvalsZ(iPerm)=max(tmpS);
                    pvalsLSA_elecs(iChan).permvalsS(iPerm)=max(tmpS2);

                else
                    pvalsLSA_elecs(iChan).permvalsZ(iPerm)=0;
                    pvalsLSA_elecs(iChan).permvalsS(iPerm)=0;
                    
                end
            else
                pvalsLSA_elecs(iChan).permvalsZ(iPerm)=0;
                pvalsLSA_elecs(iChan).permvalsS(iPerm)=0;
                
            end
        end
    end
    
  %  display(iChan)
end

pvalsLSA_cluster=zeros(size(pvalsLSAZ,1),size(pvalsLSAZ,2));
for iChan=1:length(pvalsLSA_elecs)
  %  if ~isempty(pvalsLSA_elecs(iChan).Zvals) % Z
    if ~isempty(pvalsLSA_elecs(iChan).Size) % Size
      %  iiSort=sort(pvalsLSA_elecs(iChan).permvalsZ); % Z
        iiSort=sort(pvalsLSA_elecs(iChan).permvalsS); % Size
        iiThresh=iiSort(95);
      %  for iZ=1:length(pvalsLSA_elecs(iChan).Zvals) % Z
        for iZ=1:length(pvalsLSA_elecs(iChan).Size) % Size            
            %if pvalsLSA_elecs(iChan).Zvals{iZ}>iiThresh % Z
            if pvalsLSA_elecs(iChan).Size{iZ}>iiThresh % Size
                pvalsLSA_cluster(iChan,[pvalsLSA_elecs(iChan).Start{iZ}:pvalsLSA_elecs(iChan).Start{iZ}+pvalsLSA_elecs(iChan).Size{iZ}-1])=1;
            end
        end
    end
  
end
        
        
        