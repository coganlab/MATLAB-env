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
nPerm=1000;
numTails=1;
zThresh=1.6449;
%fRange=70:100;
fRange=35:75;

for iSN=1:length(SNList)

SN = SNList(iSN);
Subject(SN).Experiment = loadExperiment(Subject(SN).Name);
Subject(SN).Trials = dbTrials(Subject(SN).Name,Subject(SN).Day,'Speech_OvertMimeMove');
%Subject(SN).Trials = dbTrials(Subject(SN).Name,Subject(SN).Day,'Speech_CovertOvert'); % Test line
Trials = Subject(SN).Trials;
experiment = Subject(SN).Experiment;

CondParams.Conds=1:18



%CondParams.bn = [-2500,3500];
%AnalParams.Tapers = [0.5,10];


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
    AnalParams.Channel=[1:140];
else
    AnalParams.Channel = [1:64];
end


    CondParams.Conds=[1:18];
    NumTrials = SelectChannels(Subject(SN).Trials, CondParams, AnalParams);
%NumTrials=repmat(270,1,66);
%SelectedChannels = AnalParams.Channel(find(NumTrials > (0.8*length(Trials)))); %STRICT?
% SelectedChannels = AnalParams.Channel(find(NumTrials > (0.65*length(Trials)))); %LESS STRICT?
SelectedChannels=AnalParams.Channel; % really loose: accounts for practice trial confound
AnalParams.ReferenceChannels = SelectedChannels;
AnalParams.Channel = SelectedChannels;
AnalParams.TrialPooling = 1; %1;  %1; % used to be 1
AnalParams.dn=0.05;

AnalParams.Tapers = [.5,10];
%AnalParams.Tapers = [.25 16];
AnalParams.fk = 500;
if experiment.recording.sample_rate==2000 || experiment.recording.sample_rate==1000
AnalParams.pad=1;
elseif experiment.recording.sample_rate==2048
    AnalParams.pad=0.5;
end

%AnalParams.RefChans=subjRefChans(Subject(SN).Name);
AnalParams.Reference = 'Grand average';% 'IndRef'; %'Grand average', 'Grand average induced'% induced' 'Single-ended','IndRef';%AnalParams.RefChans=subjRefChansInd(Subject(SN).Name);
if SN==28
AnalParams.ArtifactThreshold = 20; %8 %12;
else
    AnalParams.ArtifactThreshold = 12; %8 %12;
end
    %NumTrials=repmat(270,1,66);
    %SelectedChannels = AnalParams.Channel(find(NumTrials > (0.8*length(Trials)))); %STRICT?
    % SelectedChannels = AnalParams.Channel(find(NumTrials > (0.65*length(Trials)))); %LESS STRICT?
    SelectedChannels=AnalParams.Channel; % really loose: accounts for practice trial confound
    AnalParams.ReferenceChannels = SelectedChannels;
    AnalParams.Channel = SelectedChannels;
    AnalParams.TrialPooling = 0 %1;  %1; % used to be 1
    
    
    % CondParams.Field = 'Start';
    % CondParams.bn = [-500,1000];
    % for iCode = 1:length(CondParams.Conds)
    %
    %     if isfield(CondParams,'Conds2')
    %         CondParams.Conds = CondParams.Conds2(iCode);
    %     else
    %         CondParams.Conds = iCode;
    %     end
    %     tic
    %     [Start_Spec{iCode}, Start_Data, Start_Trials{iCode}] = subjSpectrum(Subject(SN), CondParams, AnalParams);
    %     toc
    %     display(['Cond = ' num2str(iCode)])
    % end
    
 %   load([DUKEDIR '/' Subject(SN).Name '/' Subject(SN).Day '/mat/Trials_HighLow.mat']);
 %   Subject(SN).Trials=Trials;
    
    CondParams.Conds=1:6;
    CondParams.Conds2=[5:7,12:14];
    CondParams.Field = 'Auditory';
    CondParams.bn = [-500,5500];
    for iCode = 1:length(CondParams.Conds)
        
        if isfield(CondParams,'Conds2')
            CondParams.Conds = CondParams.Conds2(iCode);
        else
            CondParams.Conds = iCode;
        end
        tic
        [Auditory_Spec{iCode}, Auditory_Data, Auditory_Trials{iCode}] = subjSpectrum(Subject(SN), CondParams, AnalParams);
        toc
        display(['Cond = ' num2str(iCode)])
    end

    
    CondParams.Conds=1:6;
    CondParams.Conds2=[5:7,12:14];
    CondParams.Field = 'Go';
    CondParams.bn = [-500,5500];
 %   CondParams.bn = [0,2000];

    for iCode = 1:length(CondParams.Conds)
        
        if isfield(CondParams,'Conds2')
            CondParams.Conds = CondParams.Conds2(iCode);
        else
            CondParams.Conds = iCode;
        end
        tic
        [Motor_Spec{iCode}, Motor_Data, Motor_Trials{iCode}] = subjSpectrum(Subject(SN), CondParams, AnalParams);
        toc
        display(['Cond = ' num2str(iCode)])
    end
    
    CondParams.Conds=1:6;
    CondParams.Conds2=[5:7,12:14];

    CondParams.Field = 'Go' %'ResponseStart';
    CondParams.bn = [-2000,0];
 %   CondParams.bn = [0,2000];

    for iCode = 1:length(CondParams.Conds)
        
        if isfield(CondParams,'Conds2')
            CondParams.Conds = CondParams.Conds2(iCode);
        else
            CondParams.Conds = iCode;
        end
        tic
        [Delay_Spec{iCode}, Delay_Data, Delay_Trials{iCode}] = subjSpectrum(Subject(SN), CondParams, AnalParams);
        toc
        display(['Cond = ' num2str(iCode)])
    end
  %  fRange=70:150;
  
  
