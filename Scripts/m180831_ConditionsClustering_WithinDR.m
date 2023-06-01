sigVal=.05;
pvalsSWNWD=zeros(size(pvalsWNWD,1),size(pvalsWNWD,2));
iiS=find(pvalsWNWD<sigVal);
pvalsSWNWD(iiS)=1;


pvalsSHLD=zeros(size(pvalsHLD,1),size(pvalsHLD,2));
iiS=find(pvalsHLD<sigVal);
pvalsSHLD(iiS)=1;

ClusterSize=3;

clusterStartWNWD=zeros(size(Spec_Chan_All,2),6);
for iChan=1:size(pvalsSWNWD,1);

    tmp=bwconncomp(sq(pvalsSWNWD(iChan,:)));
    if size(tmp.PixelIdxList,2)>0
    for ii=1:size(tmp.PixelIdxList,2);
        ii2(ii)=size(tmp.PixelIdxList{ii},1);
    end
    
    ii2B=find(ii2>=ClusterSize);
    if length(ii2B)>0
        for ii=1:length(ii2B);
            ii3(ii)=tmp.PixelIdxList{ii2B(ii)}(1);
            if ii3(ii)>=11 && ii3(ii)<=15
                clusterStartWNWD(iChan,1)=1;
            elseif ii3(ii)>=16 && ii3(ii)<=20
                clusterStartWNWD(iChan,2)=1;
            elseif ii3(ii)>=21 && ii3(ii)<=25
                clusterStartWNWD(iChan,3)=1;
            elseif ii3(ii)>=26 && ii3(ii)<=30
                clusterStartWNWD(iChan,4)=1;
            elseif ii3(ii)>=31 && ii3(ii)<=35
                clusterStartWNWD(iChan,5)=1;
            elseif ii3(ii)>=36 && ii3(ii)<=40
                clusterStartWNWD(iChan,6)=1;
            end
        end
    end
    clear ii3
 
       
    SigClusterSizeWNWD(iChan)=max(ii2);
    else
        SigClusterSizeWNWD(iChan)=0;
    end
    clear ii2
end

iiWNWD=find(SigClusterSizeWNWD>=ClusterSize);

clusterStartHLD=zeros(size(Spec_Chan_All,2),6);
for iChan=1:size(pvalsSHLD,1);

    tmp=bwconncomp(sq(pvalsSHLD(iChan,:)));
    if size(tmp.PixelIdxList,2)>0
    for ii=1:size(tmp.PixelIdxList,2);
        ii2(ii)=size(tmp.PixelIdxList{ii},1);
    end
    
    ii2B=find(ii2>=ClusterSize);
    if length(ii2B)>0
        for ii=1:length(ii2B);
            ii3(ii)=tmp.PixelIdxList{ii2B(ii)}(1);
            if ii3(ii)>=11 && ii3(ii)<=15
                clusterStartHLD(iChan,1)=1;
            elseif ii3(ii)>=16 && ii3(ii)<=20
                clusterStartHLD(iChan,2)=1;
            elseif ii3(ii)>=21 && ii3(ii)<=25
                clusterStartHLD(iChan,3)=1;
            elseif ii3(ii)>=26 && ii3(ii)<=30
                clusterStartHLD(iChan,4)=1;
            elseif ii3(ii)>=31 && ii3(ii)<=35
                clusterStartHLD(iChan,5)=1;
            elseif ii3(ii)>=36 && ii3(ii)<=40
                clusterStartHLD(iChan,6)=1;
            end
        end
    end
    clear ii3
 
       
    SigClusterSizeHLD(iChan)=max(ii2);
    else
        SigClusterSizeHLD(iChan)=0;
    end
    clear ii2
end

iiHLD=find(SigClusterSizeHLD>=ClusterSize);






pvalsSNWWD=zeros(size(pvalsWNWD,1),size(pvalsWNWD,2));
iiS=find(pvalsWNWD>.99);
pvalsSNWWD(iiS)=1;



pvalsSLHD=zeros(size(pvalsHLD,1),size(pvalsHLD,2));
iiS=find(pvalsHLD>.99);
pvalsSLHD(iiS)=1;



