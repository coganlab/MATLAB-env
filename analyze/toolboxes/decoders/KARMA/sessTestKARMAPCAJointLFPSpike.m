function [Results, PCAParams] = sessTestKARMAPCAJointLFPSpike(Sess, Tower, JointList, karmaparams, bin_time, PCAParams, allchannels,joint_file_name)
%
%  [Results, PCAParams] = sessTestKARMAJointLFPSpike(Sess, Tower, JointList, karmaparams, bin_time, PCAParams, allchannels)
%
%  Inputs:  Session = MocapSession from Behavior Database;
%           Towers = Cell array or string.  Tower/s to analyze
%               {'L_PMd','R_PMd'} to pool L_PMd and R_PMd
%               'L_PMd' or {'L_PMd'} for L_PMd alone.
%           JointList;
%           karmaparams.neural_lag = 10;
%           karmaparams.observed_lag = 10;
%           karmaparams.gamma = 0.0003;
%           karmaparams.C = 4
%           karmaparams.data_lag = 0(ms);
%           karmaparams.spike_bin_width = 50  (ms)
%           bin_time  =  Test and train bin width (in minutes)
%           PCAParams.nDim
%           PCAParams.U;
%           PCAParams.
%           allchannels = if def'd use all channels instead of spike channel selection
%           joint_file_name = file name of jnt file
%
%  Outputs:  Results = 
%


global MONKEYDIR
day = sessDay(Sess);
recs = sessRec(Sess);

% Prepare data (same as Kalman Filter prep) - note bin size is larger

if nargin < 3 || isempty(JointList)
  markerset = sessMocapMarkerset(Sess);
  JointList = whichJointNames(markerset{1}); 
end

if nargin < 4 || isempty(karmaparams)
    karmaparams = [];
end

if ~isfield(karmaparams, 'neural_lag')
    karmaparams.neural_lag = 10;
end

if ~isfield(karmaparams, 'observed_lag')
    karmaparams.observed_lag = 10;
end

if ~isfield(karmaparams, 'gamma')
    karmaparams.gamma = 0.0003;
end

if ~isfield(karmaparams, 'C')
    karmaparams.C = 4.0000;
end

if ~isfield(karmaparams, 'spike_bin_width') 
    karmaparams.spike_bin_width = 50;
end
if ~isfield(karmaparams, 'data_lag') 
    karmaparams.data_lag = 0;
end
if nargin < 5 || isempty(bin_time)
    bin_time = -1;
end

if nargin < 6 || isempty(PCAParams)
    nJoint = length(JointList);
else
    nJoint = PCAParams.nDim;
end

if nargin < 7
    allchannels = 1;
end

if nargin < 8 || isempty(joint_file_name) 
    joint_file_name = [];
else
    joint_file_name = [joint_file_name '.'];
end

spike_bin_width = karmaparams.spike_bin_width;
disp(['Using spectral hop size of ' num2str(spike_bin_width) 'ms']);


tic
path = strcat(MONKEYDIR, '/', day, '/', recs{1}, '/rec', recs{1});
load([path, '.Body.' joint_file_name 'Joint.mat'])
load([path, '.Body.' joint_file_name 'joint_names.mat'])
[dum,ind] = intersect(joint_names,JointList);
Joint = Joint(sort(ind));
joint_names = joint_names(sort(ind));
IntervalFile = [MONKEYDIR '/' day '/mat/rec' recs{1} '.Interval.mat'];
if exist(IntervalFile,'file')
    disp('Interval file')
    load(IntervalFile);
    Joint = snipJoint(Joint,Interval);
end

nJoint = length(Joint);

for iJoint = 1:length(Joint)
    ind = find(~isnan(Joint{iJoint}(2,:)));
    Joint{iJoint} = Joint{iJoint}(:,ind);
end

ind = find(Joint{1}(2,:)>0);
tmpJoint = Joint;
for iJoint = 1:length(Joint)
    tmpJoint{iJoint} = Joint{iJoint}(:,ind);
end

PCAParams_full = PCAParams;
[dum, PCAParams] = processPCAJoint(tmpJoint, PCAParams);
[PCAJoint, PCAParams] = processPCAJoint(Joint,PCAParams);
PCAParams_full.nDim = length(Joint);
[dum_full, PCAParams_full] = processPCAJoint(tmpJoint, PCAParams_full);
[PCAJoint_full, PCAParams_full] = processPCAJoint(Joint,PCAParams_full);

if iscell(Tower)
    rawlfp = [];
    pks = {};
    for iTower = 1:length(Tower)
        fid = fopen([path '.' Tower{iTower} '.lfp.dat']);
        lfpdata = fread(fid, [32,inf], 'float');
        rawlfp = [rawlfp; lfpdata];
        load([path '.' Tower{iTower} '.pk.mat'])
        pks = [pks pk];
    end

elseif ischar(Tower)
    fid = fopen([path '.' Tower{iTower} '.lfp.dat']);
    rawlfp = fread(fid, [32,inf], 'float');  
    load([path '.' Tower '.pk.mat'])
