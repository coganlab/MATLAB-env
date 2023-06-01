duke;
global experiment
Subject = struct([]);

Subject(1).Name = 'D1'; Subject(1).Day = '260216'; % 160216 is clin 1, 160217 is clin 2
Subject(3).Name = 'D3'; Subject(3).Day = '100916';
Subject(7).Name = 'D7'; Subject(7).Day = '030117';
Subject(8).Name = 'D8'; Subject(8).Day = '030317';
Subject(9).Name = 'D12'; Subject(9).Day = '090917';
Subject(10).Name = 'D13'; Subject(10).Day = '071017';
Subject(11).Name = 'D14'; Subject(11).Day = '101117';
Subject(12).Name= 'D15'; Subject(12).Day = '171217';
Subject(13).Name = 'D16'; Subject(13).Day ='200118';
Subject(14).Name = 'D17'; Subject(14).Day = '180309';
Subject(2).Name = 'S1'; Subject(2).Day = '080318';
Subject(15).Name = 'D20'; Subject(15).Day = '180518';
Subject(16).Name = 'D22'; Subject(16).Day = '270618';
Subject(17).Name = 'D23'; Subject(17).Day = '130818';

Subject(18).Name = 'S6'; Subject(18).Day = '180727';





counterChan=0;
for SN = [9:12,14,15,16,17] %[9:12,14,15];
    Subject(SN).Experiment = loadExperiment(Subject(SN).Name);
    Subject(SN).Trials = dbTrials(Subject(SN).Name,Subject(SN).Day,'Speech_OvertMimeMove');
    %Subject(SN).Trials = dbTrials(Subject(SN).Name,Subject(SN).Day,'Speech_CovertOvert'); % Test line
    Trials = Subject(SN).Trials;
    experiment = Subject(SN).Experiment;
    
    %CondParams.Conds = [1:4];
    
    
    
    %CondParams.bn = [-2500,3500];
    %AnalParams.Tapers = [0.5,10];
    AnalParams.Tapers = [.5,10];
    %AnalParams.Tapers = [1,10];
    AnalParams.fk = 500;
    %AnalParams.Reference = 'Grand average'; %'Grand average'; % other is 'Single-ended';
    AnalParams.RefChans=subjRefChans(Subject(SN).Name);
    AnalParams.Reference = 'IndRef'; %'Grand average', 'Grand average induced'% induced' 'Single-ended','IndRef';
    AnalParams.ArtifactThreshold = 8;
    AnalParams.dn=0.05;
    
    if strcmp(Subject(SN).Name,'D1')
        AnalParams.Channel = [1:66];
        
    elseif  strcmp(Subject(SN).Name,'D7')
        %   AnalParams.Channel = [1:102];
        AnalParams.Channel = [17:80]; % just grid
    elseif  strcmp(Subject(SN).Name,'D3')
        AnalParams.Channel = [1:52];
        badChans=[12];
        AnalParams.Channel=setdiff(AnalParams.Channel,badChans);
    elseif strcmp(Subject(SN).Name,'D8')
        AnalParams.Channel = [1:110];
    elseif strcmp(Subject(SN).Name,'D12')
        AnalParams.Channel = [1:110];
        %  AnalParams.ReferenceChannels=[30];
    elseif strcmp(Subject(SN).Name,'D13')
        AnalParams.Channel = [1:120];
        %   AnalParams.ReferenceChannels=[18:20];
    elseif strcmp(Subject(SN).Name,'D14')
        AnalParams.Channel = [1:120];
    elseif strcmp(Subject(SN).Name,'D15')
        AnalParams.Channel = [1:120];
    elseif strcmp(Subject(SN).Name,'D16');
        AnalParams.Channel = [1:41];
    elseif strcmp(Subject(SN).Name,'D17');
        AnalParams.Channel=[1:114];
    elseif strcmp(Subject(SN).Name,'D20');
        AnalParams.Channel=[10:129];
    elseif strcmp(Subject(SN).Name,'D22');
        AnalParams.Channel=[1:100];
    elseif strcmp(Subject(SN).Name,'D23');
        AnalParams.Channel=[1:121];
    elseif strcmp(Subject(SN).Name,'S1');
   % AnalParams.Channel=[1:256];
    AnalParams.Channel=setdiff(1:256,[2,32,64,66,96,128,130,160,192,194,224,256]);
    elseif strcmp(Subject(SN).Name,'S6');
   AnalParams.Channel=setdiff(1:256,[12,32,53,66,96,128,130,160,192,204,224,245]);
    else
        AnalParams.Channel = [1:64];
    end
    CondParams.Conds=[1:4];
    NumTrials = SelectChannels(Subject(SN).Trials, CondParams, AnalParams);
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
    
    CondParams.Conds=[1:8];
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

    
    CondParams.Conds=[1:8];
    CondParams.Field = 'ResponseStart';
    CondParams.bn = [-1000,1000];
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
    
    
    
     CondParams.Conds=[1:8];
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
    fRange=70:120;
  %  fRange=30:50;
    outcut=10;
    for iChan=1:length(AnalParams.Channel);
        iChan2=iChan+counterChan;
        baseline1=[];
        baseline2=[];
        for iCond=1:8;
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
         for iTrials=1:length(Auditory_Trials{iCond})
             tmp=cat(1,tmp,Auditory_Trials{iCond}(iTrials).Trial);
         end
         ATrials1{iCond}=tmp;
         tmp=[];
         for iTrials=1:length(Motor_Trials{iCond})
             tmp=cat(1,tmp,Motor_Trials{iCond}(iTrials).Trial);
         end
         MTrials1{iCond}=tmp;
         
          tmp=[];
         for iTrials=1:length(Start_Trials{iCond})
             tmp=cat(1,tmp,Start_Trials{iCond}(iTrials).Trial);
         end
         STrials1{iCond}=tmp;
