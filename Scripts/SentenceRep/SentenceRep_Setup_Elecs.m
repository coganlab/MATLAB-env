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

subjNames={};
for iSN=1:length(SNList);
    subjNames=cat(2,subjNames,Subject(SNList(iSN)).Name);
end
    
subj_labelsRecord=list_electrodes(subjNames);

subj_labelsAnalyze={};
counter=0;
for iSN=1:length(SNList)
    SN=SNList(iSN);
    if strcmp(Subject(SN).Name,'D1')
    AnalParams.Channel = [1:66];
elseif  strcmp(Subject(SN).Name,'D3')
    AnalParams.Channel = [1:52];
    badChans=[12];
    AnalParams.Channel=setdiff(AnalParams.Channel,badChans);
elseif  strcmp(Subject(SN).Name,'D5')
    AnalParams.Channel = [1:44]; 
elseif  strcmp(Subject(SN).Name,'D7')
    AnalParams.Channel = [1:102];
 %   AnalParams.Channel = [17:80]; % just grid    
elseif strcmp(Subject(SN).Name,'D8')
    AnalParams.Channel = [1:110];
elseif strcmp(Subject(SN).Name,'D9')
    AnalParams.Channel = [1:120]; 
elseif strcmp(Subject(SN).Name,'D11')
    AnalParams.Channel = [1:118];      
elseif strcmp(Subject(SN).Name,'D12')
    AnalParams.Channel = [1:110];
elseif strcmp(Subject(SN).Name,'D13')
    AnalParams.Channel = [1:120];
 %   AnalParams.ReferenceChannels=[18:20];
 elseif strcmp(Subject(SN).Name,'D14')
    AnalParams.Channel = [1:120];
 elseif strcmp(Subject(SN).Name,'D15')
    AnalParams.Channel = [1:120];
  %  AnalParams.ReferenceChannels=[62:63,105:106];
elseif strcmp(Subject(SN).Name,'D16')
    AnalParams.Channel = [1:41];
elseif strcmp(Subject(SN).Name,'S1');
   % AnalParams.Channel=[1:256];
    AnalParams.Channel=setdiff(1:256,[2,32,64,66,96,128,130,160,192,194,224,256]);
elseif strcmp(Subject(SN).Name,'D17');
    AnalParams.Channel=[1:114];
elseif strcmp(Subject(SN).Name,'D18');
    AnalParams.Channel=[1:122];
elseif strcmp(Subject(SN).Name,'D19');
    AnalParams.Channel=[1:76];    
elseif strcmp(Subject(SN).Name,'S6');
   AnalParams.Channel=setdiff(1:256,[12,32,53,66,96,128,130,160,192,204,224,245]);
elseif strcmp(Subject(SN).Name,'D20');
    AnalParams.Channel=[1:120];
elseif strcmp(Subject(SN).Name,'D22');
    AnalParams.Channel=[1:100];
elseif strcmp(Subject(SN).Name,'D23');
        AnalParams.Channel=[1:121];
elseif strcmp(Subject(SN).Name,'D24');
        AnalParams.Channel=[1:52];
elseif strcmp(Subject(SN).Name,'D26');
    AnalParams.Channel=[1:60];        
elseif strcmp(Subject(SN).Name,'D27');
    AnalParams.Channel=[1:114];
  %  AnalParams.ReferenceChannels=[72,99,100];
elseif strcmp(Subject(SN).Name,'D28');
    AnalParams.Channel=[1:108];
elseif strcmp(Subject(SN).Name,'D29');
    AnalParams.Channel=[1:108]; %change to 140!
else
    AnalParams.Channel = [1:64];
    end
load([DUKEDIR '\' Subject(SN).Name '\mat\experiment.mat'])

for iChan=1:length(AnalParams.Channel)
    subj_labelsAnalyze{counter+1}=cat(1,[Subject(SN).Name '-' experiment.channels(AnalParams.Channel(iChan)).name]);
    counter=counter+1;
end
end


% run m190401_Electrodes
for iElec1=1:length(subj_labelsAnalyze)
    for iElec2=1:length(subj_labels2)
        tmp=subj_labelsAnalyze{iElec1};
        if strcmp(tmp(find(~isspace(tmp))),subj_labels2{iElec2});
            subj_labelsAnalyze_loc{iElec1}=subj_labels_loc{iElec2};            
        end
    end
end

counterNWM=0;
subj_labelsAnalyze_WM=[];
counterWM=0;
for iChan=1:length(subj_labelsAnalyze_loc)
 %   if contains(subj_labels_loc{iChan},'White-Matter') || strcmp(subj_labels_loc{iChan},' ')
     if  strcmp(subj_labelsAnalyze_loc{iChan},' ') || contains(subj_labelsAnalyze_loc{iChan},'White-Matter') || strcmp(subj_labelsAnalyze_loc{iChan},'Unknown') || strcmp(subj_labelsAnalyze_loc{iChan},'unknown') || strcmp(subj_labelsAnalyze_loc{iChan},'hypointensities')
        subj_labelsAnalyze_WM(iChan)=1;
        counterWM=counterWM+1;
      %  subj_labels_NWM(iChan)=0;
    else
        subj_labelsAnalyze_WM(iChan)=0;
     %   subj_labels_NWM(counterNWM+1)=iChan;
        counterNWM=counterNWM+1;
    end
end
iiA_NWM=find(subj_labelsAnalyze_WM==0);


subj_labelsAnalyze_locUnique=unique(subj_labelsAnalyze_loc);

listVal=iiPCNW;
counter=0;
areaElecsFunction=zeros(length(subj_labelsAnalyze_locUnique),1);
for iE=1:length(listVal)
    for iS=1:length(subj_labelsAnalyze_locUnique)
        if strcmp(subj_labelsAnalyze_loc{listVal(iE)},subj_labelsAnalyze_locUnique{iS})
            areaElecsFunction(iS)=areaElecsFunction(iS)+1;
        end
    end
end
            



iiEarlyS=find(clusterStartLSSA2(iiLSSA)<18 & clusterStartLSSA2(iiLSSA)>=10);
iiLateS=find(clusterStartLSSA2(iiLSSA)>=18 & clusterStartLSSA2(iiLSSA)<=100);
iiEarlyW=find(clusterStartLSA2(iiSM2)<20 & clusterStartLSA2(iiSM2)>=6);
iiLateW=find(clusterStartLSA2(iiSM2)>=20 & clusterStartLSA2(iiSM2)<=40);

iiEarlyW=iiSM2(iiEarlyW);
iiLateW=iiSM2(iiLateW);

elecvals=zeros(length(subj_labelsAnalyze),1);
elecvals(iiLSA(iiEarlyW))=1;
elecvals(iiLSA(iiLateW))=2;
cfg=[];
cfg.hemisphere='l';
plot_subjs_on_average_grouping(subj_labelsAnalyze,elecvals,'fsaverage',cfg);
cfg.hemisphere='r';
plot_subjs_on_average_grouping(subj_labelsAnalyze,elecvals,'fsaverage',cfg);


elecvals=zeros(length(subj_labelsAnalyze),1);
elecvals(iiSM2)=1;
 %elecvals(iiA4)=2;
%elecvals(iiPCNW)=4;
cfg=[];
cfg.hemisphere='l';
plot_subjs_on_average_grouping(subj_labelsAnalyze,elecvals,'fsaverage',cfg);
cfg.hemisphere='r';
plot_subjs_on_average_grouping(subj_labelsAnalyze,elecvals,'fsaverage',cfg);






