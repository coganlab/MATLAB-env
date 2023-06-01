duke;
Subject={};
filedir=['H:\Box Sync\CoganLab\ECoG_Task_Data\Cogan_Task_Data'];

load('H:\Box Sync\CoganLab\preprocessing_documentation\environmental_task_design\proposed_w3.mat')
load('H:\Box Sync\CoganLab\preprocessing_documentation\environmental_task_design\proposed_nw3.mat')

Subject{27}.Name='D27'; Subject{27}.Prefix = '/Environmental Sternberg/D27_Environmental_Sternberg_trialInfo'; % 120
Subject{28}.Name='D28'; Subject{28}.Prefix = '/Environmental Sternberg/D28_Environmental_Sternberg_trialInfo'; % 120
Subject{29}.Name='D29'; Subject{29}.Prefix = '/Environmental Sternberg/D29_Environmental_Sternberg_trialInfo'; % 144
Subject{30}.Name='D30'; Subject{30}.Prefix = '/Environmental Sternberg/D30_Environmental_Sternberg_trialInfo'; % 168
Subject{31}.Name='D31'; Subject{31}.Prefix = '/Environmental Sternberg/D31_Environmental_Sternberg_trialInfo'; % 168
Subject{32}.Name='D32'; Subject{32}.Prefix = '/Environmental Sternberg/D32_Environmental_Sternberg_trialInfo'; % 168
Subject{34}.Name='D34'; Subject{34}.Prefix = '/Environmental Sternberg/D34_Environmental_Sternberg_trialInfo'; % 168
Subject{35}.Name='D35'; Subject{35}.Prefix = '/Environmental Sternberg/D35_Environmental_Sternberg_trialInfo';
Subject{37}.Name='D37'; Subject{37}.Prefix = '/Environmental Sternberg/D37_Environmental_Sternberg_trialInfo';
Subject{38}.Name='D38'; Subject{38}.Prefix = '/Environmental Sternberg/D38_Environmental_Sternberg_trialInfo';
Subject{39}.Name='D39'; Subject{39}.Prefix = '/Environmental_Sternberg/D39_Environmental_Sternberg_trialInfo';




SNList=[32,34,35,37,38,39]; % 


