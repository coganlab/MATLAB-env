clear all

load('H:\Box Sync\CoganLab\preprocessing_documentation\environmental_task_design\proposed_w3.mat')
load('H:\Box Sync\CoganLab\preprocessing_documentation\environmental_task_design\proposed_nw3.mat')

stimIdx=zeros(length(trialInfo),1);
for iTrials=1:length(trialInfo)
    correctVals(iTrials)=trialInfo{iTrials}.RespCorrect;
    lengthVals(iTrials)=length(trialInfo{iTrials}.stimulusSounds_idx);
    reactionVals(iTrials)=trialInfo{iTrials}.ReactionTime;
    if isfield(trialInfo{iTrials},'StimulusCategory')
        if strcmp(trialInfo{iTrials}.StimulusCategory,'environment')
            stimIdx(iTrials)=1;
        elseif strcmp(trialInfo{iTrials}.StimulusCategory,'nonwords')
            stimIdx(iTrials)=2;
        elseif strcmp(trialInfo{iTrials}.StimulusCategory,'words')
            stimIdx(iTrials)=3;
        end
    elseif isfield(trialInfo{iTrials},'StimlusCategory')
        if strcmp(trialInfo{iTrials}.StimlusCategory,'environment')
            stimIdx(iTrials)=1;
        elseif strcmp(trialInfo{iTrials}.StimlusCategory,'nonwords')
            stimIdx(iTrials)=2;
        elseif strcmp(trialInfo{iTrials}.StimlusCategory,'words')
            stimIdx(iTrials)=3;
        end
    end
end



iiW=find(stimIdx==3);
iiNW=find(stimIdx==2);
iiE=find(stimIdx==1);
correctW=mean(correctVals(iiW));
correctNW=mean(correctVals(iiNW));
correctE=mean(correctVals(iiE));

for iTrials=1:length(iiW);
    for iS=1:length(proposed_w)
        tmp=trialInfo{iiW(iTrials)}.probeSound_name;
        tmp=tmp(1:end-4);
        if strcmp(tmp,proposed_w(iS).Word)
            imagVals(iTrials)=proposed_w(iS).imaginability;
        end
    end
end

for iTrials=1:length(iiW);
    for iS=1:length(proposed_w)
        for iSL=1:length(trialInfo{iiW(iTrials)}.stimulusSounds_name);
            tmp=trialInfo{iiW(iTrials)}.stimulusSounds_name{iSL};
            tmp=tmp(1:end-4);
            if strcmp(tmp,proposed_w(iS).Word)
                imagValsMem{iTrials}(iSL)=proposed_w(iS).imaginability;
            end
        end
    end
end



iiL=find(imagVals<=5.1);
iiH=find(imagVals>5.1);
% iiL=find(imagVals<=4.7);
% iiM=find(imagVals>4.7 & imagVals<=5.5);
% iiH=find(imagVals>5.5);

imagHighCorrect=mean(correctVals(iiW(iiH)))
%imagMediumCorrect=mean(correctVals(iiW(iiM)))
imagLowCorrect=mean(correctVals(iiW(iiL)))
 
% mean(lengthVals(iiW(iiH)))
% mean(lengthVals(iiW(iiL)))
mean(reactionVals(iiW(iiH)))
mean(reactionVals(iiW(iiL)))

[r p]=corrcoef(imagVals,reactionVals(iiW))


for iTrials=1:length(iiL)
    iiLMem(iTrials)=mean(imagValsMem{iiL(iTrials)});
end

for iTrials=1:length(iiH)
    iiHMem(iTrials)=mean(imagValsMem{iiH(iTrials)});
end

for iTrials=1:length(imagValsMem)
    iiMem(iTrials)=mean(imagValsMem{iTrials});
end

iiMemL=find(iiMem<5.1);
iiMemH=find(iiMem>=5.1);

imagHighMemCorrect=mean(correctVals(iiW(iiMemH)))
imagLowMemCorrect=mean(correctVals(iiW(iiMemL)))