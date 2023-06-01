idxVals=1:925; %iiNWonly; %subj_labels_NWM;
%idxVals=intersect(iiWNWA,subj_labels_NWM);
frontalIdxLH=[];
precentralIdxLH=[];
postcentralIdxLH=[];
parietalIdxLH=[];
cingulateIdxLH=[];
hippoIdxLH=[];
insulaIdxLH=[];
parsIdxLH=[];
supramIdxLH=[];
stsIdxLH=[];
temporalIdxLH=[];

frontalIdxRH=[];
precentralIdxRH=[];
postcentralIdxRH=[];
parietalIdxRH=[];
cingulateIdxRH=[];
hippoIdxRH=[];
insulaIdxRH=[];
parsIdxRH=[];
supramIdxRH=[];
stsIdxRH=[];
temporalIdxRH=[];

for iChan=1:length(idxVals);
    if contains(subj_labels_loc{idxVals(iChan)},'frontal') && contains(subj_labels_loc{idxVals(iChan)},'lh')
        frontalIdxLH=cat(1,frontalIdxLH,iChan);
    elseif contains(subj_labels_loc{idxVals(iChan)},'precentral') && contains(subj_labels_loc{idxVals(iChan)},'lh')
        precentralIdxLH=cat(1,precentralIdxLH,iChan);
    elseif contains(subj_labels_loc{idxVals(iChan)},'postcentral') && contains(subj_labels_loc{idxVals(iChan)},'lh')
        postcentralIdxLH=cat(1,postcentralIdxLH,iChan);
    elseif contains(subj_labels_loc{idxVals(iChan)},'parietal') && contains(subj_labels_loc{idxVals(iChan)},'lh')
        parietalIdxLH=cat(1,parietalIdxLH,iChan);
    elseif contains(subj_labels_loc{idxVals(iChan)},'supramarginal') && contains(subj_labels_loc{idxVals(iChan)},'lh')
        supramIdxLH=cat(1,supramIdxLH,iChan);
    elseif contains(subj_labels_loc{idxVals(iChan)},'cingulate') && contains(subj_labels_loc{idxVals(iChan)},'lh')
        cingulateIdxLH=cat(1,cingulateIdxLH,iChan);
    elseif contains(subj_labels_loc{idxVals(iChan)},'hipp') || contains(subj_labels_loc{idxVals(iChan)},'Hipp') && contains(subj_labels_loc{idxVals(iChan)},'lh')
        hippoIdxLH=cat(1,hippoIdxLH,iChan);
    elseif contains(subj_labels_loc{idxVals(iChan)},'insula') && contains(subj_labels_loc{idxVals(iChan)},'lh')
        insulaIdxLH=cat(1,insulaIdxLH,iChan);
    elseif contains(subj_labels_loc{idxVals(iChan)},'pars') && contains(subj_labels_loc{idxVals(iChan)},'lh')
        parsIdxLH=cat(1,parsIdxLH,iChan);
    elseif contains(subj_labels_loc{idxVals(iChan)},'sts') && contains(subj_labels_loc{idxVals(iChan)},'lh')
        stsIdxLH=cat(1,stsIdxLH,iChan);
    elseif contains(subj_labels_loc{idxVals(iChan)},'temporal') && contains(subj_labels_loc{idxVals(iChan)},'lh')
        temporalIdxLH=cat(1,temporalIdxLH,iChan);
        
        
    elseif contains(subj_labels_loc{idxVals(iChan)},'frontal') && contains(subj_labels_loc{idxVals(iChan)},'rh')
        frontalIdxRH=cat(1,frontalIdxRH,iChan);
    elseif contains(subj_labels_loc{idxVals(iChan)},'precentral') && contains(subj_labels_loc{idxVals(iChan)},'rh')
        precentralIdxRH=cat(1,precentralIdxRH,iChan);
    elseif contains(subj_labels_loc{idxVals(iChan)},'postcentral') && contains(subj_labels_loc{idxVals(iChan)},'rh')
        postcentralIdxRH=cat(1,postcentralIdxRH,iChan);
    elseif contains(subj_labels_loc{idxVals(iChan)},'parietal') && contains(subj_labels_loc{idxVals(iChan)},'rh')
        parietalIdxRH=cat(1,parietalIdxRH,iChan);
    elseif contains(subj_labels_loc{idxVals(iChan)},'supramarginal') && contains(subj_labels_loc{idxVals(iChan)},'rh')
        supramIdxRH=cat(1,supramIdxRH,iChan);
    elseif contains(subj_labels_loc{idxVals(iChan)},'cingulate') && contains(subj_labels_loc{idxVals(iChan)},'rh')
        cingulateIdxRH=cat(1,cingulateIdxRH,iChan);
    elseif contains(subj_labels_loc{idxVals(iChan)},'hipp') || contains(subj_labels_loc{idxVals(iChan)},'Hipp') && contains(subj_labels_loc{idxVals(iChan)},'rh')
        hippoIdxRH=cat(1,hippoIdxRH,iChan);
    elseif contains(subj_labels_loc{idxVals(iChan)},'insula') && contains(subj_labels_loc{idxVals(iChan)},'rh')
        insulaIdxRH=cat(1,insulaIdxRH,iChan);
    elseif contains(subj_labels_loc{idxVals(iChan)},'pars') && contains(subj_labels_loc{idxVals(iChan)},'rh')
        parsIdxRH=cat(1,parsIdxRH,iChan);
    elseif contains(subj_labels_loc{idxVals(iChan)},'sts') && contains(subj_labels_loc{idxVals(iChan)},'rh')
        stsIdxRH=cat(1,stsIdxRH,iChan);
    elseif contains(subj_labels_loc{idxVals(iChan)},'temporal') && contains(subj_labels_loc{idxVals(iChan)},'rh')
        temporalIdxRH=cat(1,temporalIdxRH,iChan);
    end
    
