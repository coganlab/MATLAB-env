duke;

Subject(2).Name = 'D2'; Subject(2).Type='G'; Subject(2).Hemi='R';
Subject(3).Name = 'D3'; Subject(3).Type='G'; Subject(3).Hemi='L';
Subject(4).Name = 'D4'; Subject(4).Type='S'; Subject(4).Hemi='B';
Subject(5).Name = 'D5'; Subject(5).Type='G'; Subject(5).Hemi='L';
Subject(6).Name = 'D6'; Subject(6).Type='G'; Subject(6).Hemi='L';
Subject(7).Name = 'D7'; Subject(7).Type='G'; Subject(7).Hemi='R';
Subject(8).Name = 'D8'; Subject(8).Type='S'; Subject(8).Hemi='B';
Subject(9).Name = 'D9'; Subject(9).Type='S'; Subject(9).Hemi='B';
Subject(10).Name = 'D10'; Subject(10).Type='G'; Subject(10).Hemi='L';
Subject(12).Name = 'D12'; Subject(12).Type='S'; Subject(12).Hemi='R';
Subject(13).Name = 'D13'; Subject(13).Type='S'; Subject(13).Hemi='B';
Subject(14).Name = 'D14'; Subject(14).Type='S'; Subject(14).Hemi='R';
Subject(15).Name = 'D15'; Subject(15).Type='S'; Subject(15).Hemi='B';
Subject(16).Name=  'D16'; Subject(16).Type='G'; Subject(16).Hemi='L';
Subject(17).Name = 'D17'; Subject(17).Type='S'; Subject(17).Hemi='B';
Subject(18).Name = 'D18'; Subject(18).Type='S'; Subject(18).Hemi='B';
Subject(19).Name = 'D19'; Subject(19).Type='G'; Subject(19).Hemi='R';
Subject(20).Name = 'D20'; Subject(20).Type='S'; Subject(20).Hemi='B';
Subject(21).Name = 'D21'; Subject(21).Type='G'; Subject(21).Hemi='R';
Subject(22).Name = 'D22'; Subject(22).Type='S'; Subject(22).Hemi='L';
Subject(23).Name = 'D23'; Subject(23).Type='S'; Subject(23).Hemi='R';
Subject(24).Name = 'D24'; Subject(24).Type='G'; Subject(24).Hemi='L';
Subject(25).Name = 'D25'; Subject(25).Type='S'; Subject(25).Hemi='B';
Subject(26).Name = 'D26'; Subject(26).Type='G'; Subject(26).Hemi='R';
Subject(27).Name = 'D27'; Subject(27).Type='S'; Subject(27).Hemi='L';
Subject(28).Name = 'D28'; Subject(28).Type='S'; Subject(28).Hemi='L';
Subject(29).Name = 'D29'; Subject(29).Type='S'; Subject(29).Hemi='B';
Subject(30).Name = 'D30'; Subject(30).Type='S'; Subject(30).Hemi='R';
Subject(31).Name = 'D31'; Subject(31).Type='S'; Subject(31).Hemi='B';
Subject(32).Name = 'D32'; Subject(32).Type='S'; Subject(32).Hemi='L';
Subject(33).Name = 'D33'; Subject(33).Type='S'; Subject(33).Hemi='B';
Subject(34).Name = 'D34'; Subject(34).Type='S'; Subject(34).Hemi='B';
Subject(35).Name = 'D35'; Subject(35).Type='S'; Subject(35).Hemi='L';
Subject(36).Name = 'D36'; Subject(36).Type='S'; Subject(36).Hemi='B';
Subject(38).Name = 'D38'; Subject(38).Type='S'; Subject(38).Hemi='B';
Subject(39).Name = 'D39'; Subject(39).Type='S'; Subject(39).Hemi='B';
Subject(41).Name = 'D41'; Subject(41).Type='S'; Subject(41).Hemi='B';
Subject(42).Name = 'D42'; Subject(42).Type='S'; Subject(42).Hemi='R';
Subject(43).Name = 'D43'; Subject(43).Type='S'; Subject(43).Hemi='B';
Subject(44).Name = 'D44'; Subject(44).Type='S'; Subject(44).Hemi='B';
Subject(45).Name = 'D45'; Subject(45).Type='S'; Subject(45).Hemi='B';

