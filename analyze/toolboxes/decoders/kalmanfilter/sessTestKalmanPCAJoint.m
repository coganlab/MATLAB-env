function [Results, PCAParams, myJoint] = sessTestKalmanPCAJoint(Sess, Tower, JointList, kalmanparams, bin_time, PCAParams, allchannels,joint_file_name)
%
%  [Results, PCAParams] = sessTestKalmanJoint(Sess, Tower, JointList, kalmanparams, bin_time, PCAParams, allchannels)
%
%  Inputs:  Session = MocapSession from Behavior Database;
%           Towers = Cell array or string.  Tower/s to analyze
%               {'L_PMd','R_PMd'} to pool L_PMd and R_PMd
%               'L_PMd' or {'L_PMd'} for L_PMd alone.
%           JointList;
%           kalmanparams.lag = 10;
%           kalmanparams.data_lag = 0(ms);
%           kalmanparams.spike_bin_width = 50  (ms)
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

if nargin < 4 || isempty(kalmanparams)
    kalmanparams = [];
end

if ~isfield(kalmanparams, 'lag')
    kalmanparams.lag = 10;
end


if ~isfield(kalmanparams, 'velocity')
    kalmanparams.velocity = 0;
end

if ~isfield(kalmanparams, 'spike_bin_width') 
    kalmanparams.spike_bin_width = 50;
end
if ~isfield(kalmanparams, 'data_lag') 
    kalmanparams.data_lag = 0;
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

spike_bin_width = kalmanparams.spike_bin_width;
disp(['Using spike bin width of ' num2str(spike_bin_width) 'ms']);


% deal with multiple recording sessions
if(length(recs) == 1)
    disp('There is 1 recording')
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

    ind = find(Joint{1}(2,:)>0);
    tmpJoint = Joint;
    for iJoint = 1:length(Joint)
        tmpJoint{iJoint} = Joint{iJoint}(:,ind);
    end
    Joint = tmpJoint;
    PCAParams_full = PCAParams;
    [dum, PCAParams] = processPCAJoint(tmpJoint, PCAParams);
    [PCAJoint, PCAParams] = processPCAJoint(Joint,PCAParams);
    PCAParams_full.nDim = length(Joint);
    [dum_full, PCAParams_full] = processPCAJoint(tmpJoint, PCAParams_full);
    [PCAJoint_full, PCAParams_full] = processPCAJoint(Joint,PCAParams_full);
    if iscell(Tower)
        pks = {};
        for iTower = 1:length(Tower)
            load([path '.' Tower{iTower} '.pk.mat'])
            pks = [pks pk];
        end
        pk = pks;
    elseif ischar(Tower)
        load([path '.' Tower '.pk.mat'])
    end
    
    if exist(IntervalFile,'file')
        load(IntervalFile);
        pk = snipPk(pk,Interval);
    end
    total_pk = pk;
else
    %cell size should not be hard coded
    end_time = 0;
    for iRec = 1:length(recs)
        %loop through recs and concatinate
        path = strcat(MONKEYDIR, '/', day, '/', recs{iRec}, '/rec', recs{iRec});
        
        load([path, '.Body.' joint_file_name 'Joint.mat'])
        load([path, '.Body.' joint_file_name 'joint_names.mat'])
        [dum,ind] = intersect(joint_names,JointList);
        Joint = Joint(ind);
        if(iRec == 1)
            nJoint = length(Joint);
            PCAJoint = cell(1,nJoint);
        end
        IntervalFile = [MONKEYDIR '/' day '/mat/rec' recs{iRec} '.Interval.mat'];
        if exist(IntervalFile,'file')
            %disp('Interval file')
            load(IntervalFile);
            Joint = snipJoint(Joint,Interval);
        end
        
        PCAJoint_tmp = processPCAJoint(Joint, PCAParams);
        
        if iscell(Tower)
            pks = {};
            for iTower = 1:length(Tower)
                load([path '.' Tower{iTower} '.pk.mat'])
                pks = [pks pk];
            end
            pk_tmp = pks;
        elseif ischar(Tower)
            load([path '.' Tower '.pk.mat'])
            pk_tmp = pk;
        end
        if exist(IntervalFile,'file')
            load(IntervalFile);
            pk_tmp = snipPk(pk_tmp,Interval);
        end
        if(~exist('total_pk'))
            total_pk = cell(1,length(pk));
        end
        
        %realign data
        % calculate the last joint angle or spike time.
        current_end_time = 0;
        for iJoint = 1:nJoint
            current_end_time = max(current_end_time,PCAJoint_tmp{iJoint}(end,1));
            PCAJoint_tmp{iJoint}(:,1) = PCAJoint_tmp{iJoint}(:,1) + end_time;
            PCAJoint{iJoint} = [PCAJoint{iJoint}; PCAJoint_tmp{iJoint}];
        end
        if(length(total_pk) == 0)
            total_pk = cell(length(pk_tmp));
        end
        for iPk = 1:length(pk_tmp)
            current_end_time = max(current_end_time,pk_tmp{iPk}(end,1));
            pk_tmp{iPk}(:,1) = pk_tmp{iPk}(:,1) + end_time;
            total_pk{iPk} = [total_pk{iPk}; pk_tmp{iPk}];
        end
        end_time = end_time + current_end_time;
    end
