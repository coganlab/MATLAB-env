clear all

load('H:\Box Sync\CoganLab\preprocessing_documentation\environmental_task_design\proposed_w3.mat')
load('H:\Box Sync\CoganLab\preprocessing_documentation\environmental_task_design\proposed_nw3.mat')

% doesn't correlate!
% for iS=1:length(proposed_w);
%     imagW(iS)=proposed_w(iS).imaginability;
%     freqW(iS)=proposed_w(iS).SFreq;
% end

Subject=[];
Subject(34).Name='E34'; Subject(34).Directory='E34_Environmental_Sternberg_20197101455';
Subject(35).Name='E35'; Subject(35).Directory='E35_Environmental_Sternberg_2019712117';
Subject(36).Name='E36'; Subject(36).Directory='E36_Environmental_Sternberg_201987140';
Subject(37).Name='E37'; Subject(37).Directory='E37_Environmental_Sternberg_20198141047';
Subject(38).Name='E38'; Subject(38).Directory='E38_Environmental_Sternberg_201981691';
Subject(39).Name='E39'; Subject(39).Directory='E39_Environmental_Sternberg_2019822119';
Subject(40).Name='E40'; Subject(40).Directory='E40_Environmental_Sternberg_20191081513';
Subject(41).Name='E41'; Subject(41).Directory='E41_Environmental_Sternberg_201910241552';
Subject(32+100).Name='D32'; 
Subject(34+100).Name='D34';
Subject(35+100).Name='D35';
Subject(37+100).Name='D37';
Subject(38+100).Name='D38';


SNList=[34:41,132,134,135,137,138];

