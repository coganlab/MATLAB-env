
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
DUKEDIR = ['H:\Box Sync\CoganLab\D_Data\Neighborhood_Sternberg'];
sigMatAll=[];
sigMatAllZ=[];
for iSN=1:length(SNList);
    SN=SNList(iSN);
    load([DUKEDIR '/Output/' Subject(SN).Name '_NeighborhoodSternberg_ClusterTime_5FreqBands_2Tails_bw6_DelayWvsNW.mat']);
    sigMat=zeros(length(actClustD),5,40);
    sigMatZ=zeros(length(actClustD),5,40);
    for iChan=1:length(actClustD)
        for iF=1:5;
            zVals=[];
            for iZ=1:length(actClustD{iChan}{iF}.Z)
                zVals(iZ)=actClustD{iChan}{iF}.Z{iZ};
            end
            for iZ=1:length(zVals)
                if zVals(iZ)>actClustD{iChan}{iF}.permZ95
                    sigMat(iChan,iF,actClustD{iChan}{iF}.Start{iZ}:actClustD{iChan}{iF}.Start{iZ}+actClustD{iChan}{iF}.Size{iZ}-1)=1;
                end
            end
            sigMatZ(iChan,iF,:)=zValsRawActD{iChan}{iF};
        end
    end
    sigMatAll=cat(1,sigMatAll,sigMat);
    sigMatAllZ=cat(1,sigMatAllZ,sigMatZ);
    display(SN)
end
