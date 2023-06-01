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
Subject(13).Name = 'D16'; Subject(13).Day = '200118';

SN = 9;
Subject(SN).Experiment = loadExperiment(Subject(SN).Name);
Subject(SN).Trials = dbTrials(Subject(SN).Name,Subject(SN).Day,'Speech_OvertMimeMove');
%Subject(SN).Trials = dbTrials(Subject(SN).Name,Subject(SN).Day,'Speech_CovertOvert'); % Test line
Trials = Subject(SN).Trials;
experiment = Subject(SN).Experiment;

%CondParams.Conds = [1:4];



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
    %AnalParams.ReferenceChannels=[30];
elseif strcmp(Subject(SN).Name,'D13')
    AnalParams.Channel = [1:120];
 %   AnalParams.ReferenceChannels=[18:20];
 elseif strcmp(Subject(SN).Name,'D14')
    AnalParams.Channel = [1:120];
 elseif strcmp(Subject(SN).Name,'D15')
    AnalParams.Channel = [1:120];
elseif strcmp(Subject(SN).Name,'D16')
    AnalParams.Channel = [1:41];
else
    AnalParams.Channel = [1:64];
end
CondParams.Conds=1:4;
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

%legend('HW D','LW D','HNW D','LNW D','HW R','LW R','HNW R','LNW R');

fRange=70:150;
%fRange=fRange.*2;
%tRange=21:30;
% words within decision vs nonwords, words within rep vs nonwords
for tRange=1:size(Auditory_Spec{1}{1},2)
    for iChan=1:length(AnalParams.Channel)
        counter=0;
        for iCond1=1:4
            % word vs nonwords within each task
           % iCondIDX=1:2:8; % word vs nonword
           % high vs low in each
            iCondIDX=[1,3,2,4,5,7,6,8]; % high vs low
            iCond=iCondIDX(iCond1);
           
          
            WNW_Within{counter+1}=cat(1,Auditory_Spec{iCond}{iChan},Auditory_Spec{iCond+1}{iChan});
            tNums(counter+1)=size(WNW_Within{counter+1},1);
            counter=counter+1;
        end
        tNumsMin=min(tNums);
        
        data=[];
        for iCond=1:2
            
            iCond2=2*iCond-1;
            idx=shuffle(1:size(WNW_Within{iCond2},1));
            idx=idx(1:tNumsMin);
            tmp1=sq(mean(WNW_Within{iCond2}(idx,tRange,fRange)./repmat(mean(WNW_Within{iCond2}(idx,1:10,fRange),2),1,length(tRange),1),3));
            idx=shuffle(1:size(WNW_Within{iCond2+1},1));
            idx=idx(1:tNumsMin);
            tmp2=sq(mean(WNW_Within{iCond2+1}(idx,tRange,fRange)./repmat(mean(WNW_Within{iCond2+1}(idx,1:10,fRange),2),1,length(tRange),1),3));
            
        
            
        %    [H P CI STATS]=ttest(tmp1,tmp2);
            [P H STATS]=ranksum(tmp1,tmp2);
          %  Tvals(iChan,tRange,iCond,:)=STATS.tstat;
            Tvals(iChan,tRange,iCond,:)=STATS.zval;
            Pvals(iChan,tRange,iCond,:)=P;
        end
       
    end
     display(tRange)
end

tscale=1:size(Auditory_Spec{1}{1},2);
cutoff=0.05;
for iG=1:2
    if iG==1
        chanOff=0;
    elseif iG==2
        chanOff=60;
    end
    figure
    for iChan=1:60
        iChan2=iChan+chanOff;
        subplot(6,10,iChan);
        plot(tscale,smooth(sq(Tvals(iChan2,:,1)),3));
        ii=find(sq(Pvals(iChan2,:,1))<=cutoff);
       % ii=find(sq(Pvals(iChan2,:,1))>=1-cutoff);

        hold on;
        scatter(tscale(ii),0.1*ones(length(ii),1),'filled','bs','LineWidth',3);
        clear ii
        
        hold on;
        plot(tscale,smooth(sq(Tvals(iChan2,:,2)),3),'r');
        ii=find(sq(Pvals(iChan2,:,2))<=cutoff);
       % ii=find(sq(Pvals(iChan2,:,1))>=1-cutoff);

        hold on;
        scatter(tscale(ii),1*ones(length(ii),1),'filled','rs','LineWidth',3);
        clear ii
        title([experiment.channels(iChan2).name])
    end
   legend('','H vs L D', '', 'H vs L R');
 %   legend('','W vs NW D','','W vs NW R')
end