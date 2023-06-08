function [Waveform,mWave,sdWave] = sessMUWaveform(Sess)
%
%	[Waveform,mWave,sdWave] = sessMUWaveform(Sess)
%
%   Waveform = [event,time] Array. The waveforms for the cell
%   mWave = [1,time] Vector.  The middle tertile average spike waveform
%   sdWave = [1,time] Vector.  Standard deviation of middle tertile
%                                   waveforms.

global MONKEYDIR

if ~ischar(Sess{1})
    Trials = Sess{1};
    Sess{1} = Trials(1).Day;
end
Day = Sess{1};
    
Recs = Sess{2};
Tower = sessTower(Sess);
Ch = sessChannel(Sess);
Cl = sessCell(Sess);

Waveform = [];
for iRec = 1:length(Recs)
    disp(['Recording ' Recs{iRec}]);
    load([MONKEYDIR '/' Day '/' Recs{iRec} '/rec' Recs{iRec} '.' Tower '.sp.mat'])
    load([MONKEYDIR '/' Day '/' Recs{iRec} '/rec' Recs{iRec} '.' Tower '.pk.mat']); 
    load([MONKEYDIR '/' Day '/' Recs{iRec} '/rec' Recs{iRec} '.Rec.mat'])
    Log = load([MONKEYDIR '/' Day '/' Recs{iRec} '/rec' Recs{iRec} '.electrodelog.txt']);

    
    if exist([MONKEYDIR '/' Day '/' Recs{iRec} '/rec' Recs{iRec} '.' Tower '.clu.mat'])
        load([MONKEYDIR '/' Day '/' Recs{iRec} '/rec' Recs{iRec} '.' Tower '.clu.mat']);
    else
        clear tmp
        if isempty(pk{Ch})
            tmp = [];
        else
            tmp(:,1) = pk{Ch}(:,1);
            tmp(:,2) = 1;
        end
        clu{Ch} = tmp;
    end
    clu1ind = find(clu{Ch}(:,2) == 1);
    pk{Ch} = pk{Ch}(clu1ind,:);
    sp{Ch} = sp{Ch}(clu1ind,:);
    
    sp = sp{Ch};
    pk = pk{Ch};
    tmp = sp;
    cl = Cl{1}(3);
    if ~isempty(tmp)
        % What do we do with positive going spikes
        if(mean(pk(:,2) < 0)) %Check the peak
            ind = find(tmp(:,2) < cl);
        else
            ind = find(tmp(:,2) > cl);
        end
        if ind
            sp = tmp(ind,:);
        end
    end
    
    % Now to deal with Depth
    depth = Cl{1}(1);
    delta = Cl{1}(2);
    if ~strcmp(Tower,Rec.MT1)
        depthCh = Ch + Rec.Ch(1);
    else
        depthCh = Ch;
    end
    
    time = Log(:,1) * 1e3;
    clear spdepth
    for i = 1:size(sp,1)
        lind = find(time < sp(i,1), 1, 'last' );
        if isempty(lind) %sometime, spike comes before first time stamp
            lind = 1;
        end
        spdepth(i) = Log(lind,depthCh+1);
    end
    depthind = find(spdepth > depth - delta & spdepth < depth + delta);
    sp = sp(depthind,:);

    Waveform = [Waveform;sp(:,2:end)];

end

[a,b] = sort(Waveform(:,9));

mWave = mean(Waveform(b(round(end./3:2*end./3)),:));
sdWave = std(Waveform(b(round(end./3:2*end./3)),:));
