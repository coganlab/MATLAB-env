function [iiA iiP iiSM sigMatLSA sigMatLMA sigMatJLA sigMatLSP sigMatLMP sigMatJLP]=convertActClusttoIdxFreq(actClustLSA,actClustLMA,actClustJLA,actClustLSP,actClustLMP,actClustJLP,zVal)
actClust=actClustLSA;
sigMatAll=zeros(5,length(actClust),40);
for iF=1:5
sigMat=zeros(length(actClust),40);
counter=0;
iiVal=[];
for iChan=1:length(actClust)
    if zVal==0
        for iS=1:length(actClust{iChan}{iF}.Size)
            if iscell(actClust{iChan}{iF}.Size)
                
                if actClust{iChan}{iF}.Size{iS}>actClust{iChan}{iF}.perm95
                    iiVal(counter+1)=iChan;
                    sigMat(iChan,actClust{iChan}{iF}.Start{iS}:actClust{iChan}{iF}.Start{iS}+actClust{iChan}{iF}.Size{iS}-1)=1;
                    counter=counter+1;
                end
            end
        end
    elseif zVal==1
        for iS=1:length(actClust{iChan}{iF}.Size)
            if iscell(actClust{iChan}{iF}.Size)
                if actClust{iChan}{iF}.Z{iS}>actClust{iChan}{iF}.permZ95
                    iiVal(counter+1)=iChan;
                    sigMat(iChan,actClust{iChan}{iF}.Start{iS}:actClust{iChan}{iF}.Start{iS}+actClust{iChan}{iF}.Size{iS}-1)=1;
                    counter=counter+1;
                end
            end
        end
    end
end
iiLSA{iF}=iiVal;
sigMatAll(iF,:,:)=sigMat;
end
sigMatLSA=sigMatAll;

actClust=actClustLMA;
sigMatAll=zeros(5,length(actClust),40);
for iF=1:5
sigMat=zeros(length(actClust),40);
counter=0;
iiVal=[];
for iChan=1:length(actClust)
    if zVal==0
        for iS=1:length(actClust{iChan}{iF}.Size)
            if iscell(actClust{iChan}{iF}.Size)
                
                if actClust{iChan}{iF}.Size{iS}>actClust{iChan}{iF}.perm95
                    iiVal(counter+1)=iChan;
                    sigMat(iChan,actClust{iChan}{iF}.Start{iS}:actClust{iChan}{iF}.Start{iS}+actClust{iChan}{iF}.Size{iS}-1)=1;
                    counter=counter+1;
                end
            end
        end
    elseif zVal==1
        for iS=1:length(actClust{iChan}{iF}.Size)
            if iscell(actClust{iChan}{iF}.Size)
                if actClust{iChan}{iF}.Z{iS}>actClust{iChan}{iF}.permZ95
                    iiVal(counter+1)=iChan;
                    sigMat(iChan,actClust{iChan}{iF}.Start{iS}:actClust{iChan}{iF}.Start{iS}+actClust{iChan}{iF}.Size{iS}-1)=1;
                    counter=counter+1;
                end
            end
        end
    end
end
iiLMA{iF}=iiVal;
sigMatAll(iF,:,:)=sigMat;
end
sigMatLMA=sigMatAll;


actClust=actClustJLA;
sigMatAll=zeros(5,length(actClust),40);
for iF=1:5
sigMat=zeros(length(actClust),40);
counter=0;
iiVal=[];
for iChan=1:length(actClust)
    if zVal==0
        for iS=1:length(actClust{iChan}{iF}.Size)
            if iscell(actClust{iChan}{iF}.Size)
                
                if actClust{iChan}{iF}.Size{iS}>actClust{iChan}{iF}.perm95
                    iiVal(counter+1)=iChan;
                    sigMat(iChan,actClust{iChan}{iF}.Start{iS}:actClust{iChan}{iF}.Start{iS}+actClust{iChan}{iF}.Size{iS}-1)=1;
                    counter=counter+1;
                end
            end
        end
    elseif zVal==1
        for iS=1:length(actClust{iChan}{iF}.Size)
            if iscell(actClust{iChan}{iF}.Size)
                if actClust{iChan}{iF}.Z{iS}>actClust{iChan}{iF}.permZ95
                    iiVal(counter+1)=iChan;
                    sigMat(iChan,actClust{iChan}{iF}.Start{iS}:actClust{iChan}{iF}.Start{iS}+actClust{iChan}{iF}.Size{iS}-1)=1;
                    counter=counter+1;
                end
            end
        end
    end
end
iiJLA{iF}=iiVal;
sigMatAll(iF,:,:)=sigMat;
end
sigMatJLA=sigMatAll;

