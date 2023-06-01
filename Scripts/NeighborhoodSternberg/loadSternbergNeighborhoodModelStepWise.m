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
%SNList=[29,30,31];

%Subject(30).Name='D30'; 
%Subject(31).Name='D31';
nPerm=1000;
numTails=1;
zThresh=1.6449;
DUKEDIR = ['H:\Box Sync\CoganLab\D_Data\Neighborhood_Sternberg'];
pvalsAll=[];
bvalsAll=[];
modelFAll=[];
modelPAll=[];
for iSN=1:length(SNList);
    clear pvalsS
    clear bvalsS
    clear modelF modelP
SN=SNList(iSN);
load([DUKEDIR '/Output/' Subject(SN).Name '_NeighborhoodSternberg_Model_Stepwise.mat']);

for iChan=1:length(mdlCF)
    for iF=1:5;
        tbl=mdlCF{iChan}{iF}.Coefficients;
        tbl2=table2array(tbl);
        prop=tbl.Properties;
        pval=nan(4,1);
        bval=nan(4,1);
        for iR=1:size(tbl,1)
            if strcmp(prop.RowNames{iR},'(Intercept)')
                pval(1)=tbl2(iR,4);
                bval(1)=tbl2(iR,1);
            elseif strcmp(prop.RowNames{iR},'Length')
                pval(2)=tbl2(iR,4);
                bval(2)=tbl2(iR,1);
            elseif strcmp(prop.RowNames{iR},'Lex_1')
                pval(3)=tbl2(iR,4);
                bval(3)=tbl2(iR,1);
            elseif strcmp(prop.RowNames{iR},'Length:Lex_1')
                pval(4)=tbl2(iR,4);
                bval(4)=tbl2(iR,1);
            end
            
        end
    [p f]=coefTest(mdlCF{iChan}{iF});
    modelF(iChan,iF)=f;
    modelP(iChan,iF)=p;
        
        pvalsS(iChan,iF,:)=pval;
        bvalsS(iChan,iF,:)=bval;
    end

end
pvalsAll=cat(1,pvalsAll,pvalsS);
bvalsAll=cat(1,bvalsAll,bvalsS);
modelFAll=cat(1,modelFAll,modelF);
modelPAll=cat(1,modelPAll,modelP);
end

iiPHG=intersect(find(sq(modelPAll(:,5))<.05),iiNWM);
iiPG=intersect(find(sq(modelPAll(:,4))<.05),iiNWM);
iiPB=intersect(find(sq(modelPAll(:,3))<.05),iiNWM);
iiPA=intersect(find(sq(modelPAll(:,2))<.05),iiNWM);
iiPT=intersect(find(sq(modelPAll(:,1))<.05),iiNWM);





iF=4;
fLength=isfinite(sq(bvalsAll(:,iF,2)));
fLex=isfinite(sq(bvalsAll(:,iF,3)));
fLengthLex=isfinite(sq(bvalsAll(:,iF,4)));

fLengthP=isfinite(sq(pvalsAll(:,iF,2)));
fLexP=isfinite(sq(pvalsAll(:,iF,3)));
fLengthLexP=isfinite(sq(pvalsAll(:,iF,4)));

iifLength=intersect(find(fLength==1),iiNWM);
iifLex=intersect(find(fLex==1),iiNWM);
iifLengthLex=intersect(find(fLengthLex==1),iiNWM);

iifLengthP=intersect(find(fLengthP==1),iiNWM);
iifLexP=intersect(find(fLexP==1),iiNWM);
iifLengthLexP=intersect(find(fLengthLexP==1),iiNWM);

iifLengthP=intersect(iifLengthP,find(sq(pvalsAll(:,iF,2))<.05));
iifLexP=intersect(iifLexP,find(sq(pvalsAll(:,iF,3))<.05));
iifLengthLexP=intersect(iifLengthLexP,find(sq(pvalsAll(:,iF,4))<.05));

iiLengthfP=intersect(iifLength,find(sq(bvalsAll(:,iF,2))>0));
iiLengthfN=intersect(iifLength,find(sq(bvalsAll(:,iF,2))<0));

iiLexfP=intersect(iifLex,find(sq(bvalsAll(:,iF,3))>0));
iiLexfN=intersect(iifLex,find(sq(bvalsAll(:,iF,3))<0));

iiLengthLexfP=intersect(iifLengthLex,find(sq(bvalsAll(:,iF,4))>0));
iiLengthLexfN=intersect(iifLengthLex,find(sq(bvalsAll(:,iF,4))<0));



