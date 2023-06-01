nShuff=1000;
for chan=1:64;
freq=70:150; %70:150;
stimrange=[51:238]+20;
testsig1=sq(mean(Go_Spec{1}{chan}(:,101:450,freq),3));
testsig2=sq(mean(Go_Spec{2}{chan}(:,101:450,freq),3));
testsig3=sq(mean(Go_Spec{3}{chan}(:,101:450,freq),3));

testsig1s=sq(mean(Aud_Spec{1}{chan}(:,stimrange,freq),3));
testsig2s=sq(mean(Aud_Spec{2}{chan}(:,stimrange,freq),3));
testsig3s=sq(mean(Aud_Spec{3}{chan}(:,stimrange,freq),3));

testsig1_gt=testsig1(C1IDX,:);
testsig1s_gt=testsig1s(C1IDX,:);
firstSentences_gt=firstSentences(C1IDX,:);
testsig2_gt=testsig2(C2IDX,:);
testsig2s_gt=testsig2s(C2IDX,:);
secondSentences_gt=secondSentences(C2IDX,:);
testsig3_gt=testsig3(C3IDX,:);
testsig3s_gt=testsig3s(C3IDX,:);
thirdSentences_gt=secondSentences(C3IDX,:);

firstSentencesStim_gt=repmat(firstSentenceStim,1,length(C1IDX))';
secondSentencesStim_gt=repmat(secondSentenceStim,1,length(C2IDX))';
thirdSentencesStim_gt=repmat(thirdSentenceStim,1,length(C3IDX))';

testsigALL=cat(1,testsig1_gt,testsig2_gt,testsig3_gt);
testsigStimALL=cat(1,testsig1s_gt,testsig2s_gt,testsig3s_gt);
SentencesALL=cat(1,firstSentences_gt,secondSentences_gt,thirdSentences_gt);
SentencesStimALL=cat(1,firstSentencesStim_gt,secondSentencesStim_gt,thirdSentencesStim_gt);

for iTrials=1:size(testsigALL,1);
    [Rt Pt]=corrcoef(testsigALL(iTrials,:),SentencesALL(iTrials,:));
    RALLact(iTrials,:)=Rt(1,2).^2;
    [Rst Pst]=corrcoef(testsigStimALL(iTrials,:),SentencesStimALL(iTrials,:));
    RStimALLact(iTrials,:)=Rst(1,2).^2;
end

for iShuff=1:nShuff;
idx=shuffle(1:size(testsigALL,1));
for iTrials=1:size(testsigALL,1);
    [Rt Pt]=corrcoef(testsigALL(idx(iTrials),:),SentencesALL(iTrials,:));
    [Rst Pst]=corrcoef(testsigStimALL(idx(iTrials),:),SentencesStimALL(iTrials,:));
    RALLshuff(iShuff,iTrials,:)=Rt(1,2).^2;
    RStimALLshuff(iShuff,iTrials,:)=Rst(1,2).^2;
end
end

pvalALL=length(find(mean(RALLact)<sq(mean(RALLshuff,2))))./nShuff
pvalStimALL=length(find(mean(RStimALLact)<sq(mean(RStimALLshuff,2))))./nShuff
display(chan);
p2Out(chan)=pvalALL;
p2In(chan)=pvalStimALL;
end

