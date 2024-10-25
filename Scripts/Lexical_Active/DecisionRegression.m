HW=dir(['H:\Box Sync\CoganLab\acoustic_phoneme\highwords\']);
LW=dir(['H:\Box Sync\CoganLab\acoustic_phoneme\lowwords\']);
HNW=dir(['H:\Box Sync\CoganLab\acoustic_phoneme\highnonwords\']);
LNW=dir(['H:\Box Sync\CoganLab\acoustic_phoneme\lownonwords\']);
HW=HW(3:end);
LW=LW(3:end);
HNW=HNW(3:end);
LNW=LNW(3:end);

snValsAll=[];
condIdxAll=[];
rtValsAll=[];
rtValsNAll=[];
wordIdxAll=[];
correctValsAll=[];
noResponseIdxAll=[];

Subject(24).Name='D24'; Subject(24).Prefix = '/Lexical/D24_LexWithinNoDelay';
Subject(25).Name='D25'; Subject(25).Prefix = '/Lexical/D25_LexWithinNoDelay';
Subject(26).Name='D26'; Subject(26).Prefix = '/Lexical/D26_LexWithinNoDelay';
Subject(27).Name='D27'; Subject(27).Prefix = '/Lexical/D27_LexWithinNoDelay';
Subject(28).Name='D28'; Subject(28).Prefix = '/Lexical/D28_LexWithinNoDelay';
Subject(29).Name='D29'; Subject(29).Prefix = '/Lexical/D29_LexWithinNoDelay';

SNList=[24:29];
for iSN=1:length(SNList);
    clear correctVals
    clear rtVals
    clear trialIdx
    clear wordIdx
    clear condIdx
    clear noResponseIdx
    
    SN=SNList(iSN);
    load(['H:\Box Sync\CoganLab\ECoG_Task_Data\Cogan_Task_Data\' Subject(SN).Name '\Lexical\' Subject(SN).Name '_LexWithinNoDelay.mat'])
    counter=0;

    for iTrials=1:length(trialInfo);
        if strcmp(trialInfo{iTrials}.cue,'Yes/No');
            rtVals(counter+1)=trialInfo{iTrials}.ReactionTime;
            correctVals(counter+1)=trialInfo{iTrials}.RespCorrect;
            trialIdx(counter+1)=iTrials;
            if strcmp(trialInfo{iTrials}.Omission,'No Response')
                noResponseIdx(counter+1)=1;
            else
                noResponseIdx(counter+1)=0;
            end
            if trialInfo{iTrials}.Trigger<100
                wordIdx(counter+1)=1;
            else
                wordIdx(counter+1)=0;
            end
            for iT=1:42;
                if strcmp(trialInfo{iTrials}.sound,HW(iT).name)
                    condIdx(counter+1)=1;
                elseif strcmp(trialInfo{iTrials}.sound,LW(iT).name)
                    condIdx(counter+1)=2;
                elseif strcmp(trialInfo{iTrials}.sound,HNW(iT).name)
                    condIdx(counter+1)=3;
                elseif strcmp(trialInfo{iTrials}.sound,LNW(iT).name)
                    condIdx(counter+1)=4;
                end
            end
            counter=counter+1;
        end
    end
    snVals=SN*ones(1,length(rtVals));

    iiOut=find(noResponseIdx==1);
    rtVals(iiOut)=[];
    snVals(iiOut)=[];
    correctVals(iiOut)=[];
    wordIdx(iiOut)=[];
    condIdx(iiOut)=[];
    rtValsN=(rtVals-mean(rtVals))./std(rtVals);
    
%     iiOut=find(abs(rtValsN)>3);
%     rtVals(iiOut)=[];
%     snVals(iiOut)=[];
%     correctVals(iiOut)=[];
%     wordIdx(iiOut)=[];
%     condIdx(iiOut)=[];
%     rtValsN(iiOut)=[];

    snValsAll=cat(2,snValsAll,snVals);
    condIdxAll=cat(2,condIdxAll,condIdx);
    rtValsAll=cat(2,rtValsAll,rtVals);
    rtValsNAll=cat(2,rtValsNAll,rtValsN);
    correctValsAll=cat(2,correctValsAll,correctVals);
    wordIdxAll=cat(2,wordIdxAll,wordIdx);
end



phonemeIdxAll=zeros(1,length(wordIdxAll));
idxHW=find(condIdxAll==1);
idxHNW=find(condIdxAll==3);
idxLW=find(condIdxAll==2);
idxLNW=find(condIdxAll==4);
phonemeIdxAll(idxHW)=1;
phonemeIdxAll(idxHNW)=1;


% rtNOut1=find(abs(rtValsNAll)>2);
% rtNOut2=find(noResponseIdxAll==1);
% rtNOut=unique(cat(2,rtNOut1,rtNOut2));
% %rtNOut=find(rtValsNAll>2);
% rtValsAll(rtNOut)=[];
% rtValsNAll(rtNOut)=[];
% correctValsAll(rtNOut)=[];
% snValsAll(rtNOut)=[];
% wordIdxAll(rtNOut)=[];
% phonemeIdxAll(rtNOut)=[];
% condIdxAll(rtNOut)=[];

groups=cat(1,wordIdxAll,phonemeIdxAll);
t= table(rtValsAll',rtValsNAll',correctValsAll',snValsAll',wordIdxAll',phonemeIdxAll', ...
    'VariableNames',{'RT','RTN','Correct','Subject','Lex','Phono'});

t.Correct=categorical(t.Correct);
t.Subject=categorical(t.Subject);
t.Lex=categorical(t.Lex);
t.Phono=categorical(t.Phono);
%FULL!
mdl_CORR=fitglm(t,'Correct~Lex*Phono','Distribution','binomial');
mdl_RT=fitlme(t,'RT~Lex*Phono+(1|Subject)');
%mdl_RT=fitlme(t,'RT~Lex+Phono+(1|Subject)');
mdl_RTN=fitglm(t,'RTN~Lex*Phono','Distribution','normal');
%mdl_RTN=fitglm(t,'RTN~Lex+Phono','Distribution','normal');


[P,T,STATS,TERMS]=anovan(rtValsNAll',groups','model','interaction');