end
pk = total_pk;
%  Figure out the spiking channels
%  or use all if specified

if((length(allchannels) == 1))
    if(allchannels < 2)
        if ~allchannels
            cd([MONKEYDIR '/m/depth/'])
            allendSP = [];
            for iTower = 1:length(Tower);
                eval(['Movement_' Tower{iTower} '_' day]);
                allendSP = [allendSP endSP];
            end
            spikingchannels = find(allendSP);
            pk = pk(spikingchannels);
        end
    else
        pk = pk(allchannels-1);
    end
else
    pk = pk(allchannels);
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

[spike, jointPos_full, jointVel_full] = bin(pk,  spike_bin_width, PCAJoint2_full);
[spike, jointPos, jointVel] = bin(pk,  spike_bin_width, PCAJoint2);

if(kalmanparams.data_lag > 0)
    pad_points = ceil(kalmanparams.data_lag/10)
    for iJoint = 1:size(jointPos,2)
        jointPos(:,iJoint) = [nan(pad_points,1);jointPos(1:end - pad_points,iJoint)];
    end 
elseif(kalmanparams.data_lag < 0)
    pad_points = abs(ceil(kalmanparams.data_lag/10))
    for iJoint = 1:size(jointPos,2)
        jointPos(:,iJoint) = [jointPos(pad_points+1:end,iJoint);nan(pad_points,1)];
    end 
end
idx = find(~isnan(jointPos(:,1)) & jointPos(:,1)~=0);
spike = spike(idx,:);
jointPos = jointPos(idx,:);
jointVel = jointVel(idx,:);
jointPos_full = jointPos_full(idx,:);
jointVel_full = jointVel_full(idx,:);

if(bin_time < 0)
    X = jointPos;
    jointPosTrain = X(1:floor(end/2),:);
    jointPosTest = X(floor(end/2)+1:end,:);
    X_full = jointPos_full;
    jointPosTrain_full = X_full(1:floor(end/2),:);
    jointPosTest_full = X_full(floor(end/2)+1:end,:);
    
    X = jointVel;
    jointVelTrain = X(1:floor(end/2),:);
    jointVelTest = X(floor(end/2)+1:end,:);
    X_full = jointVel_full;
    jointVelTrain_full = X_full(1:floor(end/2),:);
    jointVelTest_full = X_full(floor(end/2)+1:end,:);
    
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
%% Kalman filter
if(kalmanparams.velocity)
    X = [jointPos,jointVel];
else
    X = [jointPos];