for iSN=1:length(SNList);
    SN=SNList(iSN);
    if SN<=41
    load(['H:\Box Sync\CoganLab\EEG\Data\' Subject(SN).Name '\Behavioral_Data(PTB)\' ...
        Subject(SN).Directory '\' Subject(SN).Name '_Block_1_TrialData.mat']);
    else
    load(['H:\Box Sync\CoganLab\ECoG_Task_Data\Cogan_Task_Data\' Subject(SN).Name '\Environmental Sternberg\' ... 
        Subject(SN).Name '_Environmental_Sternberg_trialInfo.mat'])
    end

% find categories of stimuli    
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


% index categories
iiW=find(stimIdx==3);
iiNW=find(stimIdx==2);
iiE=find(stimIdx==1);

correctW(iSN)=mean(correctVals(iiW));
correctNW(iSN)=mean(correctVals(iiNW));
correctE(iSN)=mean(correctVals(iiE));

correctW2(iSN,1)=mean(correctVals(intersect(iiW,find(lengthVals==3))));
correctW2(iSN,2)=mean(correctVals(intersect(iiW,find(lengthVals==5))));
correctW2(iSN,3)=mean(correctVals(intersect(iiW,find(lengthVals==7))));
correctW2(iSN,4)=mean(correctVals(intersect(iiW,find(lengthVals==9))));


correctNW2(iSN,1)=mean(correctVals(intersect(iiNW,find(lengthVals==3))));
correctNW2(iSN,2)=mean(correctVals(intersect(iiNW,find(lengthVals==5))));
correctNW2(iSN,3)=mean(correctVals(intersect(iiNW,find(lengthVals==7))));
correctNW2(iSN,4)=mean(correctVals(intersect(iiNW,find(lengthVals==9))));

correctE2(iSN,1)=mean(correctVals(intersect(iiE,find(lengthVals==3))));
correctE2(iSN,2)=mean(correctVals(intersect(iiE,find(lengthVals==5))));
correctE2(iSN,3)=mean(correctVals(intersect(iiE,find(lengthVals==7))));
correctE2(iSN,4)=mean(correctVals(intersect(iiE,find(lengthVals==9))));

% imag values for probe
imagVals=[];
for iTrials=1:length(iiW);
    for iS=1:length(proposed_w)
        tmp=trialInfo{iiW(iTrials)}.probeSound_name;
        tmp=tmp(1:end-4);
        if strcmp(tmp,proposed_w(iS).Word)
            imagVals(iTrials)=proposed_w(iS).imaginability;
        end
    end
end


% freq values for probe
freqVals=[];
for iTrials=1:length(iiW);
    for iS=1:length(proposed_w)
        tmp=trialInfo{iiW(iTrials)}.probeSound_name;
        tmp=tmp(1:end-4);
        if strcmp(tmp,proposed_w(iS).Word)
            freqVals(iTrials)=proposed_w(iS).SFreq;
        end
    end
end

iiFL=find(freqVals<=6);
iiFH=find(freqVals>6);


% imag values for memory
imagValsMem={};
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

% frequency values for memory
freqValsMem={};
for iTrials=1:length(iiW);
    for iS=1:length(proposed_w)
        for iSL=1:length(trialInfo{iiW(iTrials)}.stimulusSounds_name);
            tmp=trialInfo{iiW(iTrials)}.stimulusSounds_name{iSL};
            tmp=tmp(1:end-4);
            if strcmp(tmp,proposed_w(iS).Word)
                freqValsMem{iTrials}(iSL)=proposed_w(iS).SFreq;
            end
        end
    end
end

% index high and low imag values for probe
iiL=find(imagVals<=5.1);
iiH=find(imagVals>5.1);
% iiL=find(imagVals<=4.7);
% iiM=find(imagVals>4.7 & imagVals<=5.5);
% iiH=find(imagVals>5.5);

% find mean of correct values for high and low imag in probe
imagHighCorrect(iSN)=mean(correctVals(iiW(iiH)));
%imagMediumCorrect=mean(correctVals(iiW(iiM)))
imagLowCorrect(iSN)=mean(correctVals(iiW(iiL)));
 

% find mean of reaction time values for high and low imag in probe
imagHighReaction(iSN)=mean(reactionVals(iiW(iiH)));
imagLowReaction(iSN)=mean(reactionVals(iiW(iiL)));

%[r p]=corrcoef(imagVals,reactionVals(iiW))

% find mean of correct values for high and low imag in mem

iiLMem=[];
for iTrials=1:length(iiL)
    iiLMem(iTrials)=mean(imagValsMem{iiL(iTrials)});
end

iiHMem=[];
for iTrials=1:length(iiH)
    iiHMem(iTrials)=mean(imagValsMem{iiH(iTrials)});
end

iiMem=[];
for iTrials=1:length(imagValsMem)
    iiMem(iTrials)=mean(imagValsMem{iTrials});
end

iiFreqMem=[];
for iTrials=1:length(freqValsMem)
    iiFreqMem(iTrials)=mean(freqValsMem{iTrials});
end

% index high and low imag values for mem
iiMemL=find(iiMem<=median(iiMem));
iiMemH=find(iiMem>median(iiMem));

iiFreqMemL=find(iiFreqMem<=median(iiFreqMem));
iiFreqMemH=find(iiFreqMem>median(iiFreqMem));

% find mean of correct values for high and low imag in mem
imagHighMemCorrect(iSN)=mean(correctVals(iiW(iiMemH)));
imagLowMemCorrect(iSN)=mean(correctVals(iiW(iiMemL)));

% find mean of reaction time values for high and low imag in mem
imagHighMemReaction(iSN)=mean(reactionVals(iiW(iiMemH)));
imagLowMemReaction(iSN)=mean(reactionVals(iiW(iiMemL)));

% find mean of correct values for high and low freq in mem

freqHighMemCorrect(iSN)=mean(correctVals(iiW(iiFreqMemH)));
freqLowMemCorrect(iSN)=mean(correctVals(iiW(iiFreqMemL)));

% find mean of reaction time values for high and low freq in mem
freqHighMemReaction(iSN)=mean(reactionVals(iiW(iiFreqMemH)));
freqLowMemReaction(iSN)=mean(reactionVals(iiW(iiFreqMemL)));


correctWHI2(iSN,1)=mean(correctVals(intersect(iiW(iiMemH),find(lengthVals==3))));
correctWHI2(iSN,2)=mean(correctVals(intersect(iiW(iiMemH),find(lengthVals==5))));
correctWHI2(iSN,3)=mean(correctVals(intersect(iiW(iiMemH),find(lengthVals==7))));
correctWHI2(iSN,4)=mean(correctVals(intersect(iiW(iiMemH),find(lengthVals==9))));

correctWLI2(iSN,1)=mean(correctVals(intersect(iiW(iiMemL),find(lengthVals==3))));
correctWLI2(iSN,2)=mean(correctVals(intersect(iiW(iiMemL),find(lengthVals==5))));
correctWLI2(iSN,3)=mean(correctVals(intersect(iiW(iiMemL),find(lengthVals==7))));
correctWLI2(iSN,4)=mean(correctVals(intersect(iiW(iiMemL),find(lengthVals==9))));

correctWHF2(iSN,1)=mean(correctVals(intersect(iiW(iiFreqMemH),find(lengthVals==3))));
correctWHF2(iSN,2)=mean(correctVals(intersect(iiW(iiFreqMemH),find(lengthVals==5))));
correctWHF2(iSN,3)=mean(correctVals(intersect(iiW(iiFreqMemH),find(lengthVals==7))));
correctWHF2(iSN,4)=mean(correctVals(intersect(iiW(iiFreqMemH),find(lengthVals==9))));

correctWLF2(iSN,1)=mean(correctVals(intersect(iiW(iiFreqMemL),find(lengthVals==3))));
correctWLF2(iSN,2)=mean(correctVals(intersect(iiW(iiFreqMemL),find(lengthVals==5))));
correctWLF2(iSN,3)=mean(correctVals(intersect(iiW(iiFreqMemL),find(lengthVals==7))));
correctWLF2(iSN,4)=mean(correctVals(intersect(iiW(iiFreqMemL),find(lengthVals==9))));

end