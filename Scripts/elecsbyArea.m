duke;
% Subject=[];
% Subject(23).Name='D23'; Subject(23).Channel=[1:121]; % D23
% Subject(26).Name='D26'; Subject(26).Channel=[1:60];
% Subject(27).Name='D27'; Subject(27).Channel=setdiff([1:114],[1,2,21,22]); % D27
% Subject(28).Name='D28'; Subject(28).Channel=setdiff([1:108],[20,43,77,78]); % D28
% Subject(29).Name='D29'; Subject(29).Channel=setdiff([1:140],[8,56,133,136,137,140]);
% Subject(30).Name='D30'; Subject(30).Channel=setdiff([1:104],[12,19,36,37,80,82]);
% Subject(31).Name='D31'; Subject(31).Channel=setdiff([1:160],[9,17,67,68,40,117,148,149]); % D31
% Subject(32).Name='D31'; Subject(31).Channel=setdiff([1:160],[9,17,67,68,40,117,148,149]); % D31
% Subject(33).Name='D33'; Subject(33).Channel=([1:240]); %D33
% Subject(34).Name='D34'; Subject(34).Channel=setdiff([1:182],[40,41,45,100,174]); %D34
% Subject(35).Name='D35'; Subject(35).Channel=setdiff([1:174],[8,26,37,38,39,40,54,79,80,81,82,155]); %D35
% Subject(36).Name='D36';
% Subject(37).Name='D37'; Subject(31).Channel=setdiff([1:160],[9,17,67,68,40,117,148,149]); % D31
% Subject(38).Name='D38'; Subject(31).Channel=setdiff([1:160],[9,17,67,68,40,117,148,149]); % D31


global DUKEDIR
DUKEDIR=['H:\Box Sync\CoganLab\D_Data\Neighborhood_Sternberg'];

SNList=[24:36,38];
SNList=[8,9,12:15,17,18,20,22,23,25,27:36,38];

subj_labels_locAll=[];
subj_labels_locAllName=[];

for iSN=1:length(SNList);
    SN=SNList(iSN);
    
    subj_labels=list_electrodes(strcat('D',num2str(SN)));
    
    [iiWM, iiNWM, subj_labels_loc] = genWMElecs(strcat('D',num2str(SN)),subj_labels);
%     subj_labels_LocName_tmp=[];
%     for iChan=1:length(subj_labels_loc)
%         subj_labels_locName_tmp{iChan}=strcat(Subject(SN).Name,'-',subj_labels_loc{iChan});
%     end
    
    subj_labels_locAll=cat(1,subj_labels_locAll,subj_labels_loc');
    subj_labels_locAllName=cat(1,subj_labels_locAllName,subj_labels);
end

suptempValsRH=zeros(length(subj_labels_locAll),1);
suptempValsLH=zeros(length(subj_labels_locAll),1);

for iChan=1:length(subj_labels_locAll);
    idx1=subj_labels_locAll{iChan};
    if size(idx1,1)>0
%         suptempValsRH(iChan)=strcmp(idx1,'ctx-rh-superiortemporal');
%         suptempValsLH(iChan)=strcmp(idx1,'ctx-lh-superiortemporal');
%         suptempValsRH(iChan)=strcmp(idx1,'ctx-rh-middletemporal');
%         suptempValsLH(iChan)=strcmp(idx1,'ctx-lh-middletemporal');
%         suptempValsRH(iChan)=strcmp(idx1,'ctx-rh-parstriangularis');
%         suptempValsLH(iChan)=strcmp(idx1,'ctx-lh-parstriangularis');
%         suptempValsRH(iChan)=strcmp(idx1,'ctx-rh-parsopercularis');
%         suptempValsLH(iChan)=strcmp(idx1,'ctx-lh-parsopercularis');
         suptempValsRH(iChan)=strcmp(idx1,'ctx-rh-supramarginal');
         suptempValsLH(iChan)=strcmp(idx1,'ctx-lh-supramarginal');
    end
end
iiL=find(suptempValsLH==1);
iiR=find(suptempValsRH==1);

grouping_idx=zeros(length(subj_labels_locAllName),1);
grouping_idx(iiL)=1;
grouping_idx(iiR)=2;


cfg=[];
plot_subjs_on_average_grouping(subj_labels_locAllName, grouping_idx, 'fsaverage',cfg)