%          
%          ATrials2=ATrials1{iCond}(tmpIDX1);
%          MTrials2=MTrials1{iCond}(tmpIDX2);
%          STrials2=STrials1{iCond};
%            CTrials=intersect(ATrials2,MTrials2);
%            CTrials=intersect(CTrials,STrials2);
%            [C,ATrialsIdx]=intersect(ATrials1{iCond},CTrials);
%            [C,MTrialsIdx]=intersect(MTrials1{iCond},CTrials);
%            [C, STrialsIdx]=intersect(STrials1{iCond},CTrials);
            %  tmp=tmp./mean(mean(tmp(:,1:10))); % each cond baseline   
         %   tmp=tmp./mean(tmp(:,1:10),2); % each trial baseline
     
           % Spec_Chan_All_Aud{iChan2}{iCond}=sq(mean(Auditory_Spec{iCond}{iChan}(tmpIDX1,:,fRange),3));
           % Spec_Chan_All_Aud{iChan2}{iCond}=sq(mean(Auditory_Spec{iCond}{iChan}(ATrialsIdx,:,fRange),3));
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
    tmpAD=[];
    tmpAR=[];
    tmpSD=[];
    tmpSR=[];
    for iCond=1:4

              tmp=sq(log(Spec_Chan_All_Start{iChan}{iCond}(:,:)));
          %  tmp=tmp-mean(mean(tmp));
            [m s]=normfit(tmp(:));
            [i j]=find(tmp>(outcut*s+m));
            tmpIDXSD=setdiff(1:size(tmp,1),unique(i));
            
            tmp=sq(log(Spec_Chan_All_Start{iChan}{iCond+4}(:,:)));
          %  tmp=tmp-mean(mean(tmp));
            [m s]=normfit(tmp(:));
            [i j]=find(tmp>(outcut*s+m));
            tmpIDXSR=setdiff(1:size(tmp,1),unique(i));
            
    %    tmpAD=cat(1,tmpAD,Spec_Chan_All_Aud{iChan}{iCond}(tmpIDXSD,:));
    %    tmpAR=cat(1,tmpAR,Spec_Chan_All_Aud{iChan}{iCond+4}(tmpIDXSR,:));
        tmpSD=cat(1,tmpSD,Spec_Chan_All_Start{iChan}{iCond}(tmpIDXSD,:));
        tmpSR=cat(1,tmpSR,Spec_Chan_All_Start{iChan}{iCond+4}(tmpIDXSR,:));
    end
    tmpA=cat(1,tmpAD,tmpAR);
    tmpS=cat(1,tmpSD,tmpSR);
    for iCond=1:8;
        trialNA(iCond)=size(Spec_Chan_All_Aud{iChan}{iCond},1);
        trialNP(iCond)=size(Spec_Chan_All_Prod{iChan}{iCond},1);
    end
    trialNAMin=min(trialNA);
    trialNPMin=min(trialNP);
    for iCond=1:4;
        sIdxAD=shuffle(1:size(Spec_Chan_All_Aud{iChan}{iCond},1));
        sIdxPD=shuffle(1:size(Spec_Chan_All_Prod{iChan}{iCond},1));
        sIdxAR=shuffle(1:size(Spec_Chan_All_Aud{iChan}{iCond+4},1));
        sIdxPR=shuffle(1:size(Spec_Chan_All_Prod{iChan}{iCond+4},1));
