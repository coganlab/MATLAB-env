duke;
Subject(1).Name='D13';Subject(1).Day = '071017';
Subject(2).Name='D14';Subject(2).Day = '101117';
Subject(3).Name='D15';Subject(3).Day = '171217';
Subject(4).Name='D16';Subject(4).Day ='200118';


counterChan=0;
Tvals_All=[];
Chanloc_All=[];
Chanloc_Subject=[];
Pvals_All=[];
for SN=1:length(Subject)
    
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
    AnalParams.Reference = 'Single-ended'; %'Grand average'; % other is 'Single-ended';
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
    
    
    
    
%     load([DUKEDIR '/' Subject(SN).Name '/' Subject(SN).Day '/mat/Trials_HighLow.mat']);
%     Subject(SN).Trials=Trials;
%     
%     CondParams.Conds=[1:8];
%     CondParams.Field = 'Auditory';
%     CondParams.bn = [-500,1500];
%     for iCode = 1:length(CondParams.Conds)
%         
%         if isfield(CondParams,'Conds2')
%             CondParams.Conds = CondParams.Conds2(iCode);
%         else
%             CondParams.Conds = iCode;
%         end
%         tic
%         [Auditory_Spec{iCode}, Auditory_Data, Auditory_Trials{iCode}] = subjSpectrum(Subject(SN), CondParams, AnalParams);
%         toc
%         display(['Cond = ' num2str(iCode)])
%     end
%     
%     for iChan=1:length(AnalParams.Channel);
%         iChan2=counterChan+iChan;
%         for iCond=1:8;
%             tmp=Auditory_Spec{iCond}{iChan};
%             tmp=tmp./repmat(mean(tmp(:,1:10,:),2),1,size(tmp,2),1);
%             tmp=sq(mean(tmp(:,:,70:120),3));
%             
%             Auditory_Spec_All{iChan2}{iCond}=tmp;
%         end
%         
%     end
    counterChan=counterChan+length(AnalParams.Channel);
    
    
    load([DUKEDIR '/' Subject(SN).Name '/' Subject(SN).Name '_Regression.mat']);
    load([DUKEDIR '/' Subject(SN).Name '/chanloc.mat'])
    Tvals_All=cat(1,Tvals_All,Tvals);
    Pvals_All=cat(1,Pvals_All,Pvals);
    Chanloc_All=cat(2,Chanloc_All,chanloc);
    Chanloc_Subject=cat(1,Chanloc_Subject,SN*ones(size(chanloc,2),1));
   
end
       
       cutoff=2;
       alpha=.05;
       for iChan=1:size(Pvals_All,1)
           
           [pfdr pmask]=fdr(Pvals_All(iChan,:),alpha);
           if sum(pmask)>=cutoff
               sig_elecs(iChan)=1;
           elseif sum(pmask)<cutoff
               sig_elecs(iChan)=0;
           end
       end
       