end


idx1=(idxVals(temporalIdx));
idxA=intersect(idx1,iiA2);
display('Auditory Epoch')
display(['total active electrodes = ' num2str(length(idxA)) ' out of ' num2str(length(idx1)) ' electrodes, ' num2str(length(idxA)./length(idx1)*100) ' %'])
display(['words = ' num2str(length(intersect(idxA,iiWNWA))) ' out of ' num2str(length(idxA)) ', ' num2str(length(intersect(idxA,iiWNWA))./length(idxA).*100) ' %'])
display(['nonwords = ' num2str(length(intersect(idxA,iiNWWA))) ' out of ' num2str(length(idxA)) ', ' num2str(length(intersect(idxA,iiNWWA))./length(idxA).*100) ' %'])
display(['decision = ' num2str(length(intersect(idxA,iiDRA))) ' out of ' num2str(length(idxA)) ', ' num2str(length(intersect(idxA,iiDRA))./length(idxA).*100) ' %'])
display(['repetition = ' num2str(length(intersect(idxA,iiRDA))) ' out of ' num2str(length(idxA)) ', ' num2str(length(intersect(idxA,iiRDA))./length(idxA).*100) ' %'])
display(['High = ' num2str(length(intersect(idxA,iiHLA))) ' out of ' num2str(length(idxA)) ', ' num2str(length(intersect(idxA,iiHLA))./length(idxA).*100) ' %'])
display(['Low = ' num2str(length(intersect(idxA,iiLHA))) ' out of ' num2str(length(idxA)) ', ' num2str(length(intersect(idxA,iiLHA))./length(idxA).*100) ' %'])
display(' ')
display(' ')
display('Production Epoch')
idxP=intersect(idx1,iiP);
display(['total active electrodes = ' num2str(length(idxP)) ' out of ' num2str(length(idx1)) ' electrodes, ' num2str(length(idxP)./length(idx1)*100) ' %'])
display(['words = ' num2str(length(intersect(idxP,iiWNWP))) ' out of ' num2str(length(idxP)) ', ' num2str(length(intersect(idxP,iiWNWP))./length(idxP).*100) ' %'])
display(['nonwords = ' num2str(length(intersect(idxP,iiNWWP))) ' out of ' num2str(length(idxP)) ', ' num2str(length(intersect(idxP,iiNWWP))./length(idxP).*100) ' %'])
display(['decision = ' num2str(length(intersect(idxP,iiDRP))) ' out of ' num2str(length(idxP)) ', ' num2str(length(intersect(idxP,iiDRP))./length(idxP).*100) ' %'])
display(['repetition = ' num2str(length(intersect(idxP,iiRDP))) ' out of ' num2str(length(idxP)) ', ' num2str(length(intersect(idxP,iiRDP))./length(idxP).*100) ' %'])
display(['High = ' num2str(length(intersect(idxP,iiHLP))) ' out of ' num2str(length(idxP)) ', ' num2str(length(intersect(idxP,iiHLP))./length(idxP).*100) ' %'])
display(['Low = ' num2str(length(intersect(idxP,iiLHP))) ' out of ' num2str(length(idxP)) ', ' num2str(length(intersect(idxP,iiLHP))./length(idxP).*100) ' %'])





idx=(intersect(iiA2,iiLN));
areaVals=zeros(size(subj_labels_loc3,2),1);
areaCounter=zeros(size(subj_labels_loc3,2),1);
for iArea=1:length(subj_labels_loc3);
    for iElec=1:length(idx);
        if strcmp(subj_labels_loc2(idx(iElec)),subj_labels_loc3(iArea))
            areaVals(iArea,areaCounter(iArea)+1)=idx(iElec);
            areaCounter(iArea)=areaCounter(iArea)+1;
        end
    end
end

areaMatch=zeros(length(subj_labels_loc3),2);
for iArea1=1:length(subj_labels_loc3);
    for iArea2=iArea1+1:length(subj_labels_loc3);
        if strcmp(erase(subj_labels_loc3{iArea1},'ctx-lh-'),erase(subj_labels_loc3{iArea2},'ctx-rh-')) || strcmp(erase(subj_labels_loc3{iArea1},'Left-'),erase(subj_labels_loc3{iArea2},'Right-'))
            areaMatch(iArea1,1)=iArea1;
            areaMatch(iArea1,2)=iArea2;
        end
    end
end

ii=find(areaMatch(:,1)>0);
areaMatch2=areaMatch(ii,:);

elecLoc={};
elecCounter=zeros(length(subj_labels_loc3),1);
for iArea=1:length(subj_labels_loc3);
    for iElec=1:925;
        if strcmp(subj_labels_loc3{iArea},subj_labels_loc{iElec})
elecLoc{iArea}(elecCounter(iArea)+1)=iElec;
elecCounter(iArea)=elecCounter(iArea)+1;
        end
    end
end