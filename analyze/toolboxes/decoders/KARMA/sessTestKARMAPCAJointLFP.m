function Results = sessTestKARMAPCAJointLFP(Sess, Tower, KARMAParams, JointParams, LFPParams, monkeydir, result_filename)
%
%  [Results, JointParams] = sessTestKARMAJoint(Sess, Tower, KARMAparams, JointParams, LFPParams, monkeydir, result_filename)
%
%  Inputs:  Session = MocapSession from Behavior Database;
%           Towers = Cell array or string.  Tower/s to analyze
%               {'L_PMd','R_PMd'} to pool L_PMd and R_PMd
%               'L_PMd' or {'L_PMd'} for L_PMd alone.
%
%           KARMAParams.neural_lag = Scalar.  Number of bins to lag neural data in ARMA model.
%                   Defaults to 10;
%           KARMAParams.observed_lag = Scalar.  Number of bins to lag joint data in ARMA model.
%                   Defaults to 10;
%           KARMAParams.gamma = Scalar.  Gamma coefficient for SVR.
%                   Defaults to 0.0003;
%           KARMAParams.C = Scalar.  C coefficient for SVR.
%                   Defaults to 4
%           KARMAParams.Shrinking = Scalar. Whether to shrink coeffs.
%                   Defaults to 0.
%           KARMAParams.data_lag = Scalar.  Duration in ms to shift neural data with respect to joint data.
%                   Defaults to 0;  -ve shifts neural data before joint data.
%           KARMAParams.bin_width = Scalar. Duration to bin vectors before passing to decode.
%                   Defaults to 50  (ms).  
%                   Note: This needs to match spectral binning time
%           KARMAParams.Model.AllPCA
%           KARMAParams.Model.AllOrig
%           KARMAParams.Model.AllLinear
%           KARMAParams.Model.Orig
%           KARMAParams.Model.FullPCA
%	    KARMAParams.Objective = String. 'ElasticNet' or 'SVR'
%	    KARMAParams.alpha =  Scalar. For 'ElasticNet'
%	    KARMAParams.lambda = Scalar.  For 'ElasticNet'
%	    KARMAParams.Joint_RBF_sigma = Scalar.  For 'ElasticNet'
%	    KARMAParams.Neural_RBF_sigma = Scalar. For 'ElasticNet'
%		KARMAParams.RBF_alpha = Scalar. For 'ElasticNet'
%
%           JointParams.JointParams.nDim: Scalar. Number of PCA dims to use for Joint decomposition.
%                   Defaults to 10.
%           JointParams.JointParams.U; - Eigenmodes for joint decomposition
%                   Defaults to those generated from training data.
%           JointParams.JntFile = file name of jnt file
%                   Defaults to ''.
%
%           LFPParams.tapers = [N,W] Multitaper spectral parameters
%                   Defaults to [.5,5] - seconds and Hz
%           LFPParams.fk = Scalar.  Frequency range to include in decoder.
%                   Defaults to 200
%           LFPParams.dn = Scalar.
%                   Defaults to KARMAParams.bin_width
%           LFPParams.pad = Scalar.
%                   Defaults to 2.
%           LFPParams.samplingrate = Scalar.  Sampling rate of LFP.
%                   Defaults to 1e3
%           LFPParams.nDim = Scalar. Number of spectral dimensions to include in decoder.
%                   Defaults to 40
%           LFPParams.bin_time  =  Scalar. Test and train bin width (in minutes)
%                   Defaults to -1.  All data.
%           LFPParams.channels = Scalar or Array.  List of channels to analyze.  
%                   Defaults to all channels.
%                   Note: -1 indicates spiking channels only.
%
%	    result_filename = String for saving results?
%
%  Outputs:  Results = 
%

 cache = 0;
 if(cache)
     disp('WARNING: CACHING LFP PCA AND SPECTRAL VALUES ACROSS INVOCATIONS');
%     persistent PCALfpCache;
     persistent lfpspec_cache;
%     persistent PCAJoint;
%     persistent PCAJoint_full;
%     persistent JointParams;
%     persistent JointParams_full;
 else
%     PCALfpCache = []; % hack for now
     lfpspec_cache = [];
%     PCAJoint = [];
%     PCAJoint_full = [];
%     JointParams = [];
%     JointParams_full = [];
 end

 
CVflag = 0;  %  Don't do the test-train split twice.  Cut processing by 50%
if nargin < 6
    global MONKEYDIR
    monkeydir = MONKEYDIR;
    monkeydir = ['/vol/sas2a/Jester_PMd_PMv_LMF/' monkeydir];
end

day = sessDay(Sess);
recs = sessRec(Sess);

% Prepare data (same as Kalman Filter prep) - note bin size is larger
if nargin < 3 || isempty(KARMAParams)
    KARMAParams = [];
end

