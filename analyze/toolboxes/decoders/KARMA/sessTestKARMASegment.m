function Results = sessTestKARMASegment(Session, Tower, JointList, karmaparams, bin_time, allchannels,joint_file_name,segment_name)
%
%  Results = sessTestKARMAJoint(Session, Tower, JointList)
%
%  Inputs:  Session = MocapSession from Behavior Database;
%           Towers = Cell array or string.  Tower/s to analyze
%               {'L_PMd','R_PMd'} to pool L_PMd and R_PMd
%               'L_PMd' or {'L_PMd'} for L_PMd alone.
%           JointList;
%           karmaparams.neural_lag = 7;
%           karmaparams.observed_lag = 7;
%           karmaparams.data_lag = 0(ms);
%           karmaparams.gamma = 0.0003;
%           karmaparams.C = 4
%           bin_time  =  Test and train bin width (in minutes)
%           joint_file_name = file name of jnt file
%  Outputs:  Results = 
%


global MONKEYDIR
day = sessDay(Session);
recs = sessRec(Session);

% Prepare data (same as Kalman Filter prep) - note bin size is larger

if nargin < 3 || isempty(JointList)
  markerset = sessMocapMarkerset(Session);
  JointList = whichJointNames(markerset{1}); 
end
if nargin < 4 || isempty(karmaparams)
    karmaparams.neural_lag = 7;
    karmaparams.observed_lag = 7;
    karmaparams.gamma = 0.0003;
    karmaparams.C = 4.0000;
    karmaparams.data_lag = 0;
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

if nargin < 6
    joint_file_name = [];
else
    joint_file_name = [joint_file_name '.'];
end

