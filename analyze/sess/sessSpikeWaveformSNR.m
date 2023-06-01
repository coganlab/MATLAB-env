function [SNR, mWaveform, sd, Waveforms] = sessSpikeWaveformSNR(Sess, CondParams, AnalParams)
%function [SNR, mWaveform, sd, Waveforms, t] = sessSpikeWaveformSNR(Sess, CondParams, AnalParams)
%
%   [SNR, mWaveform, sd, Waveforms, t] = sessSpikeWaveformSNR(Sess, CondParams, AnalParams)
%
%   SESS    =   Cell array.  Session information
%   CONDPARAMS =   Data structure.  Parameter information for
%   condition information
%   ANALPARAMS  =   Data structure.  Analysis parameter information.
%       AnalParams.calcByFrame = 1 to get estimate for each frame.
%
%   CondParams.Rec    =   String/Cell.  Recs to pool.
%	    			To pool Task = {'001','002'};
%

global MONKEYDIR

iRec = 1;
if nargin >= 2 && isfield(CondParams,'Rec');
  iRec = find(strcmp(Sess{2},CondParams.Rec));
end

Trials = sessTrials(Sess);
Day = sessDay(Sess);
Sys = sessTower(Sess);
Sys = Sys{1};
if iscell(Sys); Sys = Sys{1}; end
Ch = sessElectrode(Sess);
Contact = sessContact(Sess);
mtCh = getChannelIndex(Trials(1),Sys,Ch,Contact);
Cl = sessCellDepthInfo(Sess);
Cl = Cl{1};

if length(Cl) == 2
  Cl = Cl(1);
elseif length(Cl) == 3 %Multiunit case
  Cl = 1;
end

calcByFrame = 0;
if nargin >= 3 && isfield(AnalParams,'calcByFrame');
  calcByFrame = AnalParams.calcByFrame;
end

SNR = [];
meanWaveform = [];
spikeTotal = [];
rec = [];
frame = [];
fIndex = 1;

Waveforms = [];
for iRec = 1:length(Sess{2})
  SortDataFile = [MONKEYDIR '/' Day '/' Sess{2}{iRec} '/rec' Sess{2}{iRec} '.' Sys '.' num2str(mtCh) '.SortData.mat'];
  MovieDataFile = [MONKEYDIR '/' Day '/' Sess{2}{iRec} '/rec' Sess{2}{iRec} '.' Sys '.' num2str(mtCh) '.MovieData.mat'];
  if exist(MovieDataFile,'file') && exist(SortDataFile,'file')
    load(SortDataFile);
    load(MovieDataFile);
    nFrame = length(MovieData);
    for iFrame = 1:nFrame
      if SortData(iFrame).Iso(Cl)
        ind = find(SortData(iFrame).Clu(:,2)==Cl);
        tmp = MovieData(iFrame).Sp(ind,:);
        Waveforms = [Waveforms ;MovieData(iFrame).Sp(ind,:)];
        
        if calcByFrame
          Waveforms = MovieData(iFrame).Sp(ind,:);
          nSpike = size(Waveforms,1);
          mWaveform = sum(Waveforms,1)./nSpike;
          sdWaveform = Waveforms - mWaveform(ones(1,nSpike),:);
          sd = std(sdWaveform(:));
          meanWaveform = [ meanWaveform; mWaveform ];
          spikeTotal = [ spikeTotal; nSpike ];
          SNR = [ SNR; (max(mWaveform)-min(mWaveform))./(2*sd) ];
          rec{fIndex} = Sess{2}{iRec};
          frame(fIndex) = iFrame;
          fIndex = fIndex + 1;
        end
        
      end
    end
  end
end

if calcByFrame
  mWaveform = [];
  sd = [];
  Waveforms = [];
  %t = [];
  snrVals = SNR;
  SNR = [];
  SNR.snr = snrVals;
  SNR.meanWaveform = meanWaveform;
  SNR.spikeTotal = spikeTotal;  
  SNR.rec = rec;
  SNR.frame = frame;
else
  nSpike = size(Waveforms,1);
  mWaveform = sum(Waveforms,1)./nSpike;
  sdWaveform = Waveforms - mWaveform(ones(1,nSpike),:);
  sd = std(sdWaveform(:));
  SNR = (max(mWaveform)-min(mWaveform))./(2*sd);
end
