phonSeq={'D18','D19','D20','D22','D23','D24','D25','D26','D27','D28','D29'}; % add 31
phonSeqElecs=list_electrodes(phonSeq);
phonSeqGrouping=22*ones(length(phonSeqElecs),1);
cfg.hemisphere = 'l';
plot_subjs_on_average_grouping(phonSeqElecs,phonSeqGrouping,'fsaverage',cfg);
cfg.hemisphere = 'r';
plot_subjs_on_average_grouping(phonSeqElecs,phonSeqGrouping,'fsaverage',cfg);

sternbergN={'D23','D24','D25','D26','D27','D28','D29','D30'}; % add 31
sternbergNElecs=list_electrodes(sternbergN);
sternbergNGrouping=22*ones(length(sternbergNElecs),1);
cfg.hemisphere = 'l';
plot_subjs_on_average_grouping(sternbergNElecs,sternbergNGrouping,'fsaverage',cfg);
cfg.hemisphere = 'r';
plot_subjs_on_average_grouping(sternbergNElecs,sternbergNGrouping,'fsaverage',cfg);


sentenceRep={'D3','D4','D5','D6','D7','D8','D9','D10','D12','D13','D14','D15','D16','D17','D18','D19','D20','D22','D23','D24','D26','D27','D28','D29','D30'}; % add 11,31
sentenceRepElecs=list_electrodes(sentenceRep);
sentenceRepGrouping=22*ones(length(sentenceRepElecs),1);
cfg.hemisphere = 'l';
plot_subjs_on_average_grouping(sentenceRepElecs,sentenceRepGrouping,'fsaverage',cfg);
cfg.hemisphere = 'r';
plot_subjs_on_average_grouping(sentenceRepElecs,sentenceRepGrouping,'fsaverage',cfg);