%          dataAD(iChan,iCond,:)=mean(Spec_Chan_All_Aud{iChan}{iCond}(sIdxAD(1:trialNAMin),:))./mean(mean(tmpSD(:,1:10)));
%          dataPD(iChan,iCond,:)=mean(Spec_Chan_All_Prod{iChan}{iCond}(sIdxPD(1:trialNPMin),:))./mean(mean(tmpSD(:,1:10)));
%          dataAR(iChan,iCond,:)=mean(Spec_Chan_All_Aud{iChan}{iCond+4}(sIdxAR(1:trialNAMin),:))./mean(mean(tmpSR(:,1:10)));
%          dataPR(iChan,iCond,:)=mean(Spec_Chan_All_Prod{iChan}{iCond+4}(sIdxPR(1:trialNPMin),:))./mean(mean(tmpSR(:,1:10)));

%          dataAD(iChan,iCond,:)=mean(Spec_Chan_All_Aud{iChan}{iCond}(:,:))./mean(mean(tmpSD(:,1:10)));
%          dataPD(iChan,iCond,:)=mean(Spec_Chan_All_Prod{iChan}{iCond}(:,:))./mean(mean(tmpSD(:,1:10)));
%          dataAR(iChan,iCond,:)=mean(Spec_Chan_All_Aud{iChan}{iCond+4}(:,:))./mean(mean(tmpSR(:,1:10)));
%          dataPR(iChan,iCond,:)=mean(Spec_Chan_All_Prod{iChan}{iCond+4}(:,:))./mean(mean(tmpSR(:,1:10)));
       
            tmp=sq(log(Spec_Chan_All_Aud{iChan}{iCond}(:,:)));
          %  tmp=tmp-mean(mean(tmp));
            [m s]=normfit(tmp(:));
            [i j]=find(tmp>(outcut*s+m));
            tmpIDXAD=setdiff(1:size(tmp,1),unique(i));
            
            tmp=sq(log(Spec_Chan_All_Prod{iChan}{iCond}(:,:)));
          %  tmp=tmp-mean(mean(tmp));
            [m s]=normfit(tmp(:));
            [i j]=find(tmp>(outcut*s+m));
            tmpIDXMD=setdiff(1:size(tmp,1),unique(i));
        
      

             tmp=sq(log(Spec_Chan_All_Aud{iChan}{iCond+4}(:,:)));
          %  tmp=tmp-mean(mean(tmp));
            [m s]=normfit(tmp(:));
            [i j]=find(tmp>(outcut*s+m));
            tmpIDXAR=setdiff(1:size(tmp,1),unique(i));
            
            tmp=sq(log(Spec_Chan_All_Prod{iChan}{iCond+4}(:,:)));
          %  tmp=tmp-mean(mean(tmp));
            [m s]=normfit(tmp(:));
            [i j]=find(tmp>(outcut*s+m));
            tmpIDXMR=setdiff(1:size(tmp,1),unique(i));
        
            
            

         [mSD sSD]=normfit(log(tmpSD(:)));
         [mSR sSR]=normfit(log(tmpSR(:)));
         [mS sS]=normfit(log(tmpS(:)));
         [mA sA]=normfit(log(tmpA(:)));
         
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
         dataAD(iChan,iCond,:)=mean(Spec_Chan_All_Aud{iChan}{iCond}(tmpIDXAD,:))./mean(mean(tmpSD(:,1:10)));
         dataPD(iChan,iCond,:)=mean(Spec_Chan_All_Prod{iChan}{iCond}(tmpIDXMD,:))./mean(mean(tmpSD(:,1:10)));
         dataAR(iChan,iCond,:)=mean(Spec_Chan_All_Aud{iChan}{iCond+4}(tmpIDXAR,:))./mean(mean(tmpSR(:,1:10)));
         dataPR(iChan,iCond,:)=mean(Spec_Chan_All_Prod{iChan}{iCond+4}(tmpIDXMR,:))./mean(mean(tmpSR(:,1:10)));         
   
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
    tmpDA=[];
    tmpRA=[];
    tmpDP=[];
    tmpRP=[];
    hDAIdx=[];
    hRAIdx=[];
    hDPIdx=[];
    hRPIdx=[];
    for iCond=1:4;
        if iCond==1 || iCond==3
            hDAIdx=cat(1,hDAIdx,ones(size(Spec_Chan_All_Aud{iChan}{iCond},1),1));
            hRAIdx=cat(1,hRAIdx,ones(size(Spec_Chan_All_Aud{iChan}{iCond+4},1),1));
            hDPIdx=cat(1,hDPIdx,ones(size(Spec_Chan_All_Prod{iChan}{iCond},1),1));
            hRPIdx=cat(1,hRPIdx,ones(size(Spec_Chan_All_Prod{iChan}{iCond+4},1),1));            
        elseif iCond==2 || iCond == 4
            hDAIdx=cat(1,hDAIdx,2.*ones(size(Spec_Chan_All_Aud{iChan}{iCond},1),1));
            hRAIdx=cat(1,hRAIdx,2.*ones(size(Spec_Chan_All_Aud{iChan}{iCond+4},1),1));
            hDPIdx=cat(1,hDPIdx,2.*ones(size(Spec_Chan_All_Prod{iChan}{iCond},1),1));
            hRPIdx=cat(1,hRPIdx,2.*ones(size(Spec_Chan_All_Prod{iChan}{iCond+4},1),1));               
        end
        tmpDA=cat(1,tmpDA,Spec_Chan_All_Aud{iChan}{iCond});
        tmpRA=cat(1,tmpRA,Spec_Chan_All_Aud{iChan}{iCond+4});
        tmpDP=cat(1,tmpDP,Spec_Chan_All_Prod{iChan}{iCond});
        tmpRP=cat(1,tmpRP,Spec_Chan_All_Prod{iChan}{iCond+4});
    end
    
     tmp1=tmpDA(:,1:10);
    [m s]=normfit(log(tmp1(:)));
    tmpDA=(log(tmpDA)-m)./s;
    tmpDP=(log(tmpDP)-m)./s;
    
    tmp1=tmpRA(:,1:10);
    [m s]=normfit(log(tmp1(:)));
    tmpRA=(log(tmpRA)-m)./s;
    tmpRP=(log(tmpRP)-m)./s;
    
    idxDAH=find(hDAIdx==1);
    idxDAL=find(hDAIdx==2);
    idxRAH=find(hRAIdx==1);
    idxRAL=find(hRAIdx==2);

    idxDPH=find(hDPIdx==1);
    idxDPL=find(hDPIdx==2);
    idxRPH=find(hRPIdx==1);
    idxRPL=find(hRPIdx==2);
    
    tmpHA=cat(1,tmpDA(idxDAH,:),tmpRA(idxRAH,:));
    tmpLA=cat(1,tmpDA(idxDAL,:),tmpRA(idxRAL,:));
    tmpHP=cat(1,tmpDP(idxDPH,:),tmpRP(idxRPH,:));
    tmpLP=cat(1,tmpDP(idxDPL,:),tmpRP(idxRPL,:));    
    
    for iTime=1:40;
    actdiffHA=mean(tmpHA(:,iTime))-mean(tmpLA(:,iTime));
    combvalHA=cat(1,mean(tmpHA(:,iTime),2),mean(tmpLA(:,iTime),2));
