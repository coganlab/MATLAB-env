function procElfp(day,rec,Ninput)
%  ELFPPROC processes RAW file to give extended freq median LFP files
%
%  Inputs:  	DAY	= String.
%		REC  = String.  Recording prefix or numbers
%
%

global MONKEYDIR
olddir = pwd;
Dir1 = dir([MONKEYDIR '/' day '/0*']);
Dir2 = dir([MONKEYDIR '/' day '/1*']);
tmp = [Dir1;Dir2];
[recs{1:length(tmp)}] = deal(tmp.name);
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

    if matlabpool('size')
      T = 10;
    else
      T = 20;
    end
    tapers = [0.0025,3000];
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

    for iMT = 1:NumTowers
        disp(['Processing ' MONKEYDIR '/' day '/' prenum '/rec' prenum '.' TowerNames{iMT} '.raw.dat']);
        if exist([MONKEYDIR '/' day '/' prenum '/rec' prenum '.' TowerNames{iMT} '.raw.dat'],'file')
            rec = ['rec' prenum];
            raw_fid = fopen([rec '.' TowerNames{iMT} '.raw.dat'],'r');
            elfp_fid = fopen([rec '.' TowerNames{iMT} '.elfp.dat'],'w');
            if nargin < 3 Ninput = 1e6; end
            %Ninput
            
            chk=1; N=0; MS = 1.5*FS./1e3;
            pre = zeros(CH(iMT),MS); mlfp = zeros(CH(iMT),FS*T+Nf-1,'single');
            while(chk && N<Ninput)
                tic
                N = N+1;
                disp(['MLFP: Loop ' num2str(N)]);
                %data = fread(raw_fid,[CH(iMT),FS*T],'int16=>single') - OFFSET;
                
                data = fread(raw_fid,[CH(iMT),FS*T],[format '=>single']) - OFFSET;
                
                if(size(data,2))
                    for iCh = 1:CH(iMT)
                        data(iCh,:) = GAIN_AD_TO_uV{iMT}(iCh).*data(iCh,:);
                    end
                    Mdata = CH(iMT);
                    Ndata = size(data,2);
                    predata = [pre data]';
                    pre = data(:,end-(MS-1):end);
                    Mdata; 
		    %premed = zeros(size(predata'),'single');
                    mlfp = zeros(Mdata,Ndata+Nf-1,'single');
                    parfor iCh = 1:Mdata
		      tmp = medfilt1(predata(:,iCh),MS)';
                      mlfp(iCh,:) = conv(tmp(1,MS+1:end),filt);
                    end
                    mlfp2 = mlfp(:,Nf./2:FS./5e3:Ndata+Nf./2-1);
                    fwrite(elfp_fid,mlfp2,'float');
                end
                if (size(data,2) < FS*T); chk = 0; end
                toc
            end
            fclose(elfp_fid);
            fclose(raw_fid);
        else
            disp('No raw file found.  Skipping.')
        end
    end
end
cd(olddir);

