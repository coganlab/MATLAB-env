duke;
Subject={};
filedir=['H:\Box Sync\CoganLab\ECoG_Task_Data\Cogan_Task_Data'];
Subject{23}.Name='D23'; Subject{23}.Prefix = '/Sternberg/D23_Sternberg_trialInfo';
Subject{24}.Name='D24'; Subject{24}.Prefix = '/Sternberg/D24_Sternberg_trialInfo';
Subject{26}.Name='D26'; Subject{26}.Prefix = '/Sternberg/D26_Sternberg_trialInfo';
Subject{27}.Name='D27'; Subject{27}.Prefix = '/Neighborhood Sternberg/D27_Sternberg_trialInfo';
Subject{28}.Name='D28'; Subject{28}.Prefix = '/Neighborhood Sternberg/D28_Sternberg_trialInfo';
Subject{29}.Name='D29'; Subject{29}.Prefix = '/NeighborhoodSternberg/D29_Sternberg_trialInfo';
Subject{30}.Name='D30'; Subject{30}.Prefix = '/NeighborhoodSternberg/D30_Sternberg_trialInfo';
Subject{31}.Name='D31'; Subject{31}.Prefix = '/NeighborhoodSternberg/D31_Sternberg_trialInfo';
Subject{33}.Name='D33'; Subject{33}.Prefix = '/NeighborhoodSternberg/D33_Sternberg_trialInfo';
Subject{34}.Name='D34'; Subject{34}.Prefix = '/NeighborhoodSternberg/D34_Sternberg_trialInfo';
Subject{35}.Name='D35'; Subject{35}.Prefix = '/NeighborhoodSternberg/D35_Sternberg_trialInfo';
Subject{36}.Name='D36'; Subject{36}.Prefix = '/NeighborhoodSternberg/D36_Sternberg_trialInfo';
Subject{37}.Name='D37'; Subject{37}.Prefix = '/NeighborhoodSternberg/D37_Sternberg_trialInfo';
Subject{38}.Name='D38'; Subject{38}.Prefix = '/NeighborhoodSternberg/D38_Sternberg_trialInfo';
Subject{39}.Name='D39'; Subject{39}.Prefix = '/Neighborhood_Sternberg/D39_Sternberg_trialInfo';

SNList=[23,26,27,28,29,30,31,34,35,36,37,38,39]; % 