end

% Ignoring any information about intensity of threshold crossing, drops
% spikes and wrist position and velocity into bins of specified width ms.
% take data from a single recording and split into two pieces.
for iJoint = 1:length(PCAJoint)
    tmp = PCAJoint{iJoint};
    tmp2(:,1) = tmp(1,:)';
    tmp2(:,2) = tmp(2,:)';
    PCAJoint2{iJoint} = tmp2;    
end

for iJoint = 1:length(PCAJoint_full)
    tmp = PCAJoint_full{iJoint};
    tmp2(:,1) = tmp(1,:)';
    tmp2(:,2) = tmp(2,:)';
    PCAJoint2_full{iJoint} = tmp2;
end

fclose(fid);
tapers = [0.5,5];
N = tapers(1);
W = tapers(2);
sampling_rate = 1e3;
dn = 0.05;
fk = 200;
pad = 2;
lfpspec = tfspec(rawlfp, [N,W],sampling_rate,dn,fk,pad);
% compute PCA of LFP features 
% XXX: THIS USES ALL THE DATA IT IS CHEATING FOR NOW
%disp('finding svd of lfp spectrum');
PCAParamsLFP.nDim = size(lfpspec,1);
%freq = [1:5,7:14,16:19,21:29,40:55,60:65,70:75,80:size(lfpspec,3)];
%lfpspec(:,:,freq) =[];
% lfpspec = shiftdim(lfpspec,1);
% PCALfp = reshape(lfpspec,size(lfpspec,1),size(lfpspec,2).*size(lfpspec,3));

[PCALfp, PCAParamsLFP] = processPCALFP(lfpspec,PCAParamsLFP);
jointPos_full = lfpbin(PCALfp, PCAJoint2_full, spike_bin_width);
jointPos      = lfpbin(PCALfp, PCAJoint2, spike_bin_width);

