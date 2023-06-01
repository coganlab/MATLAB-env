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

counterChan=0;
for iSN=1:length(SNList)

SN = SNList(iSN);
Subject(SN).Experiment = loadExperiment(Subject(SN).Name);
Subject(SN).Trials = dbTrials(Subject(SN).Name,Subject(SN).Day,'Speech_OvertMimeMove');
%Subject(SN).Trials = dbTrials(Subject(SN).Name,Subject(SN).Day,'Speech_CovertOvert'); % Test line
Trials = Subject(SN).Trials;
experiment = Subject(SN).Experiment;

CondParams.Conds = [1:18];



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
     AnalParams.Channel=[1:108]; % change to 140
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
%AnalParams.RefChans=subjRefChans(Subject(SN).Name);
AnalParams.Reference = 'Grand average';% 'IndRef'; %'Grand average', 'Grand average induced'% induced' 'Single-ended','IndRef';%AnalParams.RefChans=subjRefChansInd(Subject(SN).Name);
AnalParams.ArtifactThreshold = 12; %8 %12;
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
    
    CondParams.Conds=[1:18];
    CondParams.Field = 'Auditory';
    CondParams.bn = [-500,1500];
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

    
    CondParams.Conds=[1:18];
    CondParams.Field = 'Go';
    CondParams.bn = [-500,1500];
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
    
    
    
     CondParams.Conds=[1:18];
    CondParams.Field = 'Start' %'ResponseStart';
    CondParams.bn = [-500,500];
 %   CondParams.bn = [0,2000];

    for iCode = 1:length(CondParams.Conds)
        
        if isfield(CondParams,'Conds2')
            CondParams.Conds = CondParams.Conds2(iCode);
        else
            CondParams.Conds = iCode;
        end
        tic
        [Start_Spec{iCode}, Start_Data, Start_Trials{iCode}] = subjSpectrum(Subject(SN), CondParams, AnalParams);
        toc
        display(['Cond = ' num2str(iCode)])
    end
    fRange=70:150;
  %  fRange=30:50;
    outcut=10;
    for iChan=1:length(AnalParams.Channel);
        iChan2=iChan+counterChan;
        baseline1=[];
        baseline2=[];
        for iCond=1:18;
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
        
            tmp=sq(mean(Start_Spec{iCond}{iChan}(:,:,fRange),3));
            tmp=tmp-mean(mean(tmp));
            [m s]=normfit(tmp(:));
            [i j]=find(tmp>(outcut*s+m));
            tmpIDXS=setdiff(1:size(tmp,1),unique(i));
            tmp=[];
       
         

            Spec_Chan_All_Aud{iChan2}{iCond}=sq(mean(Auditory_Spec{iCond}{iChan}(tmpIDXA,:,fRange),3));

         %   Spec_Chan_All_Aud{iChan2}{iCond}=sq(mean(Auditory_Spec{iCond}{iChan}(ATrialsIdx,:,fRange),3))./sq(mean(mean(Auditory_Spec{iCond}{iChan}(ATrialsIdx,1:10,fRange),2),3));

            Spec_Subject_Aud(iChan2)=SN;
            
%             Spec_Chan_All_Prod{iChan2}{iCond}=sq(mean(Motor_Spec{iCond}{iChan}(tmpIDX2,:,fRange),3));
       %      Spec_Chan_All_Prod{iChan2}{iCond}=sq(mean(Motor_Spec{iCond}{iChan}(MTrialsIdx,:,fRange),3));
             Spec_Chan_All_Prod{iChan2}{iCond}=sq(mean(Motor_Spec{iCond}{iChan}(tmpIDXM,:,fRange),3));

