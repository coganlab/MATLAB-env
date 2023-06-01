cue_events=load('cue_events.txt');
response_coding=load('response_coding.txt');

for iTrials=1:length(response_coding);
    dVal=response_coding(iTrials,1)-cue_events(:,1);
    ii1=find(dVal>0);   
    [ii jj]=sort(dVal(ii1),'ascend');
    trialGuess(iTrials)=ii1(jj(1));
end;


for iTrials=1:length(trialGuess)
    RT(iTrials,1)=response_coding(iTrials,1)-cue_events(trialGuess(iTrials),1);
    RT(iTrials,2)=condIdx2(trialGuess(iTrials));
end