clusterStartNWWD=zeros(size(Spec_Chan_All,2),6);
for iChan=1:size(pvalsSNWWD,1);

    tmp=bwconncomp(sq(pvalsSNWWD(iChan,:)));
    if size(tmp.PixelIdxList,2)>0
    for ii=1:size(tmp.PixelIdxList,2);
        ii2(ii)=size(tmp.PixelIdxList{ii},1);
    end
    
    ii2B=find(ii2>=ClusterSize);
    if length(ii2B)>0
        for ii=1:length(ii2B);
            ii3(ii)=tmp.PixelIdxList{ii2B(ii)}(1);
            if ii3(ii)>=11 && ii3(ii)<=15
                clusterStartNWWD(iChan,1)=1;
            elseif ii3(ii)>=16 && ii3(ii)<=20
                clusterStartNWWD(iChan,2)=1;
            elseif ii3(ii)>=21 && ii3(ii)<=25
                clusterStartNWWD(iChan,3)=1;
            elseif ii3(ii)>=26 && ii3(ii)<=30
                clusterStartNWWD(iChan,4)=1;
            elseif ii3(ii)>=31 && ii3(ii)<=35
                clusterStartNWWD(iChan,5)=1;
            elseif ii3(ii)>=36 && ii3(ii)<=40
                clusterStartNWWD(iChan,6)=1;
            end
        end
    end
    clear ii3
 
       
    SigClusterSizeNWWD(iChan)=max(ii2);
    else
        SigClusterSizeNWWD(iChan)=0;
    end
    clear ii2
end

iiNWWD=find(SigClusterSizeNWWD>=ClusterSize);

clusterStartLHD=zeros(size(Spec_Chan_All,2),6);
for iChan=1:size(pvalsSLHD,1);

    tmp=bwconncomp(sq(pvalsSLHD(iChan,:)));
    if size(tmp.PixelIdxList,2)>0
    for ii=1:size(tmp.PixelIdxList,2);
        ii2(ii)=size(tmp.PixelIdxList{ii},1);
    end
    
    ii2B=find(ii2>=ClusterSize);
    if length(ii2B)>0
        for ii=1:length(ii2B);
            ii3(ii)=tmp.PixelIdxList{ii2B(ii)}(1);
            if ii3(ii)>=11 && ii3(ii)<=15
                clusterStartLHD(iChan,1)=1;
            elseif ii3(ii)>=16 && ii3(ii)<=20
                clusterStartLHD(iChan,2)=1;
            elseif ii3(ii)>=21 && ii3(ii)<=25
                clusterStartLHD(iChan,3)=1;
            elseif ii3(ii)>=26 && ii3(ii)<=30
                clusterStartLHD(iChan,4)=1;
            elseif ii3(ii)>=31 && ii3(ii)<=35
                clusterStartLHD(iChan,5)=1;
            elseif ii3(ii)>=36 && ii3(ii)<=40
                clusterStartLHD(iChan,6)=1;
            end
        end
    end
    clear ii3
 
       
    SigClusterSizeLHD(iChan)=max(ii2);
    else
        SigClusterSizeLHD(iChan)=0;
    end
    clear ii2
end

iiLHD=find(SigClusterSizeLHD>=ClusterSize);






pvalsSWNWR=zeros(size(pvalsWNWR,1),size(pvalsWNWR,2));
iiS=find(pvalsWNWR<sigVal);
pvalsSWNWR(iiS)=1;


pvalsSHLR=zeros(size(pvalsHLR,1),size(pvalsHLR,2));
iiS=find(pvalsHLR<sigVal);
pvalsSHLR(iiS)=1;

ClusterSize=3;

clusterStartWNWR=zeros(size(Spec_Chan_All,2),6);
for iChan=1:size(pvalsSWNWR,1);

    tmp=bwconncomp(sq(pvalsSWNWR(iChan,:)));
    if size(tmp.PixelIdxList,2)>0
    for ii=1:size(tmp.PixelIdxList,2);
        ii2(ii)=size(tmp.PixelIdxList{ii},1);
    end
    
    ii2B=find(ii2>=ClusterSize);
    if length(ii2B)>0
        for ii=1:length(ii2B);
            ii3(ii)=tmp.PixelIdxList{ii2B(ii)}(1);
            if ii3(ii)>=11 && ii3(ii)<=15
                clusterStartWNWR(iChan,1)=1;
            elseif ii3(ii)>=16 && ii3(ii)<=20
                clusterStartWNWR(iChan,2)=1;
            elseif ii3(ii)>=21 && ii3(ii)<=25
                clusterStartWNWR(iChan,3)=1;
            elseif ii3(ii)>=26 && ii3(ii)<=30
                clusterStartWNWR(iChan,4)=1;
            elseif ii3(ii)>=31 && ii3(ii)<=35
                clusterStartWNWR(iChan,5)=1;
            elseif ii3(ii)>=36 && ii3(ii)<=40
                clusterStartWNWR(iChan,6)=1;
            end
        end
    end
    clear ii3
 
       
    SigClusterSizeWNWR(iChan)=max(ii2);
    else
        SigClusterSizeWNWR(iChan)=0;
    end
    clear ii2
end

iiWNWR=find(SigClusterSizeWNWR>=ClusterSize);

