  function  [sigMatA,zValsRawA]=convertActClust1(actClustA,zValsRawActA,SN);

    if SN==23
sigMatA=zeros(length(actClustA),5,31);


zValsRawA=zeros(length(actClustA),5,31);

    else
sigMatA=zeros(length(actClustA),5,49);

zValsRawA=zeros(length(actClustA),5,48);
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
 
    
  
    
       zVals=zValsRawActA;
    for iChan=1:length(zVals)
        for iF=1:5;
            zValsRawA(iChan,iF,:)=zVals{iChan}{iF};
        end
    end
    
     