AllPCAflag = 1;
AllOrigflag = 1;
AllLinearflag = 1;
Origflag = 1;
FullPCAflag = 1;
if isfield(KARMAParams,'Model')
    if isfield(KARMAParams.Model,'AllPCA')
        AllPCAflag = KARMAParams.Model.AllPCA;
    end
    if isfield(KARMAParams.Model,'AllOrig')
        AllOrigflag = KARMAParams.Model.AllOrig;
    end
    if isfield(KARMAParams.Model,'Orig')
        Origflag = KARMAParams.Model.Orig;
    end
    if isfield(KARMAParams.Model,'FullPCA')
        FullPCAflag = KARMAParams.Model.FullPCA;
    end
    if isfield(KARMAParams.Model,'AllLinear')
        AllLinearflag = KARMAParams.Model.AllLinear;
    end
end
    
if ~isfield(KARMAParams, 'neural_lag')
    neural_lag = 10;
else 
    neural_lag = KARMAParams.neural_lag;
end
if ~isfield(KARMAParams, 'observed_lag')
    observed_lag = 10;
else
    observed_lag = KARMAParams.observed_lag;
end
if ~isfield(KARMAParams, 'gamma') % SVR
    gamma = 0.0003;
else
    gamma = KARMAParams.gamma;
end
if ~isfield(KARMAParams, 'C') % SVR
    C = 0.001;
else
    C = KARMAParams.C;
end
if ~isfield(KARMAParams, 'lambda') % Elasticnet
	lambda = 0.001;
else
        lambda = KARMAParams.lambda;
end
if ~isfield(KARMAParams, 'alpha') % Elasticnet
	alpha = 0.2;
else
        alpha = KARMAParams.alpha;
end
if ~isfield(KARMAParams, 'Neural_RBF_sigma') % Elasticnet
        Neural_RBF_sigma = 0.2;
else
        Neural_RBF_sigma = KARMAParams.Neural_RBF_sigma;
end
if ~isfield(KARMAParams, 'Joint_RBF_sigma') % Elasticnet
	Joint_RBF_sigma = 0.2;
else    
        Joint_RBF_sigma = KARMAParams.Joint_RBF_sigma;
end     
if ~isfield(KARMAParams, 'RBF_alpha') % Elasticnet
	RBF_alpha = 0.5;
else    
        RBF_alpha = KARMAParams.RBF_alpha;
end    

if ~isfield(KARMAParams, 'Shrinking') % SVR
    Shrinking = 0;
else
    Shrinking = KARMAParams.Shrinking;
end
if ~isfield(KARMAParams, 'bin_width') 
    bin_width = 50;
else
    bin_width = KARMAParams.bin_width;
end
if ~isfield(KARMAParams, 'data_lag') 
    data_lag = 0;
else
    data_lag = KARMAParams.data_lag;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin < 4 || isempty(JointParams)
    JointParams = [];
end
if ~isfield(JointParams,'JointList')
  markerset = sessMocapMarkerset(Sess);
  JointList = whichJointNames(markerset{1}); 
else
    JointList = JointParams.JointList;
end
if ~isfield(JointParams,'JntFile') 
    joint_file_name = [];


else
    joint_file_name = JointParams.JntFile;

    joint_file_name = [joint_file_name '.'];
end
if ~isfield(JointParams,'PCAParams')
	JointParams.PCAParams.nDim = 10;
end

if nargin < 5 || isempty(LFPParams)
    LFPParams = [];
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~isfield(LFPParams, 'channels')
    channels = -1;
else
    channels = LFPParams.channels;
end
if ~isfield(LFPParams, 'nDim')
    numLFPDim = 50;
else
    numLFPDim = LFPParams.nDim;
end
if ~isfield(LFPParams, 'bin_time')
    bin_time = -1;
else
    bin_time = LFPParams.bin_time;
end
if ~isfield(LFPParams, 'tapers')
    tapers = [0.5,5];
else
    tapers = LFPParams.tapers;
end
if ~isfield(LFPParams, 'sampling_rate')
    sampling_rate = 1e3;
else
    sampling_rate = LFPParams.sampling_rate;
end
if ~isfield(LFPParams, 'dn')
    dn = bin_width./1e3;
else
    dn = LFPParams.dn;
end
if ~isfield(LFPParams, 'fk')
    fk = 200;
else
    fk = LFPParams.fk;
end
if ~isfield(LFPParams, 'pad')
    pad = 2;
else
    pad = LFPParams.pad;
end

N = tapers(1);
W = tapers(2);


disp(['Using spectral hop size of ' num2str(bin_width) 'ms']);

tic

path = strcat(monkeydir, '/', day, '/', recs{1}, '/rec', recs{1});
load([path, '.Body.' joint_file_name 'Joint.mat'])
load([path, '.Body.' joint_file_name 'joint_names.mat'])
[dum,ind] = intersect(joint_names,JointList);
Joint = Joint(sort(ind));
joint_names = joint_names(sort(ind));

%  All this snipping business is very old.  The joint data needs to be
%  trimmed together with the neural data.
% 
% IntervalFile = [MONKEYDIR '/' day '/mat/rec' recs{1} '.Interval.mat'];
% if exist(IntervalFile,'file')
%     disp('Interval file')
%     load(IntervalFile);
%     Joint = snipJoint(Joint,Interval);
% end
% 
% nJoint = length(Joint);
% for iJoint = 1:length(Joint)
%     ind = find(~isnan(Joint{iJoint}(2,:)));
%     Joint{iJoint} = Joint{iJoint}(:,ind);
% end
% 
% ind = find(Joint{1}(2,:)>0);
% tmpJoint = Joint;
% for iJoint = 1:length(Joint)
%     tmpJoint{iJoint} = Joint{iJoint}(:,ind);
% end

