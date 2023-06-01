sigVal=0.05;
pvalsSWNW=zeros(size(pvalsWNW,1),size(pvalsWNW,2));
iiS=find(pvalsWNW<sigVal);
pvalsSWNW(iiS)=1;

pvalsSDR=zeros(size(pvalsDR,1),size(pvalsDR,2));
iiS=find(pvalsDR<sigVal);
pvalsSDR(iiS)=1;

pvalsSHL=zeros(size(pvalsHL,1),size(pvalsHL,2));
iiS=find(pvalsHL<sigVal);
pvalsSHL(iiS)=1;

ClusterSize=3;

clusterStartWNW=zeros(size(Spec_Chan_All,2),6);
for iChan=1:size(pvalsSWNW,1);

    tmp=bwconncomp(sq(pvalsSWNW(iChan,:)));
    if size(tmp.PixelIdxList,2)>0
    for ii=1:size(tmp.PixelIdxList,2);
        ii2(ii)=size(tmp.PixelIdxList{ii},1);
    end
    
    ii2B=find(ii2>=ClusterSize);
    if length(ii2B)>0
        for ii=1:length(ii2B);
            ii3(ii)=tmp.PixelIdxList{ii2B(ii)}(1);
            if ii3(ii)>=11 && ii3(ii)<=15
                clusterStartWNW(iChan,1)=1;
            elseif ii3(ii)>=16 && ii3(ii)<=20
                clusterStartWNW(iChan,2)=1;
            elseif ii3(ii)>=21 && ii3(ii)<=25
                clusterStartWNW(iChan,3)=1;
            elseif ii3(ii)>=26 && ii3(ii)<=30
                clusterStartWNW(iChan,4)=1;
            elseif ii3(ii)>=31 && ii3(ii)<=35
                clusterStartWNW(iChan,5)=1;
            elseif ii3(ii)>=36 && ii3(ii)<=40
                clusterStartWNW(iChan,6)=1;
            end
        end
    end
    clear ii3
 
       
    SigClusterSizeWNW(iChan)=max(ii2);
    else
        SigClusterSizeWNW(iChan)=0;
    end
    clear ii2
end

iiWNW=find(SigClusterSizeWNW>=ClusterSize);


clusterStartDR=zeros(size(Spec_Chan_All,2),6);
for iChan=1:size(pvalsSDR,1);

    tmp=bwconncomp(sq(pvalsSDR(iChan,:)));
    if size(tmp.PixelIdxList,2)>0
    for ii=1:size(tmp.PixelIdxList,2);
        ii2(ii)=size(tmp.PixelIdxList{ii},1);
    end
    
    ii2B=find(ii2>=ClusterSize);
    if length(ii2B)>0
        for ii=1:length(ii2B);
            ii3(ii)=tmp.PixelIdxList{ii2B(ii)}(1);
            if ii3(ii)>=11 && ii3(ii)<=15
                clusterStartDR(iChan,1)=1;
            elseif ii3(ii)>=16 && ii3(ii)<=20
                clusterStartDR(iChan,2)=1;
            elseif ii3(ii)>=21 && ii3(ii)<=25
                clusterStartDR(iChan,3)=1;
            elseif ii3(ii)>=26 && ii3(ii)<=30
                clusterStartDR(iChan,4)=1;
            elseif ii3(ii)>=31 && ii3(ii)<=35
                clusterStartDR(iChan,5)=1;
            elseif ii3(ii)>=36 && ii3(ii)<=40
                clusterStartDR(iChan,6)=1;
            end
        end
    end
    clear ii3
 
       
    SigClusterSizeDR(iChan)=max(ii2);
    else
        SigClusterSizeDR(iChan)=0;
    end
    clear ii2
end

iiDR=find(SigClusterSizeDR>=ClusterSize);

clusterStartHL=zeros(size(Spec_Chan_All,2),6);
for iChan=1:size(pvalsSHL,1);

    tmp=bwconncomp(sq(pvalsSHL(iChan,:)));
    if size(tmp.PixelIdxList,2)>0
    for ii=1:size(tmp.PixelIdxList,2);
        ii2(ii)=size(tmp.PixelIdxList{ii},1);
    end
    
    ii2B=find(ii2>=ClusterSize);
    if length(ii2B)>0
        for ii=1:length(ii2B);
            ii3(ii)=tmp.PixelIdxList{ii2B(ii)}(1);
            if ii3(ii)>=11 && ii3(ii)<=15
                clusterStartHL(iChan,1)=1;
            elseif ii3(ii)>=16 && ii3(ii)<=20
                clusterStartHL(iChan,2)=1;
            elseif ii3(ii)>=21 && ii3(ii)<=25
                clusterStartHL(iChan,3)=1;
            elseif ii3(ii)>=26 && ii3(ii)<=30
                clusterStartHL(iChan,4)=1;
            elseif ii3(ii)>=31 && ii3(ii)<=35
                clusterStartHL(iChan,5)=1;
            elseif ii3(ii)>=36 && ii3(ii)<=40
                clusterStartHL(iChan,6)=1;
            end
        end
    end
    clear ii3
 
       
    SigClusterSizeHL(iChan)=max(ii2);
    else
        SigClusterSizeHL(iChan)=0;
    end
    clear ii2
end

iiHL=find(SigClusterSizeHL>=ClusterSize);