%      CondParams.Conds=1:6;
%     CondParams.Conds2=[5:7,12:14];
%     CondParams.Field = 'Start' %'ResponseStart';
%     CondParams.bn = [-500,500];
%  %   CondParams.bn = [0,2000];
% 
%     for iCode = 1:length(CondParams.Conds)
%         
%         if isfield(CondParams,'Conds2')
%             CondParams.Conds = CondParams.Conds2(iCode);
%         else
%             CondParams.Conds = iCode;
%         end
%         tic
%         [Start_Spec{iCode}, Start_Data, Start_Trials{iCode}] = subjSpectrum(Subject(SN), CondParams, AnalParams);
%         toc
%         display(['Cond = ' num2str(iCode)])
%     end

    outcut=10;
      clear Spec_Chan_All_Prod Spec_Chan_All_Aud Spec_Chan_All_Start
    for iChan=1:length(AnalParams.Channel);
     %   iChan2=iChan+counterChan;
        baseline1=[];
        baseline2=[];
        for iCond=1:6;
            tmp=sq(mean(Auditory_Spec{iCond}{iChan}(:,:,fRange),3));
            tmp=tmp-mean(mean(tmp));
            [m s]=normfit(tmp(:));
            [i j]=find(tmp>(outcut*s+m));
            tmpIDXA=setdiff(1:size(tmp,1),unique(i));
            
            tmp=sq(mean(Motor_Spec{iCond}{iChan}(:,:,fRange),3));
            tmp=tmp-mean(mean(tmp));
            [m s]=normfit(tmp(:));
            [i j]=find(tmp>(outcut*s+m));
            tmpIDXM=setdiff(1:size(tmp,1),unique(i));
        
%             tmp=sq(mean(Start_Spec{iCond}{iChan}(:,:,fRange),3));
%             tmp=tmp-mean(mean(tmp));
%             [m s]=normfit(tmp(:));
%             [i j]=find(tmp>(outcut*s+m));
%             tmpIDXS=setdiff(1:size(tmp,1),unique(i));
%             tmp=[];
       
             tmp=sq(mean(Delay_Spec{iCond}{iChan}(:,:,fRange),3));
            tmp=tmp-mean(mean(tmp));
            [m s]=normfit(tmp(:));
            [i j]=find(tmp>(outcut*s+m));
            tmpIDXD=setdiff(1:size(tmp,1),unique(i));
            tmp=[];

            Spec_Chan_All_Aud{iChan}{iCond}=sq(mean(Auditory_Spec{iCond}{iChan}(tmpIDXA,:,fRange),3));

         %   Spec_Chan_All_Aud{iChan2}{iCond}=sq(mean(Auditory_Spec{iCond}{iChan}(ATrialsIdx,:,fRange),3))./sq(mean(mean(Auditory_Spec{iCond}{iChan}(ATrialsIdx,1:10,fRange),2),3));

            Spec_Subject_Aud(iChan)=SN;
            
