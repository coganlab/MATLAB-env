% collapsed across all conditions
 duke;
global experiment
Subject = struct([]);

Subject(1).Name = 'D1'; Subject(1).Day = '260216'; % 160216 is clin 1, 160217 is clin 2
Subject(3).Name = 'D3'; Subject(3).Day = '100916';
Subject(7).Name = 'D7'; Subject(7).Day = '030117';
Subject(8).Name = 'D8'; Subject(8).Day = '030317';
Subject(9).Name = 'D13'; Subject(9).Day = '071017';
Subject(10).Name = 'D14'; Subject(10).Day = '101117';
Subject(11).Name= 'D15'; Subject(11).Day = '171217';
SN = 9;
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
    AnalParams.ReferenceChannels=[30];
elseif strcmp(Subject(SN).Name,'D15')
    AnalParams.Channel = [1:120];
 %   AnalParams.ReferenceChannels=[18:20];
 elseif strcmp(Subject(SN).Name,'D14')
    AnalParams.Channel = [1:120];
 elseif strcmp(Subject(SN).Name,'D13')
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

% CondParams.Conds=[1:1];
% CondParams.Field = 'Go';
% CondParams.bn = [-500,2000];
% for iCode = 1:length(Auditory_Spec)
%     if isfield(CondParams,'Conds2')
%         CondParams.Conds = CondParams.Conds2(iCode);
%     else
%         CondParams.Conds = iCode;
%     end
%     tic
%     [Motor_Spec{iCode}, Motor_Data, Motor_Trials{iCode}] = subjSpectrum(Subject(SN), CondParams, AnalParams);
%     toc
%     display(['Cond = ' num2str(iCode)])
% end
%

% combine all for initial significance:
Auditory_Spec_All=[];
for iChan=1:length(AnalParams.Channel);
    data=[];
    for iCond=1:4;
        tmp=Auditory_Spec{iCond}{iChan};
        data=cat(1,data,tmp);
    end
    Auditory_Spec_All{iChan}=data;
end

hg=[70:150];
% hg=[70:90];
beta=15:20;
lg=[30:50];
fre=hg;
tWin=[21:30];

for chan=1:length(AnalParams.Channel)
    for tWin=1:size(Auditory_Spec_All{1}{1},2)
        tempy=Auditory_Spec_All{chan};
        tempybase=sq(mean(mean(tempy(:,1:10,fre),3),2));
        tempycompAUD=sq(mean(tempy(:,tWin,fre),3)); % 16-25 for aud, 71:80 for prod, 36:45 for delay?
        % tempy2AUD=log10(cat(1,tempybase,tempycompAUD));
        % actualvalAUD(chan)=(sum(log10(tempycompAUD))./length(tempycompAUD))-(sum(log10(tempybase))./length(tempybase));  % replace mean with sum
        tempy2AUD=cat(1,tempybase,tempycompAUD);
        actualvalAUD(chan,tWin)=mean(tempycompAUD)-mean(tempybase);
        nPerm = 1e4;
        permVarAUD = zeros(1,nPerm);
        parfor iPerm=1:nPerm % parfor
            randyAUD=randperm(length(tempy2AUD));
            permVarAUD(iPerm)=mean(tempy2AUD(randyAUD(1:length(tempycompAUD))))-mean(tempy2AUD(randyAUD(length(tempycompAUD)+1:end)));
            % permVarAUD(iPerm) = sum(tempy2AUD(randyAUD(1:length(tempybase))))./length(tempybase)-sum(tempy2AUD(randyAUD((length(tempybase)+1):length(tempy2AUD))))./length(tempybase);        end
        end
        compvalAUD(chan,tWin,:) = permVarAUD;
        
    end
    display(chan)
end
  


for iChan=1:length(actualvalAUD)
    for tWin=1:size(Auditory_Spec_All{1}{1},2)
    pvalsAUD(iChan,tWin)=length(find(sq(actualvalAUD(iChan,tWin))<sq(compvalAUD(iChan,tWin,:))))./nPerm;
  %  pvalsPROD(iChan)=length(find(actualvalPROD(iChan)<sq(compvalPROD(:,iChan,:))))./nPerm;
    end