%     actdiffRA=mean(tmpRA(:,iTime))-mean(mean(tmpRA(:,1:10)));
%     combvalRA=cat(1,mean(tmpRA(:,iTime),2),reshape(tmpRA(:,1:10),size(tmpRA,1)*10,1));
    
    actdiffHP=mean(tmpHP(:,iTime))-mean(tmpLP(:,iTime));
    combvalHP=cat(1,mean(tmpHP(:,iTime),2),mean(tmpLP(:,iTime),2));
%     actdiffRP=mean(tmpRP(:,iTime))-mean(mean(tmpRA(:,1:10)));
%     combvalRP=cat(1,mean(tmpRP(:,iTime),2),reshape(tmpRA(:,1:10),size(tmpRA,1)*10,1));
    
    for iPerm=1:nPerm;
        sIdxHA=shuffle(1:size(combvalHA,1));
        permvalHA(iPerm)=mean(combvalHA(sIdxHA(1:size(tmpHA,1))))-mean(combvalHA(sIdxHA(size(tmpHA,1)+1:length(sIdxHA))));
%       sIdxRA=shuffle(1:size(combvalRA,1));
%         permvalRA(iPerm)=mean(combvalRA(sIdxRA(1:size(tmpRA,1))))-mean(combvalRA(sIdxRA(size(tmpRA,1)+1:length(sIdxRA))));
         sIdxHP=shuffle(1:size(combvalHP,1));
        permvalHP(iPerm)=mean(combvalHP(sIdxHP(1:size(tmpHP,1))))-mean(combvalHP(sIdxHP(size(tmpHP,1)+1:length(sIdxHP))));
