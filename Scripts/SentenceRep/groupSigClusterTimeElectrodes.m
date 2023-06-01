duke;
global experiment

Subject(3).Name = 'D3'; Subject(3).Day = '160910';
Subject(5).Name = 'D5'; Subject(5).Day = '161028';
Subject(7).Name = 'D7'; Subject(7).Day = '170130';
Subject(8).Name = 'D8'; Subject(8).Day = '030317';
Subject(9).Name = 'D9'; Subject(9).Day = '170526';
Subject(11).Name = 'D11'; Subject(11).Day = '170809';
Subject(12).Name= 'D12'; Subject(12).Day = '170911';
Subject(13).Name = 'D13'; Subject(13).Day = '171009';
Subject(14).Name = 'D14'; Subject(14).Day = '171112';
Subject(15).Name = 'D15'; Subject(15).Day = '171216'; % 180309 = lexical between, 180310 = lexical long no delay
Subject(16).Name = 'D16'; Subject(16).Day = '180123';
Subject(17).Name = 'D17'; Subject(17).Day = '180310';
Subject(18).Name = 'D18'; Subject(18).Day = '180327';
Subject(20).Name = 'D20'; Subject(20).Day = '180519';
Subject(22).Name = 'D22'; Subject(22).Day = '180705';
Subject(23).Name = 'D23'; Subject(23).Day = '180715';
Subject(24).Name = 'D24'; Subject(24).Day = '181027';
Subject(26).Name = 'D26'; Subject(26).Day = '190129';
Subject(27).Name = 'D27'; Subject(27).Day = '190303';
Subject(28).Name = 'D28'; Subject(28).Day = '190302';
Subject(29).Name = 'D29'; Subject(29).Day = '190315';
%Subject(30).Name = 'D30'; Subject(30).Day = '181027';
%Subject(31).Name = 'D31'; Subject(31).Day = '181027';

SNList=[3,5,7,8,9,12,13,14,15,16,17,18,20,22,23,24,26,27,28,29];
SNList=[3,5,7,8,9,12,13,14,15,16,17,18,20,22];

iiAT=[];
iiPT=[];
iiSMT=[];
elecsT=[];
dataAT=[];
dataPT=[];

sigMatLSAT=[];
sigMatLMAT=[];
sigMatJLAT=[];
sigMatLSPT=[];
sigMatLMPT=[];
sigMatJLPT=[];
zVal=1;
counterElec=0;
for iSN=1:length(SNList)
    SN=SNList(iSN);
    if zVal==0
    load([DUKEDIR '/SentenceRep/' Subject(SN).Name '_LocalizerLSLMHL_70150_Outlier8_timepointsvsbaselineCluster.mat']);
    [iiA iiP iiSM sigMatLSA sigMatLMA sigMatJLA sigMatLSP sigMatLMP sigMatJLP]=convertActClusttoIdx(actClustLSA,actClustLMA,actClustJLA,actClustLSP,actClustLMP,actClustJLP,0);
    elseif zVal==1
      load([DUKEDIR '/SentenceRep/' Subject(SN).Name '_LocalizerLSLMHL_70100_Outlier8_timepointsvsbaselineClusterZ.mat']);
    %  load([DUKEDIR '/SentenceRep/' Subject(SN).Name '_LocalizerLSLMHL_70100_Outlier8_timepointsvsbaselineClusterZ_StartDelay.mat']);
    %  [iiA iiP iiSM sigMatLSA sigMatLMA sigMatJLA sigMatLSP sigMatLMP sigMatJLP]=convertActClusttoIdx(actClustLSA,actClustLMA,actClustJLA,actClustLSP,actClustLMP,actClustJLP,1);   
      [iiA iiP iiSM sigMatLSA sigMatLMA sigMatJLA sigMatLSP sigMatLMP sigMatJLP]=convertActClusttoIdx(actClustLSA,actClustLMA,actClustJLA,actClustLSP,actClustLMP,actClustJLP,1);   
    
    end
    sigMatLSAT=cat(1,sigMatLSAT,sigMatLSA);
    sigMatLMAT=cat(1,sigMatLMAT,sigMatLMA);
    sigMatJLAT=cat(1,sigMatJLAT,sigMatJLA);
    sigMatLSPT=cat(1,sigMatLSPT,sigMatLSP);
    sigMatLMPT=cat(1,sigMatLMPT,sigMatLMP);
    sigMatJLPT=cat(1,sigMatJLPT,sigMatJLP); 
    
 
    elecs=list_electrodes_from_experiment(Subject(SN).Name);
    elecs=elecs(AnalParams.Channel);
    dataA=dataA(1:length(AnalParams.Channel),:,:);
    dataP=dataP(1:length(AnalParams.Channel),:,:);
    dataAT=cat(1,dataAT,dataA);
    dataPT=cat(1,dataPT,dataP);
   
    if ~isempty(iiA)
        iiA=iiA+counterElec;
        iiAT=cat(2,iiAT,iiA);
    end
    if ~isempty(iiP)
        iiP=iiP+counterElec;
        iiPT=cat(2,iiPT,iiP);
    end
    if ~isempty(iiSM)
        iiSM=iiSM+counterElec;
        iiSMT=cat(2,iiSMT,iiSM);
    end
    elecsT=cat(1,elecsT,elecs);
    counterElec=counterElec+length(elecs);
end
  
iiAT=unique(iiAT);
iiPT=unique(iiPT);
iiSMT=unique(iiSMT);