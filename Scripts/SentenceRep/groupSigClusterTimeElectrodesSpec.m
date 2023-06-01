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

%SNList=[3,5,7,8,9,12,13,14,15,16,17,18,20,22,23,24,26,27,28,29];
SNList=[3,5,7,8,9,12,13,14,15,16,17,18,20,22];

sigMatLSATSP=[];
sigMatLMATSP=[];
sigMatJLATSP=[];
sigMatLSPTSP=[];
sigMatLMPTSP=[];
sigMatJLPTSP=[];
zValsRawActLSAT=[];
zValsRawActLMAT=[];
zValsRawActJLAT=[];
zValsRawActLSPT=[];
zValsRawActLMPT=[];
zValsRawActJLPT=[];
zVal=1;
counterElec=0;
for iSN=1:length(SNList)
    SN=SNList(iSN);
    load([DUKEDIR '/SentenceRep/' Subject(SN).Name '_LocalizerLSLMHL_Outlier8_timepointsvsbaselineSpecClusterZ.mat']);


[sigMatLSA, sigMatLMA, sigMatJLA, sigMatLSP, sigMatLMP, sigMatJLP]=convertActClusttoIdxSpec(actClustLSA,actClustLMA,actClustJLA,actClustLSP,actClustLMP,actClustJLP);

sigMatLSATSP=cat(1,sigMatLSATSP,sigMatLSA);
sigMatLMATSP=cat(1,sigMatLMATSP,sigMatLMA);
sigMatJLATSP=cat(1,sigMatJLATSP,sigMatJLA);
sigMatLSPTSP=cat(1,sigMatLSPTSP,sigMatLSP);
sigMatLMPTSP=cat(1,sigMatLMPTSP,sigMatLMP);
sigMatJLPTSP=cat(1,sigMatJLPTSP,sigMatJLP);


zValsRawActLSA2={};
zValsRawActLMA2={};
zValsRawActJLA2={};
zValsRawActLSP2={};
zValsRawActLMP2={};
zValsRawActJLP2={};

for iChan=1:size(sigMatLSA,1)
    zValsRawActLSA2{iChan}=zValsRawActLSA{iChan};
    zValsRawActLMA2{iChan}=zValsRawActLMA{iChan};
    zValsRawActJLA2{iChan}=zValsRawActJLA{iChan};
    zValsRawActLSP2{iChan}=zValsRawActLSP{iChan};
    zValsRawActLMP2{iChan}=zValsRawActLMP{iChan};
    zValsRawActJLP2{iChan}=zValsRawActJLP{iChan};
end


zValsRawActLSAT=cat(2,zValsRawActLSAT,zValsRawActLSA2);
zValsRawActLMAT=cat(2,zValsRawActLMAT,zValsRawActLMA2);
zValsRawActJLAT=cat(2,zValsRawActJLAT,zValsRawActJLA2);
zValsRawActLSPT=cat(2,zValsRawActLSPT,zValsRawActLSP2);
zValsRawActLMPT=cat(2,zValsRawActLMPT,zValsRawActLMP2);
zValsRawActJLPT=cat(2,zValsRawActJLPT,zValsRawActJLP2);
end


iiLSA=find(sq(sum(sum(sigMatLSATSP,2),3))>0);
iiLMA=find(sq(sum(sum(sigMatLMATSP,2),3))>0);
iiJLA=find(sq(sum(sum(sigMatJLATSP,2),3))>0);

iiLSP=find(sq(sum(sum(sigMatLSPTSP,2),3))>0);
iiLMP=find(sq(sum(sum(sigMatLMPTSP,2),3))>0);
iiJLP=find(sq(sum(sum(sigMatJLPTSP,2),3))>0);

iiA1=intersect(iiLSA,iiLMA);
iiA2=intersect(iiA1,iiJLA);
iiP1=intersect(iiLSP,iiLMP);
iiSM=intersect(iiA1,iiP1);
iiA=setdiff(iiA2,iiSM);
iiP=setdiff(iiP1,iiSM);