%         sIdxRP=shuffle(1:size(combvalRP,1));
%         permvalRP(iPerm)=mean(combvalRP(sIdxRP(1:size(tmpRP,1))))-mean(combvalRP(sIdxRP(size(tmpRP,1)+1:length(sIdxRP))));    
    end
    pvalsHLA(iChan,iTime)=length(find(permvalHA>actdiffHA))./nPerm;
%     pvalsRA(iChan,iTime)=length(find(permvalRA>actdiffRA))./nPerm;
    pvalsHLP(iChan,iTime)=length(find(permvalHP>actdiffHP))./nPerm;
%     pvalsRP(iChan,iTime)=length(find(permvalRP>actdiffRP))./nPerm;
    end
    display(iChan)
end

sigVal=0.025;
ClusterSize=5;
pvalsHLAM=zeros(size(pvalsHLA,1),size(pvalsHLA,2));
iiS=find(pvalsHLA<sigVal);
pvalsHLAM(iiS)=1;

pvalsLHAM=zeros(size(pvalsHLA,1),size(pvalsHLA,2));
iiS=find(1-pvalsHLA<sigVal);
pvalsLHAM(iiS)=1;


pvalsHLPM=zeros(size(pvalsHLP,1),size(pvalsHLP,2));
iiS=find(pvalsHLP<sigVal);
pvalsHLPM(iiS)=1;

pvalsLHPM=zeros(size(pvalsHLP,1),size(pvalsHLP,2));
iiS=find(1-pvalsHLP<sigVal);
pvalsLHPM(iiS)=1;
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

% pvalsDAM=pvalsDAM(1:size(pvalsDAM,1),1:40);
% pvalsRAM=pvalsRAM(1:size(pvalsRAM,1),1:40);
% pvalsDPM=pvalsDPM(1:size(pvalsDPM,1),1:40);
% pvalsRPM=pvalsRPM(1:size(pvalsRPM,1),1:40);
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
clusterStartHLA=zeros(size(Spec_Chan_All_Aud,2),4);
clusterStartHLA2=zeros(size(Spec_Chan_All_Aud,2),1);

