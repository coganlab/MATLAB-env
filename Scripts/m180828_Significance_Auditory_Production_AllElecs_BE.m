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
for SN = [9:12,14,15,16,17] %[9:12,14:17];
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
        AnalParams.Channel=[1:120];
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
        [Go_Spec{iCode}, Go_Data, Go_Trials{iCode}] = subjSpectrum(Subject(SN), CondParams, AnalParams);
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
            
            tmp=sq(mean(Go_Spec{iCond}{iChan}(:,:,fRange),3));
            tmp=tmp-mean(mean(tmp));
            [m s]=normfit(tmp(:));
            [i j]=find(tmp>(outcut*s+m));
            tmpIDXG=setdiff(1:size(tmp,1),unique(i));
            tmp=[];
%          for iTrials=1:length(Auditory_Trials{iCond})
%              tmp=cat(1,tmp,Auditory_Trials{iCond}(iTrials).Trial);
%          end
%          ATrials1{iCond}=tmp;
%          tmp=[];
%          for iTrials=1:length(Motor_Trials{iCond})
%              tmp=cat(1,tmp,Motor_Trials{iCond}(iTrials).Trial);
%          end
%          MTrials1{iCond}=tmp;
%          
%           tmp=[];
%          for iTrials=1:length(Start_Trials{iCond})
%              tmp=cat(1,tmp,Start_Trials{iCond}(iTrials).Trial);
%          end
%          STrials1{iCond}=tmp;
%          
%          ATrials2=ATrials1{iCond}(tmpIDX1);
%          MTrials2=MTrials1{iCond}(tmpIDX2);
%          STrials2=STrials1{iCond};
%            CTrials=intersect(ATrials2,MTrials2);
%            CTrials=intersect(CTrials,STrials2);
%            [C,ATrialsIdx]=intersect(ATrials1{iCond},CTrials);
%            [C,MTrialsIdx]=intersect(MTrials1{iCond},CTrials);
%            [C, STrialsIdx]=intersect(STrials1{iCond},CTrials);
%             %  tmp=tmp./mean(mean(tmp(:,1:10))); % each cond baseline   
%          %   tmp=tmp./mean(tmp(:,1:10),2); % each trial baseline
     
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
            
            Spec_Chan_All_Go{iChan2}{iCond}=sq(mean(Go_Spec{iCond}{iChan}(tmpIDXG,:,fRange),3));