actClust=actClustLSP;
sigMatAll=zeros(5,length(actClust),40);
for iF=1:5
sigMat=zeros(length(actClust),40);
counter=0;
iiVal=[];
for iChan=1:length(actClust)
    if zVal==0
        for iS=1:length(actClust{iChan}{iF}.Size)
            if iscell(actClust{iChan}{iF}.Size)
                
                if actClust{iChan}{iF}.Size{iS}>actClust{iChan}{iF}.perm95
                    iiVal(counter+1)=iChan;
                    sigMat(iChan,actClust{iChan}{iF}.Start{iS}:actClust{iChan}{iF}.Start{iS}+actClust{iChan}{iF}.Size{iS}-1)=1;
                    counter=counter+1;
                end
            end
        end
    elseif zVal==1
        for iS=1:length(actClust{iChan}{iF}.Size)
            if iscell(actClust{iChan}{iF}.Size)
                if actClust{iChan}{iF}.Z{iS}>actClust{iChan}{iF}.permZ95
                    iiVal(counter+1)=iChan;
                    sigMat(iChan,actClust{iChan}{iF}.Start{iS}:actClust{iChan}{iF}.Start{iS}+actClust{iChan}{iF}.Size{iS}-1)=1;
                    counter=counter+1;
                end
            end
        end
    end
end
iiLSP{iF}=iiVal;
sigMatAll(iF,:,:)=sigMat;
end
sigMatLSP=sigMatAll;

actClust=actClustLMP;
sigMatAll=zeros(5,length(actClust),40);
for iF=1:5
sigMat=zeros(length(actClust),40);
counter=0;
iiVal=[];
for iChan=1:length(actClust)
    if zVal==0
        for iS=1:length(actClust{iChan}{iF}.Size)
            if iscell(actClust{iChan}{iF}.Size)
                
                if actClust{iChan}{iF}.Size{iS}>actClust{iChan}{iF}.perm95
                    iiVal(counter+1)=iChan;
                    sigMat(iChan,actClust{iChan}{iF}.Start{iS}:actClust{iChan}{iF}.Start{iS}+actClust{iChan}{iF}.Size{iS}-1)=1;
                    counter=counter+1;
                end
            end
        end
    elseif zVal==1
        for iS=1:length(actClust{iChan}{iF}.Size)
            if iscell(actClust{iChan}{iF}.Size)
                if actClust{iChan}{iF}.Z{iS}>actClust{iChan}{iF}.permZ95
                    iiVal(counter+1)=iChan;
                    sigMat(iChan,actClust{iChan}{iF}.Start{iS}:actClust{iChan}{iF}.Start{iS}+actClust{iChan}{iF}.Size{iS}-1)=1;
                    counter=counter+1;
                end
            end
        end
    end
end
iiLMP{iF}=iiVal;
sigMatAll(iF,:,:)=sigMat;
end
sigMatLMP=sigMatAll;

actClust=actClustJLP;
sigMatAll=zeros(5,length(actClust),40);
for iF=1:5
sigMat=zeros(length(actClust),40);
counter=0;
iiVal=[];
for iChan=1:length(actClust)
    if zVal==0
        for iS=1:length(actClust{iChan}{iF}.Size)
            if iscell(actClust{iChan}{iF}.Size)
                
                if actClust{iChan}{iF}.Size{iS}>actClust{iChan}{iF}.perm95
                    iiVal(counter+1)=iChan;
                    sigMat(iChan,actClust{iChan}{iF}.Start{iS}:actClust{iChan}{iF}.Start{iS}+actClust{iChan}{iF}.Size{iS}-1)=1;
                    counter=counter+1;
                end
            end
        end
    elseif zVal==1
        for iS=1:length(actClust{iChan}{iF}.Size)
            if iscell(actClust{iChan}{iF}.Size)
                if actClust{iChan}{iF}.Z{iS}>actClust{iChan}{iF}.permZ95
                    iiVal(counter+1)=iChan;
                    sigMat(iChan,actClust{iChan}{iF}.Start{iS}:actClust{iChan}{iF}.Start{iS}+actClust{iChan}{iF}.Size{iS}-1)=1;
                    counter=counter+1;
                end
            end
        end
    end
end
iiJLP{iF}=iiVal;
sigMatAll(iF,:,:)=sigMat;
end
sigMatJLP=sigMatAll;

for iF=1:5;
iiA1{iF}=intersect(iiLSA{iF},iiLMA{iF});
iiA2{iF}=intersect(iiA1{iF},iiJLA{iF});
iiP1{iF}=intersect(iiLSP{iF},iiLMP{iF});
iiSM{iF}=intersect(iiA1{iF},iiP1{iF});
%iiA=setdiff(iiA2,iiSM);
iiA{iF}=setdiff(iiA1{iF},iiSM{iF}); % remove dependence on JL?
iiP{iF}=setdiff(iiP1{iF},iiSM{iF});
end