%SAVE_TRIAL Save model results from a recording session

out_dir = fullfile(save_path,rec.day);
mkdir(out_dir);

base_file = fullfile(out_dir,['rec' rec.rec 'ch' num2str(rec.ch)]);

out_file = [base_file '.mat'];
save(out_file,'HMM','GMM','AParams','rec','obs','test','HMM_CS','HMM_CJ','GMM_CS','GMM_CJ','GMM_P','HMM_P','HIP','state_seq','joy_seq','Test','Train');
