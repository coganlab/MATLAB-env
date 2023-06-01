function JointResults = sessTestKARMAJointNeuronDecoding(Session, Tower, permutations, neuron_step_size, JointList, karmaparams)
%
%  Results = sessTestKARMAJointNeuronDecoding(Session, Tower, JointList)
%
%  Inputs:  Session = MocapSession from Behavior Database;
%           Towers = Cell array or string.  Tower/s to analyze
%               {'L_PMd','R_PMd'} to pool L_PMd and R_PMd
%               'L_PMd' or {'L_PMd'} for L_PMd alone.
%           JointList;
%           karmaparams.neural_lag = 7;
%           karmaparams.observed_lag = 7;
%           karmaparams.gamma = 0.0003;
%           karmaparams.C = 4
%  Outputs:  Results = 
%

global MONKEYDIR
day = sessDay(Session);
recs = sessRec(Session);

% Prepare data (same as Kalman Filter prep) - note bin size is larger

if nargin < 3 || isempty(permutations)
  permutations = 10;
end

if nargin < 4 || isempty(neuron_step_size)
  neuron_step_size = 5;
end
if nargin < 5 || isempty(JointList)
  markerset = sessMocapMarkerset(Session);
  JointList = whichJointNames(markerset{1});
end
if nargin < 6 || isempty(karmaparams)
    karmaparams.neural_lag = 10;
    karmaparams.observed_lag = 10;
    karmaparams.gamma = 0.0003;
    karmaparams.C = 4.0000;
end
if(~isdir([MONKEYDIR '/mat/NeuronDropping/']))
    mkdir([MONKEYDIR '/mat/NeuronDropping/'])
end
savefilename = [MONKEYDIR '/mat/NeuronDropping/TestKARMADropNeuronsSession' num2str(Session{4}) 'Step' num2str(neuron_step_size) '.mat']
if(exist(savefilename))
    load(savefilename);
else
    JointResults = [];
end
num_permutations = permutations;


% deal with multiple recording sessions
if(length(recs) == 1)
    path = strcat(MONKEYDIR, '/', day, '/', recs{1}, '/rec', recs{1});
    load(strcat(path, '.Body.Joint.mat'))
    load(strcat(path, '.Body.joint_names.mat'))
    [dum,ind] = intersect(joint_names,JointList);
    
    nJoint = length(JointList);
    jointdata = cell(1,length(ind));
    IntervalFile = [MONKEYDIR '/' day '/mat/rec' recs{1} '.Interval.mat'];
    if exist(IntervalFile,'file')
        %disp('Interval file')
        load(IntervalFile);
        Joint = snipJoint(Joint,Interval);
    end
    for iJoint = 1:length(ind)
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
        load(strcat(path, '.Body.Joint.mat'))
        load(strcat(path, '.Body.joint_names.mat'))
        [dum,ind] = intersect(joint_names,JointList);
        IntervalFile = [MONKEYDIR '/' day '/mat/rec' recs{iRec} '.Interval.mat'];
        if exist(IntervalFile,'file')
            %disp('Interval file')
            load(IntervalFile);
            Joint = snipJoint(Joint,Interval);
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
            total_pk = cell(1,length(pk)*2);
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
% Ignoring any information about intensity of threshold crossing, drops
% spikes and wrist position and velocity into bins of specified width ms.
% take data from a single recording and split into two pieces.
binwidth = 50; % in milliseconds
[spike, jointPos, jointVel] = bin(pk,  binwidth, jointdata);

idx = find(~isnan(jointPos(:,1)) & jointPos(:,1)~=0);
spike = spike(idx,:);
jointPos = jointPos(idx,:);

start_position = length(JointResults);
original_spike = spike;
num_channels = size(original_spike,2);
num_neurons = [1:neuron_step_size:num_channels];

for iLoop = 1:length(num_neurons)
    try
        Results = JointResults(iLoop).Result;
        tmp = Results.Joint;
        perm_index = length(tmp);
    catch
        perm_index = 1;
    end
    for neuron_permutations = perm_index:num_permutations
        perms = randperm(num_channels);
        spike = original_spike(:,perms(num_neurons(iLoop)));
        X = jointPos;
        
        % set test data to half the data
        jointPosTrain = X(1:floor(end/2),:);
        spikeTrain = spike(1:floor(end/2),:);
        
        % vary test data length
        spikeTest = spike(floor(end/2)+1:end,:);
        jointPosTest = X(floor(end/2)+1:end,:);
        
        
        jointTrain = [jointPosTrain];
        jointTest = [jointPosTest];
        
        neural_lag = karmaparams.neural_lag;
        observed_lag = karmaparams.observed_lag;
        gamma = karmaparams.gamma;
        C = karmaparams.C;
        
        model = fitKARMA(spikeTrain, jointTrain, neural_lag, observed_lag, gamma, C); %10,10 worked better
        jointPred = predictKARMA(spikeTest,zeros(nJoint,1),model);
        
        jointTest = jointTest';
        nJoint = size(jointTest,1);
        KARMACorrCoef = zeros(1,nJoint);
        for iJoint = 1:nJoint
            a = corrcoef(jointTest(iJoint,:),jointPred(iJoint,:));
            KARMACorrCoef(iJoint) = a(2);
        end
        
        Results.Joint((neuron_permutations-1)*2+1).CorrCoef = KARMACorrCoef;
        Results.Joint((neuron_permutations-1)*2+1).Pred = jointPred;
        Results.Joint((neuron_permutations-1)*2+1).Test = jointTest;
        Results.Joint((neuron_permutations-1)*2+1).num_neurons = num_neurons(iLoop);
        
        
        Results.Session = Session;
        Results.Tower = Tower;
        Results.JointList = JointList;
        
        X = jointPos;
        
        % set test data to half the data
        jointPosTrain = X(floor(end/2):end,:);
        spikeTrain = spike(floor(end/2):end,:);
        
        % vary test data length
        spikeTest = spike(1:floor(end/2),:);
        jointPosTest = X(1:floor(end/2),:);
        
        
        jointTrain = [jointPosTrain];
        jointTest = [jointPosTest];
        
        neural_lag = karmaparams.neural_lag;
        observed_lag = karmaparams.observed_lag;
        gamma = karmaparams.gamma;
        C = karmaparams.C;
        
        model = fitKARMA(spikeTrain, jointTrain, neural_lag, observed_lag, gamma, C); %10,10 worked better
        jointPred = predictKARMA(spikeTest,zeros(nJoint,1),model);
        
        jointTest = jointTest';
        nJoint = size(jointTest,1);
        KARMACorrCoef = zeros(1,nJoint);
        for iJoint = 1:nJoint
            a = corrcoef(jointTest(iJoint,:),jointPred(iJoint,:));
            KARMACorrCoef(iJoint) = a(2);
        end
        
        
        Results.Joint(neuron_permutations*2).CorrCoef = KARMACorrCoef;
        Results.Joint(neuron_permutations*2).Pred = jointPred;
        Results.Joint(neuron_permutations*2).Test = jointTest;
        Results.Joint(neuron_permutations*2).num_neurons = num_neurons(iLoop);
        
        Results.Session = Session;
        Results.Tower = Tower;
        Results.JointList = JointList;
        
    end
    JointResults(iLoop).Result = Results;
    JointResults(iLoop).Params = karmaparams;
    save(savefilename,'JointResults');
end


