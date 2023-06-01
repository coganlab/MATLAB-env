idxVals=1:925; %iiNWonly; %subj_labels_NWM;
%idxVals=intersect(iiWNWA,subj_labels_NWM);
frontalIdx=[];
%superiortemporalIdx=[];
precentralIdx=[];
postcentralIdx=[];
parietalIdx=[];
cingulateIdx=[];
hippoIdx=[];
insulaIdx=[];
parsIdx=[];
supramIdx=[];
stsIdx=[];
temporalIdx=[];

for iChan=1:length(idxVals);
    if contains(subj_labels_loc{idxVals(iChan)},'frontal')
        frontalIdx=cat(1,frontalIdx,iChan);
%     elseif contains(subj_labels_loc{idxVals(iChan)},'superiortemporal') 
%         superiortemporalIdx=cat(1,superiortemporalIdx,iChan);
     elseif contains(subj_labels_loc{idxVals(iChan)},'precentral')% || contains(subj_labels_loc{idxVals(iChan)},'postcentral');
        precentralIdx=cat(1,precentralIdx,iChan);     
    elseif contains(subj_labels_loc{idxVals(iChan)},'postcentral')
        postcentralIdx=cat(1,postcentralIdx,iChan);
    elseif contains(subj_labels_loc{idxVals(iChan)},'parietal')% || contains(subj_labels_loc{idxVals(iChan)},'supramarginal');
        parietalIdx=cat(1,parietalIdx,iChan);  
       elseif contains(subj_labels_loc{idxVals(iChan)},'supramarginal');
        supramIdx=cat(1,supramIdx,iChan);        
 elseif contains(subj_labels_loc{idxVals(iChan)},'cingulate');
        cingulateIdx=cat(1,cingulateIdx,iChan);
     elseif contains(subj_labels_loc{idxVals(iChan)},'hipp') || contains(subj_labels_loc{idxVals(iChan)},'Hipp');
        hippoIdx=cat(1,hippoIdx,iChan); 
 elseif contains(subj_labels_loc{idxVals(iChan)},'insula');
        insulaIdx=cat(1,insulaIdx,iChan);
  elseif contains(subj_labels_loc{idxVals(iChan)},'pars');
        parsIdx=cat(1,parsIdx,iChan);      
   elseif contains(subj_labels_loc{idxVals(iChan)},'sts');
        stsIdx=cat(1,stsIdx,iChan);                
    elseif contains(subj_labels_loc{idxVals(iChan)},'temporal') 
        temporalIdx=cat(1,temporalIdx,iChan);
    end
    
end

temporalIdx = union(temporalIdx,stsIdx);


idx1=(idxVals(parietalIdx));
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





% idx=find(W(:,1)>=1);
% idx=iiA2(idx);
% areaVals=zeros(size(subj_labels_loc3,2),1);
% areaCounter=zeros(size(subj_labels_loc3,2),1);
% for iArea=1:length(subj_labels_loc3);
%     for iElec=1:length(idx);
%         if strcmp(subj_labels_loc2(idx(iElec)),subj_labels_loc3(iArea))
%             areaVals(iArea,areaCounter(iArea)+1)=idx(iElec);
%             areaCounter(iArea)=areaCounter(iArea)+1;
%         end
%     end
% end
% 
% areaMatch=zeros(length(subj_labels_loc3),2);
% for iArea1=1:length(subj_labels_loc3);
%     for iArea2=iArea1+1:length(subj_labels_loc3);
%         if strcmp(erase(subj_labels_loc3{iArea1},'ctx-lh-'),erase(subj_labels_loc3{iArea2},'ctx-rh-')) || strcmp(erase(subj_labels_loc3{iArea1},'Left-'),erase(subj_labels_loc3{iArea2},'Right-'))
%             areaMatch(iArea1,1)=iArea1;
%             areaMatch(iArea1,2)=iArea2;
%         end
%     end
% end
% 
% ii=find(areaMatch(:,1)>0);
% areaMatch2=areaMatch(ii,:);
% 
% elecLoc={};
% elecCounter=zeros(length(subj_labels_loc3),1);
% for iArea=1:length(subj_labels_loc3);
%     for iElec=1:925;
%         if strcmp(subj_labels_loc3{iArea},subj_labels_loc{iElec})
% elecLoc{iArea}(elecCounter(iArea)+1)=iElec;
% elecCounter(iArea)=elecCounter(iArea)+1;
%         end
%     end
% end