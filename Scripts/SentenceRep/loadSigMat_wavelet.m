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
iiA=cell(1,5);
iiP=cell(1,5);
iiSM=cell(1,5);
zValLSA=[];
zValLMA=[];
zValJLA=[];
zValLSP=[];
zValLMP=[];
zValJLP=[];
sigMatLSA=[];
sigMatJLA=[];
sigMatLMA=[];
sigMatLSP=[];
sigMatJLP=[];
sigMatLMP=[];
counter=0;
zVal=1;
for iSN=1:length(SNList)

SN = SNList(iSN);
load([DUKEDIR '/SentenceRep/' Subject(SN).Name '_LocalizerLSLMHL_5Bands_Outlier8_timepointsvsStartbaselineClusterZ_2Tails_Wavelet.mat']);
%load([DUKEDIR '/SentenceRep/' Subject(SN).Name '_LocalizerLSLMHL_5Bands_Outlier8_timepointsvsStartbaselineClusterZ_2Tails_Wavelet_AudBaseline.mat']);


[iiAt iiPt iiSMt sigMatLSAt sigMatLMAt sigMatJLAt sigMatLSPt sigMatLMPt sigMatJLPt]=convertActClusttoIdxFreq(actClustLSA,actClustLMA,actClustJLA,actClustLSP,actClustLMP,actClustJLP,zVal);

for iF=1:5;
    iiA{iF}=cat(2,iiA{iF},iiAt{iF}+counter);
    iiP{iF}=cat(2,iiP{iF},iiPt{iF}+counter);
    iiSM{iF}=cat(2,iiSM{iF},iiSMt{iF}+counter);
end

for iF=1:5
    for iChan=1:length(zValsRawActLSA)
        zValLSA(iF,iChan+counter,:)=zValsRawActLSA{iChan}{iF};
        zValJLA(iF,iChan+counter,:)=zValsRawActJLA{iChan}{iF};
        zValLMA(iF,iChan+counter,:)=zValsRawActLMA{iChan}{iF};
        zValLSP(iF,iChan+counter,:)=zValsRawActLSP{iChan}{iF};
        zValJLP(iF,iChan+counter,:)=zValsRawActJLP{iChan}{iF};
        zValLMP(iF,iChan+counter,:)=zValsRawActLMP{iChan}{iF};
    end
end
        
    sigMatLSA=cat(2,sigMatLSA,sigMatLSAt);
    sigMatJLA=cat(2,sigMatJLA,sigMatJLAt);
    sigMatLMA=cat(2,sigMatLMA,sigMatLMAt);
    sigMatLSP=cat(2,sigMatLSP,sigMatLSPt);
    sigMatJLP=cat(2,sigMatJLP,sigMatJLPt);
    sigMatLMP=cat(2,sigMatLMP,sigMatLMPt);
    counter=counter+size(sigMatLSAt,2);
    display(iSN)
end
 