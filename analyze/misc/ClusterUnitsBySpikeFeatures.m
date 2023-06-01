% ClusterUnitsBySpikeFeatures.m
% 
% Loads the mean spike waveform for each unit in the spike database and
% calculates the following features: time between max and min, time
% between half-maximal spike amplitudes before/after peak.
% 
% NOTE: This script loads IsoSummary files for all specified units.
% You must run procDaySpikeIsoSummary for the relevant day/recs/channel
% before trying to calculate spike features.

samplingRate = 3e4; % (Hz)
hsGain = 10; % headstage gain
usFactor = 8; % upsample spike waveforms by this factor
minSNR = 0; % SNR threshold for inclusion in cluster analysis
Nclust =  6; % # of clusters to find using k-means 
kiter = 100; % # iterations of k-means
% maxNclust = 10; % used to study how SSE scales with cluster total

dt = 1e3/samplingRate;
dt = dt/usFactor;

global MONKEYDIR

Session = loadSpike_Database;

spFeatures = []; % feature data for all units
waveforms = []; % mean waveforms for all units
badUnits = []; % list of units that fail to meet filtering criteria
chIDs = []; % channel IDs for all units

% Generate Spike Features
for spID = 1:length(Session)
  Sess = Session{spID}
  
  day = Sess{1};
  recs = Sess{2};
  sys = Sess{3}{1};
  ch = Sess{4};
  cl = Sess{5};
  sessID = Sess{6};
  
  meanWaveform = [];
  SNR = [];
    
  frameBoundaries = [ 0 ];
  for r=1:length(recs)
    isoFileName = [ MONKEYDIR '/' day '/' recs{r} '/rec' recs{r} '.' sys '.' num2str(ch) '.IsoSummary.mat'];
    if exist(isoFileName,'file')
      load(isoFileName);
      if length(IsoSummary)>=cl
        meanWaveform = [ meanWaveform; IsoSummary(cl).meanWaveform ];
        SNR = [ SNR; IsoSummary(cl).SNR ];
      else
        meanWaveform = [ meanWaveform; 0*IsoSummary(1).meanWaveform ];
        SNR = [ SNR; 0*IsoSummary(1).SNR ];
      end
    end
  end
  
  SNR = mean(SNR);
  mWaveform = mean(meanWaveform,1);

  if SNR>=minSNR & sum(isnan(mWaveform))==0
      
    mWaveform = mWaveform/hsGain;
    mWaveform = interp1([1:length(mWaveform)],mWaveform,...
                      [1:1/usFactor:length(mWaveform)],'spline','extrap');  
                  
    if  max(mWaveform)>abs(min(mWaveform))
      mWaveform = -mWaveform; % spikes are positive-going; invert waveform
    end

    badUnits = [ badUnits 0 ];
    waveforms = [ waveforms; mWaveform ];
  
    baselineVal = 0; % mean(mWaveform([end-9:end]));
    [peakVal,peakLoc] = min(mWaveform);
    [troughVal,troughLoc] = max(mWaveform);
  
    halfMaxLocs1 = find(mWaveform(1:peakLoc)>(peakVal-baselineVal)/2);
    halfMaxLocs2 = find(mWaveform(peakLoc:end)>(peakVal-baselineVal)/2);

    halfMaxTime = peakLoc+halfMaxLocs2(1)-halfMaxLocs1(end);
    peakTroughTime = abs(troughLoc-peakLoc);
  
    spFeatures = [ spFeatures; halfMaxTime peakTroughTime ];
    chIDs = [ chIDs Sess{4} ];  
  else
    badUnits = [ badUnits 1 ];
  end
end