%             Spec_Chan_All_Prod{iChan2}{iCond}=sq(mean(Motor_Spec{iCond}{iChan}(tmpIDX2,:,fRange),3));
       %      Spec_Chan_All_Prod{iChan2}{iCond}=sq(mean(Motor_Spec{iCond}{iChan}(MTrialsIdx,:,fRange),3));
             Spec_Chan_All_Prod{iChan}{iCond}=sq(mean(Motor_Spec{iCond}{iChan}(tmpIDXM,:,fRange),3));

%            Spec_Chan_All_Prod{iChan2}{iCond}=sq(mean(Motor_Spec{iCond}{iChan}(MTrialsIdx,:,fRange),3))./sq(mean(mean(Auditory_Spec{iCond}{iChan}(ATrialsIdx,1:10,fRange),2),3));

            Spec_Subject_Prod(iChan)=SN;
            
            
            
%             % Spec_Chan_All_Start{iChan2}{iCond}=sq(mean(Start_Spec{iCond}{iChan}(STrialsIdx,:,fRange),3));             
%              Spec_Chan_All_Start{iChan}{iCond}=sq(mean(Start_Spec{iCond}{iChan}(tmpIDXS,:,fRange),3));
% %            Spec_Chan_All_Prod{iChan2}{iCond}=sq(mean(Motor_Spec{iCond}{iChan}(MTrialsIdx,:,fRange),3))./sq(mean(mean(Auditory_Spec{iCond}{iChan}(ATrialsIdx,1:10,fRange),2),3));
% 
%             Spec_Subject_Start(iChan)=SN;
%             
            
                        % Spec_Chan_All_Start{iChan2}{iCond}=sq(mean(Start_Spec{iCond}{iChan}(STrialsIdx,:,fRange),3));             
             Spec_Chan_All_Delay{iChan2}{iCond}=sq(mean(Delay_Spec{iCond}{iChan}(tmpIDXD,:,fRange),3));
%            Spec_Chan_All_Prod{iChan2}{iCond}=sq(mean(Motor_Spec{iCond}{iChan}(MTrialsIdx,:,fRange),3))./sq(mean(mean(Auditory_Spec{iCond}{iChan}(ATrialsIdx,1:10,fRange),2),3));

            Spec_Subject_Delay(iChan2)=SN;
%             if iCond<=4
%                 baseline1=cat(1,baseline1,sq(mean(mean(Auditory_Spec{iCond}{iChan}(:,1:10,fRange),2),3)));
%             elseif iCond>=5
%                 baseline2=cat(1,baseline2,sq(mean(mean(Auditory_Spec{iCond}{iChan}(:,1:10,fRange),2),3)));
%             end
        end
       
%         baseline1=mean(baseline1);
%         baseline2=mean(baseline2);
%         for iCond=1:8;
%             if iCond<=4
%             Spec_Chan_All{iChan2}{iCond}=Spec_Chan_All{iChan2}{iCond}./baseline1;
%             elseif iCond>=5
%             Spec_Chan_All{iChan2}{iCond}=Spec_Chan_All{iChan2}{iCond}./baseline2;
%             end
%         end
   end
    


