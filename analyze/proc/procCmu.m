function procCmu(day, rec, Ninput)
%  CMUPROC processes MU file to give clean MU files
%
%  procCmu(day, rec, Ninput)
%
%  Inputs:  	DAY	= String.
%		        REC  = String.  Recording prefix or numbers
%               NINPUT = Scalar.  Number of loops to run.
%                           Defaults to 1e6 (ie the whole file)
%

global MONKEYDIR

olddir = pwd;
tmp = dir([MONKEYDIR '/' day '/0*']);
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
    
    sampling = experiment.hardware.acquisition(1).samplingrate;
    T = 0.4;
    fks = [[470,490];[950,970];[1430,1450];[1910,1930];[2390,2410];[2870,2890];[3350,3370];[3830,3850];[4310,4330];[4790,4810];[5750,5770];[6230,6250]];
    nMode = 6;

    for iMT = 1:NumTowers
        disp(['Processing ' MONKEYDIR '/' day '/' prenum '/rec' prenum '.' TowerNames{iMT} '.mu.dat']);
        if isfile([MONKEYDIR '/' day '/' prenum '/rec' prenum '.' TowerNames{iMT} '.mu.dat'])
            rec = ['rec' prenum];
            mu_fid = fopen([rec '.' TowerNames{iMT} '.mu.dat'],'r');
            cmu_fid = fopen([rec '.' TowerNames{iMT} '.cmu.dat'],'w');
            if nargin < 3 Ninput = 1e9; end
            
            mu = fread(mu_fid,[CH(iMT),1e5],'short=>single');
            fseek(mu_fid,0,'bof');
            mu2 = mu*mu';
            [u,s,proj] = svd(mu2);
            chk = 1; N = 0;
            cmu = zeros(CH(iMT), T*sampling, 'single');
            while(chk && N<Ninput)
                N = N+1;
                if ~mod(N,1000) disp(['CMU: Loop ' num2str(N)]); end
                mu = fread(mu_fid, [CH(iMT), T*sampling], 'short=>single');
                muproj = proj'*mu;
                Nmu = size(mu,2);
                if(Nmu)
                  T2 = min(T,Nmu./sampling);
                  W = max(1.5./T2,10);
                  %cmutmp = zeros(CH(iMT),Nmlfp,'single');
                  cmuproj = muproj;
                  parfor iMode = 1:nMode
                    %clfp(iCh,1:Nmlfp) = linefilter(mlfp(iCh,:), [T2, W], sampling, fks);
                    cmuproj(iMode,:) = linefilter(muproj(iMode,:), [T2, W], sampling, fks);
                    %A(iCh,:) = a;
                  end
                  cmu = proj*cmuproj;
                  fwrite(cmu_fid, cmu, 'short');
                end
                if (size(mu,2) < T*sampling); chk = 0; end
            end
            fclose(mu_fid);
            fclose(cmu_fid);
        else
            disp('No mu file found.  Skipping.')
        end
    end
end
cd(olddir);