[spike, jointPos_full, jointVel_full] = bin(pk,  spike_bin_width, PCAJoint2_full);
[spike, jointPos, jointVel] = bin(pk,  spike_bin_width, PCAJoint2);
whos PCALfp spike
jointPos(1:tapers(1)/dn+1,:) = [];
jointPos_full(1:tapers(1)/dn+1,:) = [];
spike([1:tapers(1)/dn+1,end],:) = [];
% PCALfp(:,end-tapers(1)/dn+1:end) = [];
whos spike PCALfp jointPos jointPos_full
PCALfp = double(PCALfp');

spike = [spike';PCALfp']';
whos spike PCALfp
%pause
toc
if(karmaparams.data_lag > 0)
    pad_points = ceil(karmaparams.data_lag/10)
    for iJoint = 1:size(jointPos,2)
        jointPos(:,iJoint) = [nan(pad_points,1);jointPos(1:end - pad_points,iJoint)];
    end 
elseif(karmaparams.data_lag < 0)
    pad_points = abs(ceil(karmaparams.data_lag/10))
    for iJoint = 1:size(jointPos,2)
        jointPos(:,iJoint) = [jointPos(pad_points+1:end,iJoint);nan(pad_points,1)];
    end 
end

idx = find(~isnan(jointPos(:,1)) & jointPos(:,1)~=0);
spike = spike(idx,:);
jointPos = jointPos(idx,:);
jointPos_full = jointPos_full(idx,:);


if(bin_time < 0)
    X = jointPos;
    jointPosTrain = X(1:floor(end/2),:);
    jointPosTest = X(floor(end/2)+1:end,:);
    X_full = jointPos_full;
    jointPosTrain_full = X_full(1:floor(end/2),:);
    jointPosTest_full = X_full(floor(end/2)+1:end,:);
    spikeTrain = spike(1:floor(end/2),:);
    spikeTest = spike(floor(end/2)+1:end,:);
    %sample_rate = 30000;
    repeats = 2;
    loops = 1;
    total_repeats = 2;
else
    %bin_time is in minutes
    bin_time_ms = bin_time*60*1000;
    total_data = length(jointPos(:,1))*spike_bin_width;
    repeats = floor(total_data/bin_time_ms)
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
        spikeTrain = spike((first_pos-1)*bin_length+1:(first_pos)*bin_length,:);
        spikeTest = spike((second_pos-1)*bin_length+1:(second_pos)*bin_length,:);
    else
        
        X = jointPos;
        jointPosTrain = X(1:floor(end/2),:);
        jointPosTest = X(floor(end/2)+1:end,:);
        X_full = jointPos_full;
        jointPosTrain_full = X_full(1:floor(end/2),:);
        jointPosTest_full = X_full(floor(end/2)+1:end,:);
        spikeTrain = spike(1:floor(end/2),:);
        spikeTest = spike(floor(end/2)+1:end,:);
    end
        
    jointTrain = [jointPosTrain];% jointVelTrain];
    jointTest = [jointPosTest];% jointVelTest];
    jointTrain_full = [jointPosTrain_full];
    jointTest_full = [jointPosTest_full];
    neural_lag = karmaparams.neural_lag;
    observed_lag = karmaparams.observed_lag;
    gamma = karmaparams.gamma;
    C = karmaparams.C;

    model = parfitKARMA(spikeTrain, jointTrain, neural_lag, observed_lag, gamma, C); 
    jointPred = parpredictKARMA(spikeTest,zeros(nJoint,1),model);
    
    jointTest = jointTest';
    nJoint = size(jointTest,1);
    KARMACorrCoef = zeros(1,nJoint);
    for iJoint = 1:nJoint
        a = corrcoef(jointTest(iJoint,:),jointPred(iJoint,:));
        KARMACorrCoef(iJoint) = a(2);
    end
    
    Results.Joint(1+(iLoop-1)*2).PCA.CorrCoef = KARMACorrCoef;
    Results.Joint(1+(iLoop-1)*2).PCA.Pred = jointPred;
    Results.Joint(1+(iLoop-1)*2).PCA.Test = jointTest;
    
    Pred = jointPred;
    reconPred = reconPCAJoint(Pred,PCAParams);
    Test = jointTest;
    reconTest = reconPCAJoint(Test,PCAParams);
    Test = jointTest_full';
    %whos Test
    reconFull = reconPCAJoint(Test,PCAParams_full);
    reconKARMACorrCoef = zeros(1,nJoint);
    %whos jointTest
    for iJoint = 1:length(JointList)%nJoint
        %a = corrcoef(reconTest(iJoint,:),reconPred(iJoint,:));
        a = corrcoef(reconFull(iJoint,:),reconPred(iJoint,:));
        reconKARMACorrCoef(iJoint) = a(2);
        a = corrcoef(reconTest(iJoint,:),reconPred(iJoint,:));
        reducedreconKARMACorrCoef(iJoint) = a(2);
    end
   
    
    Results.Joint(1+(iLoop-1)*2).Recon.CorrCoef = reconKARMACorrCoef;
    Results.Joint(1+(iLoop-1)*2).Recon.ReducedCorrCoef = reducedreconKARMACorrCoef;
    Results.Joint(1+(iLoop-1)*2).Recon.Pred = reconPred;
    Results.Joint(1+(iLoop-1)*2).Recon.Test = reconTest;
    Results.Joint(1+(iLoop-1)*2).Recon.TestFull = reconFull;
    
    % Now repeat on the opposite train, test assignments.
    jointTrain = [jointPosTest];% jointVelTrain];
    jointTest = [jointPosTrain];% jointVelTest];
    jointTrain_full = [jointPosTest_full];
    jointTest_full = [jointPosTrain_full];
    
    model = parfitKARMA(spikeTest, jointTrain, neural_lag, observed_lag, gamma, C); 
    jointPred = parpredictKARMA(spikeTrain,zeros(nJoint,1),model);
    
    jointTest = jointTest';
    nJoint = size(jointTest,1);
    KARMACorrCoef = zeros(1,nJoint);
    for iJoint = 1:nJoint
        a = corrcoef(jointTest(iJoint,:),jointPred(iJoint,:));
        KARMACorrCoef(iJoint) = a(2);
    end
    
    Results.Joint(iLoop*2).PCA.CorrCoef = KARMACorrCoef;
    Results.Joint(iLoop*2).PCA.Pred = jointPred;
    Results.Joint(iLoop*2).PCA.Test = jointTest;
   
    Pred = jointPred;
    reconPred = reconPCAJoint(Pred,PCAParams);
    Test = jointTest;
    reconTest = reconPCAJoint(Test,PCAParams);
    Test = jointTest_full';
    reconFull = reconPCAJoint(Test,PCAParams_full);
    reconKARMACorrCoef = zeros(1,nJoint);
    for iJoint = 1:length(JointList)%nJoint
        %a = corrcoef(reconTest(iJoint,:),reconPred(iJoint,:));
        a = corrcoef(reconFull(iJoint,:),reconPred(iJoint,:));
        reconKARMACorrCoef(iJoint) = a(2);
        a = corrcoef(reconTest(iJoint,:),reconPred(iJoint,:));
        reducedreconKARMACorrCoef(iJoint) = a(2);
    end
    Results.Joint(iLoop*2).Recon.CorrCoef = reconKARMACorrCoef;
    Results.Joint(iLoop*2).Recon.ReducedCorrCoef = reducedreconKARMACorrCoef;
    Results.Joint(iLoop*2).Recon.Pred = reconPred;
    Results.Joint(iLoop*2).Recon.Test = reconTest;
    Results.Joint(iLoop*2).Recon.TestFull = reconFull;
end
    
Results.Session = Sess;
Results.Tower = Tower;
Results.JointList = JointList;
Results.PCAParams = PCAParams;
Results.joint_names = joint_names;
Results.jnt_file = joint_file_name;
