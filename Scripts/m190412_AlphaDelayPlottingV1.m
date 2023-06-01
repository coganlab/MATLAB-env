duke('desktop');
filedir=['H:\Box Sync\CoganLab\EEG\Data'];
Subject{1}.Name='E1'; Subject{1}.Prefix='E1_SternbergAudio_210918';
Subject{2}.Name='E2'; Subject{2}.Prefix='E2_SternbergAudio'; Subject{2}.Behavior = 'E2_Sternberg_Audio_201810111134';
Subject{3}.Name='E3'; Subject{3}.Prefix='E3_SternbergAudio_181018'; Subject{3}.Behavior = 'E3_Sternberg_Audio_20181018167';
Subject{4}.Name='E4'; Subject{4}.Prefix='E4_SternbergAudio_081118'; Subject{4}.Behavior = 'E4_Sternberg_Audio_20181181412';
Subject{5}.Name='E5'; Subject{5}.Prefix='E5_SternbergAudio_061018'; Subject{5}.Behavior = 'E5_Sternberg_Audio_2018116180';
Subject{6}.Name='E6'; Subject{6}.Prefix='E6_SternbergAudio_151118'; Subject{6}.Behavior = 'E6_Sternberg_Audio_201811151647';
Subject{7}.Name='E7'; Subject{7}.Prefix='E7_SternbergAudio_061218';Subject{7}.Behavior = 'E7_Sternberg_Audio_2018126159';
Subject{8}.Name='E8'; Subject{8}.Prefix='E8_SternbergAudio_0101419'; Subject{8}.Behavior = 'E8_Sternberg_Audio_201914151';
Subject{9}.Name='E9'; Subject{9}.Prefix='E9_SternbergAudio_010219'; Subject{9}.Behavior = 'E9_Sternberg_Audio_2019211447';
Subject{10}.Name='E10'; Subject{10}.Prefix='E10_SternbergAudio_040219'; Subject{10}.Behavior = 'E10_Sternberg_Audio_2019241142'; % NB: No Captrak
Subject{11}.Name='E11'; Subject{11}.Prefix='E11_Sternberg_Audio_070219'; Subject{11}.Behavior = 'E11_Sternberg_Audio_2019271214'; % NB there are parts 2 and 3 here as well
Subject{12}.Name='E12'; Subject{12}.Prefix='E12_Sternberg_Audio_130219'; Subject{12}.Behavior = 'E12_Sternberg_Audio_2019213159';
Subject{13}.Name='E13'; Subject{13}.Prefix='E13_SternbergAudio_210219'; Subject{13}.Behavior = 'E13_Sternberg_Audio_20192211111';
Subject{15}.Name='E15'; Subject{15}.Prefix='E15_SternbergAudio_030419'; Subject{15}.Behavior = 'E15_Sternberg_Audio_2019341417';
Subject{16}.Name='E16'; Subject{16}.Prefix='E16_SternbergAudio_030519'; Subject{16}.Behavior = 'E16_Sternberg_Audio_2019351619';
Subject{17}.Name='E17'; Subject{17}.Prefix='E17_SternbergAudio_060319'; Subject{17}.Behavior = 'E17_Sternberg_Audio_2019361140';
Subject{18}.Name='E18'; Subject{18}.Prefix='E18_SternbergAudio_070319'; Subject{18}.Behavior = 'E18_Sternberg_Audio_201937142';
Subject{20}.Name='E20'; Subject{20}.Prefix='E20_SternbergAudio_220319'; Subject{20}.Behavior = 'E20_Sternberg_Audio_20193221424';
Subject{21}.Name='E21'; Subject{21}.Prefix='E21_Sternberg_Audio_250319'; Subject{21}.Behavior = 'E21_Sternberg_Audio_20193251237';
Subject{22}.Name='E22'; Subject{22}.Prefix='E22_Sternberg_Audio_280319'; Subject{22}.Behavior ='E22_Sternberg_Audio_20193281417';
Subject{23}.Name='E23'; Subject{23}.Prefix='E23_SternbergAudio_0104019'; Subject{23}.Behavior ='E23_Sternberg_Audio_2019411222';
Subject{24}.Name='E24'; Subject{24}.Prefix='E24_SternbergAudio_041119'; Subject{24}.Behavior ='E24_Sternberg_Audio_20194111156';
Subject{25}.Name='E25'; Subject{25}.Prefix='E25_SternbergAudio_041819'; Subject{25}.Behavior ='E25_Sternberg_Audio_20194181344';

%SNList=[2,3,4,5,6,7,9,11,12,13,15,16,17,18,20,21,22];

