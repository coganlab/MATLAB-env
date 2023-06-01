function procMUA(day,rec)
%  MUAPROC processes RAW file to give MUA files
%
%  Inputs:  	DAY	= String.
%		REC  = String.  Recording prefix or numbers


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
    load([MONKEYDIR '/' day '/' prenum '/rec' prenum '.Rec.mat']);
    load([MONKEYDIR '/' day '/' prenum '/rec' prenum '.experiment.mat']);
    
    T = 5; FS = Rec.Fs;

    F0 = 3500; W = 3000;
    tapers = [0.0025,W];
    n = tapers(1); w = tapers(2);
    p = n*w; k = floor(2*p-1);
    tapers = [n,p,k];
    tapers(1) = tapers(1).*FS;
    tapers = dpsschk(tapers);
    MUfilt = mtfilt(tapers, FS, F0);
%    MUfilt = single(MUfilt./sum(MUfilt));
    Nf_MU = length(MUfilt);

    W = 400;
    tapers = [0.0025,W];
    n = tapers(1); w = tapers(2);
    p = n*w; k = floor(2*p-1);
    tapers = [n,p,k];
    tapers(1) = tapers(1).*FS;
    tapers = dpsschk(tapers);
    LPfilt = mtfilt(tapers, FS, 0);
    LPfilt = single(LPfilt./sum(LPfilt));
    Nf_LP = length(LPfilt);
    
    nTow = numel(experiment.hardware.microdrive);
    for iTow = 1:nTow
        Tow = experiment.hardware.microdrive(iTow).name;
        if isfile([MONKEYDIR '/' day '/' prenum '/rec' prenum '.' Tow '.raw.dat'])
            rec = ['rec' prenum];
            
            CH = Rec.Ch(iTow);
            raw_fid = fopen([rec '.' Tow '.raw.dat'],'r');
            mua_fid = fopen([rec '.' Tow '.mua.dat'],'w');
            chk=1; N=0; 
            mua = zeros(CH,FS*T+Nf_MU-1,'single');
            fprintf('%s: ',Tow),tic;
            while(chk)
                N = N+1;
%                 keyboard
                data = fread(raw_fid,[CH,FS*T],'int16=>single');
                if(size(data,2))
                    for ii = 1:size(data,1)
                        mua(ii,1:size(data,2) + Nf_MU - 1) = 2*conv(data(ii,:),MUfilt);
                    end
                    mua2 = abs(mua(:,Nf_MU./2:size(data,2)+Nf_MU./2-1));
                    for ii = 1:size(data,1)
                        mua3(ii,1:size(mua2,2)+Nf_LP-1) = conv(mua2(ii,:),LPfilt);
                    end
                    mua4 = mua3(:,Nf_LP./2:FS./1e3:size(data,2)+Nf_LP./2-1);
                    fwrite(mua_fid,mua4,'float');
                end
                if (size(data,2) < FS*T); chk = 0; end
            end
            fclose(mua_fid); fclose(raw_fid);
            fprintf('done (%.2fs)\n',toc)
        end
    end
end
cd(olddir);

