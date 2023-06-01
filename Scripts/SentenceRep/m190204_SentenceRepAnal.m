% Sentence Rep Anal 
% Subjects:
% D1,D3,D5,D6,D7,D8,D9,D11,D12,D13,D14,D15,D16,D17,D18,D20,D22,D23,D24,D26 % ALL
% D3,D5,D6,D7,D8,D9,D12,D13,D14,D15,D16,D17,D18,D20,D22,D23,D24,D26 % ALL with Recons
duke;
plot_subjs_on_average({'D3','D5','D6','D7','D8','D9','D12','D13','D14','D15','D16','D17','D18','D20','D22','D23','D24','D26','D27','D28','D29'}, [],[])

% D3 160910 1:52
% D5 161028
% D6 NA
% D7 170130
% D8 030317
% D9 170526
% D11 170809
% D12 170911
% D13 171009
% D14 171112
% D15 171216
% D16 180123
% D17 180310
% D18 180327
% D20 180519
% D22 180705
% D23 180715
% D24 181027
% D26 NO

duke;
global experiment
Subject = struct([]);


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


SNList=[3,5,7,8,9,11,12,13,14,15,16,17,18,20,22,23,24,26,27,28,29]; 
SNList=[27];

for iSN=1:length(SNList)
clear Auditory_Spec Motor_Spec
clear Auditory_nSpec Motor_nSpec
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
     %   badChans=[28,71];
     %   AnalParams.Channel=setdiff(AnalParams.Channel,badChans);
elseif strcmp(Subject(SN).Name,'D28');
        AnalParams.Channel=[1:108];         
elseif strcmp(Subject(SN).Name,'D29');
        AnalParams.Channel=[1:140];        
else
    AnalParams.Channel = [1:64];
end
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
AnalParams.ArtifactThreshold = 8; %8 %12;
AnalParams.Pad=1;
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
for iCode = 1:length(Auditory_Spec)
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
% %
% 
% CondParams.Conds=[1:18];
% CondParams.Field = 'Del';
% CondParams.bn = [-500,5000];
% for iCode = 1:length(Auditory_Spec)
%     if isfield(CondParams,'Conds2')
%         CondParams.Conds = CondParams.Conds2(iCode);
%     else
%         CondParams.Conds = iCode;
%     end
%     tic
%     [Del_Spec{iCode}, Del_Data, Del_Trials{iCode}] = subjSpectrum(Subject(SN), CondParams, AnalParams);
%     toc
%     display(['Cond = ' num2str(iCode)])
% end


%Clear Auditory_nSpec Motor_nSpec
base=0;
%base = zeros(1,size(Auditory_Spec{iCode}{iCh},2));
for iCh = 1:length(Auditory_Spec{iCode})
    base=0;
    for iCode = 1:length(Auditory_Spec)
        %base = base + sq(Auditory_Spec{iCode}{iCh}(5,:)); % standard
        base= base+mean(sq(Auditory_Spec{iCode}{iCh}(1:10,:)),1); % used to be 1:9
        
        %base2(iCode,:)=std(sq(Auditory_Spec{iCode}{iCh}(1:6,:)),1); % std across time bins?       
        
    end
    base = base./length(Auditory_Spec);
    for iCode = 1:length(Auditory_Spec)
        Auditory_nSpec(iCode,iCh,:,:) = Auditory_Spec{iCode}{iCh}(:,:)./base(ones(1,size(Auditory_Spec{iCode}{iCh},1)),:);
        Motor_nSpec(iCode,iCh,:,:) = Motor_Spec{iCode}{iCh}(:,:)./base(ones(1,size(Motor_Spec{iCode}{iCh},1)),:);
      %  Start_nSpec(iCode,iCh,:,:) = Start_Spec{iCode}{iCh}(:,:)./base(ones(1,size(Start_Spec{iCode}{iCh},1)),:);
       % Del_nSpec(iCode,iCh,:,:) = Del_Spec{iCode}{iCh}(:,:)./base(ones(1,size(Del_Spec{iCode}{iCh},1)),:);
        %Auditory_nSpec(iCode,iCh,:,:)=(sq(Auditory_Spec{iCode}{iCh}(:,:))-base2)./(repmat(base,80,1)); % SD LINE
        
    end
    
end

plotSpecsSave(Auditory_nSpec,1:4,1:200,[0.7 1.5],1,'G:\Scripts\SentenceRep\Plots\',[Subject(SN).Name '-LS-AUD'],experiment)
plotSpecsSave(Auditory_nSpec,5:7,1:200,[0.7 1.5],1,'G:\Scripts\SentenceRep\Plots\',[Subject(SN).Name '-LSS-AUD'],experiment)
plotSpecsSave(Auditory_nSpec,9:11,1:200,[0.7 1.5],1,'G:\Scripts\SentenceRep\Plots\',[Subject(SN).Name '-JL-AUD'],experiment)
plotSpecsSave(Auditory_nSpec,12:14,1:200,[0.7 1.5],1,'G:\Scripts\SentenceRep\Plots\',[Subject(SN).Name '-JLS-AUD'],experiment)
plotSpecsSave(Auditory_nSpec,15:18,1:200,[0.7 1.5],1,'G:\Scripts\SentenceRep\Plots\',[Subject(SN).Name '-LM-AUD'],experiment)

plotSpecsSave(Motor_nSpec,1:4,1:200,[0.7 1.5],1,'G:\Scripts\SentenceRep\Plots\',[Subject(SN).Name '-LS-PROD'],experiment)
plotSpecsSave(Motor_nSpec,5:7,1:200,[0.7 1.5],1,'G:\Scripts\SentenceRep\Plots\',[Subject(SN).Name '-LSS-PROD'],experiment)
plotSpecsSave(Motor_nSpec,9:11,1:200,[0.7 1.5],1,'G:\Scripts\SentenceRep\Plots\',[Subject(SN).Name '-JL-PROD'],experiment)
plotSpecsSave(Motor_nSpec,12:14,1:200,[0.7 1.5],1,'G:\Scripts\SentenceRep\Plots\',[Subject(SN).Name '-JLS-PROD'],experiment)
plotSpecsSave(Motor_nSpec,15:18,1:200,[0.7 1.5],1,'G:\Scripts\SentenceRep\Plots\',[Subject(SN).Name '-LM-PROD'],experiment)

end