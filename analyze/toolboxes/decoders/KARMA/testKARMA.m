MONKEYDIR = '/vol/sas2a/Reggie_PMd_SC32x2/';
DATES = {'111221'};
TRIALS = [5 6];

%% Prepare data (same as Kalman Filter prep) - note bin size is larger
pks = {};
wristMarkers = {};
for date = DATES
    for trial = TRIALS
        path = strcat(MONKEYDIR, date, '/', sprintf('%0.3u',trial), '/rec', sprintf('%0.3u',trial));
        load(strcat(path{1}, '.Body.Marker.mat'))
        load(strcat(path{1}, '.Body.marker_names.mat'))
        wristMarkers = [wristMarkers Marker{find(cellfun(@(x)strcmpi(x,'R.Wrist'),marker_names),1)}];
        
        load([path{1} '.L_PMd.pk.mat'])
        lpk = pk;
        load([path{1} '.R_PMd.pk.mat'])
        rpk = pk;
        pks = [pks lpk rpk];
    end
end
        
% Ignoring any information about intensity of threshold crossing, drops
% spikes and wrist position and velocity into bins of specified width ms.
binwidth = 50; % in milliseconds
[spikeTrain,wristPosTrain,wristVelTrain] = bin(pks(1:64),  binwidth,{wristMarkers{1}([1 2],:)',wristMarkers{1}([1 3],:)',wristMarkers{1}([1 4],:)'});
[spikeTest, wristPosTest, wristVelTest ] = bin(pks(65:end),binwidth,{wristMarkers{2}([1 2],:)',wristMarkers{2}([1 3],:)',wristMarkers{2}([1 4],:)'});

% Clear zeros
idx = find(wristPosTrain(:,1));
spikeTrain = spikeTrain(idx,:);
wristPosTrain = wristPosTrain(idx,:);
wristVelTrain = wristVelTrain(idx,:);

idx = find(wristPosTest(:,1));
spikeTest = spikeTest(idx,:);
wristPosTest = wristPosTest(idx,:);
wristVelTest = wristVelTest(idx,:);

%% KARMA
%not obviously stable to parameter variations
%linear-SVR-fit ARMA does not gaurantee stability of model
%very sensitive to form of neural input (i.e. smoothed vs unsmoothed) 
%have done coarse grid search on hyperparameters within fitKARMA (maybe
%need finer grid search as well)
%requires scaled inputs
model = fitKARMA(spikeTest(1:5000,:), wristPosTest(1:5000,:), 10, 10,  0.0003, 4.0000); %10,10 worked better
yhat = predictKARMA(spikeTest(5001:end,:),zeros(3,1),model);

KARMACorrCoef = zeros(1,3);
figure
for i=1:3
    subplot(3,1,i)
%     plot(wristPosTest(:,i))
    plot(wristPosTest(5001:end,i))
    hold on
    plot(yhat(i,:),'r')
    hold off
%     a = corrcoef(wristPosTest(:,i),yhat(i,:));
    a = corrcoef(wristPosTest(5001:end,i),yhat(i,:));
    KARMACorrCoef(i) = a(2);
    title(['cc = ' num2str(a(2))])
end