clusterStartHLR=zeros(size(Spec_Chan_All,2),6);
for iChan=1:size(pvalsSHLR,1);

    tmp=bwconncomp(sq(pvalsSHLR(iChan,:)));
    if size(tmp.PixelIdxList,2)>0
    for ii=1:size(tmp.PixelIdxList,2);
        ii2(ii)=size(tmp.PixelIdxList{ii},1);
    end
    
    ii2B=find(ii2>=ClusterSize);
    if length(ii2B)>0
        for ii=1:length(ii2B);
            ii3(ii)=tmp.PixelIdxList{ii2B(ii)}(1);
            if ii3(ii)>=11 && ii3(ii)<=15
                clusterStartHLR(iChan,1)=1;
            elseif ii3(ii)>=16 && ii3(ii)<=20
                clusterStartHLR(iChan,2)=1;
            elseif ii3(ii)>=21 && ii3(ii)<=25
                clusterStartHLR(iChan,3)=1;
            elseif ii3(ii)>=26 && ii3(ii)<=30
                clusterStartHLR(iChan,4)=1;
            elseif ii3(ii)>=31 && ii3(ii)<=35
                clusterStartHLR(iChan,5)=1;
            elseif ii3(ii)>=36 && ii3(ii)<=40
                clusterStartHLR(iChan,6)=1;
            end
        end
    end
    clear ii3
 
       
    SigClusterSizeHLR(iChan)=max(ii2);
    else
        SigClusterSizeHLR(iChan)=0;
    end
    clear ii2
end

iiHLR=find(SigClusterSizeHLR>=ClusterSize);






pvalsSNWWR=zeros(size(pvalsWNWR,1),size(pvalsWNWR,2));
iiS=find(pvalsWNWR>.99);
pvalsSNWWR(iiS)=1;



pvalsSLHR=zeros(size(pvalsHLR,1),size(pvalsHLR,2));
iiS=find(pvalsHLR>.99);
pvalsSLHR(iiS)=1;



clusterStartNWWR=zeros(size(Spec_Chan_All,2),6);
for iChan=1:size(pvalsSNWWR,1);

    tmp=bwconncomp(sq(pvalsSNWWR(iChan,:)));
    if size(tmp.PixelIdxList,2)>0
    for ii=1:size(tmp.PixelIdxList,2);
        ii2(ii)=size(tmp.PixelIdxList{ii},1);
    end
    
    ii2B=find(ii2>=ClusterSize);
    if length(ii2B)>0
        for ii=1:length(ii2B);
            ii3(ii)=tmp.PixelIdxList{ii2B(ii)}(1);
            if ii3(ii)>=11 && ii3(ii)<=15
                clusterStartNWWR(iChan,1)=1;
            elseif ii3(ii)>=16 && ii3(ii)<=20
                clusterStartNWWR(iChan,2)=1;
            elseif ii3(ii)>=21 && ii3(ii)<=25
                clusterStartNWWR(iChan,3)=1;
            elseif ii3(ii)>=26 && ii3(ii)<=30
                clusterStartNWWR(iChan,4)=1;
            elseif ii3(ii)>=31 && ii3(ii)<=35
                clusterStartNWWR(iChan,5)=1;
            elseif ii3(ii)>=36 && ii3(ii)<=40
                clusterStartNWWR(iChan,6)=1;
            end
        end
    end
    clear ii3
 
       
    SigClusterSizeNWWR(iChan)=max(ii2);
    else
        SigClusterSizeNWWR(iChan)=0;
    end
    clear ii2
end

iiNWWR=find(SigClusterSizeNWWR>=ClusterSize);

clusterStartLHR=zeros(size(Spec_Chan_All,2),6);
for iChan=1:size(pvalsSLHR,1);

    tmp=bwconncomp(sq(pvalsSLHR(iChan,:)));
    if size(tmp.PixelIdxList,2)>0
    for ii=1:size(tmp.PixelIdxList,2);
        ii2(ii)=size(tmp.PixelIdxList{ii},1);
    end
    
    ii2B=find(ii2>=ClusterSize);
    if length(ii2B)>0
        for ii=1:length(ii2B);
            ii3(ii)=tmp.PixelIdxList{ii2B(ii)}(1);
            if ii3(ii)>=11 && ii3(ii)<=15
                clusterStartLHR(iChan,1)=1;
            elseif ii3(ii)>=16 && ii3(ii)<=20
                clusterStartLHR(iChan,2)=1;
            elseif ii3(ii)>=21 && ii3(ii)<=25
                clusterStartLHR(iChan,3)=1;
            elseif ii3(ii)>=26 && ii3(ii)<=30
                clusterStartLHR(iChan,4)=1;
            elseif ii3(ii)>=31 && ii3(ii)<=35
                clusterStartLHR(iChan,5)=1;
            elseif ii3(ii)>=36 && ii3(ii)<=40
                clusterStartLHR(iChan,6)=1;
            end
        end
    end
    clear ii3
 
       
    SigClusterSizeLHR(iChan)=max(ii2);
    else
        SigClusterSizeLHR(iChan)=0;
    end
    clear ii2
end

iiLHR=find(SigClusterSizeLHR>=ClusterSize);
