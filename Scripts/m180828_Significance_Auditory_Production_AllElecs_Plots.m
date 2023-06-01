% important!!
%subj_labels = list_electrodes({'D12','D13','D14','D15','D17'});
Subject=[];
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
%cfg = [];

cfg=[];
grouping_idx = zeros(925,1);


%grouping_idx(intersect(iiA2,iiNWWA))=2;
grouping_idx(51:60)=1;



% 
% cmap=zeros(30,1);
% cmap(:,1)=linspace(1,0,30);
% cmap(:,2)=linspace(0,1,30);
% cmap(:,3)=linspace(1,0,30);
% gval=mean(mdlRvals3(iiA2,25:40)-mdlRvals(iiA2,25:40),2);
% idx=iiA2; %1:925;
% minval=-0.01; %-0.5; %min(gval);
% maxval=0.01; %max(gval);
% valRange=linspace(minval,maxval,30);
% for iC=1:30;
%     if iC==1
%     ii=find(gval<minval);
%     grouping_idx(idx(ii))=iC;
%     elseif iC==30;
%         ii=find(gval>maxval);
%         grouping_idx(idx(ii))=iC;
%     else
%         ii=find(gval>valRange(iC-1) & gval<valRange(iC));
%         grouping_idx(idx(ii))=iC;
%     end
% end
% cfg.elec_colors=cmap;
% %  
%grouping_idx(1:704)=1;
%grouping_idx(intersect(iiSig{1}(iiLPos),iiSig{3}(iiPPos)))=1;
%grouping_idx(intersect(iiSig{1}(iiLPos),iiSig{2}(iiTNeg)))=2;
%grouping_idx(intersect(iiSig{3}(iiPPos),iiSig{2}(iiTNeg)))=3;

%grouping_idx(iiSig{3}(iiPNeg))=2;
%grouping_idx(iiSig{3})=3;
%grouping_idx(setdiff(totalActiveElecsJustDA,iiAC))=3;
%grouping_idx(iiA)=4;
% grouping_idx(ii6)=6;
%cfg.elec_size=150;
cfg.hemisphere='l';

plot_subjs_on_average_grouping(subj_labels, grouping_idx, 'fsaverage', cfg);

cfg.hemisphere='r';

%cfg.elec_colors=[1 1 1;0 1 0;0 0 1;1 0 0];
plot_subjs_on_average_grouping(subj_labels, grouping_idx, 'fsaverage', cfg);
