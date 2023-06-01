% bpoole
% 07/07/09
% eval_all.m
% evaluate all models on decoding move vs rest state

LOCAL = 0;


if LOCAL
    data_path='/mnt/y5/Spiff/ben/all_data0722';
    save_path='/mnt/y5/Spiff/ben/figs0727_3_3';
else
    spiff_nspike
    addpath(genpath('.'))
    save_path='/mnt/raid/Spiff/ben/figs0727_2_4_winwidth';
end
mkdir(save_path);

%%%%%%%%%%%%%%%%%%%%%%%%
% ANALYSIS PARAMETERS
%%%%%%%%%%%%%%%%%%%%%%%%
AParams.winwidth = 300;
AParams.Fs = 1000;
AParams.maxfreq = 250;
AParams.dt = AParams.winwidth/10;
AParams.tapers_time = AParams.winwidth / AParams.Fs;
AParams.modes = 3;
AParams.max_modes = 20;
AParams.comps = 3;

%%%%%%%%%%%%
% RECORDINGS
%%%%%%%%%%%%
global REC_DB RECS;
db_init();
db_add('090107','011',[3 2 1]);
db_add('090115','004',3:2:7);
db_add('090114','007',[2:5 7]);
db_add('090114','008',[2:5 7]);
%db_add('080806','008',[2 4 8]);
%db_add('090107','012',[1 2 3]);%3


db_set_all('sys','P');
db_set_all('bn',[-2000 4000]);
db_set_all('state','Move');


for r=1:length(REC_DB)

    fprintf('*************\n RECORDING %d\n*************\n',r);
    rec = REC_DB{r}

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % LOAD JOYSTICK AND NEURAL DATA
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    tic,fprintf('Loading neural data...');
    %try
    if LOCAL
         out_dir= fullfile(data_path,rec.day);
	 out_file = fullfile(out_dir,['data_rec' rec.rec 'ch' num2str(rec.ch) '.mat']);
	 load(out_file);
   else
       [Train, Test] = load_data(rec);
   end
   fprintf('done in %f\n',toc);

   % Incorporate parameters
   Train.AParams = AParams;

    %% FEATURE SELECTION

   tic,fprintf('Computing features...');
    if ~LOCAL
	AParams.SVDParams = feat_calc(AParams,rec);
    end
    fprintf('done in %f\n',toc);
    %catch
    %	keyboard
    %	continue
    %end

    %% Project Training data
   tic,fprintf('Projecting training data...');
    [obs.feats obs.rests obs.moves obs.state_seq obs.joy_seq] = project(AParams,Train,AParams.SVDParams);
   fprintf('done in %f\n',toc);


    tic,fprintf('Training GMM...');
    GMM = GMM_train(AParams, obs.feats(obs.rests,:),obs.feats(obs.moves,:),AParams.SVDParams);
    fprintf('done in %f\n',toc);
    
    tic,fprintf('Training HMM...');
    [HMM, HIP]= HMM_train(AParams,obs, GMM);
    fprintf('done in %f\n',toc);




    %%%%%%%%%%%%%%%
    % TEST MODELS
    %%%%%%%%%%%%%%%

    % Project test data
    tic,fprintf('Projecting testing data...');
    test = obs;
    %[test.feats test.rests test.moves test.state_seq test.joy_seq] = project(AParams,Test,AParams.SVDParams);
    %keyboard
    fprintf('done in %f\n',toc);

    % Test
    GMM_P = GMM_run(GMM,test.feats);
    HMM_P = HMM_run(HMM,test.feats);


    % Evaluate
    state_seq = test.state_seq - 1;
    joy_seq = test.joy_seq - 1;
    J = Train.joy_raw(1:30:end)*15;
    J = J(1:length(joy_seq));
    joy_seq(:) = 0;
    joy_seq(J > std(J) ) = 1;

    
    GMM_CS = {};
    for i=1:size(GMM_P,2)
	GMM_CS{i} = confusion_matrix(GMM_P(:,i)',state_seq);
    end
    GMM_CJ = confusion_matrix(GMM_P,joy_seq);

    HMM_CS = confusion_matrix(HMM_P,state_seq);%HIP(:,1)',state_seq);
    HMM_CJ = confusion_matrix(HMM_P,joy_seq);

    % Save
    save_trial
end


