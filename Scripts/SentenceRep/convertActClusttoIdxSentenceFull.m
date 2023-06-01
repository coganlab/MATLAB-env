function  [iiLSSA iiJLSA iiLSSP iiJLSP iiLSSD iiJLSD sigMatLSSA sigMatJLSA sigMatLSSP sigMatJLSP sigMatLSSD sigMatJLSD ]=convertActClusttoIdxSentenceFull(actClustLSA,actClustJLA,actClustLSP,actClustJLP,actClustLSD,actClustJLD,zVal);   


actClust=actClustLSA;
sigMat=zeros(length(actClust),120);
counter=0;
iiVal=[];
for iChan=1:length(actClust)
    if zVal==0
        for iS=1:length(actClust(iChan).Size)
            if iscell(actClust(iChan).Size)
                
                if actClust(iChan).Size{iS}>actClust(iChan).perm95
                    iiVal(counter+1)=iChan;
                    sigMat(iChan,actClust(iChan).Start{iS}:actClust(iChan).Start{iS}+actClust(iChan).Size{iS}-1)=1;
                    counter=counter+1;
                end
            end
        end
    elseif zVal==1
        for iS=1:length(actClust{iChan}.Size)
            if iscell(actClust{iChan}.Size)
                if actClust{iChan}.Z{iS}>actClust{iChan}.permZ95
                    iiVal(counter+1)=iChan;
                    sigMat(iChan,actClust{iChan}.Start{iS}:actClust{iChan}.Start{iS}+actClust{iChan}.Size{iS}-1)=1;
                    counter=counter+1;
                end
            end
        end
    end
end
iiLSSA=iiVal;
sigMatLSSA=sigMat;



actClust=actClustJLA;
sigMat=zeros(length(actClust),120);
counter=0;
iiVal=[];
for iChan=1:length(actClust)
    if zVal==0
        for iS=1:length(actClust(iChan).Size)
            if iscell(actClust(iChan).Size)
                
                if actClust(iChan).Size{iS}>actClust(iChan).perm95
                    iiVal(counter+1)=iChan;
                    sigMat(iChan,actClust(iChan).Start{iS}:actClust(iChan).Start{iS}+actClust(iChan).Size{iS}-1)=1;
                    counter=counter+1;
                end
            end
        end
    elseif zVal==1
        for iS=1:length(actClust{iChan}.Size)
            if iscell(actClust{iChan}.Size)
                if actClust{iChan}.Z{iS}>actClust{iChan}.permZ95
                    iiVal(counter+1)=iChan;
                    sigMat(iChan,actClust{iChan}.Start{iS}:actClust{iChan}.Start{iS}+actClust{iChan}.Size{iS}-1)=1;
                    counter=counter+1;
                end
            end
        end
    end
end
iiJLSA=iiVal;
sigMatJLSA=sigMat;

actClust=actClustLSP;
sigMat=zeros(length(actClust),120);
counter=0;
iiVal=[];
for iChan=1:length(actClust)
    if zVal==0
        for iS=1:length(actClust(iChan).Size)
            if iscell(actClust(iChan).Size)
                
                if actClust(iChan).Size{iS}>actClust(iChan).perm95
                    iiVal(counter+1)=iChan;
                    sigMat(iChan,actClust(iChan).Start{iS}:actClust(iChan).Start{iS}+actClust(iChan).Size{iS}-1)=1;
                    counter=counter+1;
                end
            end
        end
    elseif zVal==1
        for iS=1:length(actClust{iChan}.Size)
            if iscell(actClust{iChan}.Size)
                if actClust{iChan}.Z{iS}>actClust{iChan}.permZ95
                    iiVal(counter+1)=iChan;
                    sigMat(iChan,actClust{iChan}.Start{iS}:actClust{iChan}.Start{iS}+actClust{iChan}.Size{iS}-1)=1;
                    counter=counter+1;
                end
            end
        end
    end
end
iiLSSP=iiVal;
sigMatLSSP=sigMat;



actClust=actClustJLP;
sigMat=zeros(length(actClust),120);
counter=0;
iiVal=[];
for iChan=1:length(actClust)
    if zVal==0
        for iS=1:length(actClust(iChan).Size)
            if iscell(actClust(iChan).Size)
                
                if actClust(iChan).Size{iS}>actClust(iChan).perm95
                    iiVal(counter+1)=iChan;
                    sigMat(iChan,actClust(iChan).Start{iS}:actClust(iChan).Start{iS}+actClust(iChan).Size{iS}-1)=1;
                    counter=counter+1;
                end
            end
        end
    elseif zVal==1
        for iS=1:length(actClust{iChan}.Size)
            if iscell(actClust{iChan}.Size)
                if actClust{iChan}.Z{iS}>actClust{iChan}.permZ95
                    iiVal(counter+1)=iChan;
                    sigMat(iChan,actClust{iChan}.Start{iS}:actClust{iChan}.Start{iS}+actClust{iChan}.Size{iS}-1)=1;
                    counter=counter+1;
                end
            end
        end
    end
end
iiJLSP=iiVal;
sigMatJLSP=sigMat;

actClust=actClustLSD;
sigMat=zeros(length(actClust),40);
counter=0;
iiVal=[];
for iChan=1:length(actClust)
    if zVal==0
        for iS=1:length(actClust(iChan).Size)
            if iscell(actClust(iChan).Size)
                
                if actClust(iChan).Size{iS}>actClust(iChan).perm95
                    iiVal(counter+1)=iChan;
                    sigMat(iChan,actClust(iChan).Start{iS}:actClust(iChan).Start{iS}+actClust(iChan).Size{iS}-1)=1;
                    counter=counter+1;
                end
            end
        end
    elseif zVal==1
        for iS=1:length(actClust{iChan}.Size)
            if iscell(actClust{iChan}.Size)
                if actClust{iChan}.Z{iS}>actClust{iChan}.permZ95
                    iiVal(counter+1)=iChan;
                    sigMat(iChan,actClust{iChan}.Start{iS}:actClust{iChan}.Start{iS}+actClust{iChan}.Size{iS}-1)=1;
                    counter=counter+1;
                end
            end
        end
    end
end
iiLSSD=iiVal;
sigMatLSSD=sigMat;

actClust=actClustJLD;
sigMat=zeros(length(actClust),40);
counter=0;
iiVal=[];
for iChan=1:length(actClust)
    if zVal==0
        for iS=1:length(actClust(iChan).Size)
            if iscell(actClust(iChan).Size)
                
                if actClust(iChan).Size{iS}>actClust(iChan).perm95
                    iiVal(counter+1)=iChan;
                    sigMat(iChan,actClust(iChan).Start{iS}:actClust(iChan).Start{iS}+actClust(iChan).Size{iS}-1)=1;
                    counter=counter+1;
                end
            end
        end
    elseif zVal==1
        for iS=1:length(actClust{iChan}.Size)
            if iscell(actClust{iChan}.Size)
                if actClust{iChan}.Z{iS}>actClust{iChan}.permZ95
                    iiVal(counter+1)=iChan;
                    sigMat(iChan,actClust{iChan}.Start{iS}:actClust{iChan}.Start{iS}+actClust{iChan}.Size{iS}-1)=1;
                    counter=counter+1;
                end
            end
        end
    end
end
iiJLSD=iiVal;
sigMatJLSD=sigMat;


