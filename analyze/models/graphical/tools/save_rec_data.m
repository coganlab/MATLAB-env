%SAVE_TRIAL Save model results from a recording session

out_dir = fullfile(save_path,rec.day);
mkdir(out_dir);

base_file = fullfile(out_dir,['rec' rec.rec 'ch' num2str(rec.ch)]);

out_file = [base_file '.mat'];
save(out_file,'Train','Test','train','test','AParams');