for iSN=1:length(SNList);
    SN=SNList(iSN);
    %   load([filedir '\' Subject{SN}.Name '\Spec\' Subject{SN}.Name '_eegSpecDelay.mat']);
    load([filedir '\' Subject{SN}.Name  '\'  Subject{SN}.Prefix '.mat'])
        trialLengthIdx = lengthIdx(trialInfo);
    condIdx = catIdx(trialInfo);
    trialCorrectIdx = correctIdx(trialInfo);
    probeValIdx = probeIdx(trialInfo);
    trialRTIdx = rtIdx(trialInfo);
    
    behaviorMat(1,iSN,:)=iSN*ones(1,160);
    behaviorMat(2,iSN,:)=trialLengthIdx;
    behaviorMat(3,iSN,:)=condIdx;
    behaviorMat(4,iSN,:)=probeValIdx;
    
    wordIdx=find(condIdx==1 | condIdx==3);
    highIdx=find(condIdx==1 | condIdx==2);
    behaviorMat(5,iSN,wordIdx)=1;
    behaviorMat(6,iSN,highIdx)=1;
    behaviorMat(7,iSN,:)=trialCorrectIdx;
    behaviorMat(8,iSN,:)=trialRTIdx;
    behaviorMat(9,iSN,:)=(trialRTIdx-nanmean(trialRTIdx))./nanstd(trialRTIdx);
    
    probePositionVals=zeros(160,1);
    idxP=find(probeValIdx==1);
    for iP=1:length(idxP);
        pString=trialInfo{idxP(iP)}.probeSound_name;
        for iS=1:length(trialInfo{idxP(iP)}.stimulusSounds_name)
            if strcmp(pString,trialInfo{idxP(iP)}.stimulusSounds_name(iS))
                probePositionVals(idxP(iP))=iS;
            end
        end
    end
            
    behaviorMat(10,iSN,:)=probePositionVals;
    correctAvg(iSN)=mean(trialCorrectIdx);
end

relPos=zeros(size(behaviorMat,2),size(behaviorMat,3));
lengthList=[3,5,7,9];
for iSN=1:size(behaviorMat,2)
    for iTrials=1:160;
        tmp=sq(behaviorMat(:,iSN,iTrials));
        if tmp(4)==1 && tmp(10)==1
            relPos(iSN,iTrials)=1;
        elseif tmp(4)==1 && tmp(10)==2
            relPos(iSN,iTrials)=2;
        elseif tmp(2)>3 && tmp(4)==1 && tmp(10)==3
            relPos(iSN,iTrials)=2;
        elseif tmp(2)==3 && tmp(4)==1 && tmp(10)==3
            relPos(iSN,iTrials)=3;
        elseif tmp(4)==1 && tmp(10)==4
            relPos(iSN,iTrials)=2;
        elseif tmp(2)>5 && tmp(4)==1 && tmp(10)==5
            relPos(iSN,iTrials)=2;
        elseif tmp(2)==5 && tmp(4)==1 && tmp(10)==5
            relPos(iSN,iTrials)=3;
        elseif tmp(4)==1 && tmp(10)==6
            relPos(iSN,iTrials)=2;
        elseif tmp(2)>7 && tmp(4)==1 && tmp(10)==7
            relPos(iSN,iTrials)=2;
        elseif tmp(2)==7 && tmp(4)==1 && tmp(10)==7
            relPos(iSN,iTrials)=3;
        elseif tmp(4)==1 && tmp(10)==8
            relPos(iSN,iTrials)=2;
        elseif tmp(4)==1 && tmp(10)==9
            relPos(iSN,iTrials)=3;
        end
    end
end

behaviorMat(11,:,:)=relPos;

%      wordIdx=find(condIdx==1 | condIdx==3);
%      nonwordIdx=find(condIdx==2 | condIdx==4);


x_rt=reshape(sq(behaviorMat(8,:,:)),size(behaviorMat,2)*size(behaviorMat,3),1);
x_rtN=reshape(sq(behaviorMat(9,:,:)),size(behaviorMat,2)*size(behaviorMat,3),1);

x_correct=reshape(sq(behaviorMat(7,:,:)),size(behaviorMat,2)*size(behaviorMat,3),1);
groups=reshape(behaviorMat([1:6,11,10],:,:),8,size(behaviorMat,2)*size(behaviorMat,3))';

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
% [P_RT T_RT STATS_RT TERMS_RT]=anovan(x_rt2N,groups2(:,[2,4,5,6]),'model','full','display','off');
%  [P_CORRECT T_CORRECT STATS_CORRECT TERMS_CORRECT]=anovan(x_correct2,groups2(:,[2,5,6]),'model','full','display','off');
% %  

iiP=find(groups2(:,4)==1);  
iiNP=find(groups2(:,4)==0); 
iiH=find(groups2(:,6)==1);
iiL=find(groups2(:,6)==0);
iiW=find(groups2(:,5)==1);
iiNW=find(groups2(:,5)==0);
ii3=find(groups2(:,2)==3);
ii5=find(groups2(:,2)==5);
ii7=find(groups2(:,2)==7);
ii9=find(groups2(:,2)==9);
ii1P=find(groups2(:,7)==1);
ii2P=find(groups2(:,7)==2);
ii3P=find(groups2(:,7)==3);


correctW(1)=mean(x_correct2(intersect(iiW,ii3)));
correctW(2)=mean(x_correct2(intersect(iiW,ii5)));
correctW(3)=mean(x_correct2(intersect(iiW,ii7)));
correctW(4)=mean(x_correct2(intersect(iiW,ii9)));

correctNW(1)=mean(x_correct2(intersect(iiNW,ii3)));
correctNW(2)=mean(x_correct2(intersect(iiNW,ii5)));
correctNW(3)=mean(x_correct2(intersect(iiNW,ii7)));
correctNW(4)=mean(x_correct2(intersect(iiNW,ii9)));

correctH(1)=mean(x_correct2(intersect(iiH,ii3)));
correctH(2)=mean(x_correct2(intersect(iiH,ii5)));
correctH(3)=mean(x_correct2(intersect(iiH,ii7)));
correctH(4)=mean(x_correct2(intersect(iiH,ii9)));

correctL(1)=mean(x_correct2(intersect(iiL,ii3)));
correctL(2)=mean(x_correct2(intersect(iiL,ii5)));
correctL(3)=mean(x_correct2(intersect(iiL,ii7)));
correctL(4)=mean(x_correct2(intersect(iiL,ii9)));

correctHP(1)=mean(x_correct2(intersect(intersect(iiH,iiP),ii3)));
correctHP(2)=mean(x_correct2(intersect(intersect(iiH,iiP),ii5)));
correctHP(3)=mean(x_correct2(intersect(intersect(iiH,iiP),ii7)));
correctHP(4)=mean(x_correct2(intersect(intersect(iiH,iiP),ii9)));
correctLP(1)=mean(x_correct2(intersect(intersect(iiL,iiP),ii3)));
correctLP(2)=mean(x_correct2(intersect(intersect(iiL,iiP),ii5)));
correctLP(3)=mean(x_correct2(intersect(intersect(iiL,iiP),ii7)));
correctLP(4)=mean(x_correct2(intersect(intersect(iiL,iiP),ii9)));

correctHNP(1)=mean(x_correct2(intersect(intersect(iiH,iiNP),ii3)));
correctHNP(2)=mean(x_correct2(intersect(intersect(iiH,iiNP),ii5)));
correctHNP(3)=mean(x_correct2(intersect(intersect(iiH,iiNP),ii7)));
correctHNP(4)=mean(x_correct2(intersect(intersect(iiH,iiNP),ii9)));
correctLNP(1)=mean(x_correct2(intersect(intersect(iiL,iiNP),ii3)));
correctLNP(2)=mean(x_correct2(intersect(intersect(iiL,iiNP),ii5)));
correctLNP(3)=mean(x_correct2(intersect(intersect(iiL,iiNP),ii7)));
correctLNP(4)=mean(x_correct2(intersect(intersect(iiL,iiNP),ii9)));

correctWP(1)=mean(x_correct2(intersect(intersect(iiW,iiP),ii3)));
correctWP(2)=mean(x_correct2(intersect(intersect(iiW,iiP),ii5)));
correctWP(3)=mean(x_correct2(intersect(intersect(iiW,iiP),ii7)));
correctWP(4)=mean(x_correct2(intersect(intersect(iiW,iiP),ii9)));
correctNWP(1)=mean(x_correct2(intersect(intersect(iiNW,iiP),ii3)));
correctNWP(2)=mean(x_correct2(intersect(intersect(iiNW,iiP),ii5)));
correctNWP(3)=mean(x_correct2(intersect(intersect(iiNW,iiP),ii7)));
correctNWP(4)=mean(x_correct2(intersect(intersect(iiNW,iiP),ii9)));

correctWNP(1)=mean(x_correct2(intersect(intersect(iiW,iiNP),ii3)));
correctWNP(2)=mean(x_correct2(intersect(intersect(iiW,iiNP),ii5)));
correctWNP(3)=mean(x_correct2(intersect(intersect(iiW,iiNP),ii7)));
correctWNP(4)=mean(x_correct2(intersect(intersect(iiW,iiNP),ii9)));
correctNWNP(1)=mean(x_correct2(intersect(intersect(iiNW,iiNP),ii3)));
correctNWNP(2)=mean(x_correct2(intersect(intersect(iiNW,iiNP),ii5)));
correctNWNP(3)=mean(x_correct2(intersect(intersect(iiNW,iiNP),ii7)));
correctNWNP(4)=mean(x_correct2(intersect(intersect(iiNW,iiNP),ii9)));

correctHWP(1)=mean(x_correct2(intersect(intersect(intersect(iiW,iiP),iiH),ii3)));
correctHWP(2)=mean(x_correct2(intersect(intersect(intersect(iiW,iiP),iiH),ii5)));
correctHWP(3)=mean(x_correct2(intersect(intersect(intersect(iiW,iiP),iiH),ii7)));
correctHWP(4)=mean(x_correct2(intersect(intersect(intersect(iiW,iiP),iiH),ii9)));

correctLWP(1)=mean(x_correct2(intersect(intersect(intersect(iiW,iiP),iiL),ii3)));
correctLWP(2)=mean(x_correct2(intersect(intersect(intersect(iiW,iiP),iiL),ii5)));
correctLWP(3)=mean(x_correct2(intersect(intersect(intersect(iiW,iiP),iiL),ii7)));
correctLWP(4)=mean(x_correct2(intersect(intersect(intersect(iiW,iiP),iiL),ii9)));

correctHNWP(1)=mean(x_correct2(intersect(intersect(intersect(iiNW,iiP),iiH),ii3)));
correctHNWP(2)=mean(x_correct2(intersect(intersect(intersect(iiNW,iiP),iiH),ii5)));
correctHNWP(3)=mean(x_correct2(intersect(intersect(intersect(iiNW,iiP),iiH),ii7)));
correctHNWP(4)=mean(x_correct2(intersect(intersect(intersect(iiNW,iiP),iiH),ii9)));

correctLNWP(1)=mean(x_correct2(intersect(intersect(intersect(iiNW,iiP),iiL),ii3)));
correctLNWP(2)=mean(x_correct2(intersect(intersect(intersect(iiNW,iiP),iiL),ii5)));
correctLNWP(3)=mean(x_correct2(intersect(intersect(intersect(iiNW,iiP),iiL),ii7)));
correctLNWP(4)=mean(x_correct2(intersect(intersect(intersect(iiNW,iiP),iiL),ii9)));

correctHWNP(1)=mean(x_correct2(intersect(intersect(intersect(iiW,iiNP),iiH),ii3)));
correctHWNP(2)=mean(x_correct2(intersect(intersect(intersect(iiW,iiNP),iiH),ii5)));
correctHWNP(3)=mean(x_correct2(intersect(intersect(intersect(iiW,iiNP),iiH),ii7)));
correctHWNP(4)=mean(x_correct2(intersect(intersect(intersect(iiW,iiNP),iiH),ii9)));

correctLWNP(1)=mean(x_correct2(intersect(intersect(intersect(iiW,iiNP),iiL),ii3)));
correctLWNP(2)=mean(x_correct2(intersect(intersect(intersect(iiW,iiNP),iiL),ii5)));
correctLWNP(3)=mean(x_correct2(intersect(intersect(intersect(iiW,iiNP),iiL),ii7)));
correctLWNP(4)=mean(x_correct2(intersect(intersect(intersect(iiW,iiNP),iiL),ii9)));

correctHNWNP(1)=mean(x_correct2(intersect(intersect(intersect(iiNW,iiNP),iiH),ii3)));
correctHNWNP(2)=mean(x_correct2(intersect(intersect(intersect(iiNW,iiNP),iiH),ii5)));
correctHNWNP(3)=mean(x_correct2(intersect(intersect(intersect(iiNW,iiNP),iiH),ii7)));
correctHNWNP(4)=mean(x_correct2(intersect(intersect(intersect(iiNW,iiNP),iiH),ii9)));

correctLNWNP(1)=mean(x_correct2(intersect(intersect(intersect(iiNW,iiNP),iiL),ii3)));
correctLNWNP(2)=mean(x_correct2(intersect(intersect(intersect(iiNW,iiNP),iiL),ii5)));
correctLNWNP(3)=mean(x_correct2(intersect(intersect(intersect(iiNW,iiNP),iiL),ii7)));
correctLNWNP(4)=mean(x_correct2(intersect(intersect(intersect(iiNW,iiNP),iiL),ii9)));

figure;
plot(correctW);
hold on;
plot(correctNW);
legend('W','NW');
title('Word vs Nonword')

figure;
plot(correctH);
hold on;
plot(correctL);
legend('H','L');
title('High vs Low')

figure;
plot(correctHP);
hold on;
plot(correctLP);
hold on;
plot(correctHNP);
hold on;
plot(correctLNP);
legend('HP','LP','HNP','LNP')
title('High/Low & Probe/No Probe')

figure;
plot(correctWP);
hold on;
plot(correctNWP);
hold on;
plot(correctWNP);
hold on;
plot(correctNWNP);
legend('WP','NWP','WNP','NWNP')
title('Word/Nonword & Probe/No Probe')

figure;
plot(correctHWP,'b');
hold on;
plot(correctLWP,'r');
hold on;
plot(correctHNWP,'g');
hold on;
plot(correctLNWP,'m');
hold on;
plot(correctHWNP,'b--');
hold on;
plot(correctLWNP,'r--');
hold on;
plot(correctHNWNP,'g--');
hold on;
plot(correctLNWNP,'m--');
legend('HWP','LWP','HNWP','LNWP','HWNP','LWNP','HNWNP','LNWNP')
title('HIgh/Low Word/Nonword & Probe/No Probe')


t= table(x_rtN,x_rt2,x_correct2,groups2(:,1), groups2(:,2), groups2(:,4), groups2(:,5), groups2(:,6), groups2(:,8), ...
     'VariableNames',{'RTN','RT','Correct','Subject','Length','Probe','Lex','Phono','ProbePos'});

 t.Correct=categorical(t.Correct);
 t.Subject=categorical(t.Subject);
 t.Probe=categorical(t.Probe);
 t.Lex=categorical(t.Lex);
 t.Phono=categorical(t.Phono);
 
 
  t2= table(x_rt2,x_correct2,groups2(:,1), groups2(:,2), groups2(:,5), groups2(:,6), groups2(:,4), ...
     'VariableNames',{'RT','Correct','Subject','Length','Lex','Phono','Probe'}); 

%    mdl_corr= stepwiseglm(t,'constant','upper','Correct~Length*Probe*Lex*Phono','Distribution','binomial');
mdl_CORR=fitglm(t2,'Correct~Length*Probe*Lex*Phono+(1|Subject)','Distribution','binomial');

mdl_CORR=fitglme(t2,'Correct~Length+Probe+Lex+Phono+(1|Subject)','Distribution','binomial');
mdl_CORR=fitglme(t2,'Correct~Length*Probe*Lex*Phono+(1|Subject)','Distribution','binomial');

mdl_CORR=fitglme(t2,'Correct~Length+Probe+Lex+Phono+Length:Probe+Length:Lex+Length:Phono+Probe:Lex+Probe:Phono+Lex:Phono+(1|Subject)','Distribution','binomial');

 
%FULL!
mdl_CORR=fitglm(t,'Correct~Length*Lex*Probe','Distribution','binomial');
mdl_RT=fitlme(t,'RT~Length*Lex*Probe+(1|Subject)');

mdl_CORR=fitglm(t,'Correct~Length*Lex','Distribution','binomial');
mdl_RT=fitlme(t,'RT~Length*Lex+(1|Subject)');
mdl_RTN=fitglm(t,'RTN~Length*Lex','Distribution','normal');

% % FULL NO PROBE
% mdl_CORR=fitglm(t,'Correct~Length*Lex*Phono','Distribution','binomial');
% mdl_RT=fitlme(t,'RT~Length*Lex*Phono+(1|Subject)');
% TWO WAY
mdl_CORR=fitglm(t,'Correct~Length+Lex+Probe+Length:Lex+Length:Probe+Lex:Probe','Distribution','binomial');
mdl_RTN=fitglm(t,'RTN~Length+Lex+Probe+Length:Lex+Length:Probe+Lex:Probe','Distribution','normal');

mdl_RT=fitlme(t,'RT~Length+Lex+Probe+Length:Lex+Length:Probe+Lex:Probe+(1|Subject)');beta=fixedEffects(mdl_RT);
% [~,~,STATS] = randomEffects(lme_RT);
% STATS.Level = nominal(STATS.Level);

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