%SNList=[2:10,12:31];
%SNList=[3,5,7,8,9,12,13,14,15,16,17,18,20,22,23,24,26,27,28,29,30,31]; 
SNList=[2:10,12:31];
%SNList=[3,5,7,8,9,12,13,14,15,16,17];
SNList=[27:36,38:39,41:45];
%SNList=[21:30];
%ClusterSize=3;
%subj_labels = list_electrodes_from_experiment({'D2', 'D3', 'D4', 'D5', 'D6', 'D7', 'D8', 'D9', 'D10', 'D12', 'D13', 'D14', 'D15', 'D16', 'D17', 'D18', 'D19', 'D20', 'D21', 'D22', 'D23', 'D24', 'D25', 'D26', 'D27', 'D28', 'D29','D30'});
counterChan=0;
iElecS=0;
for iSN=1:length(SNList);
SN=SNList(iSN);
    filedir=[RECONDIR '/' Subject(SN).Name '/elec_recon/'];
    if strcmp(Subject(SN).Type,'S')
    filename=[filedir Subject(SN).Name '_elec_location_radius_3mm_aparc+aseg.mgz.csv'];
    elseif strcmp(Subject(SN).Type,'G')
            filename=[filedir Subject(SN).Name '_elec_location_radius_3mm_aparc+aseg.mgz_brainshifted.csv'];
    end
  %  filename=[filedir Subject(SNList(iSN)).Name '_elec_location_radius_3mm_aparc.a2009s+aseg.mgz.csv'];
  %  filename=[filedir Subject(SNList(iSN)).Name '_elec_location_radius_3mm.csv'];

    [NUM,TXT,RAW]=xlsread(filename);
    for iElec=1:length(TXT)-1
        elec_nameT=strcat(Subject(SN).Name, '-',TXT(iElec+1,2));
                 iN=3;
                 
                while (contains(TXT(iElec+1,iN),'White-Matter'))  && iN<=7 && NUM(iElec,iN-2)<0.67 
                %|| NUM(iElec,iN-2)<0.5
                    iN=iN+2;
                end

                
                while (contains(TXT(iElec+1,iN),'Unknown') || contains(TXT(iElec+1,iN),'unknown') || contains(TXT(iElec+1,iN),'hypointensities')   ) && iN<=7 
                %|| NUM(iElec,iN-2)<0.5
                    iN=iN+2;
                end
                subj_labels2(iElecS+iElec)=elec_nameT;
                subj_labelsSubj(iElecS+iElec)=char2cell(Subject(SN).Name);
                subj_labelsSN(iElecS+iElec)=SN;
                if strcmp(Subject(SN).Type,'G')
                    subj_labelsType(iElecS+iElec)=1;
                elseif strcmp(Subject(SN).Type,'S')
                    subj_labelsType(iElecS+iElec)=2;
                end               
                 if strcmp(Subject(SN).Hemi,'L')
                    subj_labelsSubjHemi(iElecS+iElec)=1;
                elseif strcmp(Subject(SN).Hemi,'R')
                    subj_labelsSubjHemi(iElecS+iElec)=2;
                elseif strcmp(Subject(SN).Hemi,'B')
                    subj_labelsSubjHemi(iElecS+iElec)=3;    
                 end
                %subj_labelsType(iElecS+iElec)=char2cell(Subject(SN).Type);
                subj_labels_loc(iElecS+iElec)=TXT(iElec+1,iN); % percentages
            %    subj_labels_loc{iElecS+iElec}=TXT(iElec+1,1); % first column
    end
    iElecS=iElecS+length(NUM);
end
%                 
%               

iiG=find(subj_labelsType==1);
iiS=find(subj_labelsType==2);


subj_labels_locUnique=unique(subj_labels_loc)';

subj_labelsLR=zeros(length(subj_labels2),1);
% iiL=find(subj_labelsSubjHemi==1);
% subj_labelsLR(iiL)=1;
% iiR=find(subj_labelsSubjHemi==2);
% subj_labelsLR(iiR)=2;

% for iChan=1:length(subj_labels2)
%     elecHemi=subj_labelsSubjHemi(iChan);
%     if elecHemi==1
%         subj_labelsLR(iChan)=1;
%     elseif elecHemi==2
%         subj_labelsLR(iChan)=2;
%     elseif elecHemi==3
%         if strfind(subj_labels2{iChan},'L')
%             subj_labelsLR(iChan)=1;
%         elseif strfind(subj_labels2{iChan},'R');
%             subj_labelsLR(iChan)=2;     
%         end
%     else
%         subj_labelsLR(iChan)=3;
%     end
% end
% iiL=find(subj_labelsLR==1);
% iiR=find(subj_labelsLR==2);

counterNWM=0;
subj_labels_WM=[];
counterWM=0;
for iChan=1:length(subj_labels_loc)
 %   if contains(subj_labels_loc{iChan},'White-Matter') || strcmp(subj_labels_loc{iChan},' ')
     if  strcmp(subj_labels_loc{iChan},' ') || contains(subj_labels_loc{iChan},'White-Matter') || strcmp(subj_labels_loc{iChan},'Unknown') || strcmp(subj_labels_loc{iChan},'unknown') || strcmp(subj_labels_loc{iChan},'hypointensities')
        subj_labels_WM(iChan)=1;
        counterWM=counterWM+1;
      %  subj_labels_NWM(iChan)=0;
    else
        subj_labels_WM(iChan)=0;
     %   subj_labels_NWM(counterNWM+1)=iChan;
        counterNWM=counterNWM+1;
    end