disp('joint pca');
% if (isempty(PCAJoint))
    PCAParams_in = JointParams.PCAParams;
    [dum, PCAParams] = processPCAJoint(Joint, PCAParams_in);
    [PCAJoint, PCAParams] = processPCAJoint(Joint,PCAParams);
    
    PCAParams_full.nDim = length(Joint);
    [dum_full, PCAParams_full] = processPCAJoint(Joint, PCAParams_full);
    [PCAJoint_full, PCAParams_full] = processPCAJoint(Joint, PCAParams_full);

% end

[LinearJoint,LinearJointParams] = linearizeJointAngles(Joint);

experiment = loadExperiment(day, recs{1}, monkeydir);

if (isempty(lfpspec_cache))
    if iscell(Tower)
        rawlfp = [];
        for iTower = 1:length(Tower)
            numtowerchannels = expNumChannels(experiment, Tower{iTower});
            fid = fopen([path '.' Tower{iTower} '.lfp.dat']);
            lfpdata = fread(fid, [numtowerchannels,inf], 'float');
            rawlfp = [rawlfp; lfpdata];
            fclose(fid);
        end
    elseif ischar(Tower)
        numtowerchannels = expNumChannels(experiment, Tower);
        fid = fopen([path '.' Tower '.lfp.dat']);
        rawlfp = fread(fid, [numtowerchannels,inf], 'float');
        fclose(fid);
    end
    whos rawlfp
    lfpspec = tfspec(rawlfp, [N,W], sampling_rate, dn, fk,pad);
    
    %  Figure out the spiking channels
    %  or use all if specified
    
    if (length(channels) == 1) && (channels==-1)
        disp('Only considering spiking channels');
        cd([monkeydir '/m/depth/']); %  Not sure about this ...
        allendSP = [];
        for iTower = 1:length(Tower);
            eval(['Movement_' Tower{iTower} '_' day]);
            allendSP = [allendSP endSP];
        end
        spikingchannels = find(allendSP);
        lfpspec = lfpspec(spikingchannels, :, :);
    else
        lfpspec = lfpspec(channels, :, :);
    end
    lfpspec_cache = lfpspec;
end
% compute PCA of LFP features
lfpspec = lfpspec_cache;

PCAParamsLFP.nDim = numLFPDim;
%if (isempty(PCALfpCache))
    whos lfpspec
    [PCALfpCache, PCAParamsLFP] = processPCALFP(lfpspec, PCAParamsLFP);
%end
PCALfp = PCALfpCache;

% take data from a single recording and split into two pieces.
for iJoint = 1:length(PCAJoint)
    tmp = PCAJoint{iJoint};
    tmp2(:,1) = tmp(1,:)';
    tmp2(:,2) = tmp(2,:)';
    PCAJoint2{iJoint} = tmp2;
end

for iJoint = 1:length(Joint)
    tmp = Joint{iJoint};
    tmp2(:,1) = tmp(1,:)';
    tmp2(:,2) = tmp(2,:)';
    Joint2{iJoint} = tmp2;
end

for iJoint = 1:length(LinearJoint)
   tmp = LinearJoint{iJoint};
   tmp2(:,1) = tmp(1,:)';
   tmp2(:,2) = tmp(2,:)';
   LinearJoint2{iJoint} = tmp2;
end


for iJoint = 1:length(PCAJoint_full)
    tmp = PCAJoint_full{iJoint};
    tmp2(:,1) = tmp(1,:)';
    tmp2(:,2) = tmp(2,:)';
    PCAJoint2_full{iJoint} = tmp2;
end

jointPos_linear = lfpbin(PCALfp, LinearJoint2, bin_width);
jointPos_orig = lfpbin(PCALfp, Joint2, bin_width);
jointPos_full = lfpbin(PCALfp, PCAJoint2_full, bin_width);
jointPos      = lfpbin(PCALfp, PCAJoint2, bin_width);

%align spectral shifted data
PCALfp(:,end-tapers(1)/dn+1:end) = [];
jointPos(1:tapers(1)/dn,:) = [];
jointPos_full(1:tapers(1)/dn,:) = [];
jointPos_orig(1:tapers(1)/dn,:) = [];
jointPos_linear(1:tapers(1)/dn,:) = [];

