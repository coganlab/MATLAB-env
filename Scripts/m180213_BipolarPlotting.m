% bipolar reference?
% collapsed across all conditions
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

SN = 12;
Subject(SN).Experiment = loadExperiment(Subject(SN).Name);
Subject(SN).Trials = dbTrials(Subject(SN).Name,Subject(SN).Day,'Speech_OvertMimeMove');
%Subject(SN).Trials = dbTrials(Subject(SN).Name,Subject(SN).Day,'Speech_CovertOvert'); % Test line
Trials = Subject(SN).Trials;
experiment = Subject(SN).Experiment;

CondParams.Conds = [1:4];



%CondParams.bn = [-2500,3500];
%AnalParams.Tapers = [0.5,10];
AnalParams.Tapers = [.5,10];
AnalParams.fk = 500;
AnalParams.Reference = 'Grand average'; %'Grand average'; % other is 'Single-ended';
AnalParams.ArtifactThreshold = 8;

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
else
    AnalParams.Channel = [1:64];
end
NumTrials = SelectChannels(Subject(SN).Trials, CondParams, AnalParams);
%NumTrials=repmat(270,1,66);
%SelectedChannels = AnalParams.Channel(find(NumTrials > (0.8*length(Trials)))); %STRICT?
% SelectedChannels = AnalParams.Channel(find(NumTrials > (0.65*length(Trials)))); %LESS STRICT?
SelectedChannels=AnalParams.Channel; % really loose: accounts for practice trial confound
%AnalParams.ReferenceChannels = SelectedChannels;
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



CondParams.Conds=[1:4];
CondParams.Field = 'Auditory';
CondParams.bn = [-500,1500];

ieeg=trialIEEG(Trials,AnalParams.Channel,CondParams.Field,[-750 2250]);

for iTrials=1:length(Trials)
    TrialsIdent(iTrials)=Trials(iTrials).StartCode;
    if Trials(iTrials).Noisy==1 || Trials(iTrials).NoResponse==1
        TrialsBad(iTrials)=1;
    else
        TrialsBad(iTrials)=0;
    end
end

TrialsBad2=find(TrialsBad==1);



for iChan=1:60
    iChan2=(2*iChan)-1;
    for iCode=1:4
        ii=find(TrialsIdent==iCode);
      %  ii=setdiff(ii,TrialsBad2);
        tmp1=sq(ieeg(ii,iChan2+1,:))-sq(ieeg(ii,iChan2,:));
     %   tmp2=sq(ieeg(ii,iChan2,:))-sq(ieeg(ii,iChan2+1,:));
        spec1 = tfspec(tmp1, [0.5 10], experiment.processing.ieeg.sample_rate, 0.05, [0 500], 2, [], 0, [], []);
       % spec2 = tfspec(tmp2, [0.5 10], experiment.processing.ieeg.sample_rate, 0.05, [0 500], 2, [], 0, [], []);

        Auditory_Spec_Bip{iChan}{iCode}=spec1;
     %   Auditory_Spec_Bip{iChan2+1}{iCode}=spec2;
    end
    display(iChan)
    %  Auditory_Spec_Bip{iCond}{iChan}=Auditory_Spec{iCond}{iChan2+1}-Auditory_Spec{iCond}{iChan2};
end



% each trial by average condition baseline
   for iChan=1:60
       for iCond=1:4
       % Auditory_Spec_BipN{iChan}{iCond}=Auditory_Spec_Bip{iChan}{iCond}./repmat(mean(Auditory_Spec_Bip{iChan}{iCond}(:,1:10,:),2),1,size(Auditory_Spec_Bip{iChan}{iCond},2),1);
        Auditory_Spec_BipN{iChan}{iCond}=Auditory_Spec_Bip{iChan}{iCond}./repmat(mean(mean(Auditory_Spec_Bip{iChan}{iCond}(:,1:10,:),1),2),size(Auditory_Spec_Bip{iChan}{iCond},1),size(Auditory_Spec_Bip{iChan}{iCond},2),1);

       end
   end
