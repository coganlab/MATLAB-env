HW=dir(['H:\Box Sync\CoganLab\acoustic_phoneme\highwords\']);
LW=dir(['H:\Box Sync\CoganLab\acoustic_phoneme\lowwords\']);
HNW=dir(['H:\Box Sync\CoganLab\acoustic_phoneme\highnonwords\']);
LNW=dir(['H:\Box Sync\CoganLab\acoustic_phoneme\lownonwords\']);
HW=HW(3:end);
LW=LW(3:end);
HNW=HNW(3:end);
LNW=LNW(3:end);


clear correctVals
clear rtVals
clear trialIdx
clear wordIdx
clear condIdx

counter=0;
for iTrials=1:length(trialInfo);
    if strcmp(trialInfo{iTrials}.cue,'Yes/No');
        rtVals(counter+1)=trialInfo{iTrials}.ReactionTime;
        correctVals(counter+1)=trialInfo{iTrials}.RespCorrect;
        trialIdx(counter+1)=iTrials;
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

rtValsN=(rtVals-mean(rtVals))./std(rtVals);

mean(correctVals(condIdx==1))
mean(correctVals(condIdx==2))
mean(correctVals(condIdx==3))
mean(correctVals(condIdx==4))

mean(rtVals(condIdx==1))
mean(rtVals(condIdx==2))
mean(rtVals(condIdx==3))
mean(rtVals(condIdx==4))

mean(rtValsN(condIdx==1))
mean(rtValsN(condIdx==2))
mean(rtValsN(condIdx==3))
mean(rtValsN(condIdx==4))