%            Spec_Chan_All_Prod{iChan2}{iCond}=sq(mean(Motor_Spec{iCond}{iChan}(MTrialsIdx,:,fRange),3))./sq(mean(mean(Auditory_Spec{iCond}{iChan}(ATrialsIdx,1:10,fRange),2),3));

            Spec_Subject_Go(iChan2)=SN;
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
             
            tmp=sq(log(Spec_Chan_All_Go{iChan}{iCond}(:,:)));
          %  tmp=tmp-mean(mean(tmp));
            [m s]=normfit(tmp(:));
            [i j]=find(tmp>(outcut*s+m));
            tmpIDXGD=setdiff(1:size(tmp,1),unique(i));       
      

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
            
            tmp=sq(log(Spec_Chan_All_Go{iChan}{iCond+4}(:,:)));
          %  tmp=tmp-mean(mean(tmp));
            [m s]=normfit(tmp(:));
            [i j]=find(tmp>(outcut*s+m));
            tmpIDXGR=setdiff(1:size(tmp,1),unique(i));
              
            
            

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
         dataGD(iChan,iCond,:)=mean(Spec_Chan_All_Go{iChan}{iCond}(tmpIDXGD,:))./mean(mean(tmpSD(:,1:10)));
         dataAR(iChan,iCond,:)=mean(Spec_Chan_All_Aud{iChan}{iCond+4}(tmpIDXAR,:))./mean(mean(tmpSR(:,1:10)));
         dataPR(iChan,iCond,:)=mean(Spec_Chan_All_Prod{iChan}{iCond+4}(tmpIDXMR,:))./mean(mean(tmpSR(:,1:10)));         
         dataGR(iChan,iCond,:)=mean(Spec_Chan_All_Go{iChan}{iCond+4}(tmpIDXGR,:))./mean(mean(tmpSR(:,1:10)));         
   
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
    for iCond=1:4;
        tmpDA=cat(1,tmpDA,Spec_Chan_All_Aud{iChan}{iCond});
        tmpRA=cat(1,tmpRA,Spec_Chan_All_Aud{iChan}{iCond+4});
        tmpDP=cat(1,tmpDP,Spec_Chan_All_Prod{iChan}{iCond});
        tmpRP=cat(1,tmpRP,Spec_Chan_All_Prod{iChan}{iCond+4});
    end
    for iTime=1:40;
    actdiffDA=mean(tmpDA(:,iTime))-mean(mean(tmpDA(:,1:10)));
    combvalDA=cat(1,mean(tmpDA(:,iTime),2),reshape(tmpDA(:,1:10),size(tmpDA,1)*10,1));
    actdiffRA=mean(tmpRA(:,iTime))-mean(mean(tmpRA(:,1:10)));
    combvalRA=cat(1,mean(tmpRA(:,iTime),2),reshape(tmpRA(:,1:10),size(tmpRA,1)*10,1));
    
    actdiffDP=mean(tmpDP(:,iTime))-mean(mean(tmpDA(:,1:10)));
    combvalDP=cat(1,mean(tmpDP(:,iTime),2),reshape(tmpDA(:,1:10),size(tmpDA,1)*10,1));
    actdiffRP=mean(tmpRP(:,iTime))-mean(mean(tmpRA(:,1:10)));
    combvalRP=cat(1,mean(tmpRP(:,iTime),2),reshape(tmpRA(:,1:10),size(tmpRA,1)*10,1));
    
    for iPerm=1:nPerm;
        sIdxDA=shuffle(1:size(combvalDA,1));
        permvalDA(iPerm)=mean(combvalDA(sIdxDA(1:size(tmpDA,1))))-mean(combvalDA(sIdxDA(size(tmpDA,1)+1:length(sIdxDA))));
        sIdxRA=shuffle(1:size(combvalRA,1));
        permvalRA(iPerm)=mean(combvalRA(sIdxRA(1:size(tmpRA,1))))-mean(combvalRA(sIdxRA(size(tmpRA,1)+1:length(sIdxRA))));
        sIdxDP=shuffle(1:size(combvalDP,1));
        permvalDP(iPerm)=mean(combvalDP(sIdxDP(1:size(tmpDP,1))))-mean(combvalDP(sIdxDP(size(tmpDP,1)+1:length(sIdxDP))));
        sIdxRP=shuffle(1:size(combvalRP,1));
        permvalRP(iPerm)=mean(combvalRP(sIdxRP(1:size(tmpRP,1))))-mean(combvalRP(sIdxRP(size(tmpRP,1)+1:length(sIdxRP))));    
    end
    pvalsDA(iChan,iTime)=length(find(permvalDA>actdiffDA))./nPerm;
    pvalsRA(iChan,iTime)=length(find(permvalRA>actdiffRA))./nPerm;
    pvalsDP(iChan,iTime)=length(find(permvalDP>actdiffDP))./nPerm;
    pvalsRP(iChan,iTime)=length(find(permvalRP>actdiffRP))./nPerm;
    end
    display(iChan)
end

sigVal=0.05;
ClusterSize=6;
pvalsDAM=zeros(size(pvalsDA,1),size(pvalsDA,2));
iiS=find(pvalsDA<sigVal);
pvalsDAM(iiS)=1;

pvalsRAM=zeros(size(pvalsRA,1),size(pvalsRA,2));
iiS=find(pvalsRA<sigVal);
pvalsRAM(iiS)=1;


pvalsDPM=zeros(size(pvalsDP,1),size(pvalsDP,2));
iiS=find(pvalsDP<sigVal);
pvalsDPM(iiS)=1;

