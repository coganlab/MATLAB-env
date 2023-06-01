function behaviorMat = genBehaviorMat(subName,subPrefix,filedir); 

behaviorMat=[];
    
     load([filedir '\' subName  '\'  subPrefix '.mat'])
        trialLengthIdx = lengthIdx(trialInfo);
    condIdx = catIdx(trialInfo);
    trialCorrectIdx = correctIdx(trialInfo);
    probeValIdx = probeIdx(trialInfo);
    trialRTIdx = rtIdx(trialInfo);
    
    behaviorMat(1,:)=ones(1,160); % now a dummy variable;
    behaviorMat(2,:)=trialLengthIdx;
    behaviorMat(3,:)=condIdx;
    behaviorMat(4,:)=probeValIdx;
    
    wordIdx=find(condIdx==1 | condIdx==3);
    highIdx=find(condIdx==1 | condIdx==2);
    behaviorMat(5,wordIdx)=1;
    behaviorMat(6,highIdx)=1;
    behaviorMat(7,:)=trialCorrectIdx;
    behaviorMat(8,:)=trialRTIdx;
    behaviorMat(9,:)=(trialRTIdx-nanmean(trialRTIdx))./nanstd(trialRTIdx);
    
    probePositionVals=zeros(160,1);
    idxP=find(probeValIdx==1);
    for iP=1:length(idxP);
        pString=trialInfo{idxP(iP)}.probeSound_name;
        for iS=1:length(trialInfo{idxP(iP)}.stimulusSounds_name)
            if strcmp(pString,trialInfo{idxP(iP)}.stimulusSounds_name(iS))
                probePositionVals(idxP(iP))=iS;
            end
        end
    end
            
    behaviorMat(10,:)=probePositionVals;
    


relPos=zeros(size(behaviorMat,2),size(behaviorMat,3));
lengthList=[3,5,7,9];

    for iTrials=1:160;
        tmp=sq(behaviorMat(:,iTrials));
        if tmp(4)==1 && tmp(10)==1
            relPos(iTrials)=1;
        elseif tmp(4)==1 && tmp(10)==2
            relPos(iTrials)=2;
        elseif tmp(2)>3 && tmp(4)==1 && tmp(10)==3
            relPos(iTrials)=2;
        elseif tmp(2)==3 && tmp(4)==1 && tmp(10)==3
            relPos(iTrials)=3;
        elseif tmp(4)==1 && tmp(10)==4
            relPos(iTrials)=2;
        elseif tmp(2)>5 && tmp(4)==1 && tmp(10)==5
            relPos(iTrials)=2;
        elseif tmp(2)==5 && tmp(4)==1 && tmp(10)==5
            relPos(iTrials)=3;
        elseif tmp(4)==1 && tmp(10)==6
            relPos(iTrials)=2;
        elseif tmp(2)>7 && tmp(4)==1 && tmp(10)==7
            relPos(iTrials)=2;
        elseif tmp(2)==7 && tmp(4)==1 && tmp(10)==7
            relPos(iTrials)=3;
        elseif tmp(4)==1 && tmp(10)==8
            relPos(iTrials)=2;
        elseif tmp(4)==1 && tmp(10)==9
            relPos(iTrials)=3;
        end
    end


behaviorMat(11,:)=relPos;