outcut=3;
for iChan=1:size(Spec_Chan_All_Aud,2);
%     tmpS=[];
%     for iCond=1:6
% 
%               tmpS=sq(log(Spec_Chan_All_Start{iChan}{iCond}(:,:)));
%           %  tmp=tmp-mean(mean(tmp));
%             [m s]=normfit(tmp(:));
%             [i j]=find(tmp>(outcut*s+m));
%             tmpIDXS=setdiff(1:size(tmp,1),unique(i));
%             
%      
%     %    tmpAD=cat(1,tmpAD,Spec_Chan_All_Aud{iChan}{iCond}(tmpIDXSD,:));
%     %    tmpAR=cat(1,tmpAR,Spec_Chan_All_Aud{iChan}{iCond+4}(tmpIDXSR,:));
%         tmpS=cat(1,tmpS,Spec_Chan_All_Start{iChan}{iCond}(tmpIDXS,:));
% 
%     end
%     
     tmpD=[];
    for iCond=1:6

              tmpD=sq(log(Spec_Chan_All_Delay{iChan}{iCond}(:,:)));
          %  tmp=tmp-mean(mean(tmp));
            [m s]=normfit(tmpD(:));
            [i j]=find(tmpD>(outcut*s+m));
            tmpIDXD=setdiff(1:size(tmpD,1),unique(i));
            
     
    %    tmpAD=cat(1,tmpAD,Spec_Chan_All_Aud{iChan}{iCond}(tmpIDXSD,:));
    %    tmpAR=cat(1,tmpAR,Spec_Chan_All_Aud{iChan}{iCond+4}(tmpIDXSR,:));
        tmpD=cat(1,tmpD,Spec_Chan_All_Delay{iChan}{iCond}(tmpIDXD,:));

    end

 
    for iCond=1:6;
   clear tmpIDXA
   clear tmpIDXM
            clear i
            tmpA=sq(log(Spec_Chan_All_Aud{iChan}{iCond}(:,:)));
          %  tmp=tmp-mean(mean(tmp));
            [m s]=normfit(tmpA(:));
            [i j]=find(tmpA>(outcut*s+m));
            tmpIDXA=setdiff(1:size(tmpA,1),unique(i));
            clear i
            tmpP=sq(log(Spec_Chan_All_Prod{iChan}{iCond}(:,:)));
          %  tmp=tmp-mean(mean(tmp));
            [m s]=normfit(tmpP(:));
            [i j]=find(tmpP>(outcut*s+m));
            tmpIDXM=setdiff(1:size(tmpP,1),unique(i));
          tmpD=sq(log(Spec_Chan_All_Delay{iChan}{iCond}(:,:)));
          %  tmp=tmp-mean(mean(tmp));
            [m s]=normfit(tmpD(:));
            [i j]=find(tmpD>(outcut*s+m));
            tmpIDXD=setdiff(1:size(tmpD,1),unique(i));
            clear i
      

            
        
            
            

%          [mS sS]=normfit(log(tmpS(:)));
         
%          dataAD(iChan,iCond,:)=mean((log(Spec_Chan_All_Aud{iChan}{iCond})-mSD)./sSD);
%          dataPD(iChan,iCond,:)=mean((log(Spec_Chan_All_Prod{iChan}{iCond})-mSD)./sSD);
%          dataAR(iChan,iCond,:)=mean((log(Spec_Chan_All_Aud{iChan}{iCond+4})-mSR)./sSR);
%          dataPR(iChan,iCond,:)=mean((log(Spec_Chan_All_Prod{iChan}{iCond+4})-mSR)./sSR);
         
         
%          dataAD(iChan,iCond,:)=mean((log(Spec_Chan_All_Aud{iChan}{iCond})-mS)./sS);
%          dataPD(iChan,iCond,:)=mean((log(Spec_Chan_All_Prod{iChan}{iCond})-mS)./sS);
%          dataAR(iChan,iCond,:)=mean((log(Spec_Chan_All_Aud{iChan}{iCond+4})-mS)./sS);
%          dataPR(iChan,iCond,:)=mean((log(Spec_Chan_All_Prod{iChan}{iCond+4})-mS)./sS);   


%          dataAD(iChan,iCond,:)=mean(Spec_Chan_All_Aud{iChan}{iCond}(:,:))./mean(mean(cat(1,tmpSD(:,1:10),tmpSR(:,1:10))));
%          dataPD(iChan,iCond,:)=mean(Spec_Chan_All_Prod{iChan}{iCond}(:,:))./mean(mean(cat(1,tmpSD(:,1:10),tmpSR(:,1:10))));
%          dataAR(iChan,iCond,:)=mean(Spec_Chan_All_Aud{iChan}{iCond+4}(:,:))./mean(mean(cat(1,tmpSD(:,1:10),tmpSR(:,1:10))));
%          dataPR(iChan,iCond,:)=mean(Spec_Chan_All_Prod{iChan}{iCond+4}(:,:))./mean(mean(cat(1,tmpSD(:,1:10),tmpSR(:,1:10))));
         dataA(iChan,iCond,:)=mean(Spec_Chan_All_Aud{iChan}{iCond}(tmpIDXA,:))./mean(mean(Spec_Chan_All_Aud{iChan}{iCond}(tmpIDXA,1:10)));
         dataP(iChan,iCond,:)=mean(Spec_Chan_All_Prod{iChan}{iCond}(tmpIDXM,:))./mean(mean(Spec_Chan_All_Aud{iChan}{iCond}(tmpIDXA,1:10)));
         dataD(iChan,iCond,:)=mean(Spec_Chan_All_Delay{iChan}{iCond}(tmpIDXD,:))./mean(mean(Spec_Chan_All_Aud{iChan}{iCond}(tmpIDXA,1:10)));
               
   
