%% load data - same as all the other ones
MONKEYDIR = './Reggie/';
DATES = {'120114'};
TRIALS = {'012'};

load([MONKEYDIR DATES{1} '/' TRIALS{1} '/rec' TRIALS{1} '.Wand.Marker.mat']);
wMarker = Marker;
load([MONKEYDIR DATES{1} '/' TRIALS{1} '/rec' TRIALS{1} '.Body.Marker.mat']);

load([MONKEYDIR DATES{1} '/' TRIALS{1} '/rec' TRIALS{1} '.MocapEvents.mat']);

tt = 2500;
TRIALS = [12];

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
binwidth = 100; % in milliseconds
[spikeTest, wristPosTest, wristVelTest ] = bin(pks,binwidth,{wristMarkers{1}([1 2],:)',wristMarkers{1}([1 3],:)',wristMarkers{1}([1 4],:)'});

idx = find(wristPosTest(:,1));
spikeTest = spikeTest(idx,:);
wristPosTest = wristPosTest(idx,:);
wristVelTest = wristVelTest(idx,:);

%
for i = 1:size(wristPosTest,1)
    if isinf(wristPosTest(i,:))
        wristPosTest(i,:) = wristPosTest(i-1,:);
    end
    if isnan(wristVelTest(i,:)) | isinf(wristVelTest(i,:))
        wristVelTest(i,:) = wristVelTest(i-1,:);
    end
end

%% This cell actually runs the RNN decoding method
% note: since a random network is involved, performance changes each time
% this section is run.

tt = 2500;

IN1 = spikeTest(1:tt,:)';
OUT1 = wristPosTest(1:tt,:)';

[zt, J, wf, wi, wo, M, N] = learnNetwork(IN1, OUT1);

IN2 = spikeTest((tt+1):end,:)';
OUT2 = wristPosTest((tt+1):end,:)';

zpt = networkPrediction(IN2, J, wf, wi, wo, M, N);

linewidth = 3;
fontsize = 14;
fontweight = 'bold';

%%
figure;
subplot 311;
plot(OUT1(1,:), 'linewidth', linewidth, 'color', 'green');
hold on;
plot(zt(1,:), 'linewidth', linewidth, 'color', 'red');
title('training', 'fontsize', fontsize, 'fontweight', fontweight);
legend('out', 'z');	
xlabel('time', 'fontsize', fontsize, 'fontweight', fontweight);
ylabel('out and z', 'fontsize', fontsize, 'fontweight', fontweight);
hold off;
subplot 312;
plot(OUT1(2,:), 'linewidth', linewidth, 'color', 'green');
hold on;
plot(zt(2,:), 'linewidth', linewidth, 'color', 'red');
title('training', 'fontsize', fontsize, 'fontweight', fontweight);
legend('out', 'z');	
xlabel('time', 'fontsize', fontsize, 'fontweight', fontweight);
ylabel('out and z', 'fontsize', fontsize, 'fontweight', fontweight);
hold off;
subplot 313;
plot(OUT1(3,:), 'linewidth', linewidth, 'color', 'green');
hold on;
plot(zt(3,:), 'linewidth', linewidth, 'color', 'red');
title('training', 'fontsize', fontsize, 'fontweight', fontweight);
legend('out', 'z');	
xlabel('time', 'fontsize', fontsize, 'fontweight', fontweight);
ylabel('out and z', 'fontsize', fontsize, 'fontweight', fontweight);
hold off;

%%
figure
subplot 311;
hold on;
plot(OUT2(1,:), 'linewidth', linewidth, 'color', 'green'); 
axis tight;
plot(zpt(1,:), 'linewidth', linewidth, 'color', 'red');
axis tight;
title('simulation', 'fontsize', fontsize, 'fontweight', fontweight);
xlabel('time', 'fontsize', fontsize, 'fontweight', fontweight);
ylabel('out and z', 'fontsize', fontsize, 'fontweight', fontweight);
legend('out', 'z');
hold off
subplot 312;
hold on;
plot(OUT2(2,:), 'linewidth', linewidth, 'color', 'green'); 
axis tight;
plot(zpt(2,:), 'linewidth', linewidth, 'color', 'red');
axis tight;
title('simulation', 'fontsize', fontsize, 'fontweight', fontweight);
xlabel('time', 'fontsize', fontsize, 'fontweight', fontweight);
ylabel('out and z', 'fontsize', fontsize, 'fontweight', fontweight);
legend('out', 'z');
hold off
subplot 313;
hold on;
plot(OUT2(3,:), 'linewidth', linewidth, 'color', 'green'); 
axis tight;
plot(zpt(3,:), 'linewidth', linewidth, 'color', 'red');
axis tight;
title('simulation', 'fontsize', fontsize, 'fontweight', fontweight);
xlabel('time', 'fontsize', fontsize, 'fontweight', fontweight);
ylabel('out and z', 'fontsize', fontsize, 'fontweight', fontweight);
legend('out', 'z');
hold off

echostateCorrCoef = zeros(1,3);
for i = 1:3
    a = corrcoef(wristPosTest((tt+1):end,i),zpt(i,:));
    echostateCorrCoef(i) = a(2);
end
echostateCorrCoef