% Run k-means to find cluster centers
[centers,options,post,errlog] = kmeans(spFeatures,Nclust);
for k=1:kiter
  centers = [ [min(spFeatures(:,1)):(max(spFeatures(:,1))-min(spFeatures(:,1)))/(Nclust-1):max(spFeatures(:,1))]' ...
              [min(spFeatures(:,2)):(max(spFeatures(:,2))-min(spFeatures(:,2)))/(Nclust-1):max(spFeatures(:,2))]' ];
  [centers,options,post,errlog] = kmeans(spFeatures,Nclust,centers);
end

cIDs = post*[1:Nclust]';
sessIDs = find(badUnits==0)';

% Save spike features and cluster assignments
eval(['save ' MONKEYDIR '/mat/SpikeClusters sessIDs cIDs spFeatures']);


%% PLOT CLUSTER SUMMARY

% Generate a 2D histogram of spike features
fHist = zeros(20*ceil(max(spFeatures(:,1))/20),20*ceil(max(spFeatures(:,2))/20));
for k=1:size(spFeatures,1)
  fHist(spFeatures(k,1),spFeatures(k,2)) = fHist(spFeatures(k,1),spFeatures(k,2)) + 1;
end

% Scatterplot spike features
figure(1);
subplot(2,2,1); hold on;
plot(spFeatures(:,1),spFeatures(:,2),'.k','MarkerSize',10);
axis([ 0 size(fHist,1) 0 size(fHist,2) ]);
set(gca,'XTick',[20:20:size(fHist,1)]);
set(gca,'YTick',[20:20:size(fHist,2)]);
set(gca,'XTickLabel',round(100*dt*[20:20:size(fHist,1)])/100);
set(gca,'YTickLabel',round(100*dt*[20:20:size(fHist,2)])/100);
axis square;
xlabel('halfMaxTime (ms)');
ylabel('peakTroughTime (ms)');
title('Spike Feature Data');
plot(centers(:,1),centers(:,2),'dr','MarkerSize',10);
hold off;

% Color-code identified clusters
subplot(2,2,2); hold on;
for cID=1:Nclust
  switch cID
      case 1
          cProfile = '.b';
      case 2
          cProfile = '.g';
      case 3
          cProfile = '.r';
      case 4
          cProfile = '.c';
      case 5
          cProfile = '.m';
      case 6
          cProfile = '.y';          
      otherwise
          cProfile = '.k';
  end
  cLocs = find(cIDs==cID);
  plot(spFeatures(cLocs,1),spFeatures(cLocs,2),cProfile,'MarkerSize',10);
end
hold off;
axis([ 0 size(fHist,1) 0 size(fHist,2) ]);
set(gca,'XTick',[20:20:size(fHist,1)]);
set(gca,'YTick',[20:20:size(fHist,2)]);
set(gca,'XTickLabel',round(100*dt*[20:20:size(fHist,1)])/100);
set(gca,'YTickLabel',round(100*dt*[20:20:size(fHist,2)])/100);
axis square;
xlabel('halfMaxTime (ms)');
ylabel('peakTroughTime (ms)');
title('Cluster Assignments');


% % How does SSE scale with  Nclusters?
% cError = [];
% for Nclust=1:maxNclust
%   errVals = [];
% %   [centers,options,post,errlog] = kmeans(spFeatures,Nclust,centers);
%   for k=1:kiter
%     centers = [ [min(spFeatures(:,1)):(max(spFeatures(:,1))-min(spFeatures(:,1)))/(Nclust-1):max(spFeatures(:,1))]' ...
%                 [min(spFeatures(:,2)):(max(spFeatures(:,2))-min(spFeatures(:,2)))/(Nclust-1):max(spFeatures(:,2))]' ];
%     [centers,options,post,errlog] = kmeans(spFeatures,Nclust,centers);
%     cIDs = post*[1:Nclust]';
%     sse = 0;
%     for cID=1:k
%       locs = find(cIDs==cID);
%       if length(locs)>0
%         sse = sse + sum((spFeatures(locs,:)-[repmat(centers(cID,1),length(locs),1) repmat(centers(cID,2),length(locs),1)]).^2);
%       end
%     end
%     errVals = [ errVals sse/k ];
%   end
%   cError = [ cError; Nclust mean(errVals) std(errVals) ];
% end
% subplot(2,2,2);
% errorbar(cError(:,1),cError(:,2),cError(:,3),'k');
% axis square;


% Summarize fraction of total units that appear in each cluster
subplot(2,2,3);
[n,x]=hist(cIDs,[1:Nclust]);
n = n./sum(n);
bar(x,n,'k');
axis([0 Nclust+1 0 0.5]);
axis square;
xlabel('Cluster ID');
ylabel('Density');
title('Membership Summary');


% Summarize mean spike waveforms for all clusters
cWaveforms = [];
waveforms = waveforms./(repmat(-min(waveforms,[],2),1,size(waveforms,2))+eps);
for k=1:Nclust
  cWaveforms = [ cWaveforms; mean(waveforms(find(cIDs==k),:),1)];
end
subplot(2,2,4);
plot(cWaveforms');
set(gca,'XTick',[0:100:size(cWaveforms,2)]);
set(gca,'XTickLabel',round(100*dt*[0:100:size(cWaveforms,2)])/100);
axis square;
xlabel('Time (ms)');
ylabel('Voltage (normalized)');
title('Cluster Mean Waveforms');
legend('C1','C2','C3','C4','C5','C6','Location','SouthEast');