for iChan=1:size(pvalsHLAM,1);

    tmp=bwconncomp(sq(pvalsHLAM(iChan,:)));
    if size(tmp.PixelIdxList,2)>0
    for ii=1:size(tmp.PixelIdxList,2);
        ii2(ii)=size(tmp.PixelIdxList{ii},1);
    end
    
    ii2B=find(ii2>=ClusterSize);
    if length(ii2B)>0
        for ii=1:length(ii2B);
            ii3(ii)=tmp.PixelIdxList{ii2B(ii)}(1);
            clusterStartHLA2(iChan)=ii3(1);
            if ii3(ii)>=11 && ii3(ii)<=15
                clusterStartHLA(iChan,1)=1;
            elseif ii3(ii)>=16 && ii3(ii)<=20
                clusterStartHLA(iChan,2)=1;
            elseif ii3(ii)>=21 && ii3(ii)<=25
                clusterStartHLA(iChan,3)=1;
            elseif ii3(ii)>=26 && ii3(ii)<=30
                clusterStartHLA(iChan,4)=1;
%             elseif ii3(ii)>=31 && ii3(ii)<=35
%                 clusterStartDA(iChan,5)=1;
%             elseif ii3(ii)>=36 && ii3(ii)<=40
%                 clusterStartDA(iChan,6)=1;
            end
        end
    end
    clear ii3
 
       
    SigClusterSizeHLA(iChan)=max(ii2);
    else
        SigClusterSizeHLA(iChan)=0;
    end
    clear ii2
end

iiHLA=find(SigClusterSizeHLA>=ClusterSize);

clusterStartLHA=zeros(size(Spec_Chan_All_Aud,2),4);
clusterStartLHA2=zeros(size(Spec_Chan_All_Aud,2),1);

for iChan=1:size(pvalsLHAM,1);

    tmp=bwconncomp(sq(pvalsLHAM(iChan,:)));
    if size(tmp.PixelIdxList,2)>0
    for ii=1:size(tmp.PixelIdxList,2);
        ii2(ii)=size(tmp.PixelIdxList{ii},1);
    end
    
    ii2B=find(ii2>=ClusterSize);
    if length(ii2B)>0
        for ii=1:length(ii2B);
            ii3(ii)=tmp.PixelIdxList{ii2B(ii)}(1);
            clusterStartLHA2(iChan)=ii3(1);
            if ii3(ii)>=11 && ii3(ii)<=15
                clusterStartLHA(iChan,1)=1;
            elseif ii3(ii)>=16 && ii3(ii)<=20
                clusterStartLHA(iChan,2)=1;
            elseif ii3(ii)>=21 && ii3(ii)<=25
                clusterStartLHA(iChan,3)=1;
            elseif ii3(ii)>=26 && ii3(ii)<=30
                clusterStartLHA(iChan,4)=1;
%             elseif ii3(ii)>=31 && ii3(ii)<=35
%                 clusterStartRA(iChan,5)=1;
%             elseif ii3(ii)>=36 && ii3(ii)<=40
%                 clusterStartRA(iChan,6)=1;
            end
        end
    end
    clear ii3
    
    SigClusterSizeLHA(iChan)=max(ii2);
    else
        SigClusterSizeLHA(iChan)=0;
    end
    clear ii2
end

iiLHA=find(SigClusterSizeLHA>=ClusterSize);


clusterStartHLP=zeros(size(Spec_Chan_All_Aud,2),4);
clusterStartLHP2=zeros(size(Spec_Chan_All_Aud,2),1);
for iChan=1:size(pvalsHLPM,1);

    tmp=bwconncomp(sq(pvalsHLPM(iChan,:)));
    if size(tmp.PixelIdxList,2)>0
    for ii=1:size(tmp.PixelIdxList,2);
        ii2(ii)=size(tmp.PixelIdxList{ii},1);
    end
    
    ii2B=find(ii2>=ClusterSize);
    if length(ii2B)>0
        for ii=1:length(ii2B);
            ii3(ii)=tmp.PixelIdxList{ii2B(ii)}(1);
            clusterStartHLP2(iChan)=ii3(1);
            if ii3(ii)>=11 && ii3(ii)<=15
                clusterStartHLP(iChan,1)=1;
            elseif ii3(ii)>=16 && ii3(ii)<=20
                clusterStartHLP(iChan,2)=1;
            elseif ii3(ii)>=21 && ii3(ii)<=25
                clusterStartHLP(iChan,3)=1;
            elseif ii3(ii)>=26 && ii3(ii)<=30
                clusterStartHLP(iChan,4)=1;