end

    
 display(find(pvalsAUD<0.01))
 
 
 
 
 Auditory_Spec_Lex=[];
for iChan=1:length(AnalParams.Channel)
        tmp1=Auditory_Spec{1}{iChan};
        tmp2=Auditory_Spec{2}{iChan};
        tmp3=Auditory_Spec{3}{iChan};
        tmp4=Auditory_Spec{4}{iChan};
        
        tmp1=tmp1./repmat(mean(tmp1(:,1:10,:),2),1,size(tmp1,2),1);
        tmp2=tmp2./repmat(mean(tmp2(:,1:10,:),2),1,size(tmp2,2),1);
        tmp3=tmp3./repmat(mean(tmp3(:,1:10,:),2),1,size(tmp3,2),1);
        tmp4=tmp4./repmat(mean(tmp4(:,1:10,:),2),1,size(tmp4,2),1);
%         tmp1=tmp1./repmat(mean(tmp1(:,1:10,:),2),1,size(tmp1,2),1); % divide by baseline to account for block effects
%         tmp2=tmp2./repmat(mean(tmp2(:,1:10,:),2),1,size(tmp2,2),1); % divide by baseline to account for block effects
%         tmp3=tmp3./repmat(mean(tmp3(:,1:10,:),2),1,size(tmp3,2),1); % divide by baseline to account for block effects
%         tmp4=tmp4./repmat(mean(tmp4(:,1:10,:),2),1,size(tmp4,2),1); % divide by baseline to account for block effects

        data1=cat(1,tmp1,tmp3);
        data2=cat(1,tmp2,tmp4);

    Auditory_Spec_Lex{iChan}{1}=data1;
    Auditory_Spec_Lex{iChan}{2}=data2;
end

hg=[70:150];
% hg=[70:90];
beta=15:20;
lg=[30:50];
fre=hg;

for chan=1:length(AnalParams.Channel)
    for tWin=1:size(Auditory_Spec_Lex{1}{1},2)
        tempy1=Auditory_Spec_Lex{chan}{1};
        tempy2=Auditory_Spec_Lex{chan}{2};
        tempybase=sq(mean(tempy2(:,tWin,fre),3));
        tempycompAUD=sq(mean(tempy1(:,tWin,fre),3)); % 16-25 for aud, 71:80 for prod, 36:45 for delay?
        % tempy2AUD=log10(cat(1,tempybase,tempycompAUD));
        % actualvalAUD(chan)=(sum(log10(tempycompAUD))./length(tempycompAUD))-(sum(log10(tempybase))./length(tempybase));  % replace mean with sum
        tempy2AUD=cat(1,tempybase,tempycompAUD);
        actualvalAUD(chan,tWin)=mean(tempycompAUD)-mean(tempybase);
        nPerm = 1e4;
        permVarAUD = zeros(1,nPerm);
        for iPerm=1:nPerm % parfor
            randyAUD=randperm(length(tempy2AUD));
            permVarAUD(iPerm)=mean(tempy2AUD(randyAUD(1:length(tempycompAUD))))-mean(tempy2AUD(randyAUD(length(tempycompAUD)+1:end)));
            % permVarAUD(iPerm) = sum(tempy2AUD(randyAUD(1:length(tempybase))))./length(tempybase)-sum(tempy2AUD(randyAUD((length(tempybase)+1):length(tempy2AUD))))./length(tempybase);
        end
        compvalAUD(chan,tWin,:) = permVarAUD;
    end
    display(chan)
end



for iChan=1:length(actualvalAUD)
    for tWin=1:size(Auditory_Spec_Lex{1}{1},2)
    pvalsLex(iChan,tWin)=length(find(actualvalAUD(iChan,tWin)<sq(compvalAUD(iChan,tWin,:))))./nPerm; % lower p = higher for words
  %  pvalsPROD(iChan)=length(find(actualvalPROD(iChan)<sq(compvalPROD(:,iChan,:))))./nPerm;
    end