end

iiNWM=find(subj_labels_WM==0);
iiWM=find(subj_labels_WM==1);


areaStr=subj_labels_locUnique{32} %45 = left superior temporal, 77 = right superior temporal
counter=0;
areaElecs=[];
for iA=1:length(subj_labels_loc)
    if strcmp(subj_labels_loc{iA},areaStr)
        areaElecs(counter+1)=iA;
        counter=counter+1;
    end
end


length(areaElecs)
areaElecsSubj=unique(subj_labelsSN(areaElecs))


subj_labels_Area={};
subj_labels_AreaTot=zeros(length(subj_labels_locUnique),1);
for iA1=1:length(subj_labels_locUnique)
    for iA2=1:length(subj_labels_loc)
        if strcmp(subj_labels_locUnique{iA1},subj_labels_loc{iA2})
          %  subj_labels_Area{iA1}=cat(2,subj_labels_Area{iA1},iA2);
            subj_labels_AreaTot(iA1)=subj_labels_AreaTot(iA1)+1;
        end
    end
end
        
        

%length(intersect(areaElecs,iiG))
%areaElecsSubj=unique(subj_labelsSN(intersect(iiG,areaElecs)));

grouping_idx=zeros(length(subj_labels2),1);
for iS=1:length(areaElecsSubj)
grouping_idx(intersect(areaElecs,find(subj_labelsSN==areaElecsSubj(iS))))=iS;
end
cfg.hemisphere = 'l';
plot_subjs_on_average_grouping(subj_labels2, grouping_idx, 'fsaverage', cfg);

cfg.hemisphere = 'r';
plot_subjs_on_average_grouping(subj_labels2, grouping_idx, 'fsaverage', cfg);



grouping_idx=zeros(length(subj_labels2),1);
for iS=1:length(areaElecsSubj)
grouping_idx(intersect(areaElecs,find(subj_labelsSN==areaElecsSubj(iS))))=iS;
end
cfg.hemisphere = 'l';
plot_subjs_on_average_grouping(subj_labels2, grouping_idx, 'fsaverage', cfg);

cfg.hemisphere = 'r';
plot_subjs_on_average_grouping(subj_labels2, grouping_idx, 'fsaverage', cfg);

grouping_idx=zeros(length(subj_labels2),1);
grouping_idx(iiNWM)=22;
cfg.hemisphere = 'l';
plot_subjs_on_average_grouping(subj_labels2, grouping_idx, 'fsaverage', cfg);

cfg.hemisphere = 'r';
plot_subjs_on_average_grouping(subj_labels2, grouping_idx, 'fsaverage', cfg);

grouping_idx=zeros(length(subj_labels2),1);
grouping_idx(iiWM)=22;
cfg.hemisphere = 'l';
plot_subjs_on_average_grouping(subj_labels2, grouping_idx, 'fsaverage', cfg);

cfg.hemisphere = 'r';
plot_subjs_on_average_grouping(subj_labels2, grouping_idx, 'fsaverage', cfg);

grouping_idx=zeros(length(subj_labels2),1);
grouping_idx(iiG)=22;
cfg.hemisphere = 'l';
plot_subjs_on_average_grouping(subj_labels2, grouping_idx, 'fsaverage', cfg);

cfg.hemisphere = 'r';
plot_subjs_on_average_grouping(subj_labels2, grouping_idx, 'fsaverage', cfg);

grouping_idx=zeros(length(subj_labels2),1);
grouping_idx(iiS)=22;
cfg.hemisphere = 'l';
plot_subjs_on_average_grouping(subj_labels2, grouping_idx, 'fsaverage', cfg);

cfg.hemisphere = 'r';
plot_subjs_on_average_grouping(subj_labels2, grouping_idx, 'fsaverage', cfg);

grouping_idx=zeros(length(subj_labels2),1);
grouping_idx(intersect(iiG,iiNWM))=22;
cfg.hemisphere = 'l';
plot_subjs_on_average_grouping(subj_labels2, grouping_idx, 'fsaverage', cfg);

cfg.hemisphere = 'r';
plot_subjs_on_average_grouping(subj_labels2, grouping_idx, 'fsaverage', cfg);

grouping_idx=zeros(length(subj_labels2),1);
grouping_idx(intersect(iiS,iiNWM))=22;
cfg.hemisphere = 'l';
plot_subjs_on_average_grouping(subj_labels2, grouping_idx, 'fsaverage', cfg);

cfg.hemisphere = 'r';
plot_subjs_on_average_grouping(subj_labels2, grouping_idx, 'fsaverage', cfg);



        