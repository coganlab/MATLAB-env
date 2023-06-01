function condIdx = catIdx(trialInfo)

% Sternberg Neighborhood
% High words = 1
% High Non-words = 2
% Low Words = 3
% Low Non-words = 4

for iTrials=1:length(trialInfo)
    
    if isfield(trialInfo{1},'StimlusCategory') && strcmp(trialInfo{iTrials}.StimlusCategory,'High Words')
        condIdx(iTrials)=1;
    elseif isfield(trialInfo{1},'StimlusCategory') && strcmp(trialInfo{iTrials}.StimlusCategory,'Low Words')
        condIdx(iTrials)=3;
    elseif isfield(trialInfo{1},'StimlusCategory') && strcmp(trialInfo{iTrials}.StimlusCategory,'High Non-Words')
        condIdx(iTrials)=2;
    elseif isfield(trialInfo{1},'StimlusCategory') && strcmp(trialInfo{iTrials}.StimlusCategory,'Low Non-words')
        condIdx(iTrials)=4;
    
    elseif isfield(trialInfo{1},'TriggerValueCondition')
    condIdx(iTrials)=trialInfo{iTrials}.TriggerValueCondition-100;
%     elseif isfield(trialInfo{1},'TriggerValue')
%     condIdx(iTrials)=trialInfo{iTrials}.TriggerValue;
    elseif isfield(trialInfo{1},'StimlusCategory') && strcmp(trialInfo{iTrials}.StimlusCategory,'environment')
    condIdx(iTrials)=1;
    elseif isfield(trialInfo{1},'StimlusCategory') && strcmp(trialInfo{iTrials}.StimlusCategory,'nonwords')
    condIdx(iTrials)=2;  
    elseif isfield(trialInfo{1},'StimlusCategory') && strcmp(trialInfo{iTrials}.StimlusCategory,'words')
    condIdx(iTrials)=3; 
      elseif isfield(trialInfo{1},'StimulusCategory') && strcmp(trialInfo{iTrials}.StimulusCategory,'environment')
    condIdx(iTrials)=1;
    elseif isfield(trialInfo{1},'StimulusCategory') && strcmp(trialInfo{iTrials}.StimulusCategory,'nonwords')
    condIdx(iTrials)=2;  
    elseif isfield(trialInfo{1},'StimulusCategory') && strcmp(trialInfo{iTrials}.StimulusCategory,'words')
    condIdx(iTrials)=3;    
    end  
end