%            Spec_Chan_All_Prod{iChan2}{iCond}=sq(mean(Motor_Spec{iCond}{iChan}(MTrialsIdx,:,fRange),3))./sq(mean(mean(Auditory_Spec{iCond}{iChan}(ATrialsIdx,1:10,fRange),2),3));

            Spec_Subject_Prod(iChan2)=SN;
            
            
            
            % Spec_Chan_All_Start{iChan2}{iCond}=sq(mean(Start_Spec{iCond}{iChan}(STrialsIdx,:,fRange),3));             
             Spec_Chan_All_Start{iChan2}{iCond}=sq(mean(Start_Spec{iCond}{iChan}(tmpIDXS,:,fRange),3));
%            Spec_Chan_All_Prod{iChan2}{iCond}=sq(mean(Motor_Spec{iCond}{iChan}(MTrialsIdx,:,fRange),3))./sq(mean(mean(Auditory_Spec{iCond}{iChan}(ATrialsIdx,1:10,fRange),2),3));

            Spec_Subject_Start(iChan2)=SN;
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
    
    counterChan=counterChan+length(AnalParams.Channel);
end

outcut=3;
for iChan=1:size(Spec_Chan_All_Aud,2);
    tmpS=[];
    for iCond=1:18

              tmpS=sq(log(Spec_Chan_All_Start{iChan}{iCond}(:,:)));
          %  tmp=tmp-mean(mean(tmp));
            [m s]=normfit(tmp(:));
            [i j]=find(tmp>(outcut*s+m));
            tmpIDXS=setdiff(1:size(tmp,1),unique(i));
            
     
    %    tmpAD=cat(1,tmpAD,Spec_Chan_All_Aud{iChan}{iCond}(tmpIDXSD,:));
    %    tmpAR=cat(1,tmpAR,Spec_Chan_All_Aud{iChan}{iCond+4}(tmpIDXSR,:));
        tmpS=cat(1,tmpS,Spec_Chan_All_Start{iChan}{iCond}(tmpIDXS,:));

    end

 
    for iCond=1:18;
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
        
      

            
        
            
            

         [mS sS]=normfit(log(tmpS(:)));
         
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