pvalsRPM=zeros(size(pvalsRP,1),size(pvalsRP,2));
iiS=find(pvalsRP<sigVal);
pvalsRPM(iiS)=1;
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

pvalsDAM=pvalsDAM(1:size(pvalsDAM,1),1:40);
pvalsRAM=pvalsRAM(1:size(pvalsRAM,1),1:40);
pvalsDPM=pvalsDPM(1:size(pvalsDPM,1),1:40);
pvalsRPM=pvalsRPM(1:size(pvalsRPM,1),1:40);
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
clusterStartDA=zeros(size(Spec_Chan_All_Aud,2),4);
clusterStartDA2=zeros(size(Spec_Chan_All_Aud,2),1);

for iChan=1:size(pvalsDAM,1);

    tmp=bwconncomp(sq(pvalsDAM(iChan,:)));
    if size(tmp.PixelIdxList,2)>0
    for ii=1:size(tmp.PixelIdxList,2);
        ii2(ii)=size(tmp.PixelIdxList{ii},1);
    end
    
    ii2B=find(ii2>=ClusterSize);
    if length(ii2B)>0
        for ii=1:length(ii2B);
            ii3(ii)=tmp.PixelIdxList{ii2B(ii)}(1);
            clusterStartDA2(iChan)=ii3(1);
            if ii3(ii)>=11 && ii3(ii)<=15
                clusterStartDA(iChan,1)=1;
            elseif ii3(ii)>=16 && ii3(ii)<=20
                clusterStartDA(iChan,2)=1;
            elseif ii3(ii)>=21 && ii3(ii)<=25
                clusterStartDA(iChan,3)=1;
            elseif ii3(ii)>=26 && ii3(ii)<=30
                clusterStartDA(iChan,4)=1;
%             elseif ii3(ii)>=31 && ii3(ii)<=35
%                 clusterStartDA(iChan,5)=1;
%             elseif ii3(ii)>=36 && ii3(ii)<=40
%                 clusterStartDA(iChan,6)=1;
            end
        end
    end
    clear ii3
 
       
    SigClusterSizeDA(iChan)=max(ii2);
    else
        SigClusterSizeDA(iChan)=0;
    end
    clear ii2
end

iiDA=find(SigClusterSizeDA>=ClusterSize);

clusterStartRA=zeros(size(Spec_Chan_All_Aud,2),4);
clusterStartRA2=zeros(size(Spec_Chan_All_Aud,2),1);

for iChan=1:size(pvalsRAM,1);

    tmp=bwconncomp(sq(pvalsRAM(iChan,:)));
    if size(tmp.PixelIdxList,2)>0
    for ii=1:size(tmp.PixelIdxList,2);
        ii2(ii)=size(tmp.PixelIdxList{ii},1);
    end
    
    ii2B=find(ii2>=ClusterSize);
    if length(ii2B)>0
        for ii=1:length(ii2B);
            ii3(ii)=tmp.PixelIdxList{ii2B(ii)}(1);
            clusterStartRA2(iChan)=ii3(1);
            if ii3(ii)>=11 && ii3(ii)<=15
                clusterStartRA(iChan,1)=1;
            elseif ii3(ii)>=16 && ii3(ii)<=20
                clusterStartRA(iChan,2)=1;
            elseif ii3(ii)>=21 && ii3(ii)<=25
                clusterStartRA(iChan,3)=1;
            elseif ii3(ii)>=26 && ii3(ii)<=30
                clusterStartRA(iChan,4)=1;
%             elseif ii3(ii)>=31 && ii3(ii)<=35
%                 clusterStartRA(iChan,5)=1;
%             elseif ii3(ii)>=36 && ii3(ii)<=40
%                 clusterStartRA(iChan,6)=1;
            end
        end
    end
    clear ii3
    
    SigClusterSizeRA(iChan)=max(ii2);
    else
        SigClusterSizeRA(iChan)=0;
    end
    clear ii2
end

iiRA=find(SigClusterSizeRA>=ClusterSize);


