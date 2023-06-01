function [sigMatLSA, sigMatLMA, sigMatJLA, sigMatLSP, sigMatLMP, sigMatJLP]=convertActClusttoIdxSpec(actClustLSA,actClustLMA,actClustJLA,actClustLSP,actClustLMP,actClustJLP) 
fRange=102;
actClust=actClustLSA;

sigMat=zeros(length(actClust),40,fRange); % 102 for 200, 100 for 2048?
for iChan=1:length(actClust)
    tmp=zeros(40,102);
    if iscell(actClust{iChan}.Z)
        for iS=1:length(actClust{iChan}.Z)
            if actClust{iChan}.Z{iS}>actClust{iChan}.permZ95% && actClust{iChan}.Size{iS}>actClust{iChan}.perm95
                tmp(actClust{iChan}.Location{iS})=1;
            end
        end
        sigMat(iChan,:,:)=tmp;
    end
end
sigMatLSA=sigMat;

actClust=actClustLMA;

sigMat=zeros(length(actClust),40,fRange); % 102 for 200, 100 for 2048?
for iChan=1:length(actClust)
    tmp=zeros(40,102);
    if iscell(actClust{iChan}.Z)
        for iS=1:length(actClust{iChan}.Z)
            if actClust{iChan}.Z{iS}>actClust{iChan}.permZ95
                tmp(actClust{iChan}.Location{iS})=1;
            end
        end
        sigMat(iChan,:,:)=tmp;
    end
end
sigMatLMA=sigMat;

actClust=actClustJLA;

sigMat=zeros(length(actClust),40,fRange); % 102 for 200, 100 for 2048?
for iChan=1:length(actClust)
    tmp=zeros(40,102);
    if iscell(actClust{iChan}.Z)
        for iS=1:length(actClust{iChan}.Z)
            if actClust{iChan}.Z{iS}>actClust{iChan}.permZ95
                tmp(actClust{iChan}.Location{iS})=1;
            end
        end
        sigMat(iChan,:,:)=tmp;
    end
end
sigMatJLA=sigMat;


actClust=actClustLSP;

sigMat=zeros(length(actClust),40,fRange); % 102 for 200, 100 for 2048?
for iChan=1:length(actClust)
    tmp=zeros(40,102);
    if iscell(actClust{iChan}.Z)
        for iS=1:length(actClust{iChan}.Z)
            if actClust{iChan}.Z{iS}>actClust{iChan}.permZ95
                tmp(actClust{iChan}.Location{iS})=1;
            end
        end
        sigMat(iChan,:,:)=tmp;
    end
end
sigMatLSP=sigMat;

actClust=actClustLMP;

sigMat=zeros(length(actClust),40,fRange); % 102 for 200, 100 for 2048?
for iChan=1:length(actClust)
    tmp=zeros(40,102);
    if iscell(actClust{iChan}.Z)
        for iS=1:length(actClust{iChan}.Z)
            if actClust{iChan}.Z{iS}>actClust{iChan}.permZ95
                tmp(actClust{iChan}.Location{iS})=1;
            end
        end
        sigMat(iChan,:,:)=tmp;
    end
end
sigMatLMP=sigMat;

actClust=actClustJLP;

sigMat=zeros(length(actClust),40,fRange); % 102 for 200, 100 for 2048?
for iChan=1:length(actClust)
    tmp=zeros(40,102);
    if iscell(actClust{iChan}.Z)
        for iS=1:length(actClust{iChan}.Z)
            if actClust{iChan}.Z{iS}>actClust{iChan}.permZ95
                tmp(actClust{iChan}.Location{iS})=1;
            end
        end
        sigMat(iChan,:,:)=tmp;
    end
end
sigMatJLP=sigMat;