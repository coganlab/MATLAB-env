global BOX_DIR
global RECONDIR
global TASK_DIR
global experiment
global DUKEDIR
global RESPONSE_DIR
BOX_DIR='C:\Users\gcoga\Box';
RECONDIR='C:\Users\gcoga\Box\ECoG_Recon';
RESPONSE_DIR='C:\Users\gcoga\Box\CoganLab\ECoG_Task_Data\response_coding\response_coding_results_PaleeEdits';

addpath(genpath([BOX_DIR '\CoganLab\Scripts\']));

Task=[];
%Task.Name='Phoneme_Sequencing';
Task.Name='LexicalDecRepDelay';

TASK_DIR=([BOX_DIR '/CoganLab/D_Data/' Task.Name]);
DUKEDIR=TASK_DIR;

Subject = popTaskSubjectData(Task.Name);

SN=9;
%for SN=1:length(Subject)
    clear ieeg*
    experiment=Subject(SN).experiment;
    Trials=Subject(SN).Trials;

    ieegA=trialIEEG(Subject(SN).Trials,Subject(SN).goodChannels,'Auditory',[-1000 2000]);
    ieegACAR=ieegA-mean(ieegA,2);
    display('Auditory Aligned Done')
    ieegP=trialIEEG(Subject(SN).Trials,Subject(SN).goodChannels,'Go',[-3000 2000]);
    ieegPCAR=ieegP-mean(ieegP,2);
    display('Go Cue Aligned Done')
    ieegM=trialIEEG(Subject(SN).Trials,Subject(SN).goodChannels,'ResponseStart',[-2000 2000]);
    ieegMCAR=ieegM-mean(ieegM,2);
    display('Response Aligned Done')
    ieegS=trialIEEG(Subject(SN).Trials,Subject(SN).goodChannels,'Start',[-1000 1000]);
    ieegSCAR=ieegS-mean(ieegS,2);
    display('Start Aligned Done')
    srateIn = experiment.recording.sample_rate;
    srateOut = 100; %experiment.recording.sample_rate;
    fRange = [70 150];
    timeWinA = [-1000./1000 2000./1000];
    timeWinP=[-3000./1000 2000./1000];
    timeWinS = [-1000./1000 1000./1000];
    timeWinM = [-2000./1000 2000./1000];
    edgeTimeWinA = [-1 2]; % to remove edge artefacts
    edgeTimeWinP=[-3 2];
    edgeTimeWinS=[-1 1];
    edgeTimeWinM=[-2 2];
    ieegGammaA = zeros(size(ieegACAR,1),size(ieegACAR,2),(edgeTimeWinA(2)-edgeTimeWinA(1))*srateOut);
    ieegGammaP = zeros(size(ieegPCAR,1),size(ieegPCAR,2),(edgeTimeWinP(2)-edgeTimeWinP(1))*srateOut);
    ieegGammaS = zeros(size(ieegSCAR,1),size(ieegSCAR,2),(edgeTimeWinS(2)-edgeTimeWinS(1))*srateOut);
    ieegGammaM = zeros(size(ieegMCAR,1),size(ieegMCAR,2),(edgeTimeWinM(2)-edgeTimeWinM(1))*srateOut);
    normFactor = []; % No normalization
    for iChan = 1:size(ieegACAR,2)
        [~,ieegGammaA(:,iChan,:)] = EcogExtractHighGammaTrial(sq(ieegACAR(:,iChan,:)), srateIn ,srateOut ,fRange  ,timeWinA ,edgeTimeWinA,  normFactor );
        [~,ieegGammaP(:,iChan,:)] = EcogExtractHighGammaTrial(sq(ieegPCAR(:,iChan,:)), srateIn ,srateOut ,fRange  ,timeWinP ,edgeTimeWinP,  normFactor );
        [~,ieegGammaS(:,iChan,:)] = EcogExtractHighGammaTrial(sq(ieegSCAR(:,iChan,:)), srateIn ,srateOut ,fRange  ,timeWinP ,edgeTimeWinP,  normFactor );
        [~,ieegGammaM(:,iChan,:)] = EcogExtractHighGammaTrial(sq(ieegMCAR(:,iChan,:)), srateIn ,srateOut ,fRange  ,timeWinM ,edgeTimeWinM,  normFactor );
        display(['Channel ' num2str(iChan) ' of ' num2str(size(ieegACAR,2))])
    end
    ieegGammaPN=ieegGammaP./mean(ieegGammaS(:,:,51:100),3);
    ieegGammaAN=ieegGammaA./mean(ieegGammaA(:,:,51:100),3);
    ieegGammaSN=ieegGammaS./mean(ieegGammaS(:,:,51:100),3);
    ieegGammaMN=ieegGammaM./mean(ieegGammaS(:,:,51:100),3);
    
    
condIdx = lexSort(Subject(SN).trialInfo);
iiR=find(condIdx>=5);
RT=[];
for iTrials=1:length(Trials);
    if Trials(iTrials).ResponseStart>0
        RT(iTrials)=(Trials(iTrials).ResponseStart-Trials(iTrials).Go)./30;
    else
        RT(iTrials)=0;
    end
end


iiIn=find(RT(iiR)>300 & RT(iiR)<1500);
[ii jj]=sort(RT(iiR(iiIn)),'descend');

iiWR=find(condIdx==5 | condIdx==6); % words rep
iiNWR=find(condIdx==7 | condIdx==8); % nonwords rep

trialNums=[];
for iTrials=1:length(Subject(SN).Trials)
    trialNums(iTrials,1)=Trials(iTrials).Trial;
    trialNums(iTrials,2)=iTrials;
end
iiWR=find(condIdx==5 | condIdx==7); % high rep
iiNWR=find(condIdx==6 | condIdx==8); % low rep

[~,~,iiWR]=intersect(iiWR,trialNums(:,1));
[~,~,iiNWR]=intersect(iiNWR,trialNums(:,1));


clear pLex tLex
    for iChan=1:size(ieegGammaAN,2);
        [h p ci stats]=ttest2(sq(mean(ieegGammaPN(iiWR,iChan,101:200),3)),sq(mean(ieegGammaPN(iiNWR,iChan,101:200),3)));
        pLex(iChan)=p;
        tLex(iChan)=stats.tstat;
        display(iChan)
    end;

    iiP=find(pLex<.05);
    
    
    iChan=54;
    display(Subject(SN).ChannelInfo(Subject(SN).goodChannels(iChan)))
    tM=linspace(-1.5,1.5,300);
    figure;
    subplot(3,1,1);
    errorbar(tM,sq(mean(ieegGammaMN(iiWR,iChan,51:350))),std(sq(ieegGammaMN(iiWR,iChan,51:350)),[],1)./sqrt(length(iiWR)));
    hold on;errorbar(tM,sq(mean(ieegGammaMN(iiNWR,iChan,51:350))),std(sq(ieegGammaMN(iiNWR,iChan,51:350)),[],1)./sqrt(length(iiNWR)));
    title('Utterance Aligned')
    %ylim([0.7 1.5])
    
    tP=linspace(-1.5,1.5,300);
    subplot(3,1,2)
    errorbar(tP,sq(mean(ieegGammaPN(iiWR,iChan,51:350))),std(sq(ieegGammaPN(iiWR,iChan,51:350)),[],1)./sqrt(length(iiWR)));
    hold on;errorbar(tP,sq(mean(ieegGammaPN(iiNWR,iChan,51:350))),std(sq(ieegGammaPN(iiNWR,iChan,51:350)),[],1)./sqrt(length(iiNWR)));
    title('Go Aligned')
    
    tA=linspace(-0.5,1.5,200);
    subplot(3,1,3)
    errorbar(tA,sq(mean(ieegGammaAN(iiWR,iChan,51:250))),std(sq(ieegGammaAN(iiWR,iChan,51:250)),[],1)./sqrt(length(iiWR)));
    hold on;errorbar(tA,sq(mean(ieegGammaAN(iiNWR,iChan,51:250))),std(sq(ieegGammaAN(iiNWR,iChan,51:250)),[],1)./sqrt(length(iiNWR)));
    title('Aud Aligned')