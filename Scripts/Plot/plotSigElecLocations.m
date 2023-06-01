global BOX_DIR
global RECONDIR
global TASK_DIR
global experiment
global DUKEDIR
BOX_DIR='C:\Users\gcoga\Box';
RECONDIR='C:\Users\gcoga\Box\ECoG_Recon';

addpath(genpath([BOX_DIR '\CoganLab\Scripts\']));
addpath(genpath([RECONDIR]));

Task=[];
Task.Name='Phoneme_Sequencing';
Task.Epoch(1).Name='Auditory';
Task.Epoch(2).Name='Maintenance';
Task.Epoch(3).Name='Go';
Task.Frequency='HighGamma';
TASK_DIR=([BOX_DIR '/CoganLab/D_Data/' Task.Name]);
DUKEDIR=TASK_DIR;

Subject = popTaskSubjectData(Task.Name);
Subject=Subject([1:12,14:15]); % get rid of D40 for phoneme sequencing!

for SN=1:length(Subject)
    [iiA iiGC]=setdiff(Subject(SN).goodChannels,Subject(SN).WM);
    for iE=1:length(Task.Epoch);
        load([TASK_DIR '/Stats/' Subject(SN).Name '_' Task.Name '_' Task.Epoch(iE).Name '_' Task.Frequency '_1Tail.mat'])
        pVals=pVals(:,1);
        iiA=find(pVals<.01);
        iiA=intersect(iiA,iiGC);
        iiSigE{SN}{iE}=iiA;
    end
end


idxAUD=[];
idxSM=[];
idxPROD=[];
counterA=0;
counterP=0;
counterS=0;
for SN=1:length(iiSigE)
        iiSM=intersect(iiSigE{SN}{1},iiSigE{SN}{3});
        iiAUD=setdiff(iiSigE{SN}{1},iiSM);
        iiPROD=setdiff(iiSigE{SN}{3},iiSM);
for iA=1:length(iiAUD)
    idxAUD{counterA+1}=Subject(SN).ChannelInfo(Subject(SN).goodChannels(iiAUD(iA))).Name;
    counterA=counterA+1;
end

for iP=1:length(iiPROD)
    idxPROD{counterP+1}=Subject(SN).ChannelInfo(Subject(SN).goodChannels(iiPROD(iP))).Name;
    counterP=counterP+1;
end

for iS=1:length(iiSM)
    idxSM{counterS+1}=Subject(SN).ChannelInfo(Subject(SN).goodChannels(iiSM(iS))).Name;
    counterS=counterS+1;
end
end

plot_subjs_on_average_grouping(idxAUD,2*ones(length(idxAUD),1),'fsaverage');
        
plot_subjs_on_average_grouping(idxSM,ones(length(idxSM),1),'fsaverage');
       
plot_subjs_on_average_grouping(cat(2,idxAUD,idxSM),ones(length(idxSM)+length(idxAUD),1),'fsaverage');
        
        
        
        
        