nPerm=1000;
for iChan=1:size(Spec_Chan_All_Aud,2);
    tmpAS=[];
    for iCond=1:18;
        tmpAS=cat(1,tmpAS,Spec_Chan_All_Aud{iChan}{iCond});
    end
    
    tmpLSA=[];
    tmpJLA=[];
    tmpLMA=[];
    tmpLSP=[];
    tmpJLP=[];
    tmpLMP=[];
    for iCond=1:4;
        tmpLSA=cat(1,tmpLSA,Spec_Chan_All_Aud{iChan}{iCond});
        tmpJLA=cat(1,tmpJLA,Spec_Chan_All_Aud{iChan}{iCond+7});
        tmpLMA=cat(1,tmpLMA,Spec_Chan_All_Aud{iChan}{iCond+14});
        tmpLSP=cat(1,tmpLSP,Spec_Chan_All_Prod{iChan}{iCond});
        tmpJLP=cat(1,tmpJLP,Spec_Chan_All_Prod{iChan}{iCond+7});
        tmpLMP=cat(1,tmpLMP,Spec_Chan_All_Prod{iChan}{iCond+14});
    end
    for iTime=1:40;
        actdiffLSA=mean(tmpLSA(:,iTime))-mean(mean(tmpAS(:,1:10)));
        %combvalLSA=cat(1,mean(tmpLSA(:,iTime),2),reshape(tmpAS(:,1:10),size(tmpAS,1)*10,1));
        combvalLSA=cat(1,mean(tmpLSA(:,iTime),2),mean(tmpAS(:,1:10),2));
      
        actdiffJLA=mean(tmpJLA(:,iTime))-mean(mean(tmpAS(:,1:10)));
        %combvalJLA=cat(1,mean(tmpJLA(:,iTime),2),reshape(tmpAS(:,1:10),size(tmpAS,1)*10,1));
        combvalJLA=cat(1,mean(tmpJLA(:,iTime),2),mean(tmpAS(:,1:10),2));

        actdiffLMA=mean(tmpLMA(:,iTime))-mean(mean(tmpAS(:,1:10)));
        %combvalLMA=cat(1,mean(tmpLMA(:,iTime),2),reshape(tmpAS(:,1:10),size(tmpAS,1)*10,1));
        combvalLMA=cat(1,mean(tmpLMA(:,iTime),2),mean(tmpAS(:,1:10),2));
        
        actdiffLSP=mean(tmpLSP(:,iTime))-mean(mean(tmpAS(:,1:10)));
        %combvalLSP=cat(1,mean(tmpLSP(:,iTime),2),reshape(tmpAS(:,1:10),size(tmpAS,1)*10,1));
        combvalLSP=cat(1,mean(tmpLSP(:,iTime),2),mean(tmpAS(:,1:10),2));
                
        actdiffJLP=mean(tmpJLP(:,iTime))-mean(mean(tmpAS(:,1:10)));
        %combvalJLP=cat(1,mean(tmpJLP(:,iTime),2),reshape(tmpAS(:,1:10),size(tmpAS,1)*10,1));
        combvalJLP=cat(1,mean(tmpJLP(:,iTime),2),mean(tmpAS(:,1:10),2));

        actdiffLMP=mean(tmpLMP(:,iTime))-mean(mean(tmpAS(:,1:10)));
        %combvalLMP=cat(1,mean(tmpLMP(:,iTime),2),reshape(tmpAS(:,1:10),size(tmpAS,1)*10,1));
        combvalLMP=cat(1,mean(tmpLMP(:,iTime),2),mean(tmpAS(:,1:10),2));
        
        
        for iPerm=1:nPerm;
            sIdxLSA=shuffle(1:size(combvalLSA,1));
            permvalLSA(iPerm)=mean(combvalLSA(sIdxLSA(1:size(tmpLSA,1))))-mean(combvalLSA(sIdxLSA(size(tmpLSA,1)+1:length(sIdxLSA))));
            sIdxJLA=shuffle(1:size(combvalJLA,1));
            permvalJLA(iPerm)=mean(combvalJLA(sIdxJLA(1:size(tmpJLA,1))))-mean(combvalJLA(sIdxJLA(size(tmpJLA,1)+1:length(sIdxJLA))));
            sIdxLMA=shuffle(1:size(combvalLMA,1));
            permvalLMA(iPerm)=mean(combvalLMA(sIdxLMA(1:size(tmpLMA,1))))-mean(combvalLMA(sIdxLMA(size(tmpLMA,1)+1:length(sIdxLMA))));
            
            
            sIdxLSP=shuffle(1:size(combvalLSP,1));
            permvalLSP(iPerm)=mean(combvalLSP(sIdxLSP(1:size(tmpLSP,1))))-mean(combvalLSP(sIdxLSP(size(tmpLSP,1)+1:length(sIdxLSP))));
            sIdxJLP=shuffle(1:size(combvalJLP,1));
            permvalJLP(iPerm)=mean(combvalJLP(sIdxJLP(1:size(tmpJLP,1))))-mean(combvalJLP(sIdxJLP(size(tmpJLP,1)+1:length(sIdxJLP))));
            sIdxLMP=shuffle(1:size(combvalLMP,1));
            permvalLMP(iPerm)=mean(combvalLMP(sIdxLMP(1:size(tmpLMP,1))))-mean(combvalLMP(sIdxLMP(size(tmpLMP,1)+1:length(sIdxLMP))));
        end
        pvalsLSA(iChan,iTime)=length(find(permvalLSA>actdiffLSA))./nPerm;
        pvalsJLA(iChan,iTime)=length(find(permvalJLA>actdiffJLA))./nPerm;
        pvalsLMA(iChan,iTime)=length(find(permvalLMA>actdiffLMA))./nPerm;
        pvalsLSP(iChan,iTime)=length(find(permvalLSP>actdiffLSP))./nPerm;
        pvalsJLP(iChan,iTime)=length(find(permvalJLP>actdiffJLP))./nPerm;
        pvalsLMP(iChan,iTime)=length(find(permvalLMP>actdiffLMP))./nPerm;
        
    end
    display(iChan)
