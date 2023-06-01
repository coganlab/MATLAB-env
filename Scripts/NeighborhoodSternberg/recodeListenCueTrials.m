function Trials2=recodeListenCueTrials(Trials);
Trials2=Trials;
for iTrials=1:length(Trials2);
    Trials2(iTrials).ListenCue=floor(Trials(iTrials).FirstStimAuditory-.8*30000);
end