%             elseif ii3(ii)>=31 && ii3(ii)<=35
%                 clusterStartDP(iChan,5)=1;
%             elseif ii3(ii)>=36 && ii3(ii)<=40
%                 clusterStartDP(iChan,6)=1;
            end
        end
    end
    clear ii3
 
       
    SigClusterSizeHLP(iChan)=max(ii2);
    else
        SigClusterSizeHLP(iChan)=0;
    end
    clear ii2
end

iiHLP=find(SigClusterSizeHLP>=ClusterSize);

clusterStartLHP=zeros(size(Spec_Chan_All_Aud,2),4);
clusterStartLHP2=zeros(size(Spec_Chan_All_Aud,2),1);
for iChan=1:size(pvalsLHPM,1);

    tmp=bwconncomp(sq(pvalsLHPM(iChan,:)));
    if size(tmp.PixelIdxList,2)>0
    for ii=1:size(tmp.PixelIdxList,2);
        ii2(ii)=size(tmp.PixelIdxList{ii},1);
    end
    
    ii2B=find(ii2>=ClusterSize);
    if length(ii2B)>0
        for ii=1:length(ii2B);
            ii3(ii)=tmp.PixelIdxList{ii2B(ii)}(1);
            clusterStartLHP2(iChan)=ii3(1);
            if ii3(ii)>=11 && ii3(ii)<=15
                clusterStartLHP(iChan,1)=1;
            elseif ii3(ii)>=16 && ii3(ii)<=20
                clusterStartLHP(iChan,2)=1;
            elseif ii3(ii)>=21 && ii3(ii)<=25
                clusterStartLHP(iChan,3)=1;
            elseif ii3(ii)>=26 && ii3(ii)<=30
                clusterStartLHP(iChan,4)=1;
%             elseif ii3(ii)>=31 && ii3(ii)<=35
%                 clusterStartRP(iChan,5)=1;
%             elseif ii3(ii)>=36 && ii3(ii)<=40
%                 clusterStartRP(iChan,6)=1;
            end
        end
    end
    clear ii3
    
    SigClusterSizeLHP(iChan)=max(ii2);
    else
        SigClusterSizeLHP(iChan)=0;
    end
    clear ii2
end

iiLHP=find(SigClusterSizeLHP>=ClusterSize);


% ii=find(clusterStartDRA2>=10);
% iiDRA=intersect(iiDRA,ii);
% ii=find(clusterStartRDA2>=10);
% iiRDA=intersect(iiRDA,ii);


% ii=max(sq(mean(dataAD,2)),[],2);
% for iChan=1:size(Spec_Chan_All_Aud,2)
%  maxAD(iChan)=find(sq(mean(dataAD(iChan,:,:),2))==ii(iChan));
% end
% 
% ii=max(sq(mean(dataAR,2)),[],2);
% for iChan=1:size(Spec_Chan_All_Aud,2)
%  maxAR(iChan)=find(sq(mean(dataAR(iChan,:,:),2))==ii(iChan));
% end
% 
% ii=max(sq(mean(dataPD,2)),[],2);
% for iChan=1:size(Spec_Chan_All_Aud,2)
%  maxPD(iChan)=find(sq(mean(dataPD(iChan,:,:),2))==ii(iChan));
% end
% 
% ii=max(sq(mean(dataPR,2)),[],2);
% for iChan=1:size(Spec_Chan_All_Aud,2)
%  maxPR(iChan)=find(sq(mean(dataPR(iChan,:,:),2))==ii(iChan));
% end