end

    

    
    
 Auditory_Spec_Task=[];
for iChan=1:length(AnalParams.Channel);
        tmp1=Auditory_Spec{1}{iChan};
        tmp2=Auditory_Spec{2}{iChan};
        tmp3=Auditory_Spec{3}{iChan};
        tmp4=Auditory_Spec{4}{iChan};
        tmp1=tmp1./repmat(mean(tmp1(:,1:10,:),2),1,size(tmp1,2),1);
        tmp2=tmp2./repmat(mean(tmp2(:,1:10,:),2),1,size(tmp2,2),1);
        tmp3=tmp3./repmat(mean(tmp3(:,1:10,:),2),1,size(tmp3,2),1);
        tmp4=tmp4./repmat(mean(tmp4(:,1:10,:),2),1,size(tmp4,2),1);        
%         tmp1=tmp1./repmat(mean(tmp1(:,1:10,:),2),1,size(tmp1,2),1); % divide by baseline to account for block effects
%         tmp2=tmp2./repmat(mean(tmp2(:,1:10,:),2),1,size(tmp2,2),1); % divide by baseline to account for block effects
%         tmp3=tmp3./repmat(mean(tmp3(:,1:10,:),2),1,size(tmp3,2),1); % divide by baseline to account for block effects
%         tmp4=tmp4./repmat(mean(tmp4(:,1:10,:),2),1,size(tmp4,2),1); % divide by baseline to account for block effects

        data1=cat(1,tmp1,tmp2);
        data2=cat(1,tmp3,tmp4);

    Auditory_Spec_Task{iChan}{1}=data1;
    Auditory_Spec_Task{iChan}{2}=data2;
end

hg=[70:150];
% hg=[70:90];
beta=15:20;
lg=[30:50];
fre=hg;

    for chan=1:length(AnalParams.Channel)
        for tWin=1:size(Auditory_Spec_Task{1}{1},2)
        tempy1=Auditory_Spec_Task{chan}{1};
        tempy2=Auditory_Spec_Task{chan}{2};
        tempybase=sq(mean(tempy1(:,tWin,fre),3));
        tempycompAUD=sq(mean(tempy2(:,tWin,fre),3)); % 16-25 for aud, 71:80 for prod, 36:45 for delay?
   % tempy2AUD=log10(cat(1,tempybase,tempycompAUD));
       % actualvalAUD(chan)=(sum(log10(tempycompAUD))./length(tempycompAUD))-(sum(log10(tempybase))./length(tempybase));  % replace mean with sum
        tempy2AUD=cat(1,tempybase,tempycompAUD);
        actualvalAUD(chan,tWin)=mean(tempycompAUD)-mean(tempybase);
        nPerm = 1e4;
        permVarAUD = zeros(1,nPerm);
        for iPerm=1:nPerm % parfor
            randyAUD=randperm(length(tempy2AUD));      
            permVarAUD(iPerm)=mean(tempy2AUD(randyAUD(1:length(tempycompAUD))))-mean(tempy2AUD(randyAUD(length(tempycompAUD)+1:end)));
           % permVarAUD(iPerm) = sum(tempy2AUD(randyAUD(1:length(tempybase))))./length(tempybase)-sum(tempy2AUD(randyAUD((length(tempybase)+1):length(tempy2AUD))))./length(tempybase);        end
        end
           compvalAUD(chan,tWin,:) = permVarAUD;
        end
        display(chan)
    end
  


for iChan=1:length(actualvalAUD)
     for tWin=1:size(Auditory_Spec_Task{1}{1},2)
    pvalsTask(iChan,tWin)=length(find(actualvalAUD(iChan,tWin)>sq(compvalAUD(iChan,tWin,:))))./nPerm; % lower p = higher for decision
  %  pvalsPROD(iChan)=length(find(actualvalPROD(iChan)<sq(compvalPROD(:,iChan,:))))./nPerm;
     end
end

    
 display(find(pvalsTask<0.01))
     

ii=find(pvalsAUD<0.05)