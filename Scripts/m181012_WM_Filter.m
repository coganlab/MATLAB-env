duke;


% important!!
%subj_labels = list_electrodes({'D12','D13','D14','D15','D17'});

Subject(1).Name = 'D1'; 
Subject(3).Name = 'D3'; 
Subject(7).Name = 'D7'; 
Subject(8).Name = 'D8'; 
Subject(9).Name = 'D12'; 
Subject(10).Name = 'D13'; 
Subject(11).Name = 'D14'; 
Subject(12).Name= 'D15'; 
Subject(13).Name = 'D16';
Subject(14).Name = 'D17'; 
Subject(2).Name = 'S1'; 
Subject(15).Name = 'D20'; 
Subject(16).Name = 'D22';
Subject(17).Name = 'D23'; 
%ClusterSize=3;
subj_labels={};
counterChan=0;
for SN = [9:12,14,15:17];
    load([DUKEDIR '/' Subject(SN).Name '/mat/experiment.mat']);
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
    elseif strcmp(Subject(SN).Name,'S1');
   % AnalParams.Channel=[1:256];
    AnalParams.Channel=setdiff(1:256,[2,32,64,66,96,128,130,160,192,194,224,256]);
   elseif strcmp(Subject(SN).Name,'D20');
        AnalParams.Channel=[1:120];
   elseif strcmp(Subject(SN).Name,'D22');
        AnalParams.Channel=[1:100];
    elseif strcmp(Subject(SN).Name,'D23');
        AnalParams.Channel=[1:121];     
    else
        AnalParams.Channel = [1:64];
     end

 for iChan=1:length(AnalParams.Channel);
     subj_labels{counterChan+1}=[Subject(SN).Name, '-', experiment.channels(AnalParams.Channel(iChan)).name];
     counterChan=counterChan+1;
 end
end

subj_labels_loc={};
subj_labels_loc2={};
SNList=[9:12,14,15:17];
for iSN=1:length(SNList);
    filedir=[RECONDIR '/' Subject(SNList(iSN)).Name '/elec_recon/'];
   % filename=[filedir Subject(SNList(iSN)).Name '_elec_location_radius_3mm_aparc+aseg.mgz.csv'];
  %  filename=[filedir Subject(SNList(iSN)).Name '_elec_location_radius_3mm_aparc.a2009s+aseg.mgz.csv'];
    filename=[filedir Subject(SNList(iSN)).Name '_elec_location_radius_3mm.csv'];

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
subj_labels_NWM=[];
counterWM=0;
for iChan=1:length(subj_labels_loc)
 %   if contains(subj_labels_loc{iChan},'White-Matter') || strcmp(subj_labels_loc{iChan},' ')
     if  strcmp(subj_labels_loc{iChan},' ') || strcmp(subj_labels_loc{iChan},'White-Matter') || strcmp(subj_labels_loc{iChan},'Unknown') || strcmp(subj_labels_loc{iChan},'unknown') || strcmp(subj_labels_loc{iChan},'hypointensities')
        subj_labels_WM(counterWM+1)=1;
        counterWM=counterWM+1;
      %  subj_labels_NWM(iChan)=0;
    else
        subj_labels_WM(iChan)=0;
        subj_labels_NWM(counterNWM+1)=iChan;
        counterNWM=counterNWM+1;
    end
end
        