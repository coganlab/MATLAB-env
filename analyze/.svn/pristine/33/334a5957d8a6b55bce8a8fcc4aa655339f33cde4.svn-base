function [Waveform,mWave,sdWave] = sessSpikeWaveform(Sess, CondParams, peakInd)
%
%	[Waveform,mWave,sdWave] = sessSpikeWaveform(Sess,CondParams, peakInd)
%
%   Waveform = [event,time] Array. The waveforms for the cell
%   mWave = [1,time] Vector.  The average spike waveform in the fraction bn
%   sdWave = [1,time] Vector.  Standard deviation of waveforms in the 
%                              fraction bn.

MONKEYDIR = sessMonkeyDir(Sess);

%Right now, I'm using CondParams just for the fraction used for mWave and
%sdWave
if nargin<2 || isempty(CondParams)
    bn = [1/3 2/3]; 
else
    bn = CondParams.bn;
end

Day = sessDay(Sess);
Recs = sessRec(Sess);
Tower = sessTower(Sess);
if iscell(Tower); Tower = Tower{1}; end
if iscell(Tower); Tower = Tower{1}; end
Ch = sessElectrode(Sess);
Contact = sessContact(Sess);
Cl = sessCellDepthInfo(Sess);
Cl = Cl{1};
Type = getSessionType(Sess);
if strcmp(Type,'Multiunit')
    thr = Cl(3);
    Cl = 1;
end

Trials = sessTrials(Sess);
mtCh = getChannelIndex(Trials(1),Tower,Ch,Contact);
if nargin < 3
peakInd = 9;  % This depends on the sampling rate
end

Waveform = [];
for iRec = 1:length(Recs)
    disp(['Recording ' Recs{iRec}]);
    load([MONKEYDIR '/' Day '/' Recs{iRec} '/rec' Recs{iRec} '.' Tower '.sp.mat'])
    
    FILENAME = [MONKEYDIR '/' Day '/' Recs{iRec} '/rec' Recs{iRec} '.' Tower '.clu.mat'];
    if exist(FILENAME,'file')
        load(FILENAME)
    else
        makeClu(Day,Recs{iRec},Tower)
        load(FILENAME)
    end
    load([MONKEYDIR '/' Day '/' Recs{iRec} '/rec' Recs{iRec} '.Rec.mat'])

    if exist([MONKEYDIR '/' Day '/' Recs{iRec} '/rec' Recs{iRec} '.' Tower '.iso.mat'],'file')
        load([MONKEYDIR '/' Day '/' Recs{iRec} '/rec' Recs{iRec} '.' Tower '.iso.mat'])
    else
        iso{Ch} = zeros(60,14);
        iso{Ch}(:,1) = 1;
    end
    
    if isempty(Rec.IsoWin)
        Rec.IsoWin = 1e5;
    end

    sp = sp{mtCh};
    clu = clu{mtCh};
    
    if strcmp(Type,'Multiunit')
        %load([MONKEYDIR '/' Day '/' Recs{iRec} '/rec' Recs{iRec} '.' Tower '.pk.mat'])
        if(thr<0) % Negative going threshold
            ind = find(sp(:,peakInd) < thr);
        else
            ind = find(sp(:,peakInd) > thr);
        end
        if ind
            sp = sp(ind,:);
            clu = clu(ind,:);
        end
    end

    if ~isempty(iso{Ch})
        IsoWin = find(iso{mtCh}(:,Cl));
    else
        IsoWin = 1:60;
    end

    ind = [];
    for i = 1:length(IsoWin)
        ind = [ind;find(sp(:,1)>Rec.IsoWin*(IsoWin(i)-1) & sp(:,1)<Rec.IsoWin*IsoWin(i))];
    end
    Waveform = [Waveform;sp(ind(find(clu(ind,2)==Cl)),2:end)];
end

[a,b] = sort(Waveform(:,peakInd));

mWave = mean(Waveform(b(round(end.*bn(1)+1:end.*bn(2))),:));
sdWave = std(Waveform(b(round(end.*bn(1)+1:end.*bn(2))),:));

%makeClu(Day,Recs{iRec},Tower)
