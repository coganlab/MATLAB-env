function Results = sessTestKARMAVelocityJointLFP(Sess, Tower, KARMAParams, JointParams, LFPParams, monkeydir, result_filename)
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
%           KARMAParams.Model.AllOrig
%           KARMAParams.Model.Orig
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
end

day = sessDay(Sess);
recs = sessRec(Sess);

% Prepare data (same as Kalman Filter prep) - note bin size is larger
if nargin < 3 || isempty(KARMAParams)
    KARMAParams = [];
end

AllOrigflag = 1;
Origflag = 1;
if isfield(KARMAParams,'Model')
    if isfield(KARMAParams.Model,'AllOrig')
        AllOrigflag = KARMAParams.Model.AllOrig;
    end
    if isfield(KARMAParams.Model,'Orig')
        Origflag = KARMAParams.Model.Orig;
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
if ~isfield(KARMAParams, 'gamma')
    gamma = 0.0003;
else
    gamma = KARMAParams.gamma;
end
if ~isfield(KARMAParams, 'C')
    C = 0.001;
else
    C = KARMAParams.C;
end
if ~isfield(KARMAParams, 'Shrinking')
    Shrinking = 1;
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

disp('joint velocity');

[JointVelocity, JointVelParams] = processVelocityJoint(Joint);
    

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
        rawlfp = rawlfp(spikingchannels, :);
    else
        rawlfp = rawlfp(channels, :);
    end
        lfpspec = tfspec(rawlfp, [N,W], sampling_rate, dn, fk,pad);

    lfpspec_cache = lfpspec;
end
% compute PCA of LFP features
lfpspec = lfpspec_cache;

clear PCAParamsLFP
PCAParamsLFP.nDim = numLFPDim;
%if (isempty(PCALfpCache))
    whos lfpspec
    [PCALfpCache, PCAParamsLFP] = processPCALFP(lfpspec, PCAParamsLFP);
%end
PCALfp = PCALfpCache;

% take data from a single recording and split into two pieces.
for iJoint = 1:length(JointVelocity)
    tmp = JointVelocity{iJoint};
    tmp2(:,1) = tmp(1,:)';
    tmp2(:,2) = tmp(2,:)';
    JointVelocity2{iJoint} = tmp2;
end

jointVel = lfpbin(PCALfp, JointVelocity2, bin_width);
%align spectral shifted data
PCALfp(:,end-tapers(1)/dn+1:end-1) = [];
jointVel(1:tapers(1)/dn,:) = [];

PCAlfp = double(PCALfp');

%whos PCALfp jointPos jointPosFull

toc
% 
% if(data_lag > 0)
%     pad_points = ceil(data_lag/bin_width);
%     disp(['Data Lag: Discarding first ' num2str(pad_points) ' samples of neural data.']);
%     for iJoint = 1:size(jointPos,2)
%         jointPos(:,iJoint) = [nan(pad_points,1); jointPos(1:end - pad_points,iJoint)];
%     end 
%     
% elseif(data_lag < 0)
%     pad_points = ceil(abs(data_lag/bin_width));
%     disp(['Data lag: Discarding first ' num2str(pad_points) ' samples of joint data.']);
%     for iJoint = 1:size(jointPos,2)
%         jointPos(:,iJoint) = [jointPos(pad_points+1:end,iJoint); nan(pad_points,1)];
%     end 
% end

idx = find(~isnan(jointVel(:,1)) & jointVel(:,1)~=0);
PCAlfp = PCAlfp(idx,:);
jointVel = jointVel(idx,:);

if(bin_time < 0)
    X = jointVel;
    jointVelTrain = X(1:floor(end/2),:);
    jointVelTest = X(floor(end/2)+1:end,:);
    PCAlfpTrain = PCAlfp(1:floor(end/2),:);
    PCAlfpTest = PCAlfp(floor(end/2)+1:end,:);
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
X = jointVel;

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
        bin_length = floor(length(jointVel)/repeats);
        jointVelTrain = X((first_pos-1)*bin_length+1:(first_pos)*bin_length,:);
        jointVelTest = X((second_pos-1)*bin_length+1:(second_pos)*bin_length,:);
        PCAlfpTrain = PCAlfp((first_pos-1)*bin_length+1:(first_pos)*bin_length,:);
        PCAlfpTest = PCAlfp((second_pos-1)*bin_length+1:(second_pos)*bin_length,:);
    else
        
        X = jointVel;
        jointVelTrain = X(1:floor(end/2),:);
        jointVelTest = X(floor(end/2)+1:end,:);
        
        PCAlfpTrain = PCAlfp(1:floor(end/2),:);
        PCAlfpTest = PCAlfp(floor(end/2)+1:end,:);
    end
        
    jointTrain = jointVelTrain;% jointVelTrain];
    jointTest = jointVelTest;% jointVelTest];
    
    if AllOrigflag
        AllOrigJointModel = parfitKARMA2(PCAlfpTrain, jointTrain, neural_lag, observed_lag, gamma, C, Shrinking);
        AllOrigJointPred = fast_karma_predict(PCAlfpTest, AllOrigJointModel);
        AllOrigJointPred = AllOrigJointPred';
    end
