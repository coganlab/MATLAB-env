sList2019={'D27','D28','D29','D30','D31','D32','D33','D34','D35','D36','D38','D39','D41','D42','D43','D44'};
subjs_S={'D4','D8','D9','D12','D13','D14','D15','D17','D18','D20','D22','D23','D25','D27','D28','D29','D30','D31','D32','D33','D34','D35','D36','D38','D39','D41','D42','D43','D44','D45'};

subjs_S2={'D22','D23','D25','D27','D28','D29','D30','D31','D32','D33','D34','D35','D36','D38','D39','D41','D42','D43','D44','D45'};

% subjs_S={'D8','D9','D12','D13','D14','D15','D17','D18','D20','D22','D23','D25','D27','D28','D29','D30','D31','D32','D33','D34','D35','D36','D38','D39','D41','D42'};
% 
% subjs_G={'D2','D3','D5','D6','D7','D10','D16','D19','D21','D24','D26'};
subjs_All=cat(2,subjs_S,subjs_G);
% subjs_P={D10','D11','D22'}
% sList2019=cat(2,subjs_G,subjs_S);
sList2019=subjs_S;

subj=[];
for iS=1:length(sList2019);
    subjT=sList2019{iS};
    [subj_labels_name, subj_labels_loc,subj_labels_WM]=genElecLocationsSubj(subjT);
    subj(iS).Name=subjT;
    subj(iS).Label=subj_labels_loc;
    subj(iS).Elecs=subj_labels_name;
    elecInfo = parse_RAS_file([RECONDIR '\' subj(iS).Name '\elec_recon\' subj(iS).Name '_elec_locations_RAS.txt']); %filename);

for iElec1=1:length(subj(iS).Elecs)
    for iElec2=1:length(elecInfo.labels)
        if strcmp(subj(iS).Elecs{iElec1},[subj(iS).Name '-' elecInfo.labels{iElec2}])
            subj(iS).xyz(iElec1,:)=elecInfo.xyz(iElec2,:);
        end
    end
end    
    
end



counterA=0;
for iS=1:length(subj)
    counter=0;
    for iElec=1:length(subj(iS).Label)
        if strcmp('',subj(iS).Label(iElec)) || contains(subj(iS).Label(iElec),'white') ...
                || contains(subj(iS).Label(iElec), 'White') || contains(subj(iS).Label(iElec),'intensit');
            subj(iS).WMElecs(counter+1)=iElec;
            subj(iS).WMElecsA(counter+1)=iElec+counterA;
            counter=counter+1;
        end
    end
    counterA=counterA+length(subj(iS).Label);
end

elecsAll=[];
elecsAllXYZ=[];
for iS=1:length(subj);
    elecsAll=cat(2,elecsAll,subj(iS).Elecs);
    elecsAllXYZ=cat(2,elecsAllXYZ,subj(iS).xyz');
end
elecsAllXYZ=elecsAllXYZ';

WMElecsIdx=[];
for iS=1:length(subj);
    WMElecsIdx=cat(2,WMElecsIdx,subj(iS).WMElecsA);
end

areaElecsSubject=[];
areaElecsNumber=[];
areaElecsSubjectTot=zeros(length(elecsAll),1);
areaElecsNumberTot=zeros(length(elecsAll),1);

counter=0;
counter2=0;
for iS=1:length(subj);
    for iL=1:length(subj(iS).Label);
        if contains(subj(iS).Label{iL},'insula')% || contains(subj(iS).Label{iL},'entor')
            areaElecsSubject(counter+1)=iS;
            areaElecsNumber(counter+1)=iL;
            areaElecsSubjectTot(counter2+1)=iS;
            areaElecsNumberTot(counter2+1)=1;
            counter=counter+1;            
        end
        counter2=counter2+1;        
    end
end


elecsAllNWM=elecsAll;
elecsAllNWM(WMElecsIdx)=[];

elecsAllNWMXYZ=elecsAllXYZ;
elecsAllNWMXYZ(WMElecsIdx,:)=[];
cfg=[];
cfg.hemisphere='l';
cfg.show_labels=0;
cfg.elec_size=25; 
%cfg.alpha = 0.75;
%cfg.show_annot = 1;
% elecsP=zeros(length(elecsAll),1);
% ii=find(areaElecsSubjectTot>0);
% elecsP(ii)=2;
plot_subjs_on_average_grouping(elecsAllNWM,4*ones(1,length(elecsAllNWM)),'fsaverage',cfg);
plot_subjs_on_average_grouping(elecsAll,areaElecsSubjectTot,'fsaverage',cfg);


plot_subjs_on_average_grouping(elecsAll,areaElecsSubjectTot,cfg);
%plot_subjs_on_average_grouping(elecsAll,elecsP,cfg);


    medialElecsLeftIdx=find(elecsAllXYZ(:,1)<0 & elecsAllXYZ(:,1)>-25 & elecsAllXYZ(:,3)<0 & elecsAllXYZ(:,2)<20); % & elecsAllXYZ(:,3)<0);
    medialElecsRightIdx=find(elecsAllXYZ(:,1)<25 & elecsAllXYZ(:,3)<0 & elecsAllXYZ(:,2)<20); % & elecsAllXYZ(:,3)<0);
    %medialElecsRightIdx=1:length(elecsAll);
    lateralElecsLeftIdx=find(elecsAllNWMXYZ(:,1)<-45); % & elecsAllXYZ(:,3)<0);
    lateralElecsRightIdx=find(elecsAllNWMXYZ(:,1)>45); % & elecsAllXYZ(:,3)<0);

    idxVals=1:length(elecsAllNWM);%lateralElecsLeftIdx;
   % grouping=zeros(length(idxVals),1);
    grouping=4*ones(length(idxVals),1);
    
    counter=1;
    gLabel=extractBefore(elecsAll{idxVals(1)},'-');
    for iG=1:length(grouping);
        gLabel2=extractBefore(elecsAll{idxVals(iG)},'-');
        if strcmp(gLabel,gLabel2)
            grouping(iG)=counter;
        else
            gLabel=gLabel2;
            counter=counter+1;
            grouping(iG)=counter;
        end
    end

    plot_subjs_on_average_grouping(elecsAllNWM(idxVals),grouping,'fsaverage',cfg);