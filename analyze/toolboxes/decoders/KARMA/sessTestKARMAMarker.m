function Results = sessTestKARMAMarker(Session, Tower, MarkerList, karmaparams)
%
%  Results = sessTestKARMAMarker(Session, Tower, MarkerList)
%
%  Inputs:  Session = MocapSession from Behavior Database;
%           Towers = Cell array or string.  Tower/s to analyze
%               {'L_PMd','R_PMd'} to pool L_PMd and R_PMd
%               'L_PMd' or {'L_PMd'} for L_PMd alone.
%           MarkerList;
%           karmaparams.neural_lag = 7;
%           karmaparams.observed_lag = 7;
%           karmaparams.data_lag = 0(ms);
%           karmaparams.gamma = 0.0003;
%           karmaparams.C = 4

global MONKEYDIR
day = sessDay(Session);
recs = sessRec(Session);

%% Prepare data (same as Kalman Filter prep) - note bin size is larger


if nargin < 3 || isempty(MarkerList)
    markerset = sessMocapMarkerset(Session);
    MarkerList = whichMarkerNames(markerset{1});
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

nMarker = length(MarkerList);
nCoord = 3;
path = strcat(MONKEYDIR, '/', day, '/', recs{1}, '/rec', recs{1});
load(strcat(path, '.Body.Marker.mat'))
load(strcat(path, '.Body.marker_names.mat'))

[dum,ind] = intersect(marker_names,MarkerList);
IntervalFile = [MONKEYDIR '/' day '/mat/rec' recs{1} '.Interval.mat'];
if exist(IntervalFile,'file')
    disp('Interval file')
    load(IntervalFile);
    Marker = snipMarker(Marker,Interval);
end
mind = 0;
nMarker = length(ind);
markerdata = cell(1,nCoord*nMarker);
for iMarker = 1:nMarker
    for iCoord = 1:nCoord
        mind = mind + 1;
        markerdata{mind}(:,1) = Marker{ind(iMarker)}(1,:)';
        markerdata{mind}(:,2) = Marker{ind(iMarker)}(iCoord+1,:)';
    end
    %markerdata{iMarker}(:,2) = medfilt1(Marker{ind(iMarker)}(2,:)',15);
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

%    end
%end
% Ignoring any information about intensity of threshold crossing, drops
% spikes and wrist position and velocity into bins of specified width ms.
% take data from a single recording and split into two pieces.

binwidth = 50; % in milliseconds
[spike, markerPos, markerVel] = bin(pk, binwidth, markerdata);


%idx = find(~isnan(markerPos(:,1)) & markerPos(:,1)~=0 & ~isnan(markerVel(:,1)) & markerVel(:,1)~=0);

for ind = 1:size(markerPos,2)
    idx = find(~isnan(markerPos(:,ind)) & ~isinf(markerPos(:,ind)) & markerPos(:,ind)~=0 & ~isnan(markerVel(:,ind)) & ~isinf(markerVel(:,ind)) & markerVel(:,ind)~=0);
    spike = spike(idx,:);
    markerPos = markerPos(idx,:);
    markerVel = markerVel(idx,:);
end


nMarker = size(markerPos,2);
markerPosTrain = markerPos(1:floor(end/2),:);
markerPosTest = markerPos(floor(end/2)+1:end,:);
markerVelTrain = markerVel(1:floor(end/2),:);
markerVelTest = markerVel(floor(end/2+1):end,:);
spikeTrain = spike(1:floor(end/2),:);
spikeTest = spike(floor(end/2)+1:end,:);


%% KARMA
%not obviously stable to parameter variations
%linear-SVR-fit ARMA doesn't gaurantee stability of model
%very sensitive to form of neural input (i.e. smoothed vs unsmoothed)
%have done coarse grid search on hyperparameters within fitKARMA (maybe
%need finer grid search as well)
%requires scaled inputs
markerTrain = [markerPosTrain]; %markerVelTrain];
markerTest = [markerPosTest]; %markerVelTest];
neural_lag = karmaparams.neural_lag;
observed_lag = karmaparams.observed_lag;
gamma = karmaparams.gamma;
C = karmaparams.C;
model = fitKARMA(spikeTrain, markerTrain, neural_lag, observed_lag, gamma, C); %10,10 worked better
markerPred = fast_karma_predict(spikeTest,model);
%markerPred = predictKARMA(spikeTest,zeros(size(markerTrain,2),1),model);
markerPred = markerPred';
markerTest = markerTest';
nMarker = size(markerTest,1);
KARMACorrCoef = zeros(1,nMarker);
for iMarker = 1:nMarker
    a = corrcoef(markerTest(iMarker,:),markerPred(iMarker,:));
    KARMACorrCoef(iMarker) = a(2);
end

Results.Marker(1).CorrCoef = KARMACorrCoef;
Results.Marker(1).Pred = markerPred;
Results.Marker(1).Test = markerTest;

% Now repeat on the opposite train, test assignments.
markerTrain = markerPosTest;
markerTest = markerPosTrain;

model = fitKARMA(spikeTest, markerTrain, neural_lag, observed_lag, gamma, C); %10,10 worked better
%markerPred = predictKARMA(spikeTrain,zeros(size(markerTrain,2),1),model);
markerPred = fast_karma_predict(spikeTrain,model);
markerPred = markerPred';
markerTest = markerTest';
nMarker = size(markerTest,1);
KARMACorrCoef = zeros(1,nMarker);
for iMarker = 1:nMarker
    a = corrcoef(markerTest(iMarker,:),markerPred(iMarker,:));
    KARMACorrCoef(iMarker) = a(2);
end

Results.Marker(2).CorrCoef = KARMACorrCoef;
Results.Marker(2).Pred = markerPred;
Results.Marker(2).Test = markerTest;

Results.Session = Session;
Results.Tower = Tower;
Results.MarkerList = MarkerList;