%         dataAD(iChan,iCond,:)=mean(Spec_Chan_All_Aud{iChan}{iCond})./sq(mean(mean(Spec_Chan_All_Aud{iChan}{iCond}(:,1:10))));
%         dataPD(iChan,iCond,:)=mean(Spec_Chan_All_Prod{iChan}{iCond})./sq(mean(mean(Spec_Chan_All_Aud{iChan}{iCond}(:,1:10))));
%         dataAR(iChan,iCond,:)=mean(Spec_Chan_All_Aud{iChan}{iCond+4})./sq(mean(mean(Spec_Chan_All_Aud{iChan}{iCond+4}(:,1:10))));
%         dataPR(iChan,iCond,:)=mean(Spec_Chan_All_Prod{iChan}{iCond+4})./sq(mean(mean(Spec_Chan_All_Aud{iChan}{iCond+4}(:,1:10))));
%         
%         dataAD(iChan,iCond,:)=sq(mean(Spec_Chan_All_Aud{iChan}{iCond}./mean(Spec_Chan_All_Aud{iChan}{iCond}(:,1:10),2)));
%         dataPD(iChan,iCond,:)=sq(mean(Spec_Chan_All_Prod{iChan}{iCond}./mean(Spec_Chan_All_Aud{iChan}{iCond}(:,1:10),2)));
%         dataAR(iChan,iCond,:)=sq(mean(Spec_Chan_All_Aud{iChan}{iCond+4}./mean(Spec_Chan_All_Aud{iChan}{iCond+4}(:,1:10),2)));
%         dataPR(iChan,iCond,:)=sq(mean(Spec_Chan_All_Prod{iChan}{iCond+4}./mean(Spec_Chan_All_Aud{iChan}{iCond+4}(:,1:10),2)));
    end
end


for iChan=1:size(Spec_Chan_All_Aud,2);
    tmpAS=[];
    for iCond=1:6;
        tmpAS=cat(1,tmpAS,Spec_Chan_All_Aud{iChan}{iCond});
    end
    
    tmpLSA=[];
    tmpJLA=[];
    tmpLSD=[];
    tmpJLD=[];

    tmpLSP=[];
    tmpJLP=[];

    for iCond=1:3;
        tmpLSA=cat(1,tmpLSA,Spec_Chan_All_Aud{iChan}{iCond});
        tmpJLA=cat(1,tmpJLA,Spec_Chan_All_Aud{iChan}{iCond+3});
        tmpLSD=cat(1,tmpLSD,Spec_Chan_All_Delay{iChan}{iCond});
        tmpJLD=cat(1,tmpJLD,Spec_Chan_All_Delay{iChan}{iCond+3});    
        tmpLSP=cat(1,tmpLSP,Spec_Chan_All_Prod{iChan}{iCond});
        tmpJLP=cat(1,tmpJLP,Spec_Chan_All_Prod{iChan}{iCond+3});
       
    end
    
    
     bSig=repmat(cat(1,tmpLSA(:,1:10),tmpJLA(:,1:10)),1,12);
     bSigD=repmat(cat(1,tmpLSA(:,1:10),tmpJLA(:,1:10)),1,4);

     aSig=tmpLSA;
     [zValsRawAct pValsRawAct actClustLSA{iChan}]=timePermCluster(aSig,bSig,nPerm,numTails,zThresh);
   
     aSig=tmpJLA;
     [zValsRawAct pValsRawAct actClustJLA{iChan}]=timePermCluster(aSig,bSig,nPerm,numTails,zThresh);
     aSig=tmpLSP;
     [zValsRawAct pValsRawAct actClustLSP{iChan}]=timePermCluster(aSig,bSig,nPerm,numTails,zThresh);
   
     aSig=tmpJLP;
     [zValsRawAct pValsRawAct actClustJLP{iChan}]=timePermCluster(aSig,bSig,nPerm,numTails,zThresh);
 display(iChan);
end    
save([DUKEDIR '/SentenceRep/' Subject(SN).Name '_Sentence_70150_Outlier8_timepointsvsbaselineClusterZ.mat'],'AnalParams','actClust*','dataA','dataP');
clear actClust*
end