pvalsSNWW=zeros(size(pvalsWNW,1),size(pvalsWNW,2));
iiS=find(pvalsWNW>1-sigVal);
pvalsSNWW(iiS)=1;

pvalsSRD=zeros(size(pvalsDR,1),size(pvalsDR,2));
iiS=find(pvalsDR>1-sigVal);
pvalsSRD(iiS)=1;

pvalsSLH=zeros(size(pvalsHL,1),size(pvalsHL,2));
iiS=find(pvalsHL>1-sigVal);
pvalsSLH(iiS)=1;



clusterStartNWW=zeros(size(Spec_Chan_All,2),6);
for iChan=1:size(pvalsSNWW,1);

    tmp=bwconncomp(sq(pvalsSNWW(iChan,:)));
    if size(tmp.PixelIdxList,2)>0
    for ii=1:size(tmp.PixelIdxList,2);
        ii2(ii)=size(tmp.PixelIdxList{ii},1);
    end
    
    ii2B=find(ii2>=ClusterSize);
    if length(ii2B)>0
        for ii=1:length(ii2B);
            ii3(ii)=tmp.PixelIdxList{ii2B(ii)}(1);
            if ii3(ii)>=11 && ii3(ii)<=15
                clusterStartNWW(iChan,1)=1;
            elseif ii3(ii)>=16 && ii3(ii)<=20
                clusterStartNWW(iChan,2)=1;
            elseif ii3(ii)>=21 && ii3(ii)<=25
                clusterStartNWW(iChan,3)=1;
            elseif ii3(ii)>=26 && ii3(ii)<=30
                clusterStartNWW(iChan,4)=1;
            elseif ii3(ii)>=31 && ii3(ii)<=35
                clusterStartNWW(iChan,5)=1;
            elseif ii3(ii)>=36 && ii3(ii)<=40
                clusterStartNWW(iChan,6)=1;
            end
        end
    end
    clear ii3
 
       
    SigClusterSizeNWW(iChan)=max(ii2);
    else
        SigClusterSizeNWW(iChan)=0;
    end
    clear ii2
end

iiNWW=find(SigClusterSizeNWW>=ClusterSize);


clusterStartRD=zeros(size(Spec_Chan_All,2),6);
for iChan=1:size(pvalsSRD,1);

    tmp=bwconncomp(sq(pvalsSRD(iChan,:)));
    if size(tmp.PixelIdxList,2)>0
    for ii=1:size(tmp.PixelIdxList,2);
        ii2(ii)=size(tmp.PixelIdxList{ii},1);
    end
    
    ii2B=find(ii2>=ClusterSize);
    if length(ii2B)>0
        for ii=1:length(ii2B);
            ii3(ii)=tmp.PixelIdxList{ii2B(ii)}(1);
            if ii3(ii)>=11 && ii3(ii)<=15
                clusterStartRD(iChan,1)=1;
            elseif ii3(ii)>=16 && ii3(ii)<=20
                clusterStartRD(iChan,2)=1;
            elseif ii3(ii)>=21 && ii3(ii)<=25
                clusterStartRD(iChan,3)=1;
            elseif ii3(ii)>=26 && ii3(ii)<=30
                clusterStartRD(iChan,4)=1;
            elseif ii3(ii)>=31 && ii3(ii)<=35
                clusterStartRD(iChan,5)=1;
            elseif ii3(ii)>=36 && ii3(ii)<=40
                clusterStartRD(iChan,6)=1;
            end
        end
    end
    clear ii3
 
       
    SigClusterSizeRD(iChan)=max(ii2);
    else
        SigClusterSizeRD(iChan)=0;
    end
    clear ii2
end

iiRD=find(SigClusterSizeRD>=ClusterSize);

clusterStartLH=zeros(size(Spec_Chan_All,2),6);
for iChan=1:size(pvalsSLH,1);

    tmp=bwconncomp(sq(pvalsSLH(iChan,:)));
    if size(tmp.PixelIdxList,2)>0
    for ii=1:size(tmp.PixelIdxList,2);
        ii2(ii)=size(tmp.PixelIdxList{ii},1);
    end
    
    ii2B=find(ii2>=ClusterSize);
    if length(ii2B)>0
        for ii=1:length(ii2B);
            ii3(ii)=tmp.PixelIdxList{ii2B(ii)}(1);
            if ii3(ii)>=11 && ii3(ii)<=15
                clusterStartLH(iChan,1)=1;
            elseif ii3(ii)>=16 && ii3(ii)<=20
                clusterStartLH(iChan,2)=1;
            elseif ii3(ii)>=21 && ii3(ii)<=25
                clusterStartLH(iChan,3)=1;
            elseif ii3(ii)>=26 && ii3(ii)<=30
                clusterStartLH(iChan,4)=1;
            elseif ii3(ii)>=31 && ii3(ii)<=35
                clusterStartLH(iChan,5)=1;
            elseif ii3(ii)>=36 && ii3(ii)<=40
                clusterStartLH(iChan,6)=1;
            end
        end
    end
    clear ii3
 
       
    SigClusterSizeLH(iChan)=max(ii2);
    else
        SigClusterSizeLH(iChan)=0;
    end
    clear ii2
end

iiLH=find(SigClusterSizeLH>=ClusterSize);