SNList=[2,3,4,5,6,7,9,11,12,13,15,16,17,18,20,21,22,23,24,25]; % GOOD NEURO?
%eegSpecA_All=zeros(length(SNList),124,192,51,41);
%eegSpecB_All=zeros(length(SNList),124,192,13,50);

%eegOutD_All=zeros(length(SNList),124,192);
%eegOutA_All=zeros(length(SNList),124,192);
%eegOutB_All=zeros(length(SNList),124,192);


for iSN=1:length(SNList);
 SN=SNList(iSN);
    %   load([filedir '\' Subject{SN}.Name '\Spec\' Subject{SN}.Name '_eegSpecDelay.mat']);
    load([filedir '\' Subject{SN}.Name  '\Behavioral_Data(PTB)\' Subject{SN}.Behavior '\' Subject{SN}.Name '_Block_1_TrialData.mat'])
    trialLengthIdx = lengthIdx(trialInfo);
    condIdx = catIdx(trialInfo);
    trialCorrectIdx = correctIdx(trialInfo);
    probeValIdx = probeIdx(trialInfo);
    trialRTIdx = rtIdx(trialInfo);
    
    behaviorMat(1,iSN,:)=iSN*ones(1,192);
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
end


eegSpecD_All=zeros(length(SNList),124,192,50);
eegSpecB_All=zeros(length(SNList),124,192,50);


for iSN=1:length(SNList);
 SN=SNList(iSN);
%load([filedir '\' Subject{SN}.Name '\Spec\' Subject{SN}.Name '_eegSpecDelay_A.mat']);
load([filedir '\' Subject{SN}.Name '\Spec\' Subject{SN}.Name '_eegSpecDelay_B.mat']);
load([filedir '\' Subject{SN}.Name '\Spec\' Subject{SN}.Name '_eegSpecDelay_D.mat']);

for iChan=1:124;
    badTrialsD=find(eegOutD(iChan,:)>(2*std(eegOutD(iChan,:))+mean(eegOutD(iChan,:))));
    badTrialsB=find(eegOutB(iChan,:)>(2*std(eegOutB(iChan,:))+mean(eegOutB(iChan,:))));
    badTrials=unique(cat(2,badTrialsD,badTrialsB));
    goodTrials{iSN}{iChan}=setdiff(1:192,badTrials);
end



eegSpecD_All(iSN,:,:,:)=sq(mean(abs(eegSpecD(:,:,26:100,:)),3)); % 26:100 should be whole delay period
eegSpecB_All(iSN,:,:,:)=sq(mean(abs(eegSpecB(:,:,1:10,:)),3));


display(iSN);
end


loadMat=zeros(20,124,4,50);
for iSN=1:20;
ii3=find(sq(behaviorMat(2,iSN,:))==3);
ii5=find(sq(behaviorMat(2,iSN,:))==5);
ii7=find(sq(behaviorMat(2,iSN,:))==7);
ii9=find(sq(behaviorMat(2,iSN,:))==9);



%goodTrials=setdiff(1:192,[7,20,75,82,90,123,144]); % E3
noResp=isnan(sq(behaviorMat(8,iSN,:)));
ii=find(noResp==1);




for iChan=1:124;
    goodTrialsTmp=setdiff(goodTrials{iSN}{iChan},ii);
    %goodTrialsTmp=setdiff(goodTrialsTmp,outlierF{iSN}{iChan});
% loadMat(iSN,iChan,1,:)=sq(mean(abs(eegSpecD_All(iSN,iChan,intersect(ii3,goodTrialsTmp)))./abs(eegSpecB_All(iSN,iChan,intersect(goodTrialsTmp,ii3),:)),3));
% loadMat(iSN,iChan,2,:)=sq(mean(abs(eegSpecD_All(iSN,iChan,intersect(ii5,goodTrialsTmp)))./abs(eegSpecB_All(iSN,iChan,intersect(goodTrialsTmp,ii5),:)),3));
% loadMat(iSN,iChan,3,:)=sq(mean(abs(eegSpecD_All(iSN,iChan,intersect(ii7,goodTrialsTmp)))./abs(eegSpecB_All(iSN,iChan,intersect(goodTrialsTmp,ii7),:)),3));
% loadMat(iSN,iChan,4,:)=sq(mean(abs(eegSpecD_All(iSN,iChan,intersect(ii9,goodTrialsTmp)))./abs(eegSpecB_All(iSN,iChan,intersect(goodTrialsTmp,ii9),:)),3));

loadMat(iSN,iChan,1,:)=sq(mean(abs(eegSpecD_All(iSN,iChan,intersect(ii3,goodTrialsTmp),:)),3)./mean(abs(eegSpecB_All(iSN,iChan,goodTrialsTmp,:)),3));
loadMat(iSN,iChan,2,:)=sq(mean(abs(eegSpecD_All(iSN,iChan,intersect(ii5,goodTrialsTmp),:)),3)./mean(abs(eegSpecB_All(iSN,iChan,goodTrialsTmp,:)),3));
loadMat(iSN,iChan,3,:)=sq(mean(abs(eegSpecD_All(iSN,iChan,intersect(ii7,goodTrialsTmp),:)),3)./mean(abs(eegSpecB_All(iSN,iChan,goodTrialsTmp,:)),3));
loadMat(iSN,iChan,4,:)=sq(mean(abs(eegSpecD_All(iSN,iChan,intersect(ii9,goodTrialsTmp),:)),3)./mean(abs(eegSpecB_All(iSN,iChan,goodTrialsTmp,:)),3));

% loadMat(iSN,iChan,1,:)=sq(mean((eegSpecD_All(iSN,iChan,intersect(ii3,goodTrialsTmp),:)),3));
% loadMat(iSN,iChan,2,:)=sq(mean((eegSpecD_All(iSN,iChan,intersect(ii5,goodTrialsTmp),:)),3));
% loadMat(iSN,iChan,3,:)=sq(mean((eegSpecD_All(iSN,iChan,intersect(ii7,goodTrialsTmp),:)),3));
% loadMat(iSN,iChan,4,:)=sq(mean((eegSpecD_All(iSN,iChan,intersect(ii9,goodTrialsTmp),:)),3));
end
display(iSN);

end

goodSubj=[1:2,4:5,7:16];
for iG=0:1
    figure;
    for iChan=1:62;
        subplot(7,10,iChan);
        iChan2=iChan+iG*62;
        errorbar(sq(mean(loadMat(goodSubj,iChan2,1,:))),std(sq(loadMat(goodSubj,iChan2,1,:)),[],1)./sqrt(size(loadMat,1)));
        hold on;
        errorbar(sq(mean(loadMat(goodSubj,iChan2,1,:))),std(sq(loadMat(goodSubj,iChan2,2,:)),[],1)./sqrt(size(loadMat,1)));
        hold on;
        errorbar(sq(mean(loadMat(goodSubj,iChan2,1,:))),std(sq(loadMat(goodSubj,iChan2,3,:)),[],1)./sqrt(size(loadMat,1)));
        hold on;
        errorbar(sq(mean(loadMat(goodSubj,iChan2,1,:))),std(sq(loadMat(goodSubj,iChan2,4,:)),[],1)./sqrt(size(loadMat,1)));
    end
end




%figure;plot(sum((eegOutB./mean(eegOutB,2))))
iiOut=find(sum((eegOutD./mean(eegOutD,2)))>(3*std(sum((eegOutD./mean(eegOutD,2))))+mean(sum((eegOutD./mean(eegOutD,2))))));
goodTrials=setdiff(1:192,iiOut);
%goodTrials=setdiff(1:192,[7,20,75,82,90,123,144]); % E3
noResp=isnan(sq(behaviorMat(8,iSN,:)));
ii=find(noResp==1);
goodTrials=setdiff(goodTrials,ii);

for iG=0:1;
    figure;
    for iChan=1:62;
        subplot(7,10,iChan);
        iChan2=iChan+iG*62;
        tvimage(sq(mean(abs(eegSpecD(iChan2,goodTrials,:,:)),2)./mean(mean(abs(eegSpecB(iChan2,goodTrials,1:10,:)),2),3)));
        caxis([0.8 1.2]);
    end
end

for iG=0:1;
    figure;
    for iChan=1:62;
        subplot(7,10,iChan);
        iChan2=iChan+iG*62;
      tvimage(sq(mean(abs(eegSpecA(iChan2,goodTrials,:,:)),2)./mean(mean(abs(eegSpecB(iChan2,goodTrials,1:10,:)),2),3)));
     %    tvimage(sq(mean(abs(eegSpecA(iChan2,goodTrials,:,:)),2)./mean(mean(abs(eegSpecA(iChan2,goodTrials,26:38,:)),2),3)));

        caxis([0.8 1.2]);
    end
end



ii3=find(sq(behaviorMat(2,iSN,:))==3);
ii5=find(sq(behaviorMat(2,iSN,:))==5);
ii7=find(sq(behaviorMat(2,iSN,:))==7);
ii9=find(sq(behaviorMat(2,iSN,:))==9);


for iG=0:1;
    figure;
    for iChan=1:62;
        subplot(7,10,iChan);
        iChan2=iChan+iG*62;
        plot(mean(sq(mean(abs(eegSpecD(iChan2,intersect(ii3,goodTrials),:,:)),2)./mean(mean(abs(eegSpecB(iChan2,goodTrials,1:10,:)),2),3))));
        hold on;
        plot(mean(sq(mean(abs(eegSpecD(iChan2,intersect(ii5,goodTrials),:,:)),2)./mean(mean(abs(eegSpecB(iChan2,goodTrials,1:10,:)),2),3))));
        hold on;
        plot(mean(sq(mean(abs(eegSpecD(iChan2,intersect(ii7,goodTrials),:,:)),2)./mean(mean(abs(eegSpecB(iChan2,goodTrials,1:10,:)),2),3))));
        hold on;
        plot(mean(sq(mean(abs(eegSpecD(iChan2,intersect(ii9,goodTrials),:,:)),2)./mean(mean(abs(eegSpecB(iChan2,goodTrials,1:10,:)),2),3))));
        
        axis('tight');
    end
end


iiHW=find(sq(behaviorMat(3,iSN,:))==1);
iiHNW=find(sq(behaviorMat(3,iSN,:))==2);
iiLW=find(sq(behaviorMat(3,iSN,:))==3);
iiLNW=find(sq(behaviorMat(3,iSN,:))==4);

iiW=cat(1,iiHW,iiLW);
iiNW=cat(1,iiHNW,iiLNW);


for iG=0:1;
    figure;
    for iChan=1:62;
        subplot(7,10,iChan);
        iChan2=iChan+iG*62;
        plot(mean(sq(mean(abs(eegSpecD(iChan2,intersect(iiHW,goodTrials),:,:)),2)./mean(mean(abs(eegSpecB(iChan2,goodTrials,1:10,:)),2),3))));
        hold on;
        plot(mean(sq(mean(abs(eegSpecD(iChan2,intersect(iiHNW,goodTrials),:,:)),2)./mean(mean(abs(eegSpecB(iChan2,goodTrials,1:10,:)),2),3))));
        hold on;
        plot(mean(sq(mean(abs(eegSpecD(iChan2,intersect(iiLW,goodTrials),:,:)),2)./mean(mean(abs(eegSpecB(iChan2,goodTrials,1:10,:)),2),3))));
        hold on;
        plot(mean(sq(mean(abs(eegSpecD(iChan2,intersect(iiLNW,goodTrials),:,:)),2)./mean(mean(abs(eegSpecB(iChan2,goodTrials,1:10,:)),2),3))));
        
        axis('tight');
    end
end


for iG=0:1;
    figure;
    for iChan=1:62;
        subplot(7,10,iChan);
        iChan2=iChan+iG*62;
        plot(mean(sq(mean(abs(eegSpecD(iChan2,intersect(iiNW,intersect(ii3,goodTrials)),:,:)),2)./mean(mean(abs(eegSpecB(iChan2,goodTrials,1:10,:)),2),3))));
        hold on;
        plot(mean(sq(mean(abs(eegSpecD(iChan2,intersect(iiNW,intersect(ii5,goodTrials)),:,:)),2)./mean(mean(abs(eegSpecB(iChan2,goodTrials,1:10,:)),2),3))));
        hold on;
        plot(mean(sq(mean(abs(eegSpecD(iChan2,intersect(iiNW,intersect(ii7,goodTrials)),:,:)),2)./mean(mean(abs(eegSpecB(iChan2,goodTrials,1:10,:)),2),3))));
        hold on;
        plot(mean(sq(mean(abs(eegSpecD(iChan2,intersect(iiNW,intersect(ii9,goodTrials)),:,:)),2)./mean(mean(abs(eegSpecB(iChan2,goodTrials,1:10,:)),2),3))));
        
        axis('tight');
    end
end




% correlate with RT?
fRange=18:22;
for iG=0:1;

    for iChan=1:62;
        iChan2=iChan+iG*62;
        scatter(sq(behaviorMat(8,iSN,goodTrials)),sq(mean(mean(abs(eegSpecD(iChan2,goodTrials,:,fRange))./mean(mean(abs(eegSpecD(iChan2,goodTrials,1:10,fRange)),2),3),3),4)));
        [R P]=corrcoef(sq(behaviorMat(8,iSN,goodTrials)),sq(mean(mean(abs(eegSpecD(iChan2,goodTrials,:,fRange))./mean(mean(abs(eegSpecD(iChan2,goodTrials,1:10,fRange)),2),3),3),4)));
Rvals(iChan2)=R(1,2);
Pvals(iChan2)=P(1,2);
    end
end
