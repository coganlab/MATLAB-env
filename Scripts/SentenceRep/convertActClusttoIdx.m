function [iiA iiP iiSM sigMatLSA sigMatLMA sigMatJLA sigMatLSP sigMatLMP sigMatJLP]=convertActClusttoIdx(actClustLSA,actClustLMA,actClustJLA,actClustLSP,actClustLMP,actClustJLP,zVal)

actClust=actClustLSA;
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
iiLSA=iiVal;
sigMatLSA=sigMat;

actClust=actClustLMA;
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
iiLMA=iiVal;
sigMatLMA=sigMat;

actClust=actClustJLA;
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
iiJLA=iiVal;
sigMatJLA=sigMat;

actClust=actClustLSP;
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
iiLSP=iiVal;
sigMatLSP=sigMat;

actClust=actClustLMP;
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
iiLMP=iiVal;
sigMatLMP=sigMat;

actClust=actClustJLP;
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
iiJLP=iiVal;
sigMatJLP=sigMat;

iiA1=intersect(iiLSA,iiLMA);
iiA2=intersect(iiA1,iiJLA);
iiP1=intersect(iiLSP,iiLMP);
iiSM=intersect(iiA1,iiP1);
%iiA=setdiff(iiA2,iiSM);
iiA=setdiff(iiA1,iiSM); % remove dependence on JL?
iiP=setdiff(iiP1,iiSM);