%        clear sig_elecs
%             cutoff=1;
%        alpha=.05;
%        for iChan=1:size(Pvals_All,1)
%            ii=length(find(Pvals_All(iChan,:)<alpha));
%          %  [pfdr pmask]=fdr(Pvals_All(iChan,:),alpha);
%            if ii>=4
%                sig_elecs(iChan)=1;
%            elseif ii<3
%                sig_elecs(iChan)=0;
%            end
%        end
       
       
     %  [s IDX]=sort(Chanloc_All);
       
       for iLoc=1:4;
           ii=find(Chanloc_All==iLoc);
           ii2=find(sig_elecs==1);
           iiAll=intersect(ii,ii2);
           AreaPlots(iLoc,:,:)=sq(mean(Tvals_All(iiAll,:,1:6)));
           for iPerm=1:1000
               shuffleIdx=shuffle(1:size(Tvals_All,1));
               AreaPlots_Shuffle(iPerm,iLoc,:,:)=sq(mean(Tvals_All(shuffleIdx(1:length(iiAll)),:,1:6)));
           end
       end
             
       for iLoc=1:4;
           for iModel=1:6;
               for iTime=1:40;
               [ii jj]=sort(sq(AreaPlots_Shuffle(:,iLoc,iTime,iModel)));
               AreaPlots_Upper(iLoc,iTime,iModel)=ii(end-25);
               AreaPlots_Lower(iLoc,iTime,iModel)=ii(25);
               end
           end
       end
       
       Areas={'temp','motor','parietal','frontal'};
       Models={'Lex','Task','Phono','Lex x Task','Lex x Phono','Task x Phono'};
       
        cvals=cat(1,[0 0.4470 0.7410],[0.8500 0.3250 0.0980],[0.9290 0.6940 0.1250],[0.4940 0.1840 0.5560],[34/255 139/255 34/255],[1 0 1],[1 192/255 203/255],[119/255 136/255 153/255]);
        
        counter=0;
        figure;
        for iA=1:4;
            for iM=1:6;
                subplot(4,6,counter+1);
                plot(sq(AreaPlots(iA,:,iM)),'color',cvals(iM,:));
                hold on;
                plot(sq(AreaPlots_Upper(iA,:,iM)),'--','color',cvals(iM,:));
                hold on;
                plot(sq(AreaPlots_Lower(iA,:,iM)),'--','color',cvals(iM,:));
                title([Areas{iA} ' & ' Models{iM}])
                counter=counter+1;
            end
        end
       
       
       
      
       
       
   
       ModelValsAll=[];
       Chanloc_All=[];
       
       for iSN=1:length(Subject)
           load([DUKEDIR '/' Subject(iSN).Name '/' Subject(iSN).Name '_RegressionModel.mat']);
           load([DUKEDIR '/' Subject(iSN).Name '/chanloc.mat'])
           
           Chanloc_All=cat(2,Chanloc_All,chanloc);
           ModelValsAll=cat(2,ModelValsAll,ModelVals);
       end

       
       for iChan=1:size(ModelValsAll,2)
           for iTime=1:40;
           TvalsLex(iChan,iTime)=ModelValsAll{iChan}{iTime}.Coefficients.tStat(2);
           TvalsTask(iChan,iTime)=ModelValsAll{iChan}{iTime}.Coefficients.tStat(3);
           TvalsPhono(iChan,iTime)=ModelValsAll{iChan}{iTime}.Coefficients.tStat(4);
           TvalsLexTask(iChan,iTime)=ModelValsAll{iChan}{iTime}.Coefficients.tStat(5);
           TvalsLexPhono(iChan,iTime)=ModelValsAll{iChan}{iTime}.Coefficients.tStat(6);
           TvalsTaskPhono(iChan,iTime)=ModelValsAll{iChan}{iTime}.Coefficients.tStat(7);
           
           PvalsLex(iChan,iTime)=ModelValsAll{iChan}{iTime}.Coefficients.pValue(2);
           PvalsTask(iChan,iTime)=ModelValsAll{iChan}{iTime}.Coefficients.pValue(3);
           PvalsPhono(iChan,iTime)=ModelValsAll{iChan}{iTime}.Coefficients.pValue(4);
           PvalsLexTask(iChan,iTime)=ModelValsAll{iChan}{iTime}.Coefficients.pValue(5);
           PvalsLexPhono(iChan,iTime)=ModelValsAll{iChan}{iTime}.Coefficients.pValue(6);
           PvalsTaskPhono(iChan,iTime)=ModelValsAll{iChan}{iTime}.Coefficients.pValue(7);
           end
           display(iChan)
       end
       
       sig_elecsLex=[];
       sig_elecsPhono=[];
       sig_elecsTask=[];
       sig_elecsLexTask=[];
       sig_elecsLexPhono=[];
       sig_elecs_TaskPhono=[];
      cutoff=2;
       alpha=.05;
       for iChan=1:size(PvalsLex,1)
           
           [pfdr pmask]=fdr(PvalsLex(iChan,:),alpha);
           if sum(pmask)>=cutoff
               sig_elecsLex(iChan)=1;
           elseif sum(pmask)<cutoff
               sig_elecsLex(iChan)=0;
           end
           
           [pfdr pmask]=fdr(PvalsTask(iChan,:),alpha);
           if sum(pmask)>=cutoff
               sig_elecsTask(iChan)=1;
           elseif sum(pmask)<cutoff
               sig_elecsTask(iChan)=0;
           end
           
            [pfdr pmask]=fdr(PvalsPhono(iChan,:),alpha);
           if sum(pmask)>=cutoff
               sig_elecsPhono(iChan)=1;
           elseif sum(pmask)<cutoff
               sig_elecsPhono(iChan)=0;
           end

       end  
       
       
       
       
       
       for iA=1:4;
           ii1=find(Chanloc_All==iA);
           iiL=find(sig_elecsLex==1);
           iiT=find(sig_elecsTask==1);
           iiP=find(sig_elecsPhono==1);
           AreaPlot(iA,1,:)=mean(TvalsLex(intersect(ii1,iiL),:),1);
           AreaPlot(iA,2,:)=mean(TvalsTask(intersect(ii1,iiT),:),1);
           AreaPlot(iA,3,:)=mean(TvalsPhono(intersect(ii1,iiP),:),1);
       end
           