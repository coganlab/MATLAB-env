function procDaySpikeIsoSummary(day,recRange,ch,forceOverwrite)

%  procDaySpikeIsoSummary(DAY,RECS,CH,FORCEOVERWRITE)
%  
%  Generates frame-by-frame ISI distributions and SNR values for all clusters
%  in the specified recs and channels.
% 
%  Inputs:  DAY       = String '030603'
%           RECRANGE  = String Range of recs to process. 
%                        e.g. '001', or num [1,2]. Leave empty for all recs.
%           CH        = int16 Channels to process. Leave empty for all channels.
%           FORCEOVERWRITE = Boolean Force overwrite of existing IsoSummary files?

% Future revisions may want to make these passable as parameters.
maxISI = 1000;
bn = 0.5; % (ms)
maxFrameLen = 100; % (sec)

global MONKEYDIR

recs = dayrecs(day); 
nRecs = length(recs);

if nargin < 2 || isempty(recRange)
    num = [1,nRecs];
elseif ischar(recRange)
    num = [find(strcmp(recs,recRange)),find(strcmp(recs,recRange))];
elseif length(recRange)==1
    num = [recRange,recRange];
elseif length(recRange)==2
    num = recRange;
end
%Note that this assumes the same number of channels on each microdrive
if ~isempty(recs)
    
    if nargin<3 || isempty(ch)
        if isfile([MONKEYDIR '/' day '/' recs{1} '/rec' recs{1} '.experiment.mat'])
            load([MONKEYDIR '/' day '/' recs{1} '/rec' recs{1} '.experiment.mat']);
            if length(bn)>1
                save([MONKEYDIR '/' day '/' recs{1} '/rec' recs{1} '.experiment.mat'],'experiment')
                bn = 0.5; % (ms)
            end
            if isfield(experiment.hardware,'microdrive')
                ch = 1:length(experiment.hardware.microdrive(1).electrodes);
            else
                ch = [];
            end
        else
            if isfile([MONKEYDIR '/' day '/' recs{1} '/rec' recs{1} '.Rec.mat'])
                load([MONKEYDIR '/' day '/' recs{1} '/rec' recs{1} '.Rec.mat']);
                if ~strcmp(Rec.Type,'Behavior')
                    ch = 1:Rec.Ch(1);
                else
                    ch = [];
                end
            else
                ch = [];
            end
        end
    end
    nChans = length(ch);
    
    if nargin<4
        forceOverwrite = 0;
    end
    
    isiVals = [0:bn:maxISI];
   
    for iRec=num(1):num(2)
        curRec = recs{iRec}
        recPath = [MONKEYDIR '/' day '/' curRec];
        if isfile([recPath '/rec' curRec '.Rec.mat'])
            load([recPath '/rec' curRec '.Rec.mat']);
            recDuration = Rec.Duration;
        else
            recDuration = 0;
        end
        if isfile([recPath '/rec' curRec '.experiment.mat'])
            load([recPath '/rec' curRec '.experiment.mat']);
            if length(bn)>1
                save([recPath '/rec' curRec '.experiment.mat'],'experiment')
            end
            if isfield(experiment.hardware,'microdrive')
                microdrive = experiment.hardware.microdrive;
            else
                microdrive = [];
            end
        else
            for m = 1:2
                if isfile([recPath '/rec' curRec '.Rec.mat'])
                    if ~strcmp(Rec.Type,'Behavior')
                        cmdstr = (['microdrive(m).name = Rec.MT' num2str(m) ';']);
                        eval(cmdstr)
                    else
                        microdrive = [];
                    end
                else
                    microdrive = [];
                end
            end
        end
        if recDuration>maxFrameLen
            frameDuration = [ 100*ones(1,floor(recDuration/maxFrameLen)) recDuration-100*floor(recDuration/maxFrameLen) ];
        else
            frameDuration = recDuration;
        end
        for m=1:length(microdrive)
            if isfield(microdrive,'name')
            Sys = microdrive(m).name;
            electrodeNum = length(microdrive(m).electrodes);
            for c=1:nChans
                e = ch(c);
                IsoSummary = [];
                movieFileName = [recPath '/rec' curRec '.' Sys '.' num2str(e) '.MovieData.mat'];
                sortFileName = [recPath '/rec' curRec '.' Sys '.' num2str(e) '.SortData.mat'];
                if exist(movieFileName,'file') && exist(sortFileName,'file')
                    movieFile = dir(movieFileName);
                    lastModifiedMovie = movieFile.date;
                    sortFile = dir(sortFileName);
                    lastModifiedSort = sortFile.date;
                    movieTimeStamp = '';
                    sortTimeStamp = '';
                    isoSummaryFileName = [ recPath '/rec' curRec '.' Sys '.' num2str(e) '.IsoSummary.mat'];
                    if exist(isoSummaryFileName,'file')
                        load(isoSummaryFileName);
                    end
                    if forceOverwrite || ...
                            ~isequal(movieTimeStamp,lastModifiedMovie) || ~isequal(sortTimeStamp,lastModifiedSort)
                        load(movieFileName);
                        load(sortFileName);
                        movieTimeStamp = lastModifiedMovie;
                        sortTimeStamp = lastModifiedSort;
                        nFrame = length(MovieData);
                        for iFrame = 1:nFrame
                            clustIDs = [];
                            if size(SortData(iFrame).Clu,1)>0
                                clustIDs = unique(SortData(iFrame).Clu(:,2));
                                clustIDs = clustIDs(clustIDs>0);
                            end
                            for iCl=1:length(clustIDs)
                                Cl = clustIDs(iCl);
                                if ~isfield(IsoSummary,'iso') || length(IsoSummary)<Cl || size(IsoSummary(Cl).iso,1)==0
                                    IsoSummary(Cl).iso = zeros(nFrame,1);
                                    IsoSummary(Cl).ISI = zeros(nFrame,length(isiVals),'uint16');
                                    IsoSummary(Cl).spikeTotal = zeros(nFrame,1,'uint16');
                                        IsoSummary(Cl).meanWaveform = zeros(nFrame,size(MovieData(1).Sp,2),'single');
                                        %IsoSummary(Cl).meanWaveform = zeros(nFrame,49,'single');
                                    IsoSummary(Cl).SNR = zeros(nFrame,1,'single');
                                end
                                IsoSummary(Cl).iso(iFrame) = SortData(iFrame).Iso(Cl);
                                ind = find(SortData(iFrame).Clu(:,2)==Cl);
                                if ~isempty(ind) && length(MovieData(iFrame).SpTimes)==size(SortData(iFrame).Clu,1)
                                    spTimes = MovieData(iFrame).SpTimes(ind);
                                    nSpike = length(spTimes);
                                    n = zeros(1,length(isiVals));
                                    if ~isempty(spTimes)
                                        [n,x] = hist(diff(spTimes),isiVals);
                                    end
                                    Waveforms = MovieData(iFrame).Sp(ind,:);
                                    mWaveform = sum(Waveforms,1)./nSpike;
                                    sdWaveform = Waveforms - mWaveform(ones(1,nSpike),:);
                                    sd = std(sdWaveform(:));
                                    snr =  (max(mWaveform)-min(mWaveform))./(2*sd);
                                    IsoSummary(Cl).spikeTotal(iFrame) = uint16(nSpike);
                                    IsoSummary(Cl).meanWaveform(iFrame,:) = single(mWaveform);
                                    IsoSummary(Cl).SNR(iFrame) = single(snr);
                                    IsoSummary(Cl).ISI(iFrame,:) = uint16(n);
                                end
                            end
                        end
                        eval(['save ' isoSummaryFileName ' IsoSummary frameDuration curRec nFrame maxISI bn movieTimeStamp sortTimeStamp ']);
                    end
                end
            end
        end
        end
    end % iRec=num(1):num(2)
end