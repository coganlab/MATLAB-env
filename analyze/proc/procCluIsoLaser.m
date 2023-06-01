function flag = procCluIsoLaser(day,rec,mt, ch)
%
% flag = procCluIso(day, rec, Tower, ch)
%
%   Inputs: DAY = String
%           REC = String
%           TOWER = String/Cell array.
%
% clusters all spikes as cluster 1
% saves Iso and Clu files
%
%   Outputs:  FLAG = 0/1.  0 if clu-iso files don't change
%                          1 if clu-iso files do change

global MONKEYDIR

recs = dayrecs(day);
nRecs = length(recs);
if nargin < 2 || isempty(rec)
    num = [1,nRecs];
elseif ischar(rec)
    num = [find(strcmp(recs,rec)),find(strcmp(recs,rec))];
elseif length(rec)==1
    num = [rec,rec];
else
    num = rec;
end

if nargin < 3 || isempty(mt)
    if exist([MONKEYDIR '/' day '/' recs{1} '/rec' recs{1} '.experiment.mat'],'file')
        load([MONKEYDIR '/' day '/' recs{1} '/rec' recs{1} '.experiment.mat']);
        Towers = [];
        for i = 1:length(experiment.hardware.microdrive)
            Towers = [Towers {experiment.hardware.microdrive(i).name}];
            CH{i} = 1:length(experiment.hardware.microdrive(i).electrodes);
        end
    else
        load(recfile);
        Towers = [{Rec.MT1} {Rec.MT2}];
        CH{1} = 1:Rec.Ch(1);
        CH{2} = 1:Rec.Ch(2);
    end
else
    if iscell(mt)
        Towers = mt;
        for iMT = 1:length(mt)
            CH{iMT} = 1;
        end
    else
        Towers = {mt};
        CH{1} = 1;
    end
end

flag = 0;
for iRec = num(1):num(2)
    rec = recs{iRec};
    
    for iTower = 1:length(Towers)
        mt = Towers{iTower};
        
        spfile = [MONKEYDIR '/' day '/' rec '/rec' rec '.' mt '.sp.mat'];
        clufile = [MONKEYDIR '/' day '/' rec '/rec' rec '.' mt '.clu.mat'];
        isofile = [MONKEYDIR '/' day '/' rec '/rec' rec '.' mt '.iso.mat'];
        rawfile = [MONKEYDIR '/' day '/' rec '/rec' rec '.' mt '.raw.dat'];
        recfile = [MONKEYDIR '/' day '/' rec '/rec' rec '.Rec.mat'];
        load(recfile);
        % nch = Rec.Ch; sampling = Rec.Fs; ss = 2; RAS edit 3/6/12
        nch = 1; sampling = Rec.Fs; ss = 2;
        f = dir(rawfile);
        reclength = (f.bytes)./ss./length(CH{iTower})./sampling*1e3;
        cluflag = exist(clufile, 'file');
        IsoWin = 1e5;
        
        if cluflag
            disp([clufile ' already exists']);
            load(clufile); 
            load(spfile);
            
            for iCh = 1:length(CH{iTower})
                ch = CH{iTower}(iCh);
                                
                if size(clu,2) < ch
                    clu{ch} = [];
                end
                if isempty(clu{ch})
                    sp_tmp = sp{ch};
                    
                    if ~isempty(sp_tmp)
                        sptimes = sp_tmp(:,1);
                        Clu = [sptimes ones(length(sptimes),1)];
                    else
                        Clu = [];
                    end
                    clu{ch} = Clu;
                    save(clufile,'clu');

                    % Now process iso
                    T = [0:IsoWin:reclength reclength];
                    nFrames = length(T)-1;
                    Iso = repmat([1 zeros(1,13)],nFrames,1);
                    isoflag = exist(isofile,'file');

                    if isoflag
                        disp('Iso exists')
                        load(isofile);
                    else
                        disp('Iso does not exist, creating')
                        iso = cell(1,nch); 
                    end
                    
                    iso{ch} = Iso;
                    save(isofile,'iso');
                    flag = 1;  %  Iso changed
                else
                    %  Nothing to do
                    T = [0:IsoWin:reclength reclength];
                    nFrames = length(T)-1;
                    Iso = repmat([1 zeros(1,13)],nFrames,1);
                    isoflag = exist(isofile,'file');
                    if isoflag
                        %disp('Iso exists')
                        load(isofile);
                    else
                        disp('Iso does not exist, creating')
                        iso = cell(1,nch);
                    end
                    iso{ch} = Iso;
                    save(isofile,'iso');

                end
            end
        else
            load(spfile);
            nch = length(sp);
            
            for iCh = 1:length(CH{iTower})
                ch = CH{iTower}(iCh);
                sp_tmp = sp{ch};
                
                IsoWin = 1e5;
                sptimes = sp_tmp(:,1);
                Clu= [sptimes ones(length(sptimes),1)];
                
                T = [0:IsoWin:reclength reclength];
                nFrames = length(T)-1;
                Iso = repmat([1 zeros(1,13)],nFrames,1);
                
                clu{ch} = Clu;
                iso{ch} = Iso;
                save(clufile,'clu');
                save(isofile,'iso');
                flag = 1;  %  Iso changed
            end
        end
    end
end

