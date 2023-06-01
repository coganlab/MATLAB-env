neural_chan_index=[1:55,65:124,129:170];

dataFile{1}=[fileDir 'D_Data\D46_Seizures\D46 SEIZURE1.edf'];
dataFile{2}=[fileDir 'D_Data\D46_Seizures\D46 SEIZURE2.edf'];
dataFile{3}=[fileDir 'D_Data\D46_Seizures\D46 SEIZURE3.edf'];
dataFile{4}=[fileDir 'D_Data\D46_Seizures\D46 SEIZURE4.edf'];
dataFile{5}=[fileDir 'D_Data\D46_Seizures\D46 SEIZURE5.edf'];
dataFile{6}=[fileDir 'D_Data\D46_Seizures\D46 MUSIC NO SEIZURE.edf'];




iD=6;
rec='001';
taskdate='200312';
edf_filename=dataFile{iD};
ieeg_prefix='D46_MusicNoSeizure_';
   % [header d]=edfread(edf_filename);
  %  labels=labels(nChans);
write_experiment_file;
clear d
    
[SPEC, F] = tfspec(sig, [0.5 10], 1024, 0.05, 500, 1, [], [], 1, []); 

figure;tvimage(SPEC./mean(SPEC(1:50,:)))
caxis([0.7 15])