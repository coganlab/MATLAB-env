function procClfp(day, rec, Ninput)
%  CLFPPROC processes MFLP file to give clean LFP files
%
%  procClfp(day, rec, Ninput)
%
%  Inputs:  	DAY	= String.
%		        REC  = String.  Recording prefix or numbers
%               NINPUT = Scalar.  Number of loops to run.
%                           Defaults to 1e6 (ie the whole file)
%

global MONKEYDIR

olddir = pwd;
Dir1 = dir([MONKEYDIR '/' day '/0*']);
Dir2 = dir([MONKEYDIR '/' day '/1*']);
tmp = [Dir1;Dir2];
[recs{1:length(tmp)}] = deal(tmp.name);
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
        sampling = experiment.hardware.acquisition.samplingrate;
        HardwareType = experiment.hardware.acquisition(1).type;
        NumTowers = length(experiment.hardware.microdrive);
        TowerNames = cell(1,NumTowers);
        for iMT = 1:NumTowers
            TowerNames{iMT} = experiment.hardware.microdrive(iMT).name;
            CH(iMT) = length(experiment.hardware.microdrive(iMT).electrodes);
        end
    else
        load([MONKEYDIR '/' day '/' prenum '/rec' prenum '.Rec.mat']);
        NumTowers = length(Rec.Ch);
        for iMT = 1:NumTowers
            eval(['TowerNames{iMT} = Rec.MT' num2str(iMT) ';']);
            CH(iMT) = Rec.Ch(iMT);
        end
    end
    
    sampling = 1e3;
    T = 0.4;
    fks = [[50,70];[110,130];[170,190];[230,250];[290,310]];

    for iMT = 1:NumTowers
        disp(['Processing ' MONKEYDIR '/' day '/' prenum '/rec' prenum '.' TowerNames{iMT} '.mlfp.dat']);
        if isfile([MONKEYDIR '/' day '/' prenum '/rec' prenum '.' TowerNames{iMT} '.mlfp.dat'])
            rec = ['rec' prenum];
            mlfp_fid = fopen([rec '.' TowerNames{iMT} '.mlfp.dat'],'r');
            clfp_fid = fopen([rec '.' TowerNames{iMT} '.clfp.dat'],'w');
            if nargin < 3 Ninput = 1e9; end
            
            chk = 1; N = 0;
            clfp = zeros(CH(iMT), T*sampling, 'single');
            while(chk && N<Ninput)
                N = N+1;
                if ~mod(N,1000) disp(['CLFP: Loop ' num2str(N)]); end
                mlfp = fread(mlfp_fid, [CH(iMT), T*sampling], 'float=>single');
                Nmlfp = size(mlfp,2);
                if(Nmlfp)
                  T2 = min(T,Nmlfp./sampling);
                  W = max(1.5./T2,10);
                  clfptmp = zeros(CH(iMT),Nmlfp,'single');
                  parfor iCh = 1:CH(iMT)
                    %clfp(iCh,1:Nmlfp) = linefilter(mlfp(iCh,:), [T2, W], sampling, fks);
                    clfptmp(iCh,:) = linefilter(mlfp(iCh,:), [T2, W], sampling, fks);
                    %A(iCh,:) = a;
                  end
                  
                  fwrite(clfp_fid, clfptmp, 'float');
                end
                if (size(mlfp,2) < T*sampling); chk = 0; end
            end
            fclose(mlfp_fid);
            fclose(clfp_fid);
        else
            disp('No mlfp file found.  Skipping.')
        end
    end
end
cd(olddir);

