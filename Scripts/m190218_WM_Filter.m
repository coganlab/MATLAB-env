duke;


% important!!
%subj_labels = list_electrodes({'D12','D13','D14','D15','D17'});

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
%ClusterSize=3;
subj_labels={};
counterChan=0;
for SN =[3,5,7,8,9,12,13,14,15,16,17,18,20,22,23,24,26,27,28,29]; 

    load([DUKEDIR '/' Subject(SN).Name '/mat/experiment.mat']);
  
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

 for iChan=1:length(AnalParams.Channel);
     subj_labels{counterChan+1}=[Subject(SN).Name, '-', experiment.channels(AnalParams.Channel(iChan)).name];
     subj_labels{counterChan+1}=strtrim(subj_labels{counterChan+1});
     counterChan=counterChan+1;
 end
end

subj_labels_loc={};
subj_labels_loc2={};
SNList=[3,5,7,8,9,12,13,14,15,16,17,18,20,22,23,24]; 
for iSN=1:length(SNList);
    
    filedir=[RECONDIR '/' Subject(SNList(iSN)).Name '/elec_recon/'];
     filename=[filedir Subject(SNList(iSN)).Name '_elec_location_radius_3mm_aparc+aseg.mgz.csv'];
    %  filename=[filedir Subject(SNList(iSN)).Name '_elec_location_radius_3mm_aparc.a2009s+aseg.mgz.csv'];
    %filename=[filedir Subject(SNList(iSN)).Name '_elec_location_radius_3mm.csv'];
    
    [NUM,TXT,RAW]=xlsread(filename);
    for iElec=1:length(TXT)-1
        elec_nameT=strcat(Subject(SNList(iSN)).Name, '-',TXT(iElec+1,2));
        for iElecS=1:length(subj_labels);
            if strcmp(elec_nameT,subj_labels{iElecS});
                
                %                 TXTidx=[1,3,5,7,9];
                %                 for iTXT=1:length(TXTidx)
                iN=3;
                while (contains(TXT(iElec+1,iN),'White-Matter') || contains(TXT(iElec+1,iN),'Unknown') || contains(TXT(iElec+1,iN),'unknown') || contains(TXT(iElec+1,iN),'hypointensities')   ) && iN<=7 && NUM(iElec,iN-2)>0.5
                    %|| NUM(iElec,iN-2)<0.5
                    iN=iN+2;
                end
                subj_labels_loc{iElecS}=TXT(iElec+1,iN);
                
            end
        end
    end
end

%                 
%               

for iElec=1:length(subj_labels_loc);
    subj_labels_loc2(iElec)=subj_labels_loc{iElec};
end
subj_labels_loc3=unique(subj_labels_loc2);


%    % is it white matter?
%    areaLocU=[];
%    strM1='Unknown';
%    strM2='unknown';
%    counter=0;
%    for iChan=1:length(subj_labels_loc);
%       if contains(subj_labels_loc{iChan},strM1) || contains(subj_labels_loc{iChan},strM2)
%        areaLocU(counter+1)=iChan;
%        counter=counter+1;
%       end
%    end
%    
% % for iChan=1:length(areaLocU);
    

counterNWM=0;
subj_labels_WM=[];
subj_labels_NWM=[];
counterWM=0;
for iChan=1:length(subj_labels_loc)
 %   if contains(subj_labels_loc{iChan},'White-Matter') || strcmp(subj_labels_loc{iChan},' ')
     if  strcmp(subj_labels_loc{iChan},' ') || strcmp(subj_labels_loc{iChan},'White-Matter') || strcmp(subj_labels_loc{iChan},'Unknown') || strcmp(subj_labels_loc{iChan},'unknown') || strcmp(subj_labels_loc{iChan},'hypointensities')
        subj_labels_WM(iChan)=1;
        counterWM=counterWM+1;
      %  subj_labels_NWM(iChan)=0;
    else
        subj_labels_WM(iChan)=0;
     %   subj_labels_NWM(counterNWM+1)=iChan;
        counterNWM=counterNWM+1;
    end
end




iiWM=find(subj_labels_WM==1);
iiNWM=setdiff(1:length(subj_labels_loc2),iiWM);

% counterWM2=0;
% for iChan1=1:length(iiWM)
%     for iChan2=1:length(subj_labels);
%         compStr1=subj_labels_Small{iiWM(iChan1)};
%         compStr2=subj_labels{iChan2};
%         if strcmp(compStr1,compStr2)
%             WMidx(counterWM2+1)=iChan2;
%             counterWM2=counterWM2+1;
%         end
%     end
% end
            

        