%  % average within cond
%     for iChan=1:60
%        for iCond=1:4
%         Auditory_Spec_BipN{iChan}{iCond}=Auditory_Spec_Bip{iChan}{iCond}./repmat(mean(mean(Auditory_Spec_Bip{iChan}{iCond}(:,1:10,:),1),2),size(Auditory_Spec_Bip{iChan}{iCond},1),size(Auditory_Spec_Bip{iChan}{iCond},2),1);
%        end
%    end
%    
%    
%    
%    
%  
%        figure;
%        for iChan=1:60
%            tmp=[];
%            subplot(6,10,iChan);
%            for iCond=1:4
%                tmp=cat(1,tmp,Auditory_Spec_BipN{iChan}{iCond});
%            end
%            %tvimage(sq(mean(tmp(:,:,1:200)))./repmat(sq(mean(mean(tmp(:,1:10,1:200))))',40,1));
%            tvimage(sq(mean(tmp(:,:,1:200),1)));
%            % tvimage(sq(mean(Auditory_Spec_BipN(iChan,:,:,1:200),2)));
%            caxis([0.7 1.5]);
%        end
%        
%        
% fvals=[70:150];
% figure;
% cvals=cat(1,[0 0.4470 0.7410],[0.8500 0.3250 0.0980],[0.9290 0.6940 0.1250],[0.4940 0.1840 0.5560]);
% for iChan=1:60
%     subplot(6,10,iChan)
%     for iCond=1:4
%         hold on;
% %         tmp=sq(mean(Auditory_Spec_Bip{iChan}{iCond}(:,:,fvals),3));
% %         baseline=sq(mean(mean(Auditory_Spec_Bip{iChan}{iCond}(:,1:10,fvals),2),3));
% %         tmp=tmp./repmat(baseline,1,size(tmp,2));
%         tmp=sq(mean(Auditory_Spec_BipN{iChan}{iCond}(:,:,fvals),3));
%       %  tmp2=sq(mean(Auditory_Spec_BipN{iChan}{iCond+2}(:,:,fvals),3));
%        % tmp=cat(1,tmp1,tmp2);
%         errorbar(mean(tmp),std(tmp,[],1)./sqrt(size(tmp,1)),'color',cvals(iCond,:));
%        % plot(sq(mean(Auditory_Spec_BipN(iChan,iCond,:,70:120),4)),'color',cvals(iCond,:));
%     end
%     axis('tight');
% end
%     legend('Words Decision','Nonwords Decision','Words Repetition','Nonwords Repetition');
% 
% 
% fvals=[70:150];
% 
% figure;
% cvals=cat(1,[0 0.4470 0.7410],[0.8500 0.3250 0.0980],[0.9290 0.6940 0.1250],[0.4940 0.1840 0.5560]);
% 
% 
% for iChan=1:60
%     subplot(6,10,iChan)
%     for iCond=1:2
%         hold on;
% %         tmp=sq(mean(Auditory_Spec_Bip{iChan}{iCond}(:,:,fvals),3));
% %         baseline=sq(mean(mean(Auditory_Spec_Bip{iChan}{iCond}(:,1:10,fvals),2),3));
% %         tmp=tmp./repmat(baseline,1,size(tmp,2));
%         tmp1=sq(mean(Auditory_Spec_BipN{iChan}{iCond}(:,:,fvals),3));
%         tmp2=sq(mean(Auditory_Spec_BipN{iChan}{iCond+2}(:,:,fvals),3));
%         tmp=cat(1,tmp1,tmp2);
%         errorbar(mean(tmp),std(tmp,[],1)./sqrt(size(tmp,1)),'color',cvals(iCond,:));
%        % plot(sq(mean(Auditory_Spec_BipN(iChan,iCond,:,70:120),4)),'color',cvals(iCond,:));
%     end
%     axis('tight');
% end
%     legend('Words','Nonwords');
%     
%     
%     
%     fvals=[70:150];
% 
% figure;
% cvals=cat(1,[0 0.4470 0.7410],[0.8500 0.3250 0.0980],[0.9290 0.6940 0.1250],[0.4940 0.1840 0.5560]);
% 
% 
% for iChan=1:60
%     subplot(6,10,iChan)
%     for iCond=1:2
%         hold on;
% %         tmp=sq(mean(Auditory_Spec_Bip{iChan}{iCond}(:,:,fvals),3));
% %         baseline=sq(mean(mean(Auditory_Spec_Bip{iChan}{iCond}(:,1:10,fvals),2),3));
% %         tmp=tmp./repmat(baseline,1,size(tmp,2));
%         tmp1=sq(mean(Auditory_Spec_BipN{iChan}{2*iCond-1}(:,:,fvals),3));
%         tmp2=sq(mean(Auditory_Spec_BipN{iChan}{2*iCond}(:,:,fvals),3));
%         tmp=cat(1,tmp1,tmp2);
%         errorbar(mean(tmp),std(tmp,[],1)./sqrt(size(tmp,1)),'color',cvals(iCond+2,:));
%        % plot(sq(mean(Auditory_Spec_BipN(iChan,iCond,:,70:120),4)),'color',cvals(iCond,:));
%     end
%     axis('tight');
% end
%     legend('Decision','Repetition');
%     
%     
    
    
    
    
    
    
    figure;
    fvals=[70:150];
cvals=cat(1,[0 0.4470 0.7410],[0.8500 0.3250 0.0980],[0.9290 0.6940 0.1250],[0.4940 0.1840 0.5560]);


for iChan=1:60
    subplot(6,10,iChan)
    for iCond=1:2
        hold on;
%         tmp=sq(mean(Auditory_Spec_Bip{iChan}{iCond}(:,:,fvals),3));
%         baseline=sq(mean(mean(Auditory_Spec_Bip{iChan}{iCond}(:,1:10,fvals),2),3));
%         tmp=tmp./repmat(baseline,1,size(tmp,2));
        tmp=sq(mean(Auditory_Spec_BipN{iChan}{iCond}(:,:,fvals),3));
       % tmp2=sq(mean(Auditory_Spec_BipN{iChan}{iCond+2}(:,:,fvals),3));
       % tmp=cat(1,tmp1,tmp2);
        errorbar(mean(tmp),std(tmp,[],1)./sqrt(size(tmp,1)),'color',cvals(iCond,:));
       % plot(sq(mean(Auditory_Spec_BipN(iChan,iCond,:,70:120),4)),'color',cvals(iCond,:));
    end
    axis('tight');
end
    legend('Words Decision','Nonwords Decision');
    
    
    
    fvals=[70:150];

figure;
cvals=cat(1,[0 0.4470 0.7410],[0.8500 0.3250 0.0980],[0.9290 0.6940 0.1250],[0.4940 0.1840 0.5560]);


for iChan=1:60
    subplot(6,10,iChan)
    for iCond=1:2
        hold on;
%         tmp=sq(mean(Auditory_Spec_Bip{iChan}{iCond}(:,:,fvals),3));
%         baseline=sq(mean(mean(Auditory_Spec_Bip{iChan}{iCond}(:,1:10,fvals),2),3));
%         tmp=tmp./repmat(baseline,1,size(tmp,2));
        tmp=sq(mean(Auditory_Spec_BipN{iChan}{iCond+2}(:,:,fvals),3));
      %  tmp2=sq(mean(Auditory_Spec_BipN{iChan}{2*iCond}(:,:,fvals),3));
       % tmp=cat(1,tmp1,tmp2);
        errorbar(mean(tmp),std(tmp,[],1)./sqrt(size(tmp,1)),'color',cvals(iCond+2,:));
       % plot(sq(mean(Auditory_Spec_BipN(iChan,iCond,:,70:120),4)),'color',cvals(iCond,:));
    end
    axis('tight');
end
    legend('Words Repetition','Nonwords Repetition');