%     
    if Origflag
        OrigJointModel = cell(1,size(jointTrain,2));
        nJoint = size(jointTrain,2); nT = size(PCAlfpTest,1);
        OrigJointPred = zeros(nJoint,nT);
        for iJoint = 1:nJoint
            OrigJointModel{iJoint} = parfitKARMA2(PCAlfpTrain, jointTrain(:,iJoint), neural_lag, observed_lag, gamma, C, Shrinking);
            OrigJointPred(iJoint,:) = fast_karma_predict(PCAlfpTest(1:end,:), OrigJointModel{iJoint});
        end
    end
    
    jointTest = jointTest';
    
    % Here, the regression does know about the other joints
    if AllOrigflag
        nJoint = size(jointTest,1);
        AllOrigKARMACorrCoef = zeros(1,nJoint);
        for iJoint = 1:nJoint
            a = corrcoef(jointTest(iJoint,:), AllOrigJointPred(iJoint,:));
            AllOrigKARMACorrCoef(iJoint) = a(2);
        end
    end
    % Here, the regression model does not know about the other joints
    if Origflag
        nJoint = size(jointTest,1);
        OrigKARMACorrCoef = zeros(1,nJoint);
        for iJoint = 1:nJoint
            a = corrcoef(jointTest(iJoint,:), OrigJointPred(iJoint,:));
            OrigKARMACorrCoef(iJoint) = a(2);
        end
    end
    
    
   
   
    if AllOrigflag
        Results.Joint(1+(iLoop-1)*2).Orig.AllCorrCoef = AllOrigKARMACorrCoef;
        Results.Joint(1+(iLoop-1)*2).Orig.AllPred = AllOrigJointPred;
        Results.Joint(1+(iLoop-1)*2).Orig.AllModel = AllOrigJointModel;
    end
    
    if Origflag
        Results.Joint(1+(iLoop-1)*2).Orig.CorrCoef = OrigKARMACorrCoef;
        Results.Joint(1+(iLoop-1)*2).Orig.Pred = OrigJointPred;
        Results.Joint(1+(iLoop-1)*2).Orig.Model = OrigJointModel;
    end
    Results.Joint(1+(iLoop-1)*2).Orig.Test = jointTest;
    
    
    
   % Now repeat on the opposite train, test assignments.
   if 1
       jointTrain = [jointVelTest];% jointVelTrain];
       jointTest = [jointVelTrain];% jointVelTest];
       
       
      
       if AllOrigflag
           AllOrigJointModel = parfitKARMA2(PCAlfpTest, jointTrain, neural_lag, observed_lag, gamma, C, Shrinking);
           AllOrigJointPred = fast_karma_predict(PCAlfpTrain, AllOrigJointModel);
           AllOrigJointPred = AllOrigJointPred';
       end
      
       if Origflag
           OrigJointModel = cell(1,size(jointTrain,2));
           for iJoint = 1:size(jointTrain,2)
               OrigJointModel{iJoint} = parfitKARMA2(PCAlfpTest, jointTrain(:,iJoint), neural_lag, observed_lag, gamma, C, Shrinking);
           end
            nJoint = size(jointTrain,2); nT = size(PCAlfpTrain,1);
            OrigJointPred = zeros(nJoint,nT);

           for iJoint = 1:size(jointTrain,2)
               OrigJointPred(iJoint,:) = fast_karma_predict(PCAlfpTrain, OrigJointModel{iJoint});
           end
       end
       
       jointTest = jointTest';       
      
      
       % Here, the regression does know about the other joints
       if AllOrigflag
           nJoint = size(jointTest,1);
           AllOrigKARMACorrCoef = zeros(1,nJoint);
           for iJoint = 1:nJoint
               a = corrcoef(jointTest(iJoint,:), AllOrigJointPred(iJoint,:));
               AllOrigKARMACorrCoef(iJoint) = a(2);
           end
       end
       % Here, the regression model does not know about the other joints
       if Origflag
           nJoint = size(jointTest,1);
           OrigKARMACorrCoef = zeros(1,nJoint);
           for iJoint = 1:nJoint
               a = corrcoef(jointTest(iJoint,:), OrigJointPred(iJoint,:));
               OrigKARMACorrCoef(iJoint) = a(2);
           end
       end
       
       
       
       if AllOrigflag
           Results.Joint(iLoop*2).Orig.AllCorrCoef = AllOrigKARMACorrCoef;
           Results.Joint(iLoop*2).Orig.AllPred = AllOrigJointPred;
           Results.Joint(iLoop*2).Orig.AllModel = AllOrigJointModel;
       end
       
       if Origflag
           Results.Joint(iLoop*2).Orig.CorrCoef = OrigKARMACorrCoef;
           Results.Joint(iLoop*2).Orig.Pred = OrigJointPred;
           Results.Joint(iLoop*2).Orig.Model = OrigJointModel;
       end
       Results.Joint(iLoop*2).Orig.Test = jointTest;
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
