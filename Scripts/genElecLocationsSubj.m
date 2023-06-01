function [subj_labels_Name subj_labels_loc,subj_labels_WM] = genElecLocationsSubj(subj)
global RECONDIR
% generates non-white matter electrode per subject


%SNList=[3,5,7,8,9,12,13,14,15,16,17,18,20,22,23,24,26,27,28,29]; % sentence rep

%SNList=[23,26,27,28,29,30,31,33]; % sternberg neighborhood
%SNList=[18,19,20,22,23,24,25,27,29,20,31]; % phoneme seq

%ClusterSize=3;
%subj_labels = list_electrodes_from_experiment({'D2', 'D3', 'D4', 'D5', 'D6', 'D7', 'D8', 'D9', 'D10', 'D12', 'D13', 'D14', 'D15', 'D16', 'D17', 'D18', 'D19', 'D20', 'D21', 'D22', 'D23', 'D24', 'D25', 'D26', 'D27', 'D28', 'D29','D30'});
counterChan=0;
iElecS=0;

    %elecs=list_electrodes_from_experiment(subj);
    elecs=list_electrodes(subj);

    
    filedir=[RECONDIR '/' subj '/elec_recon/'];
%     if strcmp(Subject(SN).Type,'S')  %|| strcmp(Subject(SN).Name,'D16')
        filename=[filedir subj '_elec_location_radius_3mm_aparc+aseg.mgz.csv'];
%     elseif strcmp(Subject(SN).Type,'G')
%         filename=[filedir Subject(SN).Name '_elec_location_radius_3mm_aparc+aseg.mgz_brainshifted.csv'];
%    end
    %  filename=[filedir Subject(SNList(iSN)).Name '_elec_location_radius_3mm_aparc.a2009s+aseg.mgz.csv'];
    %  filename=[filedir Subject(SNList(iSN)).Name '_elec_location_radius_3mm.csv'];
    [NUM,TXT,RAW]=xlsread(filename);
    TXT=TXT(2:end,:);
    for iElec=1:length(elecs);
        for iElec2=1:length(TXT)
            if strcmp(elecs{iElec},(strcat(subj,'-',TXT(iElec2,2))))
                elecIdx(iElec)=iElec2;
            end
        end
    end
    ii=find(elecIdx==0);
    elecIdx(ii)=[];
    
    TXT=TXT(elecIdx,:);
    NUM=NUM(elecIdx,:);
    for iElec=1:length(TXT)
        elec_nameT=strcat(subj, '-',TXT(iElec,2));
        iN=3;
        
        while (contains(TXT(iElec,iN),'White-Matter'))  && iN<=7 && NUM(iElec,iN-2)<0.67 % .67
            %|| NUM(iElec,iN-2)<0.5
            iN=iN+2;
        end
        
        
        while (contains(TXT(iElec,iN),'Unknown') || contains(TXT(iElec,iN),'unknown') || contains(TXT(iElec,iN),'hypointensities')   ) && iN<=7
            %|| NUM(iElec,iN-2)<0.5
            iN=iN+2;
        end
        subj_labels_Name(iElecS+iElec)=elec_nameT;
        subj_labelsSubj(iElecS+iElec)=char2cell(subj);
      %  subj_labelsSN(iElecS+iElec)=SN;
%         if strcmp(Subject(SN).Type,'G')
%             subj_labelsType(iElecS+iElec)=1;
%         elseif strcmp(Subject(SN).Type,'S')
%             subj_labelsType(iElecS+iElec)=2;
%         end
%         if strcmp(Subject(SN).Hemi,'L')
%             subj_labelsSubjHemi(iElecS+iElec)=1;
%         elseif strcmp(Subject(SN).Hemi,'R')
%             subj_labelsSubjHemi(iElecS+iElec)=2;
%         elseif strcmp(Subject(SN).Hemi,'B')
%             subj_labelsSubjHemi(iElecS+iElec)=3;
%         end
        %subj_labelsType(iElecS+iElec)=char2cell(Subject(SN).Type);
        subj_labels_loc(iElecS+iElec)=TXT(iElec,iN); % percentages
        %    subj_labels_loc{iElecS+iElec}=TXT(iElec+1,1); % first column
    end

%
%               

% iiG=find(subj_labelsType==1);
% iiS=find(subj_labelsType==2);


%subj_labels_locUnique=unique(subj_labels_loc);

%subj_labelsLR=zeros(length(subj_labels2),1);
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
    if isempty(subj_labels_loc{iChan})
        subj_labels_WM(iChan)=1;
        counterWM=counterWM+1;
    elseif  strcmp(subj_labels_loc{iChan},' ') || contains(subj_labels_loc{iChan},'White-Matter') || strcmp(subj_labels_loc{iChan},'Unknown') || strcmp(subj_labels_loc{iChan},'unknown') || strcmp(subj_labels_loc{iChan},'hypointensities')
        subj_labels_WM(iChan)=1;
        counterWM=counterWM+1;
        %  subj_labels_NWM(iChan)=0;
    else
        subj_labels_WM(iChan)=0;
        %   subj_labels_NWM(counterNWM+1)=iChan;
        counterNWM=counterNWM+1;
    end
end

% iiNWM=find(subj_labels_WM==0);
% iiWM=find(subj_labels_WM==1);
% 
% subj_labels_locUnique=unique(subj_labels_loc)';
% % 
% areaStr=subj_labels_locUnique{68}; %45 = left superior temporal, 77 = right superior temporal
% counter=0;
% areaElecs=[];
% for iA=1:length(subj_labels_loc)
%     if strcmp(subj_labels_loc{iA},areaStr)
%         areaElecs(counter+1)=iA;
%         counter=counter+1;
%     end
% end