% iiA=iiDRA;
% iiB=iiRDA;
% iiC=iiDRP;
% iiD=iiRDP;
% 
% % % 706 total,
% 
% iiABCD=intersect(iiA,intersect(iiB,intersect(iiC,iiD))); % 47 SM ALL
% 
% iiABC=setdiff(intersect(iiA,intersect(iiB,iiC)),iiD); % 6 ALL S, DEC M
% iiABD=setdiff(intersect(iiA,intersect(iiB,iiD)),iiC); % 14 ALL S, REP M
% iiACD=setdiff(intersect(iiA,intersect(iiC,iiD)),iiB); % 19 DEC S, ALL M
% iiBCD=setdiff(intersect(iiB,intersect(iiC,iiD)),iiA); % 20  REP S, ALL M
% 
% iiBC=setdiff(intersect(iiB,iiC),unique(cat(2,iiBCD,iiABC,iiABCD))); % 3 REP S, DEC M
% iiAC=setdiff(intersect(iiA,iiC),unique(cat(2,iiACD,iiABC,iiABCD))); % 37 DEC S, DEC M
% iiAD=setdiff(intersect(iiA,iiD),unique(cat(2,iiACD,iiABD,iiABCD))); % 5 DEC S, REP M
% iiBD=setdiff(intersect(iiB,iiD),unique(cat(2,iiBCD,iiABD,iiABCD))); % 22 REP S, REP M
% iiCD=setdiff(intersect(iiC,iiD),unique(cat(2,iiBCD,iiACD,iiABCD))); % 47 DEC M, REP M
% iiAB=setdiff(intersect(iiA,iiB),unique(cat(2,iiABC,iiABD,iiABCD))); % 9 DEC S, REP S
% 
% iiA=setdiff(iiA,unique(cat(2,iiAB,iiAC,iiABC,iiABCD,iiACD,iiAD,iiABD))); % 33 JUST DEC S
% iiB=setdiff(iiB,unique(cat(2,iiAB,iiBC,iiABC,iiBCD,iiABCD,iiBD,iiABD))); % 17 JUST REP S
% iiC=setdiff(iiC,unique(cat(2,iiCD,iiBC,iiBCD,iiABC,iiABCD,iiAC,iiACD))); % 62 JUST DEC M
% iiD=setdiff(iiD,unique(cat(2,iiCD,iiBCD,iiBD,iiABCD,iiABD,iiACD,iiAD))); % 33 JUST REP M
% 
% 
% totalActiveElecsDA=cat(2,iiABCD,iiABC,iiABD,iiACD,iiAC,iiAD,iiAB,iiA); % 170 DEC S
% totalActiveElecsDM=cat(2,iiABCD,iiABC,iiACD,iiBCD,iiBC,iiAC,iiCD,iiC); % 241 DEC M
% totalActiveElecsRA=cat(2,iiABCD,iiABC,iiABD,iiBCD,iiBC,iiBD,iiAB,iiB); % 138 REP S
% totalActiveElecsRP=cat(2,iiABCD,iiABD,iiACD,iiBCD,iiAD,iiBD,iiCD,iiD); % REP M
% totalActiveElecsJustDA=cat(2,iiACD,iiAC,iiAD,iiA); % 94 JUST DEC S (NOT REP S, MOTOR IRRELEVANT)
% totalActiveElecsJustRA=cat(2,iiBCD,iiBC,iiBD,iiB); % 62 JUST REP S (NOT DEC S, MOTOR IRRELEVANT)
% totalActiveElecsRDA=cat(2,iiABCD,iiABC,iiABD,iiAB); % 76 BOTH REP S AND DEC S (MOTOR IRRELEVANT)
% 
% totalActiveElecs=cat(2,iiABCD,iiABC,iiABD,iiACD,iiBCD,iiBC,iiAC,iiAD,iiBD,iiCD,iiAB,iiA,iiB,iiC,iiD); % 374 TOTAL ACTIVE
% totalActiveElecsA=cat(2,iiABCD,iiABC,iiABD,iiACD,iiBCD,iiBC,iiAC,iiAD,iiBD,iiAB,iiA,iiB); % 232 TOTAL IN S
% totalActiveElecsM=cat(2,iiABCD,iiABC,iiABD,iiACD,iiBCD,iiBC,iiAC,iiAD,iiBD,iiCD,iiC,iiD); % 315 TOTAL IN M

save('G:\D_Data\misc\Pvals_AUD_PROD_HG_70120_Outlier8_HighvsLowExp_RespAlignedAligned_WrongRespExc_IndivBaseSub_D22andD23InclFixed_MoreTrials.mat','pvals*','ii*','Sig*');

