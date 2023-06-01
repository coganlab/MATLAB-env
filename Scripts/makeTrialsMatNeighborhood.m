function Trials = makeTrialsMatNeighborhood(subj,Rec,Day,FilenamePrefix,trigTimes,trialInfo,srate,trialOffset,fileNameSave)                

% subj = subject ID
% Rec = Rec Session (e.g. 001, 002, etc.)
% Day = Date YYMMDD
% FilenamePrefix = prefix of file name to read from
% trigTimes = trigger times that have been adjusted for audio latency
% trialInfo = trial Information file
% srate = sampling rate
% trialOffset = number to offset trial count by
% fileNameSave = name of output file
% Note: assumes 2 triggers per trial: one first auditory stimulus and one probe
audIdx=1:2:length(trigTimes);
probeIdx=2:2:length(trigTimes);
Trials=[];
for iTrials=1:length(trialInfo);
Trials(iTrials).Subject=subj;
Trials(iTrials).Trials=iTrials+trialOffset;
Trials(iTrials).Rec = Rec;
Trials(iTrials).Day = Day;
Trials(iTrials).FilenamePrefix = [FilenamePrefix Day];
Trials(iTrials).Auditory=round(30000*trigTimes(audIdx(iTrials))./srate);
Trials(iTrials).FirstStimAuditory=Trials(iTrials).Auditory;
Trials(iTrials).StimAuditory(1)=Trials(iTrials).Auditory;
for iS=1:length(trialInfo{iTrials}.stimulusAlignedTrigger)-1
    Trials(iTrials).StimAuditory(iS+1)=Trials(iTrials).Auditory+ ...
        round(30000*(trialInfo{iTrials}.stimulusAlignedTrigger(iS+1)-trialInfo{iTrials}.stimulusAlignedTrigger(1)));
end
Trials(iTrials).ProbeAuditory=Trials(iTrials).Auditory...
    +round(30000*(trialInfo{iTrials}.probeAudioStart-trialInfo{iTrials}.stimulusAlignedTrigger(1)));
Trials(iTrials).ListenCueOnset=Trials(iTrials).Auditory...
    -round(30000*(trialInfo{iTrials}.stimulusAlignedTrigger(1)-trialInfo{iTrials}.ListenCueOnset));
Trials(iTrials).MaintenanceOnset=Trials(iTrials).Auditory...
    +round(30000*(trialInfo{iTrials}.MaintenancePeriodOnset-trialInfo{iTrials}.stimulusAlignedTrigger(1)));
Trials(iTrials).ProbeCueTime=trigTimes(probeIdx(iTrials));
Trials(iTrials).RespCorrect=trialInfo{iTrials}.RespCorrect;
Trials(iTrials).ReactionTime=trialInfo{iTrials}.ReactionTime;
Trials(iTrials).StartCode=1;
Trials(iTrials).Start=round(30000*trigTimes(probeIdx(iTrials))./srate);
Trials(iTrials).AuditoryCode=26;
Trials(iTrials).Noisy=0;
Trials(iTrials).NoResponse=0;
end

save(fileNameSave,'Trials')
