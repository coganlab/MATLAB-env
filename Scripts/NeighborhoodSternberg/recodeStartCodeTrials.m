function Trials2=recodeStartCodeTrials(Trials);
Trials2=Trials;
for iTrials=1:length(Trials2);
    Trials2(iTrials).StartCode=1;
    Trials2(iTrials).Start=Trials2(iTrials).FirstStimAuditory;
    Trials2(iTrials).RespOnset=Trials2(iTrials).ListenCueOnset+30000*Trials2(iTrials).ReactionTime;
end
