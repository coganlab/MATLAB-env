function sp = procSpMuLfp(day,rec,threshfac,saveflag,Ninput, ARTMAX)
%  PROCSPMULFP processes RAW file to give MU files
%
%  sp = procSpMuLfp(day,rec,threshfac,saveflag,Ninput)
%
%  Inputs:  	DAY	= String.
%		REC  = String.  Recording prefix or numbers
%
%
%  Note: MU data are saved in units of 0.1uV as shorts to save disk space.

SCALEFACTOR = 10;  % The MU data are saved in units of 0.1uV as shorts.
if nargin < 6
    ARTMAX = 1.5e3;
end

if nargin < 3; threshfac = -3.5; end
if nargin < 4; saveflag = 1; end


global MONKEYDIR
olddir = pwd;
recs= dayrecs(day);

nRecs = length(recs);
if nargin < 2
    num = [1,nRecs];
elseif ischar(rec)
    num = [find(strcmp(recs,rec)),find(strcmp(recs,rec))];
elseif length(rec)==1
    num = [rec,rec];
else
    num = rec;
end
num

% create matlab pool
hPool=parpool('local');

for iRec = num(1):num(2)
    prenum = recs{iRec};
    disp(['Processing ' day ':' prenum]);
    cd([MONKEYDIR '/' day '/' prenum]);
    tic
    if exist([MONKEYDIR '/' day '/' prenum '/rec' prenum '.experiment.mat'],'file')
        load([MONKEYDIR '/' day '/' prenum '/rec' prenum '.experiment.mat']);
        HardwareType = experiment.hardware.acquisition(1).type;

        switch HardwareType
            case {'nstream','nstream_32','nstream128_32','nstream_64','nstream_128','nstream_256','nstream_rig2_256_256'}
                format = 'int16';
            case{'Laminar_Broker','Broker','Si32_Broker'}
                format = 'int16';
            case{'NI'}
                format = 'float';
            case{'plexon'}
                format = 'short';
            case{'blackrock','human_blackrock_cerebus'}
                format = 'short';
            otherwise
                format = experiment.hardware.acquisition(1).type;
        end
        FS = experiment.hardware.acquisition.samplingrate;
        nMicrodrive = length(experiment.hardware.microdrive);
        %TowerNames = cell(1,NumTowers);
        AD_neural_gain = experiment.hardware.acquisition(1).AD_neural_gain;
        for iMicrodrive = 1:nMicrodrive
            TowerNames{iMicrodrive} = experiment.hardware.microdrive(iMicrodrive).name;
            CH(iMicrodrive) = 0; nElectrode = length(experiment.hardware.microdrive(iMicrodrive).electrodes);
            startCh = 1;
            for iElectrode = 1:nElectrode
                Electrode = experiment.hardware.microdrive(iMicrodrive).electrodes(iElectrode);
                if isfield(Electrode,'numContacts') && length(Electrode.numContacts)
                    numContacts = Electrode.numContacts;
                else
                    numContacts = 1;
                end
                CH(iMicrodrive) = CH(iMicrodrive) + numContacts;
                electrode_gain = experiment.hardware.microdrive(iMicrodrive).electrodes(iElectrode).gain;
                GAIN_AD_TO_uV{iMicrodrive}(startCh:startCh + numContacts - 1) = AD_neural_gain./electrode_gain.*1e6;
                startCh = startCh + numContacts;
            end
        end
       
    else
        % No longer being maintained: LEGACY
        load([MONKEYDIR '/' day '/' prenum '/rec' prenum '.Rec.mat']);
        switch Rec.BinaryDataFormat
            case 'short'
                HardwareType = 'Broker';
                AD_neural_gain = 10./4096;
                format = 'int16';
            case 'ushort'
                HardwareType = 'nstream';
                AD_neural_gain = 1e-6;
                format = 'int16';
            otherwise
                HardwareType = 'DAM-80';
                AD_neural_gain = 1e-6;  %???????  
                format = 'float';
        end
        
        FS = Rec.Fs;
        NumTowers = length(Rec.Ch);
        for iMicrodrive = 1:NumTowers
            eval(['TowerNames{iMicrodrive} = Rec.MT' num2str(iMicrodrive) ';']);
            CH(iMicrodrive) = Rec.Ch(iMicrodrive);
            for iCh = 1:CH(iMicrodrive)
                electrode_gain = Rec.Gain((iMicrodrive-1)*Rec.Ch(1)+iCh);
                GAIN_AD_TO_uV{iMicrodrive}(iCh) = AD_neural_gain./electrode_gain.*1e6;
            end
        end
    end
    
    switch HardwareType
        case {'Laminar_Broker','Broker','Si32_Broker'}
            disp(['Laminar_Broker or Broker']);
            OFFSET = 2048;
        case {'nstream','nstream_32','NI','nstream128_32','nstream_64','nstream_128','nstream_256', 'nstream_rig2_256_256', 'plexon', 'blackrock','human_blackrock_cerebus'}
            OFFSET = 0;
    end

  mem = meminfo;
  % Data per second per microdrive in kbytes:  
  DataRate_kb = CH*FS*2./1024;

    T = min(floor((mem.MemTotal-4*1024*1024)./DataRate_kb./20./hPool.NumWorkers)); % This is the amount of data to load per window of data processing.

    tapers = [0.01,3000];
    n = tapers(1);
    w = tapers(2);
    p = n*w;
    k = floor(2*p-1);
    tapers = [n,p,k];
    tapers(1) = tapers(1).*FS;
    tapers = dpsschk(tapers);
    Mufilt = 2*real(mtfilt(tapers, FS, 3300));
    MuNf = length(Mufilt);

    tapers = [0.0025,400];
    n = tapers(1);
    w = tapers(2);
    p = n*w;
    k = floor(2*p-1);
    tapers = [n,p,k];
    tapers(1) = tapers(1).*FS;
    tapers = dpsschk(tapers);
    filt = mtfilt(tapers, FS, 0);
    Lfpfilt = single(filt./sum(filt));
    LfpNf = length(Lfpfilt);
    thresh = cell(1,nMicrodrive);

    for iMicrodrive = 1:nMicrodrive
        disp(['Processing ' MONKEYDIR '/' day '/' prenum '/rec' prenum '.' TowerNames{iMicrodrive} '.raw.dat']);
        if exist([MONKEYDIR '/' day '/' prenum '/rec' prenum '.' TowerNames{iMicrodrive} '.raw.dat'],'file')
            rec = ['rec' prenum];
            raw_fid = fopen([rec '.' TowerNames{iMicrodrive} '.raw.dat'],'r');
            mu_fid = fopen([rec '.' TowerNames{iMicrodrive} '.mu.dat'],'w');
            lfp_fid = fopen([rec '.' TowerNames{iMicrodrive} '.lfp.dat'],'w');
            if nargin < 5  Ninput = 1e6; end
            %Ninput
            a = dir([rec '.' TowerNames{iMicrodrive} '.raw.dat']);
            nbytes = a.bytes;
            ntimes = ceil(nbytes./2./CH(iMicrodrive)./FS./T);


            sp = cell(1,CH(iMicrodrive));
            for iCh = 1:CH(iMicrodrive)
                sp{iCh} = zeros(ntimes*T*20,FS*1.6./1e3+1+1);
            end
            for iCh = 1:CH(iMicrodrive)
                thresh{iMicrodrive}(iCh) = 0;
                disp(['... electrode contact ' num2str(iCh)]);
                fseek(raw_fid,0,'bof');
                artchk = 1;
                munoise=[];
                while artchk
                    raw = fread(raw_fid,[CH(iMicrodrive),FS*10],format) - OFFSET;
                    
                    if ~isempty(raw) % while we're not out of data
                        mu = (conv(GAIN_AD_TO_uV{iMicrodrive}(iCh).*raw(iCh,:),Mufilt));
                        if max(abs(mu(length(Mufilt)+1:end-length(Mufilt))))< ARTMAX % To get rid of segments with artifacts, make sure to check outside of filter ringing
                            artchk = 0;
                            sd = median(abs(mu(length(Mufilt)+1:end-length(Mufilt))))./0.6745;
                            thresh{iMicrodrive}(iCh) = threshfac*sd;
                        else
                            munoise = [munoise mu(length(Mufilt)+1:end-length(Mufilt))];
                        end
                        
                    else % noisy channel, force threshold by estimating threshold across all data
                        
                        artchk = 0;
