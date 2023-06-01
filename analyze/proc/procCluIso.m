function flag = procCluIso(day,rec,mt, ch)
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
    disp(recs{1})
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
        disp(['Working on ' rec ':' mt]);
        spfile = [MONKEYDIR '/' day '/' rec '/rec' rec '.' mt '.sp.mat'];
        clufile = [MONKEYDIR '/' day '/' rec '/rec' rec '.' mt '.clu.mat'];
        isofile = [MONKEYDIR '/' day '/' rec '/rec' rec '.' mt '.iso.mat'];
        rawfile = [MONKEYDIR '/' day '/' rec '/rec' rec '.' mt '.raw.dat'];
        recfile = [MONKEYDIR '/' day '/' rec '/rec' rec '.Rec.mat'];
        load(recfile);
        try
            nch = Rec.Ch;
        catch
            nch = ch;
        end
        sampling = Rec.Fs; ss = 2;
        f = dir(rawfile);
        reclength = (f.bytes)./ss./length(CH{iTower})./sampling*1e3;
        cluflag = exist(clufile, 'file');
        IsoWin = 1e5;
	
	for iCh = 1:nch
		moviefile = [MONKEYDIR '/' day '/' rec '/rec' rec '.' mt '.' num2str(iCh) '.MovieData.mat'];
		MovieData = struct([]);
		
        	movieflag = ~exist(moviefile, 'file');
		if movieflag
			disp([moviefile ' is being created'])
			if exist([MONKEYDIR '/' day '/' rec '/rec' rec '.' mt '.' num2str(iCh) '.sp.mat'],'file');
			  load([MONKEYDIR '/' day '/' rec '/rec' rec '.' mt '.' num2str(iCh) '.sp.mat']);
			  spch= sp;
			else
			  load([MONKEYDIR '/' day '/' rec '/rec' rec '.' mt '.sp.mat']);
			  spch = sp{iCh};
			end
			sptimes = spch(:,1);
			T = [0:IsoWin:max(sptimes) max(sptimes)];
			nFrames = length(T)-1;
			disp([num2str(nFrames) ' frames']);
			MAXFRAME = nFrames;

			N = zeros(1,nFrames+1);
			for i = 2:nFrames+1
    				N(i) = find(sptimes<T(i), 1, 'last' );
			end
			N(end) = N(end)+1;
			sp_seg = spch(N(1)+1:N(1+1),2:end);
			[U_seg,pcold,eigvalues] = spikepcs(spch(N(1)+1:N(2),:));
			MovieData(1).Sp = spch(N(1)+1:N(2),2:end);
			MovieData(1).U = U_seg;
			MovieData(1).SpTimes = spch(N(1)+1:N(2),1);
			MovieData(1).PC=pcold;
			MovieData(1).EigFrac=(eigvalues.^2)/sum(eigvalues.^2); %fractional sum of squares
			MovieData(1).TempInclude = ones(size(U_seg,1),1);

			for iFrame = 2:nFrames
    			  disp(['Frame ' num2str(iFrame) ' has ' num2str(N(iFrame+1)-N(iFrame)-1) ' spikes'] )
    			  if N(iFrame+1)-(N(iFrame)+1);
        		    [U_seg,pc,eigvalues] = spikepcs(spch(N(iFrame)+1:N(iFrame+1),:),pcold);
        		    U_old = spch(N(iFrame-1)+1:N(iFrame),2:end)*pcold;
        		    U_new = spch(N(iFrame-1)+1:N(iFrame),2:end)*pc;
        		    MovieData(iFrame).U = U_seg;
        		    MovieData(iFrame).PC = pc;
        		    MovieData(iFrame).EigFrac = (eigvalues.^2)/sum(eigvalues.^2); %fractional sum of squares
        		    MovieData(iFrame).Sp = spch(N(iFrame)+1:N(iFrame+1),2:end);
        		    MovieData(iFrame).SpTimes = spch(N(iFrame)+1:N(iFrame+1),1);
        		    MovieData(iFrame).TempInclude = ones(size(U_seg,1),1);
        		    pcold = pc;
    			  end
			end
			save(moviefile,'MovieData');
		else
			disp([moviefile ' already exists']);
		end % End movieflag for a channel
	end	% End channel loop
        
        if cluflag
            disp([clufile ' already exists']);
            load(clufile); 
            load(spfile);
            
            for iCh = 1:length(sp)
                ch = iCh;
                                
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
            IsoWin = 1e5;
            for iCh = 1:nch
                ch = iCh;
                sp_tmp = sp{ch};
                
                if ~isempty(sp_tmp)
                    sptimes = sp_tmp(:,1);
                    Clu= [sptimes ones(length(sptimes),1)];
                    clu{ch} = Clu;
                else
                    clu{ch} = [];
                end
                T = [0:IsoWin:reclength reclength];
                nFrames = length(T)-1;
                Iso = repmat([1 zeros(1,13)],nFrames,1);
                iso{ch} = Iso;
                save(clufile,'clu');
                save(isofile,'iso');
                flag = 1;  %  Iso changed
            end
        end
    end
end


