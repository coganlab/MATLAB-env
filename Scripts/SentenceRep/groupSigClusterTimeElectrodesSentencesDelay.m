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

iiLSSAT=[];
iiJLSAT=[];
iiLSSPT=[];
iiJLSPT=[];
iiLSSDT=[];
iiJLSDT=[];
dataAST=[];
dataPST=[];
dataDST=[];
elecsT=[];
elecsSN=[];
sigMatLSSAT=[];
sigMatJLSAT=[];
sigMatLSSPT=[];
sigMatJLSPT=[];
sigMatLSSDT=[];
sigMatJLSDT=[];
zVal=1;
counterElec=0;
for iSN=1:length(SNList)
    SN=SNList(iSN);
    if zVal==0
  %  load([DUKEDIR '/SentenceRep/' Subject(SN).Name '_LocalizerLSLMHL_70150_Outlier8_timepointsvsbaselineCluster.mat']);
   % [iiA iiP iiSM sigMatLSA sigMatLMA sigMatJLA sigMatLSP sigMatLMP sigMatJLP]=convertActClusttoIdx(actClustLSA,actClustLMA,actClustJLA,actClustLSP,actClustLMP,actClustJLP,0);
    elseif zVal==1
    %  load([DUKEDIR '/SentenceRep/' Subject(SN).Name '_LocalizerLSLMHL_70150_Outlier8_timepointsvsbaselineClusterZ.mat']);
   %     load([DUKEDIR '/SentenceRep/' Subject(SN).Name '_Sentence_70150_Outlier8_timepointsvsbaselineClusterZ.mat']);
        load([DUKEDIR '/SentenceRep/' Subject(SN).Name '_Sentence_70100_Outlier8_timepointsvsbaselineClusterZDelay.mat']);

      %  load([DUKEDIR '/SentenceRep/' Subject(SN).Name '_LocalizerLSLMHL_70100_Outlier8_timepointsvsbaselineClusterZ_StartDelay.mat']);
    %  [iiA iiP iiSM sigMatLSA sigMatLMA sigMatJLA sigMatLSP sigMatLMP sigMatJLP]=convertActClusttoIdx(actClustLSA,actClustLMA,actClustJLA,actClustLSP,actClustLMP,actClustJLP,1);   
%    [iiLSSA iiJLSA iiLSSP iiJLSP sigMatLSSA sigMatJLSA sigMatLSSP sigMatJLSP]=convertActClusttoIdxSentence(actClustLSA,actClustJLA,actClustLSP,actClustJLP,zVal);   
    [iiLSSA iiJLSA iiLSSP iiJLSP iiLSSD iiJLSD sigMatLSSA sigMatJLSA sigMatLSSP sigMatJLSP sigMatLSSD sigMatJLSD ]=convertActClusttoIdxSentenceFull(actClustLSA,actClustJLA,actClustLSP,actClustJLP,actClustLSD,actClustJLD,zVal);   

    end
    
%     if SN==29;
%         iiLSSA=setdiff(iiLSSA,109:140);
%         iiJLSA=setdiff(iiJLSA,109:140);
%         iiLSSP=setdiff(iiLSSP,109:140);
%         iiJLSA=setdiff(iiJLSP,109:140);
%         sigMatLSSA=sigMatJLSA(1:108,:);
%         sigMatJLSA=sigMatJLSA(1:108,:);
%         sigMatLSSP=sigMatLSSP(1:108,:);
%         sigMatJLSP=sigMatJLSP(1:108,:);
%     end
        
    sigMatLSSAT=cat(1,sigMatLSSAT,sigMatLSSA);
    sigMatJLSAT=cat(1,sigMatJLSAT,sigMatJLSA);
    sigMatLSSPT=cat(1,sigMatLSSPT,sigMatLSSP);
    sigMatJLSPT=cat(1,sigMatJLSPT,sigMatJLSP); 
    sigMatLSSDT=cat(1,sigMatLSSDT,sigMatLSSD);
    sigMatJLSDT=cat(1,sigMatJLSDT,sigMatJLSD);
 
    elecs=list_electrodes_from_experiment(Subject(SN).Name);
    elecs=elecs(AnalParams.Channel);
%     if SN==29
%         elecs=elecs(1:108);
%         dataA=dataA(1:108,:,:);
%         dataP=dataP(1:108,:,:);
%     else
    dataA=dataA(1:length(AnalParams.Channel),:,:);
    dataP=dataP(1:length(AnalParams.Channel),:,:);
%     end
    dataAST=cat(1,dataAST,dataA);
    dataPST=cat(1,dataPST,dataP);
    dataDST=cat(1,dataDST,dataD);
   
    if ~isempty(iiLSSA)
        iiLSSA=iiLSSA+counterElec;
        iiLSSAT=cat(2,iiLSSAT,iiLSSA);
    end
    if ~isempty(iiJLSA)
        iiJLSA=iiJLSA+counterElec;
        iiJLSAT=cat(2,iiJLSAT,iiJLSA);
    end
    
    if ~isempty(iiLSSP)
        iiLSSP=iiLSSP+counterElec;
        iiLSSPT=cat(2,iiLSSPT,iiLSSP);
    end
    if ~isempty(iiJLSP)
        iiJLSP=iiJLSP+counterElec;
        iiJLSPT=cat(2,iiJLSPT,iiJLSP);
    end 
    
      if ~isempty(iiLSSD)
        iiLSSD=iiLSSD+counterElec;
        iiLSSDT=cat(2,iiLSSDT,iiLSSD);
    end
    if ~isempty(iiJLSD)
        iiJLSD=iiJLSD+counterElec;
        iiJLSDT=cat(2,iiJLSDT,iiJLSD);
    end
    elecsT=cat(1,elecsT,elecs);
    elecsSN=cat(1,elecsSN,SN*ones(length(elecs),1));
    counterElec=counterElec+length(elecs);
end
  
iiLSSAT=unique(iiLSSAT);
iiJLSAT=unique(iiJLSAT);
iiLSSPT=unique(iiLSSPT);
iiJLSPT=unique(iiJLSPT);
iiLSSDT=unique(iiLSSDT);
iiJLSDT=unique(iiJLSDT);

iiLSSPT=find(sq(sum(sum(sigMatLSSPT,2),3))>0);
iiLSSAT=find(sq(sum(sum(sigMatLSSAT,2),3))>0);
iiSMLSST=intersect(iiLSSAT,iiLSSPT);
iiSMLSST2=intersect(iiSMLSST,iiNWM);
iiPLSST=setdiff(iiLSSPT,iiSMLSST);
iiALSST=setdiff(iiLSSAT,iiSMLSST);
iiPLSST2=intersect(iiPLSST,iiNWM);
iiALSST2=intersect(iiALSST,iiNWM);