end

sigVal=0.05;
ClusterSize=4;
pvalsLSAM=zeros(size(pvalsLSA,1),size(pvalsLSA,2));
iiS=find(pvalsLSA<sigVal);
pvalsLSAM(iiS)=1;

% [pmask pfdr]=fdr(reshape(pvalsLSA,size(pvalsLSA,1)*size(pvalsLSA,2),1),.05);
% pvalsLSAM=reshape(pfdr,size(pvalsLSA,1),size(pvalsLSA,2));


pvalsJLAM=zeros(size(pvalsJLA,1),size(pvalsJLA,2));
iiS=find(pvalsJLA<sigVal);
pvalsJLAM(iiS)=1;

% [pmask pfdr]=fdr(reshape(pvalsJLA,size(pvalsJLA,1)*size(pvalsJLA,2),1),.05);
% pvalsJLAM=reshape(pfdr,size(pvalsJLA,1),size(pvalsJLA,2));

pvalsLMAM=zeros(size(pvalsLMA,1),size(pvalsLMA,2));
iiS=find(pvalsLMA<sigVal);
pvalsLMAM(iiS)=1;

% 
% [pmask pfdr]=fdr(reshape(pvalsLMA,size(pvalsLMA,1)*size(pvalsLMA,2),1),.05);
% pvalsLMAM=reshape(pfdr,size(pvalsLMA,1),size(pvalsLMA,2));
% 
pvalsLSPM=zeros(size(pvalsLSP,1),size(pvalsLSP,2));
iiS=find(pvalsLSP<sigVal);
pvalsLSPM(iiS)=1;


% [pmask pfdr]=fdr(reshape(pvalsLSP,size(pvalsLSP,1)*size(pvalsLSP,2),1),.05);
% pvalsLSPM=reshape(pfdr,size(pvalsLSP,1),size(pvalsLSP,2));


pvalsJLPM=zeros(size(pvalsJLP,1),size(pvalsJLP,2));
iiS=find(pvalsJLP<sigVal);
pvalsJLPM(iiS)=1;


% [pmask pfdr]=fdr(reshape(pvalsJLP,size(pvalsJLP,1)*size(pvalsJLP,2),1),.05);
% pvalsJLPM=reshape(pfdr,size(pvalsJLP,1),size(pvalsJLP,2));

pvalsLMPM=zeros(size(pvalsLMP,1),size(pvalsLMP,2));
iiS=find(pvalsLMP<sigVal);
pvalsLMPM(iiS)=1;


% [pmask pfdr]=fdr(reshape(pvalsLMP,size(pvalsLMP,1)*size(pvalsLMP,2),1),.05);
% pvalsLMPM=reshape(pfdr,size(pvalsLMP,1),size(pvalsLMP,2));
% 
% [PMASK PFDR]=fdr(reshape(pvalsDA,size(pvalsDA,1)*size(pvalsDA,2),1),0.01);
% pvalsDAM=reshape(PFDR,size(pvalsDA,1),size(pvalsDA,2));
% pvalsDAM=1.*pvalsDAM;
% [PMASK PFDR]=fdr(reshape(pvalsDP,size(pvalsDP,1)*size(pvalsDP,2),1),0.01);
% pvalsDPM=reshape(PFDR,size(pvalsDP,1),size(pvalsDP,2));
% pvalsDPM=1.*pvalsDPM;
% [PMASK PFDR]=fdr(reshape(pvalsRA,size(pvalsRA,1)*size(pvalsRA,2),1),0.01);
% pvalsRAM=reshape(PFDR,size(pvalsRA,1),size(pvalsRA,2));
% pvalsRAM=1.*pvalsRAM;
% [PMASK PFDR]=fdr(reshape(pvalsRP,size(pvalsRP,1)*size(pvalsRP,2),1),0.01);
% pvalsRPM=reshape(PFDR,size(pvalsRP,1),size(pvalsRP,2));
% pvalsRPM=1.*pvalsRPM;

