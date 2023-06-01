function data = spontReadTSdat(Day, Rec, drive, fileType, recLen)

%data = spontReadTSdat(Day, Rec, drive, fileType, recLen)
%
%reads time-series data from specified file(s).
%when given multiple recs, will concatonate across time.
%returns structure organized by drive(s) loaded.
%
%can also use to load nspike.dat file(s). When loading these files, uses
%channelid definitions in recording experiment definition to divide data
%into drives. 
%
%INPUTS: Day - string with recording day 'YYMMDD' format
%        Rec - recording number(s) to use. Format options:
%               numeric vector (e.g. [1 2 3])
%               string or cell of strings (e.g. '001' or {'001', '002'})
%               empty or 'all' to use all recordings from a day
%        drive - drives to load. Format options:
%                numeric vector reffering to drive index in exp defn file (e.g. [1 2 3])
%                string or cell of strings with drive names (as set in exp defn file (e.g. 'PMd', or {'PMd', 'M1'})
%        fileType - type of file to load (e.g. 'raw' (default), 'lfp', 'clfp' etc.).
%        recLen   - length of time to load from each rec file in seconds (default: all)
%OUTPUT: data - (# drives x 1) structure. Fields:
%               tsDat      - time series (#electrodes x time) data
%               recID      - index of recording file each time-sample belongs to (1 x time)
%               driveName  - name of drive
%               driveNum   - number index of drive (in exp. defn file)
%               Fs         - sampling rate
%               datType    - fileType loaded
%
%A. Orsborn, 2015

global MONKEYDIR
if ~exist('fileType', 'var')
    fileType = 'raw';
end
if ~exist('recLen', 'var')
    recLen = inf;
end

if isempty(Rec) | strcmp(Rec, 'all') %#ok<OR2>
    Rec = dayrecs(Day);
end

%deal with formatting of 'rec'
if isnumeric(Rec)
    tmp = cell(size(Rec));
    for iR=1:length(Rec)
        if Rec(iR)<10
            numTag = '00';
        elseif Rec(iR)<100
            numTag = '0';
        else
            numTag = '';
        end
        
        tmp{iR} = [numTag, num2str(Rec(iR))];
    end
    
    Rec = tmp;
end
if ischar(Rec)
    Rec = {Rec};
end
nRec = length(Rec);

if ischar(drive)
    drive = {drive};
end

dat = cell(nRec, length(drive)); recID = dat;
for iR=1:nRec
    
    datDir = [MONKEYDIR, '/', Day, '/', Rec{iR}, '/'];
    
    load([datDir, 'rec', Rec{iR}, '.experiment.mat'], 'experiment')
    nDrive = max(size(experiment.hardware.microdrive));
    drivenames = cell(size(experiment.hardware.microdrive));
    [drivenames{1:nDrive}] = deal(experiment.hardware.microdrive(:).name);
    
    %find drive(s) to load
    if strcmp(drive, 'all')
        driveInds = 1:length(drivenames);
    elseif iscell(drive)
        
        driveInds = find(ismember(drivenames, drive));
    else
        driveInds = drive;
        
        if any(~ismember(driveInds, 1:nDrive))
            error(['Drive ', num2str(~ismember(driveInds, 1:nDrive)), ' does not exist.'])
        end
    end
    
    
    if strcmpi(fileType, 'nspike')
        Fs = experiment.hardware.acquisition.samplingrate;
        datType = 'short';
        fn = [datDir, 'rec', Rec{iR}, '.', fileType, '.dat'];
        datSize = [experiment.hardware.acquisition.num_channels_streamed Fs*recLen];
        
        %load experiment data
        fid = fopen(fn);
        
        dat_tmp = fread(fid, datSize, datType);
        fclose(fid);
        
        for iD=1:length(driveInds)
            
            channels = [experiment.hardware.microdrive(iD).electrodes(:).channelid];
            
            dat{iR,iD} = dat_tmp(channels,:);
            recID{iR, iD} = ones(1, size(dat{iR,iD},2))*iR;
        end
        
    else
        
        for iD=1:length(driveInds)
            
            nChan = size(experiment.hardware.microdrive(driveInds(iD)).electrodes,2);
            
            switch lower(fileType)
                case {'raw', 'mu', 'cmu'}
                    Fs = experiment.hardware.acquisition.samplingrate;
                    datType = 'short'; %experiment.hardware.acquisition.data_format
                    fn = [datDir, 'rec', Rec{iR}, '.', drivenames{driveInds(iD)}, '.', fileType, '.dat'];
                    datSize = [nChan Fs*recLen];
                case {'lfp', 'clfp', 'mlfp'}
                    Fs = 1000;
                    datType = 'float';
                    fn = [datDir, 'rec', Rec{iR}, '.', drivenames{driveInds(iD)}, '.', fileType, '.dat'];
                    datSize = [nChan Fs*recLen];
                otherwise
                    error('Unsupported data file type.')
            end
            
            
            %load experiment data
            fid = fopen(fn);
            
            dat{iR, iD} = fread(fid, datSize, datType);
            recID{iR, iD} = ones(1, size(dat{iR,iD},2))*iR;
            fclose(fid);
        end
    end
end


%format data
nChans = cellfun('size', dat, 1); nChan_tot = sum(nChans,2);
if length(unique(nChan_tot))>1
    error('Recordings do not have equal number of channels. Investigate.')
end

data = struct('tsDat', [], 'recID', [], 'drive', []);
for iD=1:length(driveInds)
    %eval(['data(iD).' fileType, ' = cat(2, dat{:,iD});']);
    data(iD).tsDat = cat(2, dat{:,iD});
    data(iD).driveName = drivenames{driveInds(iD)};
    data(iD).driveNum  = driveInds(iD);
    data(iD).recID = cat(2, recID{:,iD});
    data(iD).Fs    = Fs;
    data(iD).datType = fileType;
end
