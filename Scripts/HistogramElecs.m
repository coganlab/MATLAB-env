%function [histBinFill,histBinFillIdx]=HistogramElecs(SNList);
            
duke;

Subject=[];
Subject(2).Name = 'D2'; 
Subject(3).Name = 'D3'; 
Subject(4).Name = 'D4';
Subject(5).Name = 'D5'; 
Subject(6).Name = 'D6';
Subject(7).Name = 'D7'; 
Subject(8).Name = 'D8'; 
Subject(9).Name = 'D9'; 
Subject(10).Name = 'D10';
Subject(12).Name= 'D12'; 
Subject(13).Name = 'D13'; 
Subject(14).Name = 'D14'; 
Subject(15).Name = 'D15'; 
Subject(16).Name = 'D16'; 
Subject(17).Name = 'D17'; 
Subject(18).Name = 'D18'; 
Subject(19).Name = 'D19'; 
Subject(20).Name = 'D20'; 
Subject(21).Name = 'D21';
Subject(22).Name = 'D22'; 
Subject(23).Name = 'D23'; 
Subject(24).Name = 'D24'; 
Subject(25).Name = 'D25';
Subject(26).Name = 'D26'; 
Subject(27).Name = 'D27'; 
Subject(28).Name = 'D28'; 
Subject(29).Name = 'D29'; 
Subject(30).Name='D30'; 
Subject(31).Name='D31'; 
Subject(32).Name='D32';
Subject(33).Name='D33'; 
Subject(34).Name='D34'; 
Subject(35).Name='D35'; 
Subject(36).Name='D36'; 
%Subject(37).Name='D37'; 
Subject(38).Name='D38'; 
Subject(39).Name='D39';

subjs_S=[8,9,12,13,14,15,17,18,20,22,23,25,27,28,29,30,31,32,33,34,35,36,38,39];
subjs_S=[29,30,31,32,33,34,36,35,38,39]; % latest 10
subjs_S=[25,27,28,29,30,31,32,33,34,35,36,38,39]; % calendar year-ish
%subjs_G=[2,3,4,5,6,7,10,16,19,21,24,26];
subjs_G=[4,5,6,7,10,16,19,21,24,26]; % last 10

%SNList=subjs_S;
%DUKEDIR = ['H:\Box Sync\CoganLab\D_Data\Neighborhood_Sternberg'];
elecsAll=[];
subj_labels_locAll=[];
nWMAll=[];
for iSN=1:length(SNList);
    
    SN=SNList(iSN);
    
    elecs=list_electrodes(Subject(SN).Name);
    nWM=zeros(length(elecs),1);
    [iiWM, iiNWM, subj_labels_loc] = genWMElecs(Subject(SN).Name,elecs);
    nWM(iiNWM)=1;
    elecsAll=cat(1,elecsAll,elecs);
    subj_labels_locAll=cat(2,subj_labels_locAll,subj_labels_loc);
    nWMAll=cat(1,nWMAll,nWM);
%     lengthCheck(iSN,1)=length(elecs);
%     lengthCheck(iSN,2)=length(subj_labels_loc);
end
subj_labels_locAllt=subj_labels_locAll;
elecsAllt=elecsAll;
subj_labels_locAll=subj_labels_locAll(nWMAll==1);
elecsAll=elecsAll(nWMAll==1);

grouping_idxAll=ones(length(subj_labels_locAll),1);




idx=find(grouping_idxAll==1); % 2 = A, 1 = M, 6 = AM
histBinLabels=unique(categorical(string(subj_labels_locAll)))'; % my god!
histBinFill=zeros(length(histBinLabels),1);
 histBinFillIdx=cell(length(histBinLabels),1);
for iChan=1:length(idx)
    for iLabel=1:length(histBinLabels)
        if strcmp(subj_labels_locAll{idx(iChan)},string(histBinLabels(iLabel)))
            histBinFill(iLabel)=histBinFill(iLabel)+1;
            histBinFillIdx{iLabel}=cat(1,histBinFillIdx{iLabel},idx(iChan));
        end
    end
end


% cfg=[];
% grouping_idxSub=zeros(length(grouping_idxAll),1);
% grouping_idxSub(histBinFillIdx{5})=2;
% plot_subjs_on_average_grouping(elecsAll,grouping_idxSub,'fsaverage',cfg)
         