clusterStartDP=zeros(size(Spec_Chan_All_Aud,2),4);
clusterStartDP2=zeros(size(Spec_Chan_All_Aud,2),1);
for iChan=1:size(pvalsDPM,1);

    tmp=bwconncomp(sq(pvalsDPM(iChan,:)));
    if size(tmp.PixelIdxList,2)>0
    for ii=1:size(tmp.PixelIdxList,2);
        ii2(ii)=size(tmp.PixelIdxList{ii},1);
    end
    
    ii2B=find(ii2>=ClusterSize);
    if length(ii2B)>0
        for ii=1:length(ii2B);
            ii3(ii)=tmp.PixelIdxList{ii2B(ii)}(1);
            clusterStartDP2(iChan)=ii3(1);
            if ii3(ii)>=11 && ii3(ii)<=15
                clusterStartDP(iChan,1)=1;
            elseif ii3(ii)>=16 && ii3(ii)<=20
                clusterStartDP(iChan,2)=1;
            elseif ii3(ii)>=21 && ii3(ii)<=25
                clusterStartDP(iChan,3)=1;
            elseif ii3(ii)>=26 && ii3(ii)<=30
                clusterStartDP(iChan,4)=1;
%             elseif ii3(ii)>=31 && ii3(ii)<=35
%                 clusterStartDP(iChan,5)=1;
%             elseif ii3(ii)>=36 && ii3(ii)<=40
%                 clusterStartDP(iChan,6)=1;
            end
        end
    end
    clear ii3
 
       
    SigClusterSizeDP(iChan)=max(ii2);
    else
        SigClusterSizeDP(iChan)=0;
    end
    clear ii2
end

iiDP=find(SigClusterSizeDP>=ClusterSize);

clusterStartRP=zeros(size(Spec_Chan_All_Aud,2),4);
clusterStartRP2=zeros(size(Spec_Chan_All_Aud,2),1);
for iChan=1:size(pvalsRPM,1);

    tmp=bwconncomp(sq(pvalsRPM(iChan,:)));
    if size(tmp.PixelIdxList,2)>0
    for ii=1:size(tmp.PixelIdxList,2);
        ii2(ii)=size(tmp.PixelIdxList{ii},1);
    end
    
    ii2B=find(ii2>=ClusterSize);
    if length(ii2B)>0
        for ii=1:length(ii2B);
            ii3(ii)=tmp.PixelIdxList{ii2B(ii)}(1);
            clusterStartRP2(iChan)=ii3(1);
            if ii3(ii)>=11 && ii3(ii)<=15
                clusterStartRP(iChan,1)=1;
            elseif ii3(ii)>=16 && ii3(ii)<=20
                clusterStartRP(iChan,2)=1;
            elseif ii3(ii)>=21 && ii3(ii)<=25
                clusterStartRP(iChan,3)=1;
            elseif ii3(ii)>=26 && ii3(ii)<=30
                clusterStartRP(iChan,4)=1;
%             elseif ii3(ii)>=31 && ii3(ii)<=35
%                 clusterStartRP(iChan,5)=1;
%             elseif ii3(ii)>=36 && ii3(ii)<=40
%                 clusterStartRP(iChan,6)=1;
            end
        end
    end
    clear ii3
    
    SigClusterSizeRP(iChan)=max(ii2);
    else
        SigClusterSizeRP(iChan)=0;
    end
    clear ii2
end

iiRP=find(SigClusterSizeRP>=ClusterSize);

% 
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

iiA=iiDA;
iiB=iiRA;
iiC=iiDP;
iiD=iiRP;

% % 706 total,

iiABCD=intersect(iiA,intersect(iiB,intersect(iiC,iiD))); % 47 SM ALL

iiABC=setdiff(intersect(iiA,intersect(iiB,iiC)),iiD); % 6 ALL S, DEC M
iiABD=setdiff(intersect(iiA,intersect(iiB,iiD)),iiC); % 14 ALL S, REP M
iiACD=setdiff(intersect(iiA,intersect(iiC,iiD)),iiB); % 19 DEC S, ALL M
iiBCD=setdiff(intersect(iiB,intersect(iiC,iiD)),iiA); % 20  REP S, ALL M

