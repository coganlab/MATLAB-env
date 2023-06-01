  function  [sigMatS, sigMatA, sigMatD, sigMatR zValsRawS,zValsRawA,zValsRawD,zValsRawR]=convertActClust(actClustS,actClustA,actClustD,actClustR,zValsRawActS,zValsRawActA,zValsRawActD,zValsRawActR,SN);

 
sigMatS=zeros(length(actClustS),5,size(zValsRawActS{1}{1},1));
sigMatA=zeros(length(actClustA),5,size(zValsRawActA{1}{1},1));
sigMatD=zeros(length(actClustD),5,size(zValsRawActD{1}{1},1));
sigMatR=zeros(length(actClustR),5,size(zValsRawActR{1}{1},1));

zValsRawS=zeros(length(actClustS),5,size(zValsRawActS{1}{1},1));
zValsRawA=zeros(length(actClustA),5,size(zValsRawActA{1}{1},1));
zValsRawD=zeros(length(actClustD),5,size(zValsRawActD{1}{1},1));
zValsRawR=zeros(length(actClustR),5,size(zValsRawActR{1}{1},1));

    
    actClust=actClustS;
    for iChan=1:length(actClust)  
        for iF=1:5
            clear sigMat
            sigMat=zeros(size(sigMatS,3),1);
            for iZ=1:length(actClust{iChan}{iF}.Z)
                if actClust{iChan}{iF}.Z{iZ}>actClust{iChan}{iF}.permZ95
                    sigMat(actClust{iChan}{iF}.Start{iZ}:actClust{iChan}{iF}.Start{iZ}+(actClust{iChan}{iF}.Size{iZ}-1))=1;
                end
            end
            sigMatS(iChan,iF,:,:)=sigMat;
        end
    end
 
      actClust=actClustA;
    for iChan=1:length(actClust)  
        for iF=1:5
            clear sigMat
            sigMat=zeros(size(sigMatA,3),1);
            for iZ=1:length(actClust{iChan}{iF}.Z)
                if actClust{iChan}{iF}.Z{iZ}>actClust{iChan}{iF}.permZ95
                    sigMat(actClust{iChan}{iF}.Start{iZ}:actClust{iChan}{iF}.Start{iZ}+(actClust{iChan}{iF}.Size{iZ}-1))=1;
                end
            end
            sigMatA(iChan,iF,:,:)=sigMat;
        end
    end
     actClust=actClustD;
    for iChan=1:length(actClust)  
        for iF=1:5
            clear sigMat
            sigMat=zeros(size(sigMatD,3),1);
            for iZ=1:length(actClust{iChan}{iF}.Z)
                if actClust{iChan}{iF}.Z{iZ}>actClust{iChan}{iF}.permZ95
                    sigMat(actClust{iChan}{iF}.Start{iZ}:actClust{iChan}{iF}.Start{iZ}+(actClust{iChan}{iF}.Size{iZ}-1))=1;
                end
            end
            sigMatD(iChan,iF,:,:)=sigMat;
        end
    end
     actClust=actClustR;
    for iChan=1:length(actClust)  
        for iF=1:5
            clear sigMat
            sigMat=zeros(size(sigMatR,3),1);
            for iZ=1:length(actClust{iChan}{iF}.Z)
                if actClust{iChan}{iF}.Z{iZ}>actClust{iChan}{iF}.permZ95
                    sigMat(actClust{iChan}{iF}.Start{iZ}:actClust{iChan}{iF}.Start{iZ}+(actClust{iChan}{iF}.Size{iZ}-1))=1;
                end
            end
            sigMatR(iChan,iF,:,:)=sigMat;
        end
    end
    
    zVals=zValsRawActS;
    for iChan=1:length(zVals)
        for iF=1:5;
            zValsRawS(iChan,iF,:)=zVals{iChan}{iF};
        end
    end
    
       zVals=zValsRawActA;
    for iChan=1:length(zVals)
        for iF=1:5;
            zValsRawA(iChan,iF,:)=zVals{iChan}{iF};
        end
    end
    
       zVals=zValsRawActD;
    for iChan=1:length(zVals)
        for iF=1:5;
            zValsRawD(iChan,iF,:)=zVals{iChan}{iF};
        end
    end
    
       zVals=zValsRawActR;
    for iChan=1:length(zVals)
        for iF=1:5;
            zValsRawR(iChan,iF,:)=zVals{iChan}{iF};
        end
    end
    