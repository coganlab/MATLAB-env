global BOX_DIR
global RECONDIR
BOX_DIR='H:\Box Sync';
RECONDIR=[BOX_DIR '\ECoG_Recon'];
SNList={'D10','D24','D66','D65','D64','D63','D61','D60','D59',...
    'D58','D57','D56','D55','D54','D53','D52','D49','D48','D47',...
    'D46','D45','D43','D42','D41','D40'};
SNList={'D66','D65','D64','D63','D61','D60','D59',...
    'D58','D57','D56','D55','D54','D53','D52','D49','D48','D47',...
    'D46','D45','D43','D42','D41','D40','D39','D38'};

iElecS=0;
Subject=[];
elecLocsAll={};
elecNamesAll={};
load([BOX_DIR '/CoganLab/D_Data/gList.mat'])
for SN=1:length(SNList);
    clear elecIdx
    %SN=SNList(iSN);
    Subject(SN).Name=cell2mat(SNList(SN));
    Subject(SN).Type='SEEG';
    % for iG=1:length(gListNames)
    while strcmp(Subject(SN).Name,gListNames)
        Subject(SN).Type='ECoG';
    end
    %end
    % load([TASK_DIR '/' Subject(SN).Name '/mat/experiment.mat'])
    elecs=list_electrodes(Subject(SN).Name);
    
    % load regular locations if seeg, brain shifted if grid
    rfiledir=[RECONDIR '/' Subject(SN).Name '/elec_recon/'];
    if strcmp(Subject(SN).Type,'SEEG')  %|| strcmp(Subject(SN).Name,'D16')
       % filename=[rfiledir Subject(SN).Name '_elec_location_radius_3mm_aparc+aseg.mgz.csv'];
        filename=[rfiledir Subject(SN).Name '_elec_location_radius_3mm_aparc.a2009s+aseg.mgz.csv'];
        elecInfo = parse_RAS_file([rfiledir Subject(SN).Name '_elec_locations_RAS.txt']);
    elseif strcmp(Subject(SN).Type,'ECoG')
     %   filename=[rfiledir Subject(SN).Name '_elec_location_radius_3mm_aparc+aseg.mgz_brainshifted.csv'];
        filename=[rfiledir Subject(SN).Name '_elec_location_radius_3mm_aparc.a2009s+aseg.mgz_brainshifted.csv'];
        elecInfo = parse_RAS_file([rfiledir Subject(SN).Name '_elec_locations_RAS_brainshifted.txt']);
    end
    
    
    % read through the xls file
    %[NUM,TXT,RAW]=xlsread(filename);
    T=readtable(filename);
    TXT=T;
    NUM=table2array(T(:,[4,6,8,10]));
    %     NUM=zeros(size(T,1),4);
    %     iN_List=[4,6,8,10];
    %     for iN=1:5
    %         NUM(:,iN)=table2array(T(:,iN_List(iN)));
    %     end
    %     NUM=table2cell(T(:,[4,6,8,10]));
    
    %TXT=TXT(2:end,:);
    Tname=table2array(TXT(:,2));
    Trest=table2cell(TXT(:,1:2:size(TXT,2)));
    
    for iElec=1:length(elecs);
        for iElec2=1:size(TXT,1)
            if strcmp(elecs{iElec},(strcat(Subject(SN).Name,'-',Tname(iElec2,:))))
                elecIdx(iElec)=iElec2;
            end
        end
    end
    ii=find(elecIdx==0);
    elecIdx(ii)=[];
    TXT=TXT(elecIdx,:);
    NUM=NUM(elecIdx,:);
    Tname=Tname(elecIdx,:);
    Trest=Trest(elecIdx,:);
    % this can be adjusted! Looks for proportion that is white matter (less
    % than 0.67) and keeps it. Could be higher or lower
    for iElec=1:size(TXT,1)
        elec_nameT=strcat(Subject(SN).Name, '-',Tname(iElec,:));
        iN=1;
        
        while (contains(Trest(iElec,iN),'White-Matter'))  && iN<=7 && NUM(iElec,iN)<0.8
            %|| NUM(iElec,iN-2)<0.5
            iN=iN+1;
        end
        
        
        while (contains(Trest(iElec,iN),'Unknown') || contains(Trest(iElec,iN),'unknown') || contains(Trest(iElec,iN),'hypointensities')   ) && iN<=7
            %|| NUM(iElec,iN-2)<0.5
            iN=iN+1;
        end
        subj_labels2(iElecS+iElec)=elec_nameT;
        %
        subj_labels_loc(iElecS+iElec)=Trest(iElec,iN); % percentages
        %    subj_labels_loc{iElecS+iElec}=TXT(iElec+1,1); % first column
    end
    iElecS=iElecS+size(TXT,1);


end
elecLocsAll=subj_labels_loc;
elecNamesAll=subj_labels2;

% labels?
labelChan=[];
%label='Plan_temp';
%label='precentral';
%label='postcentral';
%label='supram';
%label='Triang';
%label='operc';
%label='S_central';
%label='G_temp_sup';
%label='S_temporal_sup';
label='S_temporal_tran';
counter=0;
for iChan=1:length(elecLocsAll);
    if contains(elecLocsAll{iChan},label,'IgnoreCase',1);
        labelChan(counter+1)=iChan;
        counter=counter+1;
    end
end

