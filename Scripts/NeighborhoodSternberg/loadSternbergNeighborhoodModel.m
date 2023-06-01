duke;

Subject=[];


filedir=['H:\Box Sync\CoganLab\ECoG_Task_Data\Cogan_Task_Data'];
Subject(23).Name='D23'; Subject(23).Prefix = '/Sternberg/D23_Sternberg_trialInfo'; Subject(23).Day = '180718';
Subject(24).Name='D24'; Subject(24).Prefix = '/Sternberg/D24_Sternberg_trialInfo'; Subject(24).Day = '181028';
Subject(26).Name='D26'; Subject(26).Prefix = '/Sternberg/D26_Sternberg_trialInfo'; Subject(26).Day = '190128';
Subject(27).Name='D27'; Subject(27).Prefix = '/Neighborhood Sternberg/D27_Sternberg_trialInfo'; Subject(27).Day = '190304';
Subject(28).Name='D28'; Subject(28).Prefix = '/Neighborhood Sternberg/D28_Sternberg_trialInfo';  Subject(28).Day = '190302';
Subject(29).Name='D29'; Subject(29).Prefix = '/NeighborhoodSternberg/D29_Sternberg_trialInfo';  Subject(29).Day = '190315';
Subject(30).Name='D30'; Subject(30).Prefix = '/NeighborhoodSternberg/D30_Sternberg_trialInfo'; Subject(30).Day = '190413';
Subject(31).Name='D31'; Subject(31).Prefix = '/NeighborhoodSternberg/D31_Sternberg_trialInfo'; Subject(31).Day = '190423';

SNList=[23,26,27,28,29,30,31];


%Subject(30).Name='D30'; 
cValsAll=[];
pValsAll=[];
DUKEDIR = ['H:\Box Sync\CoganLab\D_Data\Neighborhood_Sternberg'];
for iSN=1:length(SNList);
    SN=SNList(iSN);
    
load([DUKEDIR '/Output/' Subject(SN).Name '_NeighborhoodSternberg_Model.mat']);
%load([DUKEDIR '/Output/' Subject(SN).Name '_NeighborhoodSternberg_Model_OnlyCorrect.mat']);
%load([DUKEDIR '/Output/' Subject(SN).Name '_NeighborhoodSternberg_Model_CorrectPred.mat']);

cValsAll=cat(1,cValsAll,cvals);
pValsAll=cat(1,pValsAll,pvals);
end

iiPvalsActiveHG=intersect(find(sq(pValsAll(:,5,1))<.05),iiNWM);
iiPvalsLengthHG=intersect(find(sq(pValsAll(:,5,2))<.05),iiNWM);
iiPvalsLexHG=intersect(find(sq(pValsAll(:,5,3))<.05),iiNWM);
iiPvalsLengthLexHG=intersect(find(sq(pValsAll(:,5,4))<.05),iiNWM);

iiPvalsActiveG=intersect(find(sq(pValsAll(:,4,1))<.05),iiNWM);
iiPvalsLengthG=intersect(find(sq(pValsAll(:,4,2))<.05),iiNWM);
iiPvalsLexG=intersect(find(sq(pValsAll(:,4,3))<.05),iiNWM);
iiPvalsLengthLexG=intersect(find(sq(pValsAll(:,4,4))<.05),iiNWM);

iiPvalsActiveB=intersect(find(sq(pValsAll(:,3,1))<.05),iiNWM);
iiPvalsLengthB=intersect(find(sq(pValsAll(:,3,2))<.05),iiNWM);
iiPvalsLexB=intersect(find(sq(pValsAll(:,3,3))<.05),iiNWM);
iiPvalsLengthLexB=intersect(find(sq(pValsAll(:,3,4))<.05),iiNWM);

iiPvalsActiveA=intersect(find(sq(pValsAll(:,2,1))<.05),iiNWM);
iiPvalsLengthA=intersect(find(sq(pValsAll(:,2,2))<.05),iiNWM);
iiPvalsLexA=intersect(find(sq(pValsAll(:,2,3))<.05),iiNWM);
iiPvalsLengthLexA=intersect(find(sq(pValsAll(:,2,4))<.05),iiNWM);

iiPvalsActiveT=intersect(find(sq(pValsAll(:,1,1))<.05),iiNWM);
iiPvalsLengthT=intersect(find(sq(pValsAll(:,1,2))<.05),iiNWM);
iiPvalsLexT=intersect(find(sq(pValsAll(:,1,3))<.05),iiNWM);
iiPvalsLengthLexT=intersect(find(sq(pValsAll(:,1,4))<.05),iiNWM);