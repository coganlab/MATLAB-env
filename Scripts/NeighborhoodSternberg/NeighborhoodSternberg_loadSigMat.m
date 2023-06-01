


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
%Subject(31).Name='D31';
sigMatSAll=[];
sigMatAAll=[];
sigMatDAll=[];
sigMatRAll=[];
elecsAll=[];
zValsRawActSAll=[];
zValsRawActAAll=[];
zValsRawActDAll=[];
zValsRawActRAll=[];

DUKEDIR = ['H:\Box Sync\CoganLab\D_Data\Neighborhood_Sternberg'];
for iSN=1:length(SNList);
    SN=SNList(iSN);
  %  load([DUKEDIR '\Output\' Subject(SN).Name '_NeighborhoodSternberg_ClusterTime_5FreqBands_1Tails.mat']);
      load([DUKEDIR '\Output\' Subject(SN).Name '_NeighborhoodSternberg_ClusterTime_5FreqBands_2Tails_bw6.mat']);    
    %  load([DUKEDIR '/Output/' Subject(SN).Name '_NeighborhoodSternberg_ClusterTime_5FreqBands_1Tails_AuditoryCollapse.mat']);

    [sigMatS, sigMatA, sigMatD, sigMatR zValsRawS,zValsRawA,zValsRawD,zValsRawR]=convertActClust(actClustS,actClustA,actClustD,actClustR,zValsRawActS,zValsRawActA,zValsRawActD,zValsRawActR,SN);
  % [sigMatA,zValsRawA]=convertActClust1(actClustA,zValsRawActA,SN);

    elecs=list_electrodes_from_experiment(Subject(SN).Name);
    
sigMatSAll=cat(1,sigMatSAll,sigMatS);
sigMatAAll=cat(1,sigMatAAll,sigMatA);
sigMatDAll=cat(1,sigMatDAll,sigMatD);
sigMatRAll=cat(1,sigMatRAll,sigMatR);

elecsAll=cat(1,elecsAll,elecs);
zValsRawActSAll=cat(1,zValsRawActSAll,zValsRawS);
zValsRawActAAll=cat(1,zValsRawActAAll,zValsRawA);
zValsRawActDAll=cat(1,zValsRawActDAll,zValsRawD);
zValsRawActRAll=cat(1,zValsRawActRAll,zValsRawR);

end