% pvalsSDM=zeros(size(pvalsSD,1),size(pvalsSD,2));
% for iChan=1:size(pvalsSDM,1)
% [pmask pfdr]=fdr(pvalsSD(iChan,:),.05);
% pvalsSDM(iChan,:)=pfdr;
% end
% 
% pvalsSRM=zeros(size(pvalsSR,1),size(pvalsSR,2));
% for iChan=1:size(pvalsSRM,1)
% [pmask pfdr]=fdr(pvalsSR(iChan,:),.05);
% pvalsSRM(iChan,:)=pfdr;
% end

% %
clusterStartLSA=zeros(size(Spec_Chan_All_Aud,2),4);
clusterStartLSA2=zeros(size(Spec_Chan_All_Aud,2),1);

for iChan=1:size(pvalsLSAM,1);

    tmp=bwconncomp(sq(pvalsLSAM(iChan,:)));
    if size(tmp.PixelIdxList,2)>0
    for ii=1:size(tmp.PixelIdxList,2);
        ii2(ii)=size(tmp.PixelIdxList{ii},1);
    end
    
    ii2B=find(ii2>=ClusterSize);
    if length(ii2B)>0
        for ii=1:length(ii2B);
            ii3(ii)=tmp.PixelIdxList{ii2B(ii)}(1);
            clusterStartLSA2(iChan)=ii3(1);
            if ii3(ii)>=11 && ii3(ii)<=15
                clusterStartLSA(iChan,1)=1;
            elseif ii3(ii)>=16 && ii3(ii)<=20
                clusterStartLSA(iChan,2)=1;
            elseif ii3(ii)>=21 && ii3(ii)<=25
                clusterStartLSA(iChan,3)=1;
            elseif ii3(ii)>=26 && ii3(ii)<=30
                clusterStartLSA(iChan,4)=1;
%             elseif ii3(ii)>=31 && ii3(ii)<=35
%                 clusterStartDA(iChan,5)=1;
%             elseif ii3(ii)>=36 && ii3(ii)<=40
%                 clusterStartDA(iChan,6)=1;
            end
        end
    end
    clear ii3
 
       
    SigClusterSizeLSA(iChan)=max(ii2);
    else
        SigClusterSizeLSA(iChan)=0;
    end
    clear ii2
end

iiLSA=find(SigClusterSizeLSA>=ClusterSize);

clusterStartJLA=zeros(size(Spec_Chan_All_Aud,2),4);
clusterStartJLA2=zeros(size(Spec_Chan_All_Aud,2),1);

for iChan=1:size(pvalsJLAM,1);

    tmp=bwconncomp(sq(pvalsJLAM(iChan,:)));
    if size(tmp.PixelIdxList,2)>0
    for ii=1:size(tmp.PixelIdxList,2);
        ii2(ii)=size(tmp.PixelIdxList{ii},1);
    end
    
    ii2B=find(ii2>=ClusterSize);
    if length(ii2B)>0
        for ii=1:length(ii2B);
            ii3(ii)=tmp.PixelIdxList{ii2B(ii)}(1);
            clusterStartJLA2(iChan)=ii3(1);
            if ii3(ii)>=11 && ii3(ii)<=15
                clusterStartJLA(iChan,1)=1;
            elseif ii3(ii)>=16 && ii3(ii)<=20
                clusterStartJLA(iChan,2)=1;
            elseif ii3(ii)>=21 && ii3(ii)<=25
                clusterStartJLA(iChan,3)=1;
            elseif ii3(ii)>=26 && ii3(ii)<=30
                clusterStartJLA(iChan,4)=1;