% deal with multiple recording sessions
if(length(recs) == 1)
    path = strcat(MONKEYDIR, '/', day, '/', recs{1}, '/rec', recs{1});
    load([path, '.Body.' joint_file_name 'Joint.mat'])
    load([path, '.Body.' joint_file_name 'joint_names.mat'])
    [dum,ind] = intersect(joint_names,JointList);
    IntervalFile = [MONKEYDIR '/' day '/mat/rec' recs{1} '.Interval.mat'];
    if exist(IntervalFile,'file')
        %disp('Interval file')
        load(IntervalFile);
        Joint = snipJoint(Joint,Interval);
    end
    
    nJoint = length(ind);
    PCAJoint = cell(1,nJoint);
    for iJoint = 1:nJoint
        jointdata{iJoint}(:,1) = Joint{ind(iJoint)}(1,:)';
        jointdata{iJoint}(:,2) = medfilt1(Joint{ind(iJoint)}(2,:)',15);
    end
    
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
        jointdata_tmp = cell(1,nJoint);
        %loop through recs and concatinate
        
        path = strcat(MONKEYDIR, '/', day, '/', recs{iRec}, '/rec', recs{iRec});
        load([path, '.Body.' joint_file_name 'Joint.mat'])
        load([path, '.Body.' joint_file_name 'joint_names.mat'])
        [dum,ind] = intersect(joint_names,JointList);
        IntervalFile = [MONKEYDIR '/' day '/mat/rec' recs{iRec} '.Interval.mat'];
        if exist(IntervalFile,'file')
            %disp('Interval file')
            load(IntervalFile);
            Joint = snipJoint(Joint,Interval);
        end
        
        if(iRec == 1)
            nJoint = length(ind);
            PCAJoint = cell(1,nJoint);
        end
        for iJoint = 1:nJoint
            jointdata_tmp{iJoint}(:,1) = Joint{ind(iJoint)}(1,:)';
            jointdata_tmp{iJoint}(:,2) = medfilt1(Joint{ind(iJoint)}(2,:)',15);
        end
        
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
            current_end_time = max(current_end_time,jointdata_tmp{iJoint}(end,1));
            jointdata_tmp{iJoint}(:,1) = jointdata_tmp{iJoint}(:,1) + end_time;
            jointdata{iJoint} = [jointdata{iJoint}; jointdata_tmp{iJoint}];
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
binwidth = 50; % in milliseconds
[spike, jointPos, jointVel] = bin(pk,  binwidth, jointdata);

if(karmaparams.data_lag ~= 0)
    pad_points = ceil(karmaparams.data_lag/10)
    for iJoint = 1:size(jointPos,2)
        jointPos(:,iJoint) = [nan(pad_points,1);jointPos(1:end - pad_points,iJoint)];
    end 
end

idx = find(~isnan(jointPos(:,1)) & jointPos(:,1)~=0);
spike = spike(idx,:);
jointPos = jointPos(idx,:);

% convert joints to segment position
jointPos = jointsToSegments(jointPos, joint_file_name, segment_name);

if(bin_time < 0)
    X = jointPos;
    jointPosTrain = X(1:floor(end/2),:);
    jointPosTest = X(floor(end/2)+1:end,:);
    spikeTrain = spike(1:floor(end/2),:);
    spikeTest = spike(floor(end/2)+1:end,:);
    %sample_rate = 30000;
    repeats = 2;
    loops = 1;
    total_repeats = 2;
else
    %bin_time is in minutes
    bin_time_ms = bin_time*60*1000;
    total_data = length(jointPos(:,1))*binwidth;
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
for i = 1:total_repeats
   for j = 1:total_repeats
       if(j > i)
            unique_perms = [unique_perms;i,j];
       end
   end
end
if(loops~=size(unique_perms,1))
    disp('error in calculating pemutations')
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
        spikeTrain = spike(1:floor(end/2),:);
        spikeTest = spike(floor(end/2)+1:end,:);
    end
        
    jointTrain = [jointPosTrain];% jointVelTrain];
    jointTest = [jointPosTest];% jointVelTest];
    
    size(jointTest)
    size(jointTrain)
   
    neural_lag = karmaparams.neural_lag;
    observed_lag = karmaparams.observed_lag;
    gamma = karmaparams.gamma;
    C = karmaparams.C;
    
    model = parfitKARMA(spikeTrain, jointTrain, neural_lag, observed_lag, gamma, C); %10,10 worked better
    %jointPred = predictKARMA(spikeTest,zeros(nJoint,1),model);
    jointPred = fast_karma_predict(spikeTest,model);
    jointPred = jointPred';
    
    jointTest = jointTest';
    nJoint = size(jointTest,1);
    KARMACorrCoef = zeros(1,nJoint);
    for iJoint = 1:nJoint
        a = corrcoef(jointTest(iJoint,:),jointPred(iJoint,:));
        KARMACorrCoef(iJoint) = a(2);
    end
    
    Results.Segment(1+(iLoop-1)*2).CorrCoef = KARMACorrCoef;
    Results.Segment(1+(iLoop-1)*2).Pred = jointPred;
    Results.Segment(1+(iLoop-1)*2).Test = jointTest;
    
    % Now repeat on the opposite train, test assignments.
    jointTrain = [jointPosTest];% jointVelTrain];
    jointTest = [jointPosTrain];% jointVelTest];
    
    model = fitKARMA(spikeTest, jointTrain, neural_lag, observed_lag, gamma, C); %10,10 worked better
    %jointPred = predictKARMA(spikeTrain,zeros(nJoint,1),model);
    jointPred = fast_karma_predict(spikeTrain,model);
    jointPred = jointPred';
    
    jointTest = jointTest';
    nJoint = size(jointTest,1);
    KARMACorrCoef = zeros(1,nJoint);
    for iJoint = 1:nJoint
        a = corrcoef(jointTest(iJoint,:),jointPred(iJoint,:));
        KARMACorrCoef(iJoint) = a(2);
    end
    
    Results.Segment(iLoop*2).CorrCoef = KARMACorrCoef;
    Results.Segment(iLoop*2).Pred = jointPred;
    Results.Segment(iLoop*2).Test = jointTest;
end

Results.SegmentName = segment_name;    
Results.Session = Session;
Results.Tower = Tower;
Results.JointList = JointList;
Results.jnt_file = joint_file_name;