PCAlfp = double(PCALfp');

%whos PCALfp jointPos jointPosFull

toc

if(data_lag > 0)
    pad_points = ceil(data_lag/bin_width);
    disp(['Data Lag: Discarding first ' num2str(pad_points) ' samples of neural data.']);
    for iJoint = 1:size(jointPos,2)
        jointPos(:,iJoint) = [nan(pad_points,1); jointPos(1:end - pad_points,iJoint)];
    end 
    for iJoint = 1:size(jointPos_orig,2)
        jointPos_full(:,iJoint) = [nan(pad_points,1); jointPos_full(1:end - pad_points,iJoint)];
        jointPos_orig(:,iJoint) = [nan(pad_points,1); jointPos_orig(1:end - pad_points,iJoint)];
        jointPos_linear(:,iJoint) = [nan(pad_points,1); jointPos_linear(1:end - pad_points,iJoint)];
    end
elseif(data_lag < 0)
    pad_points = ceil(abs(data_lag/bin_width));
    disp(['Data lag: Discarding first ' num2str(pad_points) ' samples of joint data.']);
    for iJoint = 1:size(jointPos,2)
        jointPos(:,iJoint) = [jointPos(pad_points+1:end,iJoint); nan(pad_points,1)];
    end 
    for iJoint = 1:size(jointPos_orig,2)
        jointPos_full(:,iJoint) = [jointPos_full(pad_points+1:end,iJoint); nan(pad_points,1)];
        jointPos_orig(:,iJoint) = [jointPos_orig(pad_points+1:end,iJoint); nan(pad_points,1)];
        jointPos_linear(:,iJoint) = [jointPos_linear(pad_points+1:end,iJoint); nan(pad_points,1)];
    end
end

idx = find(~isnan(jointPos(:,1)) & jointPos(:,1)~=0);
PCAlfp = PCAlfp(idx,:);
jointPos = jointPos(idx,:);
jointPos_full = jointPos_full(idx,:);
jointPos_orig = jointPos_orig(idx,:);
jointPos_linear = jointPos_linear(idx,:);

if(bin_time < 0)
    X = jointPos;
    jointPosTrain = X(1:floor(end/2),:);
    jointPosTest = X(floor(end/2)+1:end,:);
    X_full = jointPos_full;
    jointPosTrain_full = X_full(1:floor(end/2),:);
    jointPosTest_full = X_full(floor(end/2)+1:end,:);
    X_orig = jointPos_orig;
    jointPosTrain_orig = X_orig(1:floor(end/2),:);
    jointPosTest_orig = X_orig(floor(end/2)+1:end,:);
    X_linear = jointPos_linear;
    jointPosTrain_linear = X_linear(1:floor(end/2),:);
    jointPosTest_linear = X_linear(floor(end/2)+1:end,:);

    PCAlfpTrain = PCAlfp(1:floor(end/2),:);
    PCAlfpTest = PCAlfp(floor(end/2)+1:end,:);
    %sample_rate = 30000;
    repeats = 2;
    loops = 1;
    total_repeats = 2;
else
    %bin_time is in minutes
    bin_time_ms = bin_time*60*1000;
    total_data = length(jointPos(:,1))*bin_width;
    repeats = floor(total_data/bin_time_ms);
    if(repeats < 2)
        error(['Bin width is too large. Max bin width is ' num2str(total_data/1000/60/2) ' minutes'])
    end
    total_repeats = -1;
    if(repeats > 4) 
        total_repeats = 4;
    else
        total_repeats = repeats;
    end
    loops = nchoosek(total_repeats,2)
end
%% KARMA
%not obviously stable to parameter variations
%linear-SVR-fit ARMA doesn't gaurantee stability of model
%very sensitive to form of neural input (i.e. smoothed vs unsmoothed) 
%have done coarse grid search on hyperparameters within fitKARMA (maybe
%need finer grid search as well)
%requires scaled inputs
X = jointPos;
X_orig = jointPos_orig;
X_linear = jointPos_linear;

unique_perms = [];
for iN = 1:total_repeats
   for j = 1:total_repeats
       if(j > iN)
            unique_perms = [unique_perms;iN,j];
       end
   end
end
if(loops~=size(unique_perms,1))
    disp('error in calculating permutations')
    pause
end
for iLoop = 1:loops
    if(loops > 1)
        first_pos = unique_perms(iLoop,1);
        second_pos = unique_perms(iLoop,2);
        bin_length = floor(length(jointPos)/repeats);
        jointPosTrain = X((first_pos-1)*bin_length+1:(first_pos)*bin_length,:);
        jointPosTest = X((second_pos-1)*bin_length+1:(second_pos)*bin_length,:);
	jointPosTrain_linear = X_linear((first_pos-1)*bin_length+1:(first_pos)*bin_length,:);
	jointPosTest_linear = X_linear((second_pos-1)*bin_length+1:(second_pos)*bin_length,:);
        PCAlfpTrain = PCAlfp((first_pos-1)*bin_length+1:(first_pos)*bin_length,:);
        PCAlfpTest = PCAlfp((second_pos-1)*bin_length+1:(second_pos)*bin_length,:);
    else
        
        X = jointPos;
        jointPosTrain = X(1:floor(end/2),:);
        jointPosTest = X(floor(end/2)+1:end,:);
        X_full = jointPos_full;
        jointPosTrain_full = X_full(1:floor(end/2),:);
        jointPosTest_full = X_full(floor(end/2)+1:end,:);
        X_orig = jointPos_orig;
        jointPosTrain_orig = X_orig(1:floor(end/2),:);
        jointPosTest_orig = X_orig(floor(end/2)+1:end,:);
	X_linear = jointPos_linear;
        jointPosTrain_linear = X_linear(1:floor(end/2),:);
	jointPosTest_linear = X_linear(floor(end/2)+1:end,:);

        PCAlfpTrain = PCAlfp(1:floor(end/2),:);
        PCAlfpTest = PCAlfp(floor(end/2)+1:end,:);
    end
        
    jointTrain = [jointPosTrain];% jointVelTrain];
    jointTest = [jointPosTest];% jointVelTest];
    jointTrain_full = [jointPosTrain_full];
    jointTest_full = [jointPosTest_full];
    jointTrain_orig = [jointPosTrain_orig];
    jointTest_orig = [jointPosTest_orig];
    jointTrain_linear = [jointPosTrain_linear];
    jointTest_linear = [jointPosTest_linear];


    if AllPCAflag
        AllPCAJointModel = parfitKARMA2(PCAlfpTrain, jointTrain, neural_lag, observed_lag, gamma, C, Shrinking);
        AllPCAJointPred = fast_karma_predict(PCAlfpTest, AllPCAJointModel);
        AllPCAJointPred = AllPCAJointPred';
    end
    if AllOrigflag
	    switch KARMAParams.Objective
		    case 'SVR'
        		AllOrigJointModel = parfitKARMA2(PCAlfpTrain, jointTrain_orig, neural_lag, observed_lag, gamma, C, Shrinking);
        		AllOrigJointPred = fast_karma_predict(PCAlfpTest, AllOrigJointModel);
			AllOrigJointPred = AllOrigJointPred';
		case 'ElasticNet'
			[AllOrigJointModel, AllOrigJointPred] = fit_and_predictElasticNet(PCAlfpTrain, jointTrain_orig, PCAlfpTest, neural_lag, observed_lag, alpha, lambda, Neural_RBF_sigma, Joint_RBF_sigma, RBF_alpha);
		end
    end
    if AllLinearflag
        switch KARMAParams.Objective
        case 'ElasticNet'
            			[AllLinearJointModel, AllLinearJointPred] = fit_and_predictElasticNet(PCAlfpTrain, jointTrain_linear, PCAlfpTest, neural_lag, observed_lag, alpha, lambda, Neural_RBF_sigma, Joint_RBF_sigma, RBF_alpha);
        end

    end
    if FullPCAflag
        FullPCAJointModel = cell(1,size(jointTrain_full,2));
        for iJointMode = 1:size(jointTrain_full,2)
            FullPCAJointModel{iJointMode} = parfitKARMA2(PCAlfpTrain, jointTrain_full(:,iJointMode), neural_lag, observed_lag, gamma, C, Shrinking);
        end
        FullPCAJointPred = zeros(size(jointTest_full))';
        for iJointMode = 1:size(jointTrain_full,2)
            FullPCAJointPred(iJointMode,:) = fast_karma_predict(PCAlfpTest, FullPCAJointModel{iJointMode});
        end
    end
    if Origflag
        OrigJointModel = cell(1,size(jointTrain_orig,2));
        OrigJointPred = zeros(size(jointTest_orig))';
        for iJoint = 1:size(jointTrain_orig,2)
            OrigJointModel{iJoint} = parfitKARMA2(PCAlfpTrain, jointTrain_orig(:,iJoint), neural_lag, observed_lag, gamma, C, Shrinking);
            OrigJointPred(iJoint,:) = fast_karma_predict(PCAlfpTest, OrigJointModel{iJoint});
        end
    end
    
    jointTest = jointTest';
    jointTest_orig = jointTest_orig';
    jointTest_linear = jointTest_linear';
    jointTest_full = jointTest_full';

    % Here, the regression does know about the other PCA modes, up to the
    % number in the PCAParams - ie 10
    if AllPCAflag
        nJointMode = size(jointTest,1);
        AllPCAKARMACorrCoef = zeros(1,nJointMode);
        for iJointMode = 1:nJointMode
            a = corrcoef(jointTest(iJointMode,:), AllPCAJointPred(iJointMode,:));
            AllPCAKARMACorrCoef(iJointMode) = a(2);
        end
    end
    % Here, the regression does not know about the other PCA modes
    if FullPCAflag
        nJointMode = size(jointTest_full,1);
        FullPCAKARMACorrCoef = zeros(1,nJointMode);
        for iJointMode = 1:nJointMode
            a = corrcoef(jointTest_full(iJointMode,:), FullPCAJointPred(iJointMode,:));
            FullPCAKARMACorrCoef(iJointMode) = a(2);
        end
    end
    % Here, the regression does know about the other joints
    if AllOrigflag
        nJoint = size(jointTest_orig,1);
        AllOrigKARMACorrCoef = zeros(1,nJoint);
        for iJoint = 1:nJoint
            a = corrcoef(jointTest_orig(iJoint,:), AllOrigJointPred(iJoint,:));
            AllOrigKARMACorrCoef(iJoint) = a(2);
        end
    end
    if AllLinearflag
        nJoint = size(jointTest_linear,1);
        AllLinearKARMACorrCoef = zeros(1,nJoint);
        for iJoint = 1:nJoint
            a = corrcoef(jointTest_linear(iJoint,:), AllLinearJointPred(iJoint,:));
            AllLinearKARMACorrCoef(iJoint) = a(2);
        end
    end
    % Here, the regression model does not know about the other joints
    if Origflag
        nJoint = size(jointTest_orig,1);
        OrigKARMACorrCoef = zeros(1,nJoint);
        for iJoint = 1:nJoint
            a = corrcoef(jointTest_orig(iJoint,:), OrigJointPred(iJoint,:));
            OrigKARMACorrCoef(iJoint) = a(2);
        end
    end
    % Here, we want to transform the joint modes to joints to assess
    % performance
    %
    %Start with the PCA regression which knows about all other modes up to
    %N
    if AllPCAflag
        nJoint = length(JointList);
        AllPCAReconJointPred = reconPCAJoint(AllPCAJointPred,PCAParams);
        for iJoint = 1:nJoint
            a = corrcoef(jointTest_orig(iJoint,:), AllPCAReconJointPred(iJoint,:));
            AllPCAReconKARMACorrCoef(iJoint) = a(2);
        end
    end
    % Next compute for the PCA regression which only knows about the same
    % modes and constitute from up to N modes.  Let's us determine if the
    % interactions across modes improves performance.
    if FullPCAflag
        nJoint = length(JointList);
        nDim = size(jointTest,1);
        PCAReconJointPred = reconPCAJoint(FullPCAJointPred(1:PCAParams.nDim,:),PCAParams);
        for iJoint = 1:nJoint
            a = corrcoef(jointTest_orig(iJoint,:), PCAReconJointPred(iJoint,:));
            PCAReconKARMACorrCoef(iJoint) = a(2);
        end
        % Next compute for the PCA regression which only knows about the same
        % modes and constitute from all modes.
        FullPCAReconJointPred = reconPCAJoint(FullPCAJointPred,PCAParams_full);
        FullPCAReconKARMACorrCoef = zeros(1,nJoint);
        for iJoint = 1:nJoint
            a = corrcoef(jointTest_orig(iJoint,:),FullPCAReconJointPred(iJoint,:));
            FullPCAReconKARMACorrCoef(iJoint) = a(2);
        end
    end
   
    if AllPCAflag
        Results.Joint(1+(iLoop-1)*2).PCA.AllCorrCoef = AllPCAKARMACorrCoef;
        Results.Joint(1+(iLoop-1)*2).PCA.AllPred = AllPCAJointPred;
        Results.Joint(1+(iLoop-1)*2).PCA.AllModel = AllPCAJointModel;
        Results.Joint(1+(iLoop-1)*2).Recon.AllPCACorrCoef = AllPCAReconKARMACorrCoef;
        Results.Joint(1+(iLoop-1)*2).Recon.AllPCAPred = AllPCAReconJointPred;
    end
    Results.Joint(1+(iLoop-1)*2).PCA.Test = jointTest;
    
    Results.Joint(1+(iLoop-1)*2).PCA.FullTest = jointTest_full;
    
    if AllOrigflag
        Results.Joint(1+(iLoop-1)*2).Orig.AllCorrCoef = AllOrigKARMACorrCoef;
        Results.Joint(1+(iLoop-1)*2).Orig.AllPred = AllOrigJointPred;
        Results.Joint(1+(iLoop-1)*2).Orig.AllModel = AllOrigJointModel;
    end
    
    if AllLinearflag
        Results.Joint(1+(iLoop-1)*2).Linear.AllCorrCoef = AllLinearKARMACorrCoef;
        Results.Joint(1+(iLoop-1)*2).Linear.AllPred = AllLinearJointPred;
        Results.Joint(1+(iLoop-1)*2).Linear.AllModel = AllLinearJointModel;
    end
    
    if Origflag
        Results.Joint(1+(iLoop-1)*2).Orig.CorrCoef = OrigKARMACorrCoef;
        Results.Joint(1+(iLoop-1)*2).Orig.Pred = OrigJointPred;
        Results.Joint(1+(iLoop-1)*2).Orig.Model = OrigJointModel;
    end
    Results.Joint(1+(iLoop-1)*2).Orig.Test = jointTest_orig;
    
    if FullPCAflag
        Results.Joint(1+(iLoop-1)*2).PCA.FullCorrCoef = FullPCAKARMACorrCoef;
        Results.Joint(1+(iLoop-1)*2).PCA.FullPred = FullPCAJointPred;
        Results.Joint(1+(iLoop-1)*2).PCA.FullModel = FullPCAJointModel;
        Results.Joint(1+(iLoop-1)*2).Recon.PCACorrCoef = PCAReconKARMACorrCoef;
        Results.Joint(1+(iLoop-1)*2).Recon.PCAPred = PCAReconJointPred;
        Results.Joint(1+(iLoop-1)*2).Recon.FullPCACorrCoef = FullPCAReconKARMACorrCoef;
        Results.Joint(1+(iLoop-1)*2).Recon.FullPCAPred = FullPCAReconJointPred;
    end
    
    Results.Joint(1+(iLoop-1)*2).Recon.Test = jointTest_orig;
   % Results.Joint(1+(iLoop-1)*2).Recon.TestFull = reconFull;
    
   % Now repeat on the opposite train, test assignments.
   if 1
       jointTrain = [jointPosTest];% jointVelTrain];
       jointTest = [jointPosTrain];% jointVelTest];
       jointTrain_full = [jointPosTest_full];
       jointTest_full = [jointPosTrain_full];
       jointTrain_orig = [jointPosTest_orig];
       jointTest_orig = [jointPosTrain_orig];
       jointTrain_linear = [jointPosTest_linear];
       jointTest_linear = [jointPosTrain_linear];
       
       if AllPCAflag
           AllPCAJointModel = parfitKARMA2(PCAlfpTest, jointTrain, neural_lag, observed_lag, gamma, C, Shrinking);
           AllPCAJointPred = fast_karma_predict(PCAlfpTrain, AllPCAJointModel);
           AllPCAJointPred = AllPCAJointPred';
       end
       if AllOrigflag
           switch KARMAParams.Objective
               case 'SVR'
                   AllOrigJointModel = parfitKARMA2(PCAlfpTest, jointTrain_orig, neural_lag, observed_lag, gamma, C, Shrinking);
                   AllOrigJointPred = fast_karma_predict(PCAlfpTrain, AllOrigJointModel);
                   AllOrigJointPred = AllOrigJointPred';
               case 'ElasticNet'
                   [AllOrigJointModel, AllOrigJointPred] = fit_and_predictElasticNet(PCAlfpTest, jointTrain_orig, PCAlfpTrain, neural_lag, observed_lag, alpha, lambda, Neural_RBF_sigma, Joint_RBF_sigma, RBF_alpha);
           end
       end
       if AllLinearflag
           switch KARMAParams.Objective
               case 'ElasticNet'
                    [AllLinearJointModel, AllLinearJointPred] = fit_and_predictElasticNet(PCAlfpTest, jointTrain_linear, PCAlfpTrain, neural_lag, observed_lag, alpha, lambda, Neural_RBF_sigma, Joint_RBF_sigma, RBF_alpha);

           end
       end
       if FullPCAflag
           FullPCAJointModel = cell(1,size(jointTrain_full,2));
           for iJointMode = 1:size(jointTrain_full,2)
               FullPCAJointModel{iJointMode} = parfitKARMA2(PCAlfpTest, jointTrain_full(:,iJointMode), neural_lag, observed_lag, gamma, C, Shrinking);
           end
           FullPCAJointPred = zeros(size(jointTest_full))';
           for iJointMode = 1:size(jointTrain_full,2)
               FullPCAJointPred(iJointMode,:) = fast_karma_predict(PCAlfpTrain,FullPCAJointModel{iJointMode});
           end
       end
       if Origflag
           OrigJointModel = cell(1,size(jointTrain_orig,2));
           for iJoint = 1:size(jointTrain_orig,2)
               OrigJointModel{iJoint} = parfitKARMA2(PCAlfpTest, jointTrain_orig(:,iJoint), neural_lag, observed_lag, gamma, C, Shrinking);
           end
           OrigJointPred = zeros(size(jointTest_orig))';
           for iJoint = 1:size(jointTrain_orig,2)
               OrigJointPred(iJoint,:) = fast_karma_predict(PCAlfpTrain, OrigJointModel{iJoint});
           end
       end
       
       jointTest = jointTest';
       jointTest_orig = jointTest_orig';
       jointTest_full = jointTest_full';
       jointTest_linear = jointTest_linear';
       
       % Here, the regression does know about the other PCA modes, up to the
       % number in the PCAParams - ie 10
       if AllPCAflag
           nJointMode = size(jointTest,1);
           AllPCAKARMACorrCoef = zeros(1,nJointMode);
           for iJointMode = 1:nJointMode
               a = corrcoef(jointTest(iJointMode,:), AllPCAJointPred(iJointMode,:));
               AllPCAKARMACorrCoef(iJointMode) = a(2);
           end
       end
       % Here, the regression does not know about the other PCA modes
       if FullPCAflag
           nJointMode = size(jointTest_full,1);
           FullPCAKARMACorrCoef = zeros(1,nJointMode);
           for iJointMode = 1:nJointMode
               a = corrcoef(jointTest_full(iJointMode,:), FullPCAJointPred(iJointMode,:));
               FullPCAKARMACorrCoef(iJointMode) = a(2);
           end
       end
       % Here, the regression does know about the other joints
       if AllOrigflag
           nJoint = size(jointTest_orig,1);
           AllOrigKARMACorrCoef = zeros(1,nJoint);
           for iJoint = 1:nJoint
               a = corrcoef(jointTest_orig(iJoint,:), AllOrigJointPred(iJoint,:));
               AllOrigKARMACorrCoef(iJoint) = a(2);
           end
       end
       %
       if AllLinearflag
           nJoint = size(jointTest_linear,1);
           AllLinearKARMACorrCoef = zeros(1,nJoint);
           for iJoint = 1:nJoint
               a = corrcoef(jointTest_linear(iJoint,:), AllLinearJointPred(iJoint,:));
               AllLinearKARMACorrCoef(iJoint) = a(2);
           end
       end
       % Here, the regression model does not know about the other joints
       if Origflag
           nJoint = size(jointTest_orig,1);
           OrigKARMACorrCoef = zeros(1,nJoint);
           for iJoint = 1:nJoint
               a = corrcoef(jointTest_orig(iJoint,:), OrigJointPred(iJoint,:));
               OrigKARMACorrCoef(iJoint) = a(2);
           end
       end
       % Here, we want to transform the joint modes to joints to assess
       % performance
       %
       %Start with the PCA regression which knows about all other modes up to
       %N
       if AllPCAflag
           nJoint = length(JointList);
           AllPCAReconJointPred = reconPCAJoint(AllPCAJointPred,PCAParams);
           for iJoint = 1:nJoint
               a = corrcoef(jointTest_orig(iJoint,:),AllPCAReconJointPred(iJoint,:));
               AllPCAReconKARMACorrCoef(iJoint) = a(2);
           end
       end
       % Next compute for the PCA regression which only knows about the same
       % modes and constitute from up to N modes.  Let's us determine if the
       % interactions across modes improves performance.
       if FullPCAflag
           nJoint = length(JointList);
           nDim = size(jointTest,1);
           PCAReconJointPred = reconPCAJoint(FullPCAJointPred(1:PCAParams.nDim,:), PCAParams);
           for iJoint = 1:nJoint
               a = corrcoef(jointTest_orig(iJoint,:), PCAReconJointPred(iJoint,:));
               PCAReconKARMACorrCoef(iJoint) = a(2);
           end
           % Next compute for the PCA regression which only knows about the same
           % modes and constitute from all modes.
           FullPCAReconJointPred = reconPCAJoint(FullPCAJointPred, PCAParams_full);
           FullPCAReconKARMACorrCoef = zeros(1,nJoint);
           for iJoint = 1:nJoint
               a = corrcoef(jointTest_orig(iJoint,:), FullPCAReconJointPred(iJoint,:));
               FullPCAReconKARMACorrCoef(iJoint) = a(2);
           end
       end
       
       if AllPCAflag
           Results.Joint(iLoop*2).PCA.AllCorrCoef = AllPCAKARMACorrCoef;
           Results.Joint(iLoop*2).PCA.AllPred = AllPCAJointPred;
           Results.Joint(iLoop*2).PCA.AllModel = AllPCAJointModel;
           Results.Joint(iLoop*2).Recon.AllPCACorrCoef = AllPCAReconKARMACorrCoef;
           Results.Joint(iLoop*2).Recon.AllPCAPred = AllPCAReconJointPred;
       end
       Results.Joint(iLoop*2).PCA.Test = jointTest;
       
       if FullPCAflag
           Results.Joint(iLoop*2).PCA.FullCorrCoef = FullPCAKARMACorrCoef;
           Results.Joint(iLoop*2).PCA.FullPred = FullPCAJointPred;
           Results.Joint(iLoop*2).PCA.FullModel = FullPCAJointModel;
           Results.Joint(iLoop*2).Recon.PCACorrCoef = PCAReconKARMACorrCoef;
           Results.Joint(iLoop*2).Recon.PCAPred = PCAReconJointPred;
           Results.Joint(iLoop*2).Recon.FullPCACorrCoef = FullPCAReconKARMACorrCoef;
           Results.Joint(iLoop*2).Recon.FullPCAPred = FullPCAReconJointPred;
           
       end
       Results.Joint(iLoop*2).PCA.FullTest = jointTest_full;
       
       if AllOrigflag
           Results.Joint(iLoop*2).Orig.AllCorrCoef = AllOrigKARMACorrCoef;
           Results.Joint(iLoop*2).Orig.AllPred = AllOrigJointPred;
           Results.Joint(iLoop*2).Orig.AllModel = AllOrigJointModel;
       end
       
       if AllLinearflag
           Results.Joint(iLoop*2).Linear.AllCorrCoef = AllLinearKARMACorrCoef;
           Results.Joint(iLoop*2).Linear.AllPred = AllLinearJointPred;
           Results.Joint(iLoop*2).Linear.AllModel = AllLinearJointModel;
       end
       
       if Origflag
           Results.Joint(iLoop*2).Orig.CorrCoef = OrigKARMACorrCoef;
           Results.Joint(iLoop*2).Orig.Pred = OrigJointPred;
           Results.Joint(iLoop*2).Orig.Model = OrigJointModel;
       end
       Results.Joint(iLoop*2).Orig.Test = jointTest_orig;
       Results.Joint(iLoop*2).Linear.Test = jointTest_linear;
       Results.Joint(iLoop*2).Recon.Test = jointTest_orig;
   end
end
    
Results.Session = Sess;
Results.Tower = Tower;
Results.KARMParams = KARMAParams;
Results.JointParams = JointParams;
Results.PCAParamsLFP = PCAParamsLFP;
Results.LFPParams = LFPParams;


% if exist('result_filename','var')
%     save(result_filename,'Results');
% end
