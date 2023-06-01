

duke;

% important!!
%subj_labels = list_electrodes({'D12','D13','D14','D15','D17'});
Subject=[];
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
Subject(24).Name = 'D24'; Subject(24).Day = '181027';%ClusterSize=3;
subj_labels={};
counterChan=0;
for SN = [3,5,7,8,9,12,13,14,15,16,17,18,20,22,23,24]; % [3,5,7,8,9,11,12,13,14,15,16,17,18,20,22,23,24]; 
    load([DUKEDIR '/' Subject(SN).Name '/mat/experiment.mat']);
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
else
    AnalParams.Channel = [1:64];
    end


ii11=find(Spec_Subject_Aud==11);
iiGood=setdiff(1:size(Spec_Subject_Aud,2),ii11);


 for iChan=1:length(AnalParams.Channel);
     subj_labels{counterChan+1}=[Subject(SN).Name, '-', experiment.channels(AnalParams.Channel(iChan)).name];
     counterChan=counterChan+1;
 end
end
%cfg = [];


iiA1=intersect(iiLSA,iiLMA);
iiA2=intersect(iiA1,iiJLA);
iiP1=intersect(iiLSP,iiLMP);
iiSM=intersect(iiA1,iiP1);
iiP=setdiff(iiP1,iiSM);
iiA=setdiff(iiA2,iiSM);

iiA=setdiff(iiA,ii11);
iiP=setdiff(iiP,ii11);
iiSM=setdiff(iiSM,ii11);

ii=find(iiA>428);
iiA(ii)=iiA(ii)-118;

ii=find(iiP>428);
iiP(ii)=iiP(ii)-118;

ii=find(iiSM>428);
iiSM(ii)=iiSM(ii)-118;




iiAS=intersect(iiLSSA,iiJLSA);
iiPS=iiLSSP;

iiAS2=setdiff(iiAS,iiA);
iiAS2=setdiff(iiAS2,iiSM);
%iiAS2=setdiff(iiAS2,iiP);

iiPS2=setdiff(iiPS,iiP);
iiPS2=setdiff(iiPS2,iiSM);
%iiPS2=setdiff(iiPS2,iiA);

iiSMS=intersect(iiAS2,iiPS2);
iiAS2=setdiff(iiAS2,iiSMS);
iiPS2=setdiff(iiPS2,iiSMS);



iiAS=setdiff(iiAS,ii11);
iiPS=setdiff(iiPS,ii11);

iiAS2=setdiff(iiAS2,ii11);
iiPS2=setdiff(iiPS2,ii11);
iiSMS=setdiff(iiSMS,ii11);
% iiSMS_A=setdiff(iiSMS_A,ii11);
% iiSMS_SM=setdiff(iiSMS_SM,ii11);
% iiSMS_N=setdiff(iiSMS_N,ii11);


ii=find(iiSMS>428);
iiSMS(ii)=iiSMS(ii)-118;

% ii=find(iiSMS_A>428);
% iiSMS_A(ii)=iiSMS_A(ii)-118;
% 
% ii=find(iiSMS_SM>428);
% iiSMS_SM(ii)=iiSMS_SM(ii)-118;
% 
% ii=find(iiSMS_N>428);
% iiSMS_N(ii)=iiSMS_N(ii)-118;

ii=find(iiAS>428);
iiAS(ii)=iiAS(ii)-118;

ii=find(iiPS>428);
iiPS(ii)=iiPS(ii)-118;

ii=find(iiAS2>428);
iiAS2(ii)=iiAS2(ii)-118;

ii=find(iiPS2>428);
iiPS2(ii)=iiPS2(ii)-118;
% NB, no D11
iiL=[1:51,52:95,198:237,308:367,538:597,778:867,898:938,939:974,1053:1130,1175:1264,1295:1394,1516:1567];
iiR=[96:197,238:307,368:427,428:537,598:657,658:777,868:897,975:1052,1131:1174,1265:1294,1395:1515];

cfg=[];
grouping_idx = zeros(1567,1);

 grouping_idx(iiR)=22;
 grouping_idx(iiL)=22;
%grouping_idx(intersect(iiA2,iiNWWA))=2;
%grouping_idx(iiA)=2;
%grouping_idx(iiP)=4;
%grouping_idx(iiSM)=1;
%grouping_idx(iiSM(46:75))=1;


% grouping_idx(iiSMS_A)=2;
% grouping_idx(iiSMS_N)=4;
% grouping_idx(iiSMS_SM)=1;

%  grouping_idx(iiAS2)=2;
%  grouping_idx(iiPS2)=4;
% grouping_idx(iiSMS)=1;


% 
% cmap=zeros(30,1);
% cmap(:,1)=linspace(1,0,30);
% cmap(:,2)=linspace(0,1,30);
% cmap(:,3)=linspace(1,0,30);
% gval=mean(mdlRvals3(iiA2,25:40)-mdlRvals(iiA2,25:40),2);
% idx=iiA2; %1:925;
% minval=-0.01; %-0.5; %min(gval);
% maxval=0.01; %max(gval);
% valRange=linspace(minval,maxval,30);
% for iC=1:30;
%     if iC==1
%     ii=find(gval<minval);
%     grouping_idx(idx(ii))=iC;
%     elseif iC==30;
%         ii=find(gval>maxval);
%         grouping_idx(idx(ii))=iC;
%     else
%         ii=find(gval>valRange(iC-1) & gval<valRange(iC));
%         grouping_idx(idx(ii))=iC;
%     end
% end
% cfg.elec_colors=cmap;
% %  
%grouping_idx(1:704)=1;
%grouping_idx(intersect(iiSig{1}(iiLPos),iiSig{3}(iiPPos)))=1;
%grouping_idx(intersect(iiSig{1}(iiLPos),iiSig{2}(iiTNeg)))=2;
%grouping_idx(intersect(iiSig{3}(iiPPos),iiSig{2}(iiTNeg)))=3;

%grouping_idx(iiSig{3}(iiPNeg))=2;
%grouping_idx(iiSig{3})=3;
%grouping_idx(setdiff(totalActiveElecsJustDA,iiAC))=3;
%grouping_idx(iiA)=4;
% grouping_idx(ii6)=6;
%cfg.elec_size=150;
cfg.hemisphere='l';

plot_subjs_on_average_grouping(subj_labels, grouping_idx, 'fsaverage', cfg);

cfg.hemisphere='r';

%cfg.elec_colors=[1 1 1;0 1 0;0 0 1;1 0 0];
plot_subjs_on_average_grouping(subj_labels, grouping_idx, 'fsaverage', cfg);