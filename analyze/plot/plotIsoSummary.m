% Plot unit isolation summary across all recs/frames for each unit.
% Assumes user has previously run procDaySpikeIsoSummary for relevant data
% and loaded Session metadata into memory.

bn = 1; % (ms) time resolution used by procDaySpikeIsoSummary
refTimeMS = 2; % (ms) downsample ISI histogram bins to this resolution
maxISI = 2; % (ms) refractory period

ind = 1;

totalElapsed = 0;
for s= 1:length(Session)
  Sess = Session{s};
  
  day = Sess{1};
  recs = Sess{2};
  sys = Sess{3}{1};
  ch = Sess{4};
  cl = Sess{5};
  sessID = Sess{6};
  
  disp([day ' - ch ' num2str(ch) ', cl ' num2str(cl)]);
  
  iso = [];
  ISI = [];
  spikeTotal = [];
  meanWaveform = [];
  SNR = [];
  
  isiBins = [ 0:bn:maxISI ];
  refLocs = find(isiBins<refTimeMS);
  
  frameBoundaries = [ 0 ];
  for r=1:length(recs)
    isoFileName = [ MONKEYDIR '/' day '/' recs{r} '/rec' recs{r} '.' sys '.' num2str(ch) '.IsoSummary.mat'];
    load(isoFileName);
    if length(IsoSummary)>=cl
      iso = [ iso; IsoSummary(cl).iso ];
      ISI = [ ISI; IsoSummary(cl).ISI ];    
      spikeTotal = [ spikeTotal; double(IsoSummary(cl).spikeTotal) ];
      meanWaveform = [ meanWaveform; IsoSummary(cl).meanWaveform ];
      SNR = [ SNR; IsoSummary(cl).SNR ];
      frameBoundaries = [ frameBoundaries frameBoundaries(end)+length(IsoSummary(cl).iso) ];
    else
      iso = [ iso; 0*IsoSummary(1).iso ];
      ISI = [ ISI; 0*IsoSummary(1).ISI ];    
      spikeTotal = [ spikeTotal; 0*double(IsoSummary(1).spikeTotal) ];
      meanWaveform = [ meanWaveform; 0*IsoSummary(1).meanWaveform ];
      SNR = [ SNR; 0*IsoSummary(1).SNR ];
      frameBoundaries = [ frameBoundaries frameBoundaries(end)+length(IsoSummary(1).iso) ];
    end
  end
 
  SNR(find(isinf(SNR))) = 1;

  figure(1); % (sessID);

  subplot(2,2,1); hold on;
  plot([1:49],meanWaveform','k');
  axis([1 49 min(min(meanWaveform)) max(max(meanWaveform)) ]);
%   axis square;
  xlabel('Samples'); ylabel('Voltage (uV)'); title('Mean Waveforms');
    
  subplot(2,2,2); hold on;
  plot([1:frameBoundaries(end)],SNR,'k',[1 frameBoundaries(end)],[mean(SNR) mean(SNR)],'b--');
  for b=1:length(frameBoundaries)
    plot([frameBoundaries(b) frameBoundaries(b)],[0 50],'r--');
  end
  axis([1 frameBoundaries(end) 1 max(SNR)+std(SNR)]);
%   axis square;
  xlabel('Frames'); ylabel('SNR'); title('SNR vs Frame');
    
  subplot(2,2,3); hold on;
  plot([1:frameBoundaries(end)],spikeTotal,'k',[1 frameBoundaries(end)],[mean(spikeTotal) mean(spikeTotal)],'b--');
  for b=1:length(frameBoundaries)
    plot([frameBoundaries(b) frameBoundaries(b)],[0 100000],'r--');
  end
  axis([1 frameBoundaries(end) 0 max(spikeTotal)+std(spikeTotal)]);
%   axis square;
  xlabel('Frames'); ylabel('SPikeTotal'); title('SpikeTotal vs Frame');


  refPct = sum(ISI(:,refLocs),2)./(sum(ISI,2)+eps);
  subplot(2,2,4); hold on;
  plot([1:frameBoundaries(end)],refPct,'k',[1 frameBoundaries(end)],[mean(refPct) mean(refPct)],'b--');
  for b=1:length(frameBoundaries)
    plot([frameBoundaries(b) frameBoundaries(b)],[0 1],'r--');
  end
  axis([1 frameBoundaries(end) 0 max(refPct)+std(refPct)]);
%   axis square;
  xlabel('Frames'); ylabel('RefPct'); title('RefPct vs Frame');
  
  pause;
  
  close all;
end
