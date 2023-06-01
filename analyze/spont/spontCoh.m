function [cohDat, specDat, data] = spontCoh(Day, Rec, drive, cohParams, datParams, data)

%[specDat, data] = spontCoh(Day, Rec, drive, specType, specParams, datParams);
%
%wrapper function to load and pre-process time-series data and call tfcoh to calculate pair-wise coh
%loads time-series of data. Divides into arbitrary trials, identifies
%artifact trials, then computes field-field coherence.
%
%INPUTS: Day - string with recording day 'YYMMDD' format
%        Rec - recording number(s) to use. Format options:
%               numeric vector (e.g. [1 2 3])
%               string or cell of strings (e.g. '001' or {'001', '002'})
%               empty or 'all' to use all recordings from a day
%        drive - drives to load. Format options:
%                numeric vector reffering to drive index in exp defn file (e.g. [1 2 3])
%                string or cell of strings with drive names (as set in exp defn file (e.g. 'PMd', or {'PMd', 'M1'})
%
%        specParams - structure with optional parameters for tfspec.
%           Fields:
%           -'tapers' - tapers to use in [K,TIME], [N,P,K] or [N,W] form.
%			   	        [N,W] Form:  N = duration of analysis window in s.
%                                    W = bandwidth of frequency smoothing in Hz. (default: [1 3 3])
%           -'dn'     - time overlap between neighboring windows
%           -'fk'     - cutoff frequency (Hz) (default: 500)
%           -'pad'    - flag to pad data or not (default: [])
%           -'pval'   - flag to calculate p-values on spectral estimates (default: [])
%        datParams   - structure with optional parameters for loading/pre-processing data
%           -fileType - type of file to load (e.g. 'raw' , 'lfp', 'clfp'(default)  etc.).
%           -recLen   - length of time to load from each rec file in seconds (default: all)
%           -trLen    - length of 'trials' in seconds (default: 5)
%           -sigmaThreshold - number of SD from mean to use as indicator of an artifact (default: 5)
%                             to SKIP artifact rejection, set sigmaThreshold <= 0
%           -trMin    - min # of trials to compute coherence
%       data - if data is already loaded, can provide as input to
%              skip re-loading. Expects data to be formatted as outlined in
%              readTSdat. trial-sorted data can be specified with '_tr' tag in the field.
%OUTPUT:specDat - (#drives x 1) structure. Fields:
%                PS - power spectral data (size depends on specType)
%                freq - frequency values for spectral estimates
%                drive - name of drive
%       data - (# drives x 1) structure. Fields:
%               tsDat      - time series (#electrodes x time) data
%               recID      - index of recording file each time-sample belongs to (1 x time)
%               drive      - name of drive
%               Fs         - sampling rate
%               trDat      - time series (#electrodes x time x trials) of trial-sorted data
%               artTr      - flag identifiying artifacts (#electrodes x trials)
%               datType    - fileType of data loaded
%               datParams  - copy of data parameters
%
%A. Orsborn, 2015


if exist('cohParams', 'var')
    fn = fieldnames(cohParams);
else
    fn = {};
    cohParams = struct([]);
end
parameters = {'tapers', 'dn', 'fk', 'pad', 'pval', 'flag', 'contFlag'}; %rec length in s
defaults   = {[1 3 3],  0.05,  500,  [],    [],      11,    0}; %#ok<NASGU>

for i=1:length(parameters)
    if ~ismember(parameters{i}, fn)
        eval(['cohParams(1).', parameters{i}, '= defaults{i};'])
    end
end

if exist('datParams', 'var')
    fn = fieldnames(datParams);
else
    fn = {};
    datParams = struct([]);
end
parameters = {'fileType', 'trLen', 'sigmaThreshold', 'recLen', 'trMin'}; %rec length in s
defaults   = {'clfp',      5,        5,                inf,      5}; %#ok<NASGU>

for i=1:length(parameters)
    if ~ismember(parameters{i}, fn)
        eval(['datParams(1).', parameters{i}, '= defaults{i};'])
    end
end


%load up data if not input
if ~exist('data', 'var')
    data = spontReadTSdat(Day, Rec, drive, datParams.fileType, datParams.recLen);
end
nDrive = size(data,1);

specDat = struct('PS', [], 'freq', [], 'drive', [], 'datType', []);
cnt = 1;
for iD1=1:nDrive
    
    Fs = data(iD1).Fs;
    
    fields = fieldnames(data(iD1));
    if all(cellfun('isempty', strfind(fields, '_tr')))
        %divide data into arbitrary trials
        disp('Creating arbitrary trials...')
        data(iD1).tsDat_tr = spontMakeTrials(data(iD1).tsDat, datParams.trLen, Fs);
    end
    
    if all(cellfun('isempty', strfind(fields, '_artTr'))) & datParams.sigmaThreshold > 0
        %reject artifacts
        disp('Finding outlier trials...')
        data(iD1).artTr = spontFindArtTrials(data(iD1).tsDat_tr, datParams.sigmaThreshold);
    elseif datParams.sigmaThreshold < 0
        data(iD1).artTr = false(size(trDat,1), size(trDat,3));
    end
    
    data(iD1).datParams = datParams;
    
    %pre-compute frequencies for spectral calculations. Allows
    %pre-allocation etc. 
    nT = size(data(iD1).tsDat_tr,2);
    f = spontCalcMTfreq(nT, Fs, cohParams.tapers, cohParams.dn, cohParams.fk, cohParams.pad);
    nF = length(f);
    
    
    %loop through this drive and earlier (i.e. within-drive coherence and
    %across-drive coherence w/out double-counting pairs)
    for iD2=iD1:-1:1
        disp(['computing coherence: Drive ', num2str(iD1), ' w/ ', num2str(iD2), '...'])
        
        DATA1 = data(iD1).tsDat_tr; INDS1 = data(iD1).artTr;
        DATA2 = data(iD2).tsDat_tr; INDS2 = data(iD2).artTr;
        
        nE1 = size(DATA1,1);
        nE2 = size(DATA2,1);
        
        hPool = gcp('nocreate');
        if isempty(hPool)
            hPool = parpool('local'); %#ok<NASGU>
        end
        
        parfor iE1=1:nE1
            if mod(iE1,10)==1
                fprintf('     electrode %d...\n', iE1)
            end
            %for within-drive pairs, don't double-count electrode pairs
            if iD1==iD2
                e2Inds = iE1+1:nE2
            else
                e2Inds = 1:nE2;
            end
            
            coh_tmp1 = nan(nE2,nF);
            spec_tmp1 = nan(1,nF);
            %freq_tmp1 = nan(1,nF);
            for iE2=e2Inds
                
                trInds = (~INDS1(iE1,:) & ~INDS2(iE2,:))';
                if sum(trInds)>=datParams.trMin

                    [coh, ~, sx, ~] = tfcoh(sq(DATA1(iE1,:,trInds))', sq(DATA2(iE2,:,trInds))', cohParams.tapers, Fs, cohParams.dn, ...
                        cohParams.fk, cohParams.pad, cohParams.pval, cohParams.flag, cohParams.contFlag);

                    %save average across time
                    coh_tmp1(iE2, :) = mean(abs(coh),1);
                    
                    %power spectrum only needs tot be saved once
                    spec_tmp1 = mean(sx,1);
                    
                    %freq_tmp1 = freq;
                    
                else
                    disp(['     Skipping:, E1 = ', num2str(iE1), ', E2 = ', num2str(iE2), '.'])
                end
            end %second electrode
            
            coh_tmp2(iE1,:,:) = coh_tmp1;
            spec_tmp2(iE1,:) = spec_tmp1;
            %freq_tmp2(iE1,:) = freq_tmp1;
        end %first electrode
        
        cohDat(cnt).coh = coh_tmp2;
        cohDat(cnt).freq = f; %freq_tmp2(1,:);
        cohDat(cnt).driveIDs = {data(iD1).driveName data(iD2).driveName};
        cohDat(cnt).category = data(iD1).driveNum + data(iD2).driveNum; %for easy ID of coh calculations
        
        specDat(iD1).PS = spec_tmp2;
        specDat(iD1).freq = f; %freq_tmp2(1,:);
        specDat(iD1).driveName = data(iD1).driveName;
        specDat(iD1).driveNum  = data(iD1).driveNum;
        specDat(iD1).datType = datParams.fileType;
        specDat(iD1).params = cohParams;
        
        
        cnt = cnt+1;
    end %second drive
    
end %first drive
    
    
    
    
