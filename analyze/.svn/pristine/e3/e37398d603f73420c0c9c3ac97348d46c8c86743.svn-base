

LOCAL = 1;


if LOCAL
    data_path='/home/poolio/skf/data/';
    save_path='/home/poolio/skf/out1121/';
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
	Train.AParams.SVDParams = AParams.SVDParams;
    end
    fprintf('done in %f\n',toc);


    %% Project Training data
   tic,fprintf('Projecting training data...');
    train = project(AParams,Train,AParams.SVDParams);
   fprintf('done in %f\n',toc);



    %%%%%%%%%%%%%%%
    % TEST MODELS
    %%%%%%%%%%%%%%%

    % Project test data
    tic,fprintf('Projecting testing data...');
    test = project(AParams,Test,AParams.SVDParams);
    %keyboard
    fprintf('done in %f\n',toc);

    save_rec_data
end


