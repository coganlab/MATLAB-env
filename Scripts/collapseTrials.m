function trialsCollapse = collapseTrials(Trials)

for iTrials=1:length(Trials);
    Trials(iTrials).StartCode=1;
    Trials(iTrials).AuditoryCode=26;
    Trials(iTrials).DelCode=51;
    Trials(iTrials).GoCode=76;
end
trialsCollapse=Trials;