iiBC=setdiff(intersect(iiB,iiC),unique(cat(2,iiBCD,iiABC,iiABCD))); % 3 REP S, DEC M
iiAC=setdiff(intersect(iiA,iiC),unique(cat(2,iiACD,iiABC,iiABCD))); % 37 DEC S, DEC M
iiAD=setdiff(intersect(iiA,iiD),unique(cat(2,iiACD,iiABD,iiABCD))); % 5 DEC S, REP M
iiBD=setdiff(intersect(iiB,iiD),unique(cat(2,iiBCD,iiABD,iiABCD))); % 22 REP S, REP M
iiCD=setdiff(intersect(iiC,iiD),unique(cat(2,iiBCD,iiACD,iiABCD))); % 47 DEC M, REP M
iiAB=setdiff(intersect(iiA,iiB),unique(cat(2,iiABC,iiABD,iiABCD))); % 9 DEC S, REP S

iiA=setdiff(iiA,unique(cat(2,iiAB,iiAC,iiABC,iiABCD,iiACD,iiAD,iiABD))); % 33 JUST DEC S
iiB=setdiff(iiB,unique(cat(2,iiAB,iiBC,iiABC,iiBCD,iiABCD,iiBD,iiABD))); % 17 JUST REP S
iiC=setdiff(iiC,unique(cat(2,iiCD,iiBC,iiBCD,iiABC,iiABCD,iiAC,iiACD))); % 62 JUST DEC M
iiD=setdiff(iiD,unique(cat(2,iiCD,iiBCD,iiBD,iiABCD,iiABD,iiACD,iiAD))); % 33 JUST REP M


totalActiveElecsDA=cat(2,iiABCD,iiABC,iiABD,iiACD,iiAC,iiAD,iiAB,iiA); % 170 DEC S
totalActiveElecsDM=cat(2,iiABCD,iiABC,iiACD,iiBCD,iiBC,iiAC,iiCD,iiC); % 241 DEC M
totalActiveElecsRA=cat(2,iiABCD,iiABC,iiABD,iiBCD,iiBC,iiBD,iiAB,iiB); % 138 REP S
totalActiveElecsRP=cat(2,iiABCD,iiABD,iiACD,iiBCD,iiAD,iiBD,iiCD,iiD); % REP M
totalActiveElecsJustDA=cat(2,iiACD,iiAC,iiAD,iiA); % 94 JUST DEC S (NOT REP S, MOTOR IRRELEVANT)
totalActiveElecsJustRA=cat(2,iiBCD,iiBC,iiBD,iiB); % 62 JUST REP S (NOT DEC S, MOTOR IRRELEVANT)
totalActiveElecsRDA=cat(2,iiABCD,iiABC,iiABD,iiAB); % 76 BOTH REP S AND DEC S (MOTOR IRRELEVANT)

totalActiveElecs=cat(2,iiABCD,iiABC,iiABD,iiACD,iiBCD,iiBC,iiAC,iiAD,iiBD,iiCD,iiAB,iiA,iiB,iiC,iiD); % 374 TOTAL ACTIVE
totalActiveElecsA=cat(2,iiABCD,iiABC,iiABD,iiACD,iiBCD,iiBC,iiAC,iiAD,iiBD,iiAB,iiA,iiB); % 232 TOTAL IN S
totalActiveElecsM=cat(2,iiABCD,iiABC,iiABD,iiACD,iiBCD,iiBC,iiAC,iiAD,iiBD,iiCD,iiC,iiD); % 315 TOTAL IN M

save('G:\D_Data\misc\Pvals_AUD_PROD_HG_70120_Outlier8_TimePtsvsBaseExp_RespAlignedAligned_WrongRespExc_IndivBaseSub_D22andD23InclFixed_MoreTrialsCAR.mat','pvals*','ii*','Sig*');

