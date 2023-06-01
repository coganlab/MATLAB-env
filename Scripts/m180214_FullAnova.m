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

SN = 11;
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
AnalParams.dn=0.025;

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
    AnalParams.ReferenceChannels=[30];
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

load([DUKEDIR '/' Subject(SN).Name '/' Subject(SN).Day '/mat/Trials_HighLow.mat']);
Subject(SN).Trials=Trials;

CondParams.Conds=[1:4];
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

designMat=[1 1 0 0 1 1 0 0;1 1 1 1 0 0 0 0;1 0 1 0 1 0 1 0];


fRange=70:150;
%fRange=fRange.*2;
%tRange=21:30;
for tRange=1:size(Auditory_Spec{1}{1},2)
for iChan=1:length(AnalParams.Channel)
    F1=[];
    F2=[];
    F3=[];
    for iCond=1:8
          F1=cat(1,F1,designMat(1,iCond)*ones(size(Auditory_Spec{iCond}{iChan},1),1));
          F2=cat(1,F2,designMat(2,iCond)*ones(size(Auditory_Spec{iCond}{iChan},1),1));
          F3=cat(1,F3,designMat(3,iCond)*ones(size(Auditory_Spec{iCond}{iChan},1),1));
    end

    for iCond=1:8
        tNums(iCond)=size(Auditory_Spec{iCond}{iChan},1);
    end
    tNumsMin=min(tNums);
    F1=[];
    F2=[];
    F3=[];
    data=[];
    for iCond=1:8
        idx=shuffle(1:size(Auditory_Spec{iCond}{iChan},1));
        idx=idx(1:tNumsMin);
        tmp=sq(mean(Auditory_Spec{iCond}{iChan}(idx,tRange,fRange)./repmat(mean(mean(Auditory_Spec{iCond}{iChan}(idx,1:10,fRange),2),1),length(idx),length(tRange),1),3));
        data=cat(1,data,tmp);
        %data=cat(1,data,sq(mean(mean(Auditory_Spec{iCond}{iChan}(idx,tRange,fRange),2),3)));
        if iCond==1 || iCond==3
        F1=cat(1,F1,zeros(length(idx),1));
        elseif iCond==2 || iCond==4
        F1=cat(1,F1,ones(length(idx),1));
        end
        if iCond<=2
        F2=cat(1,F2,zeros(length(idx),1));
        elseif iCond>=3
        F2=cat(1,F2,ones(length(idx),1));
        end
        
        for iTrials=1:length(idx)
            trialNum=Auditory_Trials{iCond}(idx(iTrials)).Trial;
            trialNum2=TrialsHighLow.Trials(trialNum).StartCode;
            if trialNum2==1 || trialNum2 == 3 || trialNum2 == 5 || trialNum2 == 7
                F3t(iTrials)=0;
            elseif trialNum2==2 || trialNum2 == 4 || trialNum2 == 6 || trialNum2 == 8
                F3t(iTrials)=1;
            end
        end
        F3=cat(1,F3,F3t');
        
  % FS=cat(2,F1,F2,F3');
    end
    FS=cat(2,F1,F2,F3);
   [P T]=anovan(data,FS,'model','full','display','off');
   for iT=1:7;
       Tvals1(iT)=cell2num(T(iT+1,6));
   end
   Tvals(iChan,tRange,:)=Tvals1;
   Pvals(iChan,tRange,:)=P;
end
display(tRange)
end

% figure;plot(log(Pvals(:,1)));hold on;plot(log(.01*ones(1,120)),'r--');
% title('Lex');
% 
% figure;plot(log(Pvals(:,2)));hold on;plot(log(.01*ones(1,120)),'r--');
% title('Task');
% 
% figure;plot(log(Pvals(:,3)));hold on;plot(log(.01*ones(1,120)),'r--');
% title('Lex x Task');
% %[stats] = rm_anova2(data',subj,F1',F2',{'Lex','Task'});

% 1 = Lex
% 2 = Task
% 3 = Phono
% 4 = Lex x Task
% 5 = Lex x Phono
% 6 = Task x Phono
% 7 = Lex x Task x Phono
% figure;
% for iChan2=1:41
%     subplot(6,10,iChan2);
%     hold on;
%     plot(-log(sq(Pvals(iChan2,:,1))),'b');
%     hold on;
%     plot(-log(sq(Pvals(iChan2,:,2))),'g');
%     hold on;
%     plot(-log(sq(Pvals(iChan2,:,3))),'m');
%     hold on;
%     plot(-log(0.01*ones(size(Pvals,2),1)),'--r')
%     hold on;
%     plot(-log(0.05*ones(size(Pvals,2),1)),'--c')
%     axis('tight')
% end
% legend('Lex','Task','Phono')

% figure;
% for iChan2=1:41
%     subplot(6,10,iChan2);
%     hold on;
%     plot(sq(Tvals(iChan2,:,1)),'b');
%     hold on;
%     plot(sq(Tvals(iChan2,:,2)),'g');
%     hold on;
%     plot(sq(Tvals(iChan2,:,3)),'m');
%    
%     axis('tight')
% end
% legend('Lex','Task','Phono')

% figure;
% for iChan2=1:41
%     subplot(6,10,iChan2);
%     hold on;
%     plot(sq(Tvals(iChan2,:,4)),'b');
%     hold on;
%     plot(sq(Tvals(iChan2,:,5)),'g');
%     hold on;
%     plot(sq(Tvals(iChan2,:,6)),'m');
%     hold on;
%     plot(sq(Tvals(iChan2,:,7)),'k');
%    
%     axis('tight')
% end
% legend('Lex x Task','Lex x Phono','Task x Phono','Lex x Task x Phono')
% 


% figure;
% for iChan2=1:41
%     subplot(6,10,iChan2);
%     hold on;
%     plot(-log(sq(Pvals(iChan2,:,4))),'b');
%     hold on;
%     plot(-log(sq(Pvals(iChan2,:,5))),'g');
%     hold on;
%     plot(-log(sq(Pvals(iChan2,:,6))),'m');
%     hold on;
%     plot(-log(sq(Pvals(iChan2,:,7))),'k');
%     hold on;
%     plot(-log(0.01*ones(size(Pvals,2),1)),'--r')
%     hold on;
%     plot(-log(0.05*ones(size(Pvals,2),1)),'--c')
%     axis('tight')
% end
% legend('Lex x Task','Lex x Phono','Task x Phono','Lex x Task x Phono')
% 

chanOffIDX(1)=0;
chanOffIDX(2)=50;
cutoff=0.01;
%tvals=linspace(CondParams.bn(1),CondParams.bn(2),size(Tvals,2));
tvals=1:size(Auditory_Spec{1}{1},2);
for iG=1:2
    if iG==1
        chanOff=chanOffIDX(1);
    elseif iG==2
        chanOff=chanOffIDX(2);
    end
figure;
for iChan=1:60
    iChan2=iChan+chanOff;
    subplot(6,10,iChan);
  
    plot(tvals,smooth(sq(Tvals(iChan2,:,1)),3),'b');
    ii=find(sq(Pvals(iChan2,:,1))<=cutoff);
    hold on;
    scatter(tvals(ii),0.01*ones(length(ii),1),'filled','bs','LineWidth',3);
    clear ii
    
    hold on;
    plot(tvals,smooth(sq(Tvals(iChan2,:,2)),3),'g');
    ii=find(sq(Pvals(iChan2,:,2))<=cutoff);
    hold on;
    scatter(tvals(ii),0.5*ones(length(ii),1),'filled','gs','LineWidth',3);
    clear ii
     
    hold on;
    plot(tvals,smooth(sq(Tvals(iChan2,:,3)),3),'m');
    ii=find(sq(Pvals(iChan2,:,3))<=cutoff);
    hold on;
    scatter(tvals(ii),1*ones(length(ii),1),'filled','ms','LineWidth',3);
    clear ii

    ylim([0 8])
    title([experiment.channels(iChan2).name])
end
legend('Lex','','Task','','Phono')
end


cutoff=0.05;

for iG=1:2
    if iG==1
        chanOff=chanOffIDX(1);
    elseif iG==2
        chanOff=chanOffIDX(2);
    end
    
    figure;
for iChan=1:60
    iChan2=iChan+chanOff;
    subplot(6,10,iChan);
  
    plot(tvals,smooth(sq(Tvals(iChan2,:,4)),3),'b');
    ii=find(sq(Pvals(iChan2,:,4))<=cutoff);
    hold on;
    scatter(tvals(ii),0.01*ones(length(ii),1),'filled','bs','LineWidth',3);
    clear ii
    
    hold on;
    plot(tvals,smooth(sq(Tvals(iChan2,:,5)),3),'g');
    ii=find(sq(Pvals(iChan2,:,5))<=cutoff);
    hold on;
    scatter(tvals(ii),0.5*ones(length(ii),1),'filled','gs','LineWidth',3);
    clear ii
     
    hold on;
    plot(tvals,smooth(sq(Tvals(iChan2,:,6)),3),'m');
    ii=find(sq(Pvals(iChan2,:,6))<=cutoff);
    hold on;
    scatter(tvals(ii),1*ones(length(ii),1),'filled','ms','LineWidth',3);
    clear ii
    
    hold on;
    plot(tvals,smooth(sq(Tvals(iChan2,:,7)),3),'k');
    ii=find(sq(Pvals(iChan2,:,7))<=cutoff);
    hold on;
    scatter(tvals(ii),1.5*ones(length(ii),1),'filled','ks','LineWidth',3);
    clear ii

    ylim([0 8])
    title([experiment.channels(iChan2).name])
end

legend('Lex x Task','','Lex x Phono','','Task x Phono','','Lex x Task x Phono')
end



cutoff=0.01;
%tvals=linspace(CondParams.bn(1),CondParams.bn(2),size(Tvals,2));
tvals=1:40;
chanOff=0;
figure;
for iChan=1:length(AnalParams.Channel)
    iChan2=iChan+chanOff;
    subplot(6,10,iChan);
  
    plot(tvals,smooth(sq(Tvals(iChan2,:,1)),3),'b');
    ii=find(sq(Pvals(iChan2,:,1))<=cutoff);
    hold on;
    scatter(tvals(ii),0.01*ones(length(ii),1),'filled','bs','LineWidth',3);
    clear ii
    
    hold on;
    plot(tvals,smooth(sq(Tvals(iChan2,:,2)),3),'g');
    ii=find(sq(Pvals(iChan2,:,2))<=cutoff);
    hold on;
    scatter(tvals(ii),0.5*ones(length(ii),1),'filled','gs','LineWidth',3);
    clear ii
     
    hold on;
    plot(tvals,smooth(sq(Tvals(iChan2,:,3)),3),'m');
    ii=find(sq(Pvals(iChan2,:,3))<=cutoff);
    hold on;
    scatter(tvals(ii),1*ones(length(ii),1),'filled','ms','LineWidth',3);
    clear ii

    ylim([0 8])
    title([experiment.channels(iChan2).name])
end
legend('Lex','','Task','','Phono')



cutoff=0.05;


    
    figure;
for iChan=1:length(AnalParams.Channel)
    iChan2=iChan+chanOff;
    subplot(6,10,iChan);
  
    plot(tvals,smooth(sq(Tvals(iChan2,:,4)),3),'b');
    ii=find(sq(Pvals(iChan2,:,4))<=cutoff);
    hold on;
    scatter(tvals(ii),0.01*ones(length(ii),1),'filled','bs','LineWidth',3);
    clear ii
    
    hold on;
    plot(tvals,smooth(sq(Tvals(iChan2,:,5)),3),'g');
    ii=find(sq(Pvals(iChan2,:,5))<=cutoff);
    hold on;
    scatter(tvals(ii),0.5*ones(length(ii),1),'filled','gs','LineWidth',3);
    clear ii
     
    hold on;
    plot(tvals,smooth(sq(Tvals(iChan2,:,6)),3),'m');
    ii=find(sq(Pvals(iChan2,:,6))<=cutoff);
    hold on;
    scatter(tvals(ii),1*ones(length(ii),1),'filled','ms','LineWidth',3);
    clear ii
    
    hold on;
    plot(tvals,smooth(sq(Tvals(iChan2,:,7)),3),'k');
    ii=find(sq(Pvals(iChan2,:,7))<=cutoff);
    hold on;
    scatter(tvals(ii),1*ones(length(ii),1),'filled','ks','LineWidth',3);
    clear ii

    ylim([0 8])
    title([experiment.channels(iChan2).name])
end

legend('Lex x Task','','Lex x Phono','','Task x Phono','','Lex x Task x Phono')



% threshval=4;
% for iChan=1:size(Pvals,1)
%     for iA=1:3
%         NumSig(iChan,iA)=length(find(sq(Pvals(iChan,11:end,iA))<0.01));
%         if NumSig(iChan,iA)>threshval
%             ActSig(iChan,iA)=1;
%         else
%             ActSig(iChan,iA)=0;
%         end
%     end
% end
% 
% PvalsT=ones(120,4,4,40);
% fRange=70:120;
% %tRange=21:30;
% for tRange=1:40
%     for iChan=1:120
%         for iCond=1:4
%             tNums(iCond)=size(Auditory_Spec{iCond}{iChan},1);
%         end
%         tNumsMin=min(tNums);
%         F1=[];
%         F2=[];
%         data=[];
%         for iCond=1:4
%             for iCond2=iCond+1:4
%                 idx=shuffle(1:size(Auditory_Spec{iCond}{iChan},1));
%                 idx=idx(1:tNumsMin);
%                 tmp=sq(mean(Auditory_Spec{iCond}{iChan}(idx,tRange,fRange)./repmat(mean(mean(Auditory_Spec{iCond}{iChan}(idx,1:10,fRange),2),1),length(idx),length(tRange),1),3));
%                 data1=tmp;
%                 
%                 idx=shuffle(1:size(Auditory_Spec{iCond2}{iChan},1));
%                 idx=idx(1:tNumsMin);
%                 tmp=sq(mean(Auditory_Spec{iCond2}{iChan}(idx,tRange,fRange)./repmat(mean(mean(Auditory_Spec{iCond2}{iChan}(idx,1:10,fRange),2),1),length(idx),length(tRange),1),3));
%                 data2=tmp;
%                 %data=cat(1,data,sq(mean(mean(Auditory_Spec{iCond}{iChan}(idx,tRange,fRange),2),3)));
%                 [H P]=ttest(data1,data2);
%                 PvalsT(iChan,iCond,iCond2,tRange)=P;
%             end
%         end
%         
%         
%         
%     end
% end
% 
% 
% for iG=1:2
%     if iG==1
%         chanOff=0;
%     elseif iG==2
%         chanOff=60;
%     end
% figure;
% for iChan=1:60
%     iChan2=iChan+chanOff;
%     subplot(6,10,iChan);
%     plot(-log(sq(PvalsT(iChan2,1,2,:))),'b');
%     hold on;
%     plot(-log(sq(PvalsT(iChan2,1,3,:))),'g');
%     hold on;
%    % plot(-log(sq(PvalsT(iChan2,1,4,:))),'m');
%    % hold on;
%    % plot(-log(sq(PvalsT(iChan2,2,3,:))),'color',[1 1 51/255]);
%    % hold on;
%     plot(-log(sq(PvalsT(iChan2,2,4,:))),'color',[75/255 0 30/255]);
%     hold on;
%     plot(-log(sq(PvalsT(iChan2,3,4,:))),'color',[1 192/255 203/255]);
%     hold on;
%     plot(-log(0.01*ones(size(Pvals,2),1)),'--r')
%     hold on;
%     plot(-log(0.05*ones(size(Pvals,2),1)),'--c')
%     axis('tight')
% end
% %legend('WD vs NWD','WD vs WR','WD vs NWR','NWD vs WR','NWD vs NWR','WR vs NWR')
% legend('WD vs NWD','WD vs WR','NWD vs NWR','WR vs NWR')
% 
% end


        