function [ISI] = sessSpikeISIHist(Sess, CondParams, AnalParams)
%
%   [ISI] = sessSpikeISIHist(Sess, CondParams, AnalParams)
%
%   SESS    =   Cell array.  Session information
%   CONDPARAMS =   Data structure.  Parameter information for
%   condition information
%   ANALPARAMS  =   Data structure.  Analysis parameter information.
%
%   If ANALPARAMS.calcByFrame = 1, the ISI distribution will be calculated
%   separately for each frame.
% 
%   CondParams.Rec    =   String/Cell.  Recs to pool.
%	    			To pool Task = {'001','002'};
%

global MONKEYDIR

iRec = 1;
if nargin >= 2 & isfield(CondParams,'Rec');
  iRec = find(strcmp(Sess{2},CondParams.Rec));
end

Day = sessDay(Sess);
Sys = sessTower(Sess);
Ch = sessElectrode(Sess);
Contact = sessContact(Sess);
Cl = sessCell(Sess);

mtCh = getChannelIndex(Trials(1),Sys,Ch,Contact);

maxISI = 1000;
bn = 0.5; % (ms)
calcByFrame = 0;
if nargin >= 3
  if isfield(AnalParams,'maxISI')
    maxISI = AnalParams.maxISI; 
  end
  if isfield(AnalParams,'bn')
    bn = AnalParams.bn; 
  end
  if isfield(AnalParams,'calcByFrame');
    calcByFrame = AnalParams.calcByFrame;
  end
end

ISI = [];
rec = [];
frame = [];
fIndex = 1;

isi = [];

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
        spTimes = MovieData(iFrame).SpTimes(ind);
        
        if calcByFrame
          [n,x] = hist(diff(spTimes),[0:bn:maxISI]);
          ISI.isiHist(fIndex).data = n;
          rec{fIndex} = Sess{2}{iRec};
          frame(fIndex) = iFrame;
          fIndex = fIndex + 1;
        else
          isi = [ isi diff(spTimes)' ];
        end
        
      end
    end
  end
end

ISI.bn = bn;
ISI.maxISI = maxISI;

if calcByFrame
  ISI.rec = rec;
  ISI.frame = frame;
else
  [n,x]=hist(isi,[0:bn:maxISI]);
  ISI.isiHist = n;
end
