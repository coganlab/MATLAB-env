function [dtVsRateDiff,rssMatrix] = calcSpikeDtVsRateDifference(SpikeData,MatrixParams);

%  dtVsRateDiff = calcSpikeDtVsRateDifference(SpikeData,MatrixParams)
%  
%  Calculate the difference in timing between successive spikes in two
%  simultaneously recorded spike trains and summarize this as a function
% of their instantaneous firing rates (determined by preceding ISI).

dtVsRateDiff = [];
rssMatrix = [];

Trial = SpikeData.Trial; % trial indexes
Spike1 = SpikeData.Spike1;
Spike2 = SpikeData.Spike2;
dtVsRateDiff = SpikeData.dtVsRateDiff;

if length(Spike1)>0 & length(Spike2)>0
  maxSampleTotal = 0;
  for tIndex=1:length(Spike1)
    maxSampleTotal = maxSampleTotal + length(Spike1{tIndex}) + length(Spike2{tIndex}); 
  end
  dtVsRateDiff = zeros(maxSampleTotal,6); % [ trialIndex refUnit time1 time2 R1 R2 ];
  ind = 1;
  for iter=1:2
    if iter==2
      Spike1_temp = Spike1;
      Spike1 = Spike2;
      Spike2 = Spike1_temp;
    end
    for tIndex=1:length(Trial)
      sp1 = Spike1{tIndex};
      sp2 = Spike2{tIndex};
      if length(sp1)>1 & length(sp2)>1
        r1 = 1000./(diff(sp1)+eps);
        r2 = 1000./(diff(sp2)+eps);
        sp1 = sp1(2:end);
        sp2 = sp2(2:end);
        for r1Index=1:length(r1)
          sp1val = sp1(r1Index);
          locs = find(sp2<=sp1val);
          if length(locs)>0
%            if sp1val>0 & sp2(locs(end))>0
              if iter==1
                dtVsRateDiff(ind,:) = single([ Trial(tIndex) iter sp1val sp2(locs(end)) r1(r1Index) r2(locs(end)) ]);
              else
                dtVsRateDiff(ind,:) = single([ Trial(tIndex) iter sp2(locs(end)) sp1val r2(locs(end)) r1(r1Index) ]);
              end
%           end
            ind = ind + 1;
          end
        end
      end
    end
  end
  dtVsRateDiff(ind:end,:) = [];
%   dtVsRateDiff(find(dtVsRateDiff(:,1)==0),:) = [];
end

if nargin==2 & exist('MatrixParams','var');
  % Convert this table into a dtVsRateDiff matrix
  rssEstWinLengths = MatrixParams.rssEstWinLengths;
  bn = MatrixParams.bn;
  ds_dt = MatrixParams.ds_dt;

  maxDt = MatrixParams.maxDt;
  maxRateDiff = MatrixParams.maxRateDiff;
  dtInc = MatrixParams.dtInc;
  rateInc = MatrixParams.rateInc;
  synchWinLengths = MatrixParams.synchWinLengths;
  ridgeWidths = MatrixParams.ridgeWidths;
  
  % Dimensions: (# time points, # estimation windows, # rateDiff bins, # dt bins)
  timeBinTotal = ceil(diff(bn)/ds_dt)+1;
  rssMatrix = zeros(timeBinTotal,length(rssEstWinLengths),ceil(maxRateDiff/rateInc),ceil(maxDt/dtInc));
  for t=1:timeBinTotal
    timeBinCenter = bn(1)+(t-1)*ds_dt;
    for w=1:length(rssEstWinLengths)
      halfEstWinLength = rssEstWinLengths(w)/2;
      estWin = [ timeBinCenter-halfEstWinLength timeBinCenter+halfEstWinLength ];
      qLocs = find((dtVsRateDiff(:,2)==1&dtVsRateDiff(:,3)>estWin(1)&dtVsRateDiff(:,3)<=estWin(2))|...
                   (dtVsRateDiff(:,2)==2&dtVsRateDiff(:,4)>estWin(1)&dtVsRateDiff(:,4)<=estWin(2)));
      dt = abs(diff(dtVsRateDiff(qLocs,3:4),1,2));
      rateDiff = abs(diff(dtVsRateDiff(qLocs,5:6),1,2));
      dtBin = min(ceil(maxDt/dtInc),max(1,ceil(dt/dtInc)));
      rateDiffBin = min(ceil(maxRateDiff/rateInc),max(1,ceil(rateDiff/rateInc)));
      for k=1:length(qLocs)
        rssMatrix(t,w,rateDiffBin(k),dtBin(k)) = rssMatrix(t,w,rateDiffBin(k),dtBin(k)) + 1;
      end
    end
  end
end