end
unique_perms = [];
for i = 1:total_repeats
   for j = 1:total_repeats
       if(j > i)
            unique_perms = [unique_perms;i,j];
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
        if(kalmanparams.velocity)
            X = [jointPos,jointVel];
            jointPosTrain = X(1:floor(end/2),:);
            jointPosTest = X(floor(end/2)+1:end,:);
            X_full = [jointPos_full,jointVel_full];
            jointPosTrain_full = X_full(1:floor(end/2),:);
            jointPosTest_full = X_full(floor(end/2)+1:end,:);
        else
            X = jointPos;
            jointPosTrain = X(1:floor(end/2),:);
            jointPosTest = X(floor(end/2)+1:end,:);
            X_full = jointPos_full;
            jointPosTrain_full = X_full(1:floor(end/2),:);
            jointPosTest_full = X_full(floor(end/2)+1:end,:);
        end
        
        spikeTrain = spike(1:floor(end/2),:);
        spikeTest = spike(floor(end/2)+1:end,:);
    end
        
    jointTrain = [jointPosTrain];% jointVelTrain];
    jointTest = [jointPosTest];% jointVelTest];
    jointTrain_full = [jointPosTrain_full];
    jointTest_full = [jointPosTest_full];
  
    % Fit Linear Dynamical System by regression, as well as subtracting the
    % mean input and output
    [A C Q R meanSpike meanJoint] = fitKalman(spikeTrain',[jointTrain'],kalmanparams.lag);

    % Decode on held-out data
    tmp = spikeTest'-meanSpike*ones(1,size(spikeTest,1));

    [jointPred jointVar] = kalmanFilter(tmp,A,C,Q,R,zeros(length(A),1),Q);

    jointTest = jointTest';
    nJoint = size(jointTest,1);
    KalmanCorrCoef = zeros(1,nJoint);
    for iJoint = 1:nJoint
        a = corrcoef(jointTest(iJoint,:),jointPred(iJoint,:));
        KalmanCorrCoef(iJoint) = a(2);
    end

    Results.Joint(1+(iLoop-1)*2).PCA.CorrCoef = KalmanCorrCoef;
    Results.Joint(1+(iLoop-1)*2).PCA.Pred = jointPred;
    Results.Joint(1+(iLoop-1)*2).PCA.Test = jointTest;


  
    
    Pred = jointPred;
  
    if(kalmanparams.velocity)
        end_point = nJoint/2;
    else
        end_point = nJoint;
    end
    PCAParams.Mean = PCAParams.Mean';
    PCAParams_full.Mean = PCAParams_full.Mean';
    reconPred = reconPCAJoint(Pred(1:end_point,:),PCAParams);
    Test = jointTest;
    reconTest = reconPCAJoint(Test(1:end_point,:),PCAParams);
    Test = jointTest_full';
    %whos Test
    reconFull = reconPCAJoint(Test(1:end_point,:),PCAParams_full);
    reconKalmanCorrCoef = zeros(1,nJoint);
    %whos jointTest
    for iJoint = 1:length(JointList)%nJoint
        %a = corrcoef(reconTest(iJoint,:),reconPred(iJoint,:));
        a = corrcoef(reconFull(iJoint,:),reconPred(iJoint,:));
        reconKalmanCorrCoef(iJoint) = a(2);
        a = corrcoef(reconTest(iJoint,:),reconPred(iJoint,:));
        reducedreconKalmanCorrCoef(iJoint) = a(2);
    end
   
    
    Results.Joint(1+(iLoop-1)*2).Recon.CorrCoef = reconKalmanCorrCoef;
    Results.Joint(1+(iLoop-1)*2).Recon.ReducedCorrCoef = reducedreconKalmanCorrCoef;
    Results.Joint(1+(iLoop-1)*2).Recon.Pred = reconPred;
    Results.Joint(1+(iLoop-1)*2).Recon.Test = reconTest;
    Results.Joint(1+(iLoop-1)*2).Recon.TestFull = reconFull;
    Results.Joint(1+(iLoop-1)*2).model.A = A;
    Results.Joint(1+(iLoop-1)*2).model.C = C;
    Results.Joint(1+(iLoop-1)*2).model.Q = Q;
    Results.Joint(1+(iLoop-1)*2).model.R = R;
    Results.Joint(1+(iLoop-1)*2).model.mSpike = meanSpike;
    Results.Joint(1+(iLoop-1)*2).model.mJoint = meanJoint;
    
    % Now repeat on the opposite train, test assignments.
    jointTrain = [jointPosTest];% jointVelTrain];
    jointTest = [jointPosTrain];% jointVelTest];
    jointTrain_full = [jointPosTest_full];
    jointTest_full = [jointPosTrain_full];
    

    % Fit Linear Dynamical System by regression, as well as subtracting the
    % mean input and output
    
    [A C Q R meanSpike meanJoint] = fitKalman(spikeTest',[jointTrain'],kalmanparams.lag);

    % Decode on held-out data
    tmp = spikeTrain'-meanSpike*ones(1,size(spikeTrain,1));

    [jointPred jointVar] = kalmanFilter(tmp,A,C,Q,R,zeros(length(A),1),Q);
    jointTest = jointTest';
    nJoint = size(jointTest,1);
    KalmanCorrCoef = zeros(1,nJoint);
    for iJoint = 1:nJoint
        a = corrcoef(jointTest(iJoint,:),jointPred(iJoint,:));
        KalmanCorrCoef(iJoint) = a(2);
    end

    Results.Joint(iLoop*2).PCA.CorrCoef = KalmanCorrCoef;
    Results.Joint(iLoop*2).PCA.Pred = jointPred;
    Results.Joint(iLoop*2).PCA.Test = jointTest;
   
    Pred = jointPred;
    reconPred = reconPCAJoint(Pred(1:end_point,:),PCAParams);
    Test = jointTest;
    reconTest = reconPCAJoint(Test(1:end_point,:),PCAParams);
    Test = jointTest_full';
    reconFull = reconPCAJoint(Test(1:end_point,:),PCAParams_full);
    reconKalmanCorrCoef = zeros(1,nJoint);
    for iJoint = 1:length(JointList)%nJoint
        %a = corrcoef(reconTest(iJoint,:),reconPred(iJoint,:));
        a = corrcoef(reconFull(iJoint,:),reconPred(iJoint,:));
        reconKalmanCorrCoef(iJoint) = a(2);
        a = corrcoef(reconTest(iJoint,:),reconPred(iJoint,:));
        reducedreconKalmanCorrCoef(iJoint) = a(2);
    end
    Results.Joint(iLoop*2).Recon.CorrCoef = reconKalmanCorrCoef;
    Results.Joint(iLoop*2).Recon.ReducedCorrCoef = reducedreconKalmanCorrCoef;
    Results.Joint(iLoop*2).Recon.Pred = reconPred;
    Results.Joint(iLoop*2).Recon.Test = reconTest;
    Results.Joint(iLoop*2).Recon.TestFull = reconFull;
    Results.Joint(iLoop*2).model.A = A;
    Results.Joint(iLoop*2).model.C = C;
    Results.Joint(iLoop*2).model.Q = Q;
    Results.Joint(iLoop*2).model.R = R;
    Results.Joint(iLoop*2).model.mSpike = meanSpike;
    Results.Joint(iLoop*2).model.mJoint = meanJoint;
end
    
Results.Session = Sess;
Results.Tower = Tower;
Results.JointList = JointList;
Results.PCAParams = PCAParams;
Results.joint_names = joint_names;
Results.jnt_file = joint_file_name;
Results.channels = allchannels;
