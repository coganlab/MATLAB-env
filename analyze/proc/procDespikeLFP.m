function procDespikeLFP(day, rec, Ninput)
%  PROCDESPIKELFP processes RAW file to give despike LFP files
%
%   procDespikeLFP(day, rec, Ninput)
%
%  Inputs:  DAY	= String.
%           REC  = String.  Recording prefix or numbers
%           NINPUT = Scalar.  Number of iterations to run
%

global MONKEYDIR
olddir = pwd;

recs = dayrecs(day);

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
if nargin < 3 Ninput = 1e6; end


for iRec = num(1):num(2)
    prenum = recs{iRec};
    disp(['Processing ' day ':' prenum]);
    cd([MONKEYDIR '/' day '/' prenum]);
    tic
    if exist([MONKEYDIR '/' day '/' prenum '/rec' prenum '.experiment.mat'],'file')
        load([MONKEYDIR '/' day '/' prenum '/rec' prenum '.experiment.mat']);
        HardwareType = experiment.hardware.acquisition(1).type;
        
        switch HardwareType
            case {'nstream','nstream_32'}
                format = 'int16';
            case{'Broker'}
                format = 'int16';
            otherwise
                format = experiment.hardware.acquisition(1).type;
        end
        FS = experiment.hardware.acquisition.samplingrate;
        NumTowers = length(experiment.hardware.microdrive);
        TowerNames = cell(1,NumTowers);
        AD_neural_gain = experiment.hardware.acquisition(1).AD_neural_gain;
        for iMT = 1:NumTowers
            TowerNames{iMT} = experiment.hardware.microdrive(iMT).name;
            CH(iMT) = length(experiment.hardware.microdrive(iMT).electrodes);
            for iCh = 1:CH(iMT)
                electrode_gain = experiment.hardware.microdrive(iMT).electrodes(iCh).gain;
                GAIN_AD_TO_uV{iMT}(iCh) = AD_neural_gain./electrode_gain.*1e6;
            end
        end
        
    else
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
        for iMT = 1:NumTowers
            eval(['TowerNames{iMT} = Rec.MT' num2str(iMT) ';']);
            CH(iMT) = Rec.Ch(iMT);
            for iCh = 1:CH(iMT)
                electrode_gain = Rec.Gain((iMT-1)*Rec.Ch(1)+iCh);
                GAIN_AD_TO_uV{iMT}(iCh) = AD_neural_gain./electrode_gain.*1e6;
            end
        end
    end
    
    switch HardwareType
        case 'Broker'
            disp('Broker');
            OFFSET = 2048;
        case {'nstream','nstream_32','NI'}
            OFFSET = 0;
    end
    
    T = 100;
    
    tapers = [0.0025,400];
    n = tapers(1);
    w = tapers(2);
    p = n*w;
    k = floor(2*p-1);
    tapers = [n,p,k];
    tapers(1) = tapers(1).*FS;
    tapers = dpsschk(tapers);
    filt = mtfilt(tapers, FS, 0);
    filt = single(filt./sum(filt));
    Nf = length(filt);
    
    Hipass = 10; Lowpass = 1e3;
    % Full debugging info
    opts.displaylevel = 2;
    
    for iMT = 1:NumTowers
        disp(['Processing ' MONKEYDIR '/' day '/' prenum '/rec' prenum '.' TowerNames{iMT} '.raw.dat']);
        if exist([MONKEYDIR '/' day '/' prenum '/rec' prenum '.' TowerNames{iMT} '.raw.dat'],'file')
            rec = ['rec' prenum];
            raw_fid = fopen([rec '.' TowerNames{iMT} '.raw.dat'],'r');
            dsplfp_fid = fopen([rec '.' TowerNames{iMT} '.dsplfp.dat'],'w');
            
            sp_filename = [rec '.' TowerNames{iMT} '.sp.mat'];
            clu_filename = [rec '.' TowerNames{iMT} '.clu.mat'];
            iso_filename = [rec '.' TowerNames{iMT} '.iso.mat'];
            
            if exist(iso_filename,'file')
                load(sp_filename);
                load(clu_filename);
                load(iso_filename);
                
                disp('Compute LFP spectrum estimate for despiking')
                data = fread(raw_fid,[CH(iMT),FS*T],[format '=>double']) - OFFSET;
                fseek(raw_fid,0,'bof');
                g = cell(1,CH(iMT));
                for iCh = 1:length(iso)
                    if size(iso{iCh}) 
                        if sum(sum(iso{iCh}(:,2:end)))
                        data(iCh,:) = GAIN_AD_TO_uV{iMT}(iCh).*data(iCh,:);
                        a = data(iCh,:)';
                        g{iCh} = fitLFPpowerSpectrum(a, Hipass, Lowpass, FS);
                        end
                    end
                end
                
                chk=1; N=0; MS = 1.5*FS./1e3;  Bs = eye(MS);
                %pre = zeros(CH(iMT),MS);
                %             dsplfp = zeros(CH(iMT),FS*T+Nf-1,'single');
                while(chk && N<Ninput)
                    tic
                    N = N+1;
                    disp(['DSPLFP: Loop ' num2str(N)]);
                    data = fread(raw_fid,[CH(iMT),FS*T],[format '=>double']) - OFFSET;
                    Ndata = size(data,2);
                    if(size(data,2))
                        dsplfp = zeros(CH(iMT), Ndata+Nf-1, 'double');
                        for iCh = 1:length(iso)
                            data(iCh,:) = GAIN_AD_TO_uV{iMT}(iCh).*data(iCh,:);
                            chdata = data(iCh,:)';
                            chsp = sp{iCh};
                            chclu = clu{iCh};
                            if Ndata == FS*T
                                chg = g{iCh};
                            else
                                chg = fitLFPpowerSpectrum(chdata, Hipass, Lowpass, FS);
                            end
                            if size(iso{iCh},1)>N-1
                                CluInd = find(iso{iCh}(N,2:end))+1;
                            else
                                CluInd = 0;
                            end
                            if CluInd
                                for iClu = 1:length(CluInd)
                                    S = zeros(length(chdata),1);
                                    spind = find(chsp(:,1) > (N-1)*1e3+1 & chsp(:,1) < N*1e3);
                                    cluind = find(chclu(spind,2)==CluInd(iClu));
                                    spkinds = floor(chsp(spind(cluind),1)*FS./1e3);
                                    %snipidx = bsxfun(@plus,spkinds,[-MS:MS]);
                                    %snippets = chdata(snipidx);
                                    S(spkinds - 15) = 1;
                                    Results = despikeLFP(chdata,S,Bs,chg,opts);
                                    chdata = Results.z;
                                end
                            end
                            dsplfp(iCh,:) = conv(chdata',filt);
                            %                     Mdata = CH(iMT);
                            %                     predata = [pre data]';
                            %                     pre = data(:,end-(MS-1):end);
                            
                            %                     parfor iCh = 1:Mdata
                            %                         tmp = medfilt1(predata(:,iCh),MS)';
                            %                         dsplfp(iCh,:) = conv(tmp(1,MS+1:end),filt);
                            %                     end
                        end
                    end
                    dsplfp2 = dsplfp(:,Nf./2:FS./1e3:Ndata+Nf./2-1);
                    fwrite(dsplfp_fid,dsplfp2,'float');
                    
                    if (size(data,2) < FS*T); chk = 0; end
                    toc
                end
                fclose(dsplfp_fid);
                fclose(raw_fid);
            end
        else
            disp('No raw file found.  Skipping.')
        end
    end
end
cd(olddir);

