for iTrials=1:length(Trials);
    condVals(iTrials)=Trials(iTrials).StartCode;
end
ii=find(condVals<=4);
ii2=setdiff(1:length(Trials),ii);
for iTrials=1:length(ii);
    ResponseCorrect(iTrials)=Trials(ii(iTrials)).ResponseCorrect;
end
ResponseIncorrect=ones(length(ii),1);
iiT=find(ResponseCorrect==1);
ResponseIncorrect(iiT)=0;

for iTrials=1:length(ii);
    Trials(ii(iTrials)).Incorrect=ResponseIncorrect(iTrials);
end
for iTrials=1:length(ii2);
    Trials(ii2(iTrials)).Incorrect=0;
end