%                         sd = median(abs(mu(length(Mufilt)+1:end-length(Mufilt))))./0.6745;
                        sd = median(abs(munoise))./0.6745;
                        thresh{iMicrodrive}(iCh) = threshfac*sd;
                    end
                end
            end
            
            fseek(raw_fid,0,'bof');
            time = 0;            
            chk=1; N=0;
            NSp = zeros(1,CH(iMicrodrive));
            while(chk && N<Ninput)
                tic
                N = N+1;
                disp(['SPMULFP: Loop ' num2str(N) ' of ' num2str(ntimes)]);
                data = fread(raw_fid,[CH(iMicrodrive),FS*T],[format]) - OFFSET;
                
                if(size(data,2))
                    for iCh = 1:CH(iMicrodrive)
                        data(iCh,:) = GAIN_AD_TO_uV{iMicrodrive}(iCh).*data(iCh,:);
                    end
                    Ndata = size(data,2);
                    MuOut = cell(1,CH(iMicrodrive));
                    LfpOut = cell(1,CH(iMicrodrive));
                    parfor iCh = 1:CH(iMicrodrive)
                        tmp = conv(data(iCh,:),Mufilt);
                        mu = tmp(1,MuNf./2:Ndata+MuNf./2-1);
%thresh{iMicrodrive}(iCh)./std(mu)
%thresh{iMicrodrive}(iCh)
%hold off; plot(mu); hold on;
%plot(ones(1,length(mu))*thresh{iMicrodrive}(iCh),'r')
%pause

                        tmp = conv(data(iCh,:),Lfpfilt);
                        lfp = tmp(1,LfpNf./2:FS./1e3:Ndata+LfpNf./2-1);
                        [Sp_tmp, Spktimes_tmp] = spikeextract(mu, thresh{iMicrodrive}(iCh), FS);
                        NSp_tmp = length(Spktimes_tmp);
                        if NSp_tmp > 1
                            SpMat = [Spktimes_tmp+time Sp_tmp];
                            sp{iCh}(NSp(iCh)+1:NSp(iCh)+NSp_tmp,:) = [SpMat];
                            NSp(iCh) = NSp(iCh) + NSp_tmp;
                        end
                        MuOut{iCh} = mu;
                        LfpOut{iCh} = lfp;
                    end
                    mu2 = zeros(CH(iMicrodrive),Ndata); lfp2 = zeros(CH(iMicrodrive),size(LfpOut{1},2));
                    for iCh = 1:CH(iMicrodrive)
                        mu2(iCh,:) = MuOut{iCh};
                        lfp2(iCh,:) = LfpOut{iCh};
                    end

                    fwrite(mu_fid,SCALEFACTOR*mu2,'short');
                    fwrite(lfp_fid,lfp2,'float');

                    time = time+T*1e3;
                end
                if (size(data,2) < FS*T); chk = 0; end
                Elapsed = toc; disp([num2str(Elapsed) 's to process ' num2str(T) 's']);
            end
            fclose(mu_fid);
            fclose(raw_fid);
            fclose(lfp_fid);

            if saveflag
                threshfactor = threshfac;
                for iCh = 1:CH(iMicrodrive)
                    sp{iCh} = sp{iCh}(1:NSp(iCh),:);
                end
                save([rec '.' TowerNames{iMicrodrive} '.sp.mat'],'sp','thresh','threshfactor','-v7.3');
            end
        else
            disp('No raw file found.  Skipping.')
        end
    end
end

if saveflag
	splitSptoChannels(day);
end
delete(hPool)