%             elseif ii3(ii)>=31 && ii3(ii)<=35
%                 clusterStartDA(iChan,5)=1;
%             elseif ii3(ii)>=36 && ii3(ii)<=40
%                 clusterStartDA(iChan,6)=1;
            end
        end
    end
    clear ii3
 
       
    SigClusterSizeJLA(iChan)=max(ii2);
    else
        SigClusterSizeJLA(iChan)=0;
    end
    clear ii2
end

iiJLA=find(SigClusterSizeJLA>=ClusterSize);


clusterStartLMA=zeros(size(Spec_Chan_All_Aud,2),4);
clusterStartLMA2=zeros(size(Spec_Chan_All_Aud,2),1);

for iChan=1:size(pvalsLMAM,1);

    tmp=bwconncomp(sq(pvalsLMAM(iChan,:)));
    if size(tmp.PixelIdxList,2)>0
    for ii=1:size(tmp.PixelIdxList,2);
        ii2(ii)=size(tmp.PixelIdxList{ii},1);
    end
    
    ii2B=find(ii2>=ClusterSize);
    if length(ii2B)>0
        for ii=1:length(ii2B);
            ii3(ii)=tmp.PixelIdxList{ii2B(ii)}(1);
            clusterStartLMA2(iChan)=ii3(1);
            if ii3(ii)>=11 && ii3(ii)<=15
                clusterStartLMA(iChan,1)=1;
            elseif ii3(ii)>=16 && ii3(ii)<=20
                clusterStartLMA(iChan,2)=1;
            elseif ii3(ii)>=21 && ii3(ii)<=25
                clusterStartLMA(iChan,3)=1;
            elseif ii3(ii)>=26 && ii3(ii)<=30
                clusterStartLMA(iChan,4)=1;
%             elseif ii3(ii)>=31 && ii3(ii)<=35
%                 clusterStartDA(iChan,5)=1;
%             elseif ii3(ii)>=36 && ii3(ii)<=40
%                 clusterStartDA(iChan,6)=1;
            end
        end
    end
    clear ii3
 
       
    SigClusterSizeLMA(iChan)=max(ii2);
    else
        SigClusterSizeLMA(iChan)=0;
    end
    clear ii2
end

iiLMA=find(SigClusterSizeLMA>=ClusterSize);

clusterStartLSP=zeros(size(Spec_Chan_All_Aud,2),4);
clusterStartLSP2=zeros(size(Spec_Chan_All_Aud,2),1);

for iChan=1:size(pvalsLSPM,1);

    tmp=bwconncomp(sq(pvalsLSPM(iChan,:)));
    if size(tmp.PixelIdxList,2)>0
    for ii=1:size(tmp.PixelIdxList,2);
        ii2(ii)=size(tmp.PixelIdxList{ii},1);
    end
    
    ii2B=find(ii2>=ClusterSize);
    if length(ii2B)>0
        for ii=1:length(ii2B);
            ii3(ii)=tmp.PixelIdxList{ii2B(ii)}(1);
            clusterStartLSP2(iChan)=ii3(1);
            if ii3(ii)>=11 && ii3(ii)<=15
                clusterStartLSP(iChan,1)=1;
            elseif ii3(ii)>=16 && ii3(ii)<=20
                clusterStartLSP(iChan,2)=1;
            elseif ii3(ii)>=21 && ii3(ii)<=25
                clusterStartLSP(iChan,3)=1;
            elseif ii3(ii)>=26 && ii3(ii)<=30
                clusterStartLSP(iChan,4)=1;
%             elseif ii3(ii)>=31 && ii3(ii)<=35
%                 clusterStartDA(iChan,5)=1;
%             elseif ii3(ii)>=36 && ii3(ii)<=40
%                 clusterStartDA(iChan,6)=1;
            end
        end
    end
    clear ii3
 
       
    SigClusterSizeLSP(iChan)=max(ii2);
    else
        SigClusterSizeLSP(iChan)=0;
    end
    clear ii2