for iSN=1:length(SNList);
    SN=SNList(iSN);
   
 
  %  load(['H:\Box Sync\CoganLab\ECoG_Task_Data\Cogan_Task_Data\' Subject{SN}.Name '\Environmental Sternberg\' ... 
   %     Subject{SN}.Name '_Environmental_Sternberg_trialInfo.mat'])
        load(['H:\Box Sync\CoganLab\ECoG_Task_Data\Cogan_Task_Data\' Subject{SN}.Name '/' Subject{SN}.Prefix '.mat'])
    if SN==39
        trialInfo=trialInfo(1:168);
    end
   
    %   load([filedir '\' Subject{SN}.Name '\Spec\' Subject{SN}.Name '_eegSpecDelay.mat']);
    %load([filedir '\' Subject{SN}.Name  '\'  Subject{SN}.Prefix '.mat'])
    trialLengthIdx = lengthIdx(trialInfo);
    condIdx = catIdx(trialInfo);
    trialCorrectIdx = correctIdx(trialInfo);
    probeValIdx = probeIdx(trialInfo);
    trialRTIdx = rtIdx(trialInfo);
    
    behaviorMat(1,iSN,:)=iSN*ones(1,168);
    behaviorMat(2,iSN,:)=trialLengthIdx;
    behaviorMat(3,iSN,:)=condIdx;
    behaviorMat(4,iSN,:)=probeValIdx;
    
    %     wordIdx=find(condIdx==1 | condIdx==3);
    %     highIdx=find(condIdx==1 | condIdx==2);
    %     behaviorMat(5,iSN,wordIdx)=1;
    %     behaviorMat(6,iSN,highIdx)=1;
    behaviorMat(5,iSN,:)=trialCorrectIdx;
    behaviorMat(6,iSN,:)=trialRTIdx;
    behaviorMat(7,iSN,:)=(trialRTIdx-nanmean(trialRTIdx))./nanstd(trialRTIdx);
    
    probePositionVals=zeros(168,1);
    idxP=find(probeValIdx==1);
    for iP=1:length(idxP);
        pString=trialInfo{idxP(iP)}.probeSound_name;
        for iS=1:length(trialInfo{idxP(iP)}.stimulusSounds_name)
            if strcmp(pString,trialInfo{idxP(iP)}.stimulusSounds_name(iS))
                probePositionVals(idxP(iP))=iS;
            end
        end
    end
    
    behaviorMat(8,iSN,:)=probePositionVals;
    
    imagT=zeros(length(trialInfo),1);
    freqT=zeros(length(trialInfo),1);
    for iTrials=1:length(trialInfo)
        imagTmp=[];
        freqTmp=[];
        for iW=1:length(trialInfo{iTrials}.stimulusSounds_name)
            for iW2=1:length(proposed_w)
                tmp=char(trialInfo{iTrials}.stimulusSounds_name(iW));
                if strcmp(tmp(1:end-4),proposed_w(iW2).Word)
                    imagTmp(iW)=proposed_w(iW2).imaginability;
                    freqTmp(iW)=proposed_w(iW2).SFreq;
                end
            end
        end
        imagT(iTrials)=mean(imagTmp);
        freqT(iTrials)=mean(freqTmp);
    end
    behaviorMat(10,iSN,:)=imagT;
    behaviorMat(11,iSN,:)=freqT;
end

relPos=zeros(size(behaviorMat,2),size(behaviorMat,3));
lengthList=[3,5,7,9];
for iSN=1:size(behaviorMat,2)
    for iTrials=1:168;
        tmp=sq(behaviorMat(:,iSN,iTrials));
        if tmp(4)==1 && tmp(8)==1
            relPos(iSN,iTrials)=1;
        elseif tmp(4)==1 && tmp(8)==2
            relPos(iSN,iTrials)=2;
        elseif tmp(2)>3 && tmp(4)==1 && tmp(8)==3
            relPos(iSN,iTrials)=2;
        elseif tmp(2)==3 && tmp(4)==1 && tmp(8)==3
            relPos(iSN,iTrials)=3;
        elseif tmp(4)==1 && tmp(8)==4
            relPos(iSN,iTrials)=2;
        elseif tmp(2)>5 && tmp(4)==1 && tmp(8)==5
            relPos(iSN,iTrials)=2;
        elseif tmp(2)==5 && tmp(4)==1 && tmp(8)==5
            relPos(iSN,iTrials)=3;
        elseif tmp(4)==1 && tmp(8)==6
            relPos(iSN,iTrials)=2;
        elseif tmp(2)>7 && tmp(4)==1 && tmp(8)==7
            relPos(iSN,iTrials)=2;
        elseif tmp(2)==7 && tmp(4)==1 && tmp(8)==7
            relPos(iSN,iTrials)=3;
        elseif tmp(4)==1 && tmp(8)==8
            relPos(iSN,iTrials)=2;
        elseif tmp(4)==1 && tmp(8)==9
            relPos(iSN,iTrials)=3;
        end
    end
end

behaviorMat(9,:,:)=relPos;




%      wordIdx=find(condIdx==1 | condIdx==3);
%      nonwordIdx=find(condIdx==2 | condIdx==4);
lengthList=[3,5,7,9];
for iSN=1:length(SNList)
    for iCond=1:3
        for iLength=1:4
            ii1=find(sq(behaviorMat(3,iSN,:))==iCond);
            ii2=find(sq(behaviorMat(2,iSN,:))==lengthList(iLength));
            tmp=sum(behaviorMat(5,iSN,intersect(ii1,ii2)))./length(intersect(ii1,ii2));
            condLength(iSN,iCond,iLength)=tmp;
        end
    end
end

x_rt=reshape(sq(behaviorMat(6,:,:)),size(behaviorMat,2)*size(behaviorMat,3),1);
x_rtN=reshape(sq(behaviorMat(7,:,:)),size(behaviorMat,2)*size(behaviorMat,3),1);

x_correct=reshape(sq(behaviorMat(5,:,:)),size(behaviorMat,2)*size(behaviorMat,3),1);
groups=reshape(behaviorMat([1:6,9:11],:,:),9,size(behaviorMat,2)*size(behaviorMat,3))';

TimeOutIdx=isnan(x_rt);
x_rt2=x_rt;
groups2=groups;
x_correct2=x_correct;

x_rt2(TimeOutIdx)=[];
groups2(TimeOutIdx,:)=[];
x_correct2(TimeOutIdx)=[];
x_rtN(TimeOutIdx)=[];

ii=find(x_rtN>3);
%ii=find(x_rt2>2);

x_rt2(ii)=[];
groups2(ii,:)=[];
x_correct2(ii)=[];
x_rtN(ii)=[];

groups3=groups2;
ii=find(groups3(:,4)==0);
groups3(ii,:)=[];
x_rt3=x_rt2;
x_correct3=x_correct2;
x_rt3(ii)=[];
x_correct3(ii)=[];

iiW=find(groups2(:,3)==3);
iiNW=find(groups2(:,3)==2);
iiE=find(groups2(:,3)==1);
iiP=find(groups2(:,4)==1);
iiNP=find(groups2(:,4)==0);
ii3=find(groups2(:,2)==3);
ii5=find(groups2(:,2)==5);
ii7=find(groups2(:,2)==7);
ii9=find(groups2(:,2)==9);
iiLI=find(groups2(iiW,8)<=median(groups2(iiW,8)));
iiHI=find(groups2(iiW,8)>median(groups2(iiW,8)));
iiLF=find(groups2(iiW,9)<=median(groups2(iiW,9)));
iiHF=find(groups2(iiW,9)>median(groups2(iiW,9)));


correctWP(1)=mean(x_correct2(intersect(intersect(iiW,iiP),ii3)));
correctWP(2)=mean(x_correct2(intersect(intersect(iiW,iiP),ii5)));
correctWP(3)=mean(x_correct2(intersect(intersect(iiW,iiP),ii7)));
correctWP(4)=mean(x_correct2(intersect(intersect(iiW,iiP),ii9)));
correctNWP(1)=mean(x_correct2(intersect(intersect(iiNW,iiP),ii3)));
correctNWP(2)=mean(x_correct2(intersect(intersect(iiNW,iiP),ii5)));
correctNWP(3)=mean(x_correct2(intersect(intersect(iiNW,iiP),ii7)));
correctNWP(4)=mean(x_correct2(intersect(intersect(iiNW,iiP),ii9)));
correctEP(1)=mean(x_correct2(intersect(intersect(iiE,iiP),ii3)));
correctEP(2)=mean(x_correct2(intersect(intersect(iiE,iiP),ii5)));
correctEP(3)=mean(x_correct2(intersect(intersect(iiE,iiP),ii7)));
correctEP(4)=mean(x_correct2(intersect(intersect(iiE,iiP),ii9)));

correctHIP(1)=mean(x_correct2(intersect(intersect(iiW(iiHI),iiP),ii3)));
correctHIP(2)=mean(x_correct2(intersect(intersect(iiW(iiHI),iiP),ii5)));
correctHIP(3)=mean(x_correct2(intersect(intersect(iiW(iiHI),iiP),ii7)));
correctHIP(4)=mean(x_correct2(intersect(intersect(iiW(iiHI),iiP),ii9)));
correctLIP(1)=mean(x_correct2(intersect(intersect(iiW(iiLI),iiP),ii3)));
correctLIP(2)=mean(x_correct2(intersect(intersect(iiW(iiLI),iiP),ii5)));
correctLIP(3)=mean(x_correct2(intersect(intersect(iiW(iiLI),iiP),ii7)));
correctLIP(4)=mean(x_correct2(intersect(intersect(iiW(iiLI),iiP),ii9)));

correctHFP(1)=mean(x_correct2(intersect(intersect(iiW(iiHF),iiP),ii3)));
correctHFP(2)=mean(x_correct2(intersect(intersect(iiW(iiHF),iiP),ii5)));
correctHFP(3)=mean(x_correct2(intersect(intersect(iiW(iiHF),iiP),ii7)));
correctHFP(4)=mean(x_correct2(intersect(intersect(iiW(iiHF),iiP),ii9)));
correctLFP(1)=mean(x_correct2(intersect(intersect(iiW(iiLF),iiP),ii3)));
correctLFP(2)=mean(x_correct2(intersect(intersect(iiW(iiLF),iiP),ii5)));
correctLFP(3)=mean(x_correct2(intersect(intersect(iiW(iiLF),iiP),ii7)));
correctLFP(4)=mean(x_correct2(intersect(intersect(iiW(iiLF),iiP),ii9)));

correctWNP(1)=mean(x_correct2(intersect(intersect(iiW,iiNP),ii3)));
correctWNP(2)=mean(x_correct2(intersect(intersect(iiW,iiNP),ii5)));
correctWNP(3)=mean(x_correct2(intersect(intersect(iiW,iiNP),ii7)));
correctWNP(4)=mean(x_correct2(intersect(intersect(iiW,iiNP),ii9)));
correctNWNP(1)=mean(x_correct2(intersect(intersect(iiNW,iiNP),ii3)));
correctNWNP(2)=mean(x_correct2(intersect(intersect(iiNW,iiNP),ii5)));
correctNWNP(3)=mean(x_correct2(intersect(intersect(iiNW,iiNP),ii7)));
correctNWNP(4)=mean(x_correct2(intersect(intersect(iiNW,iiNP),ii9)));
correctENP(1)=mean(x_correct2(intersect(intersect(iiE,iiNP),ii3)));
correctENP(2)=mean(x_correct2(intersect(intersect(iiE,iiNP),ii5)));
correctENP(3)=mean(x_correct2(intersect(intersect(iiE,iiNP),ii7)));
correctENP(4)=mean(x_correct2(intersect(intersect(iiE,iiNP),ii9)));

correctHINP(1)=mean(x_correct2(intersect(intersect(iiW(iiHI),iiNP),ii3)));
correctHINP(2)=mean(x_correct2(intersect(intersect(iiW(iiHI),iiNP),ii5)));
correctHINP(3)=mean(x_correct2(intersect(intersect(iiW(iiHI),iiNP),ii7)));
correctHINP(4)=mean(x_correct2(intersect(intersect(iiW(iiHI),iiNP),ii9)));
correctLINP(1)=mean(x_correct2(intersect(intersect(iiW(iiLI),iiNP),ii3)));
correctLINP(2)=mean(x_correct2(intersect(intersect(iiW(iiLI),iiNP),ii5)));
correctLINP(3)=mean(x_correct2(intersect(intersect(iiW(iiLI),iiNP),ii7)));
correctLINP(4)=mean(x_correct2(intersect(intersect(iiW(iiLI),iiNP),ii9)));

correctHFNP(1)=mean(x_correct2(intersect(intersect(iiW(iiHF),iiNP),ii3)));
correctHFNP(2)=mean(x_correct2(intersect(intersect(iiW(iiHF),iiNP),ii5)));
correctHFNP(3)=mean(x_correct2(intersect(intersect(iiW(iiHF),iiNP),ii7)));
correctHFNP(4)=mean(x_correct2(intersect(intersect(iiW(iiHF),iiNP),ii9)));
correctLFNP(1)=mean(x_correct2(intersect(intersect(iiW(iiLF),iiNP),ii3)));
correctLFNP(2)=mean(x_correct2(intersect(intersect(iiW(iiLF),iiNP),ii5)));
correctLFNP(3)=mean(x_correct2(intersect(intersect(iiW(iiLF),iiNP),ii7)));
correctLFNP(4)=mean(x_correct2(intersect(intersect(iiW(iiLF),iiNP),ii9)));


figure;
plot(correctWP);
hold on;
plot(correctNWP);
hold on;
plot(correctEP);
hold on;
plot(correctWNP);
hold on;
plot(correctNWNP);
hold on;
plot(correctENP);

legend('WP','NWP','EP','WNP','NWNP','ENP')
title('Word/Nonword/Environ & Probe/No Probe')


figure;
plot(correctHIP);
hold on;
plot(correctLIP);
hold on;
plot(correctNWP);
% hold on;
% plot(correctEP);
hold on;
plot(correctHINP);
hold on;
plot(correctLINP);
hold on;
plot(correctNWNP);
% hold on;
% plot(correctENP);

%legend('HIP','LIP','NWP','EP','HINP','LINP','NWNP','ENP')
legend('HIP','LIP','NWP','HINP','LINP','NWNP')

title('Imag/Nonword/Environ & Probe/No Probe')

figure;
plot(correctHFP);
hold on;
plot(correctLFP);
hold on;
plot(correctNWP);
% hold on;
% plot(correctEP);
hold on;
plot(correctHFNP);
hold on;
plot(correctLFNP);
hold on;
plot(correctNWNP);
% hold on;
% plot(correctENP);

%legend('HIP','LIP','NWP','EP','HINP','LINP','NWNP','ENP')
legend('HFP','LFP','NWP','HFNP','LFNP','NWNP')

title('Freq/Nonword/Environ & Probe/No Probe')


% [P_RT T_RT STATS_RT TERMS_RT]=anovan(x_rt2N,groups2(:,[2,4,5,6]),'model','full','display','off');
%  [P_CORRECT T_CORRECT STATS_CORRECT TERMS_CORRECT]=anovan(x_correct2,groups2(:,[2,5,6]),'model','full','display','off');
% %  

t= table(x_rtN,x_rt2,x_correct2,groups2(:,1), groups2(:,2), groups2(:,4), groups2(:,3), ...
     'VariableNames',{'RTN','RT','Correct','Subject','Length','Probe','Cat'});

%  t.Correct=categorical(t.Correct);
%  t.Subject=categorical(t.Subject);
%  t.Probe=categorical(t.Probe);
%  t.Cat=categorical(t.Cat);
 
 
 mdl_CORR=fitglme(t,'Correct~Length+Probe+Cat+(1|Subject)','Distribution','binomial');
 mdl_CORR=fitglme(t,'Correct~Length*Probe*Cat+(1|Subject)','Distribution','binomial');



% anova?
nestedVals=zeros(4,4);
nestedVals(4,3)=1;
[p,tbl,stats,terms] = anovan(x_correct2,groups2(:,[2,5,4,7]),'model','interaction','varnames',{'Length','Lex','Probe','RelPos'},'nested',nestedVals);
[p,tbl,stats,terms] = anovan(x_rtN,groups2(:,[2,5,4,7]),'model','interaction','varnames',{'Length','Lex','Probe','RelPos'},'nested',nestedVals);

nestedVals=zeros(5,5);
nestedVals(5,4)=1;
[p,tbl,stats,terms] = anovan(x_rt2,groups2(:,[1,2,5,4,7]),'model','interaction','varnames',{'Subject','Length','Lex','Probe','RelPos'},'nested',nestedVals,'random',1);


t= table(groups2(:,2), groups2(:,4), groups2(:,5),x_correct2, ...
     'VariableNames',{'Length','Probe','Lex','Correct'});

 %t.Correct=categorical(t.Correct);
 %t.Subject=categorical(t.Subject);
%  t.Probe=categorical(t.Probe);
%  t.Lex=categorical(t.Lex);
%  t.Phono=categorical(t.Phono);
 
 mdl_corr = stepwiseglm(t,'constant','upper','interactions','Distribution','binomial');

 t= table(groups2(:,2), groups2(:,4), groups2(:,5),x_rt2, ...
     'VariableNames',{'Length','Probe','Lex','RT'});
 
  mdl_rt = stepwiseglm(t,'constant','upper','interactions','Distribution','normal');




for iTrials=1:length(trialInfo);
    RTvals(iTrials)=trialInfo{iTrials}.ReactionTime;
    if strcmp(trialInfo{iTrials}.StimulusCategory,'environment')
        condVals(iTrials)=1;
    elseif strcmp(trialInfo{iTrials}.StimulusCategory,'nonwords')
        condVals(iTrials)=2;
    elseif   strcmp(trialInfo{iTrials}.StimulusCategory,'words')
        condVals(iTrials)=3;
    end
    lengthVals(iTrials)=length(trialInfo{iTrials}.stimulusAudioStart);
    correctVals(iTrials)=trialInfo{iTrials}.RespCorrect;
end