end

iiLSP=find(SigClusterSizeLSP>=ClusterSize);

clusterStartJLP=zeros(size(Spec_Chan_All_Aud,2),4);
clusterStartJLP2=zeros(size(Spec_Chan_All_Aud,2),1);

for iChan=1:size(pvalsJLPM,1);

    tmp=bwconncomp(sq(pvalsJLPM(iChan,:)));
    if size(tmp.PixelIdxList,2)>0
    for ii=1:size(tmp.PixelIdxList,2);
        ii2(ii)=size(tmp.PixelIdxList{ii},1);
    end
    
    ii2B=find(ii2>=ClusterSize);
    if length(ii2B)>0
        for ii=1:length(ii2B);
            ii3(ii)=tmp.PixelIdxList{ii2B(ii)}(1);
            clusterStartJLP2(iChan)=ii3(1);
            if ii3(ii)>=11 && ii3(ii)<=15
                clusterStartJLP(iChan,1)=1;
            elseif ii3(ii)>=16 && ii3(ii)<=20
                clusterStartJLP(iChan,2)=1;
            elseif ii3(ii)>=21 && ii3(ii)<=25
                clusterStartJLP(iChan,3)=1;
            elseif ii3(ii)>=26 && ii3(ii)<=30
                clusterStartJLP(iChan,4)=1;
%             elseif ii3(ii)>=31 && ii3(ii)<=35
%                 clusterStartDA(iChan,5)=1;
%             elseif ii3(ii)>=36 && ii3(ii)<=40
%                 clusterStartDA(iChan,6)=1;
            end
        end
    end
    clear ii3
 
       
    SigClusterSizeJLP(iChan)=max(ii2);
    else
        SigClusterSizeJLP(iChan)=0;
    end
    clear ii2
end

iiJLP=find(SigClusterSizeJLP>=ClusterSize);

clusterStartLMP=zeros(size(Spec_Chan_All_Aud,2),4);
clusterStartLMP2=zeros(size(Spec_Chan_All_Aud,2),1);

for iChan=1:size(pvalsLMPM,1);

    tmp=bwconncomp(sq(pvalsLMPM(iChan,:)));
    if size(tmp.PixelIdxList,2)>0
    for ii=1:size(tmp.PixelIdxList,2);
        ii2(ii)=size(tmp.PixelIdxList{ii},1);
    end
    
    ii2B=find(ii2>=ClusterSize);
    if length(ii2B)>0
        for ii=1:length(ii2B);
            ii3(ii)=tmp.PixelIdxList{ii2B(ii)}(1);
            clusterStartLMP2(iChan)=ii3(1);
            if ii3(ii)>=11 && ii3(ii)<=15
                clusterStartLMP(iChan,1)=1;
            elseif ii3(ii)>=16 && ii3(ii)<=20
                clusterStartLMP(iChan,2)=1;
            elseif ii3(ii)>=21 && ii3(ii)<=25
                clusterStartLMP(iChan,3)=1;
            elseif ii3(ii)>=26 && ii3(ii)<=30
                clusterStartLMP(iChan,4)=1;
%             elseif ii3(ii)>=31 && ii3(ii)<=35
%                 clusterStartDA(iChan,5)=1;
%             elseif ii3(ii)>=36 && ii3(ii)<=40
%                 clusterStartDA(iChan,6)=1;
            end
        end
    end
    clear ii3
 
       
    SigClusterSizeLMP(iChan)=max(ii2);
    else
        SigClusterSizeLMP(iChan)=0;
    end
    clear ii2
end

iiLMP=find(SigClusterSizeLMP>=ClusterSize);


save([DUKEDIR '/SentenceRep/' 'D3toD29_LocalizerLSLMHL_70150_Outlier8_timepointsvsbaseline.mat'],'SNList','pvals*','ii*','sig*','clusterSt*','Spec_Subject*');
