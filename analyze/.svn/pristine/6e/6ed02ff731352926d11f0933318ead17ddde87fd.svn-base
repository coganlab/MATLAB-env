function benchPLVConnectome
% plv connectivity


global MONKEYDIR MONKEYNAME
jug_sc96_analysis % in /pesaranlab/Matlab/monkeys

OUTDIR = sprintf('./results/%s_plvconnectome/',MONKEYNAME);
if ~exist(OUTDIR), mkdir(OUTDIR); end
DIRLOG = sprintf('./logs/%s_plvconnectome/',MONKEYNAME);
if ~exist(DIRLOG), mkdir(DIRLOG); end

% database
load Field_Session_Flagged;
fsess=sess; clear sess
load Multiunit_Session_Flagged;
sess=sess(isig);
nsess=numel(sess);

% Parameters
fsample = 1000;
nboot = 1000;
fsample = 1000;
foi = 2.^[2:1/4:8]; nfoi=numel(foi); % % Center frequencies
octave = 0.5;       % Frequency resolution
foi_min = 2*foi/(2^octave+1);
foi_max = 2*foi/(2^-octave+1);
delta_foi = foi_max-foi_min; % 2*std in foi domain
delta_time = 6/pi./delta_foi;
delta_time = round(delta_time*1000)/1000;
n_off = ceil(delta_time(1)./2*fsample);

% Task part
ALIGN = 'TargsOn';
BN = [-500-n_off 0+n_off];

% field dates and channels
fdates = cell(numel(sess),1);
fchan = nan(numel(sess),1);
for ifsess = 1:numel(fsess)
    fdates{ifsess}=fsess{ifsess}{1};
    Ch = sessChannel(fsess{ifsess});
    fchan(ifsess)=Ch{1};
end

for isess = 1:numel(sess)
    ChSP = sessChannel(sess{isess});
    ChSP = ChSP{1};
    outname = sprintf('%s_%d',sess{isess}{1},ChSP);
    if ~exist(sprintf('%s%s_work',DIRLOG,outname)) & ~exist(sprintf('%s%s_done',DIRLOG,outname))
        eval(sprintf('!touch %s%s_work',DIRLOG,outname))
        trials = dbSelectTrials(sess{isess}{1});

        % field sessions for the spike session
        sfsess = strmatch(sess{isess}{1},fdates);
        iself = find(fchan(sfsess)==ChSP); % remove self
        sfsess(iself)=[];
        nsfsess=numel(sfsess);
        chanid = fchan(sfsess);
        
        % spike channel information
        SysSP = sessTower(sess{isess});
        InfoSP = sessCellDepthInfo(sess{isess});
        ContactSP = sessContact(sess{isess});
        spikes = trialSpike(trials,SysSP,ChSP,ContactSP{1},InfoSP,ALIGN,BN,MONKEYDIR);
       
        % delete spikes that are out of bounds because of LFP windowing
        nsample = numel(BN(1):BN(2));
        for isp=1:numel(spikes)
            spikes{isp}(spikes{isp}<n_off+1)=[];
            spikes{isp}(spikes{isp}>nsample-n_off)=[];
        end
       
        
        % preallocation
        plv=zeros(nsfsess,nfoi);
        ray=zeros(nsfsess,nfoi);
        
        
        for isfsess = 1:nsfsess
            tic, fprintf('Spike %d/%d, Field %d/%d..',isess,nsess,isfsess,nsfsess)

            % trials, spikes
            t=trials;
            s=spikes;
            
            % field channel information
            SysF = sessTower(fsess{sfsess(isfsess)});
            ChF = sessElectrode(fsess{sfsess(isfsess)});
            ContactF = sessContact(fsess{sfsess(isfsess)});
            
            % load data
            lfp = trialLfp(t,SysF,ChF,ContactF(1),ALIGN,BN,MONKEYDIR); % LFP of the field electrode
            
            % lfp cleaning
            z = (lfp-repmat(mean(lfp,2),[1 size(lfp,2)]))./repmat(std(lfp,[],2),[1 size(lfp,2)]);
            [r dummy]=find(abs(z)>5);
            r=unique([r]);
            if ~isempty(r)
                t(r)=[];
                s(r)=[];
                lfp(r,:)=[];
            end
            ntr = numel(t); ns=size(sfspXtr,1);
            clear r dummy z
            
            % create spike trial condition lookup table
            nspikes=0;
            nspikesbefore=0;
            nspikes_tr = zeros(numel(s),1);
            spXtr=[];
            %         cond=zeros(numel(t),1);
            for isp=1:numel(s)
                nspikes = nspikes+numel(s{isp});
                nspikes_tr(isp) = numel(s{isp});
                if numel(s{isp})>0
                    spXtr(nspikesbefore+1:nspikes,1)=s{isp}; % spiketimes
                    spXtr(nspikesbefore+1:nspikes,2)=isp; % trial
                    %                 spXtr(nspikesbefore+1:nspikes,3)=cond(isp); % condition the spike occurs under
                    nspikesbefore=nspikes;
                end
            end
            clear nspikesbefore
            
            % frequency transform
            X=zeros(nspikes,nfoi);
            for ifoi = 1:nfoi
                % Define frequency kernel
                n_win   = round(delta_time(ifoi)*fsample);
                TAPER   = gausswin(n_win,3)'; TAPER = TAPER/sum(TAPER);
                iEXP    = exp(sqrt(-1) * ((1:n_win)-n_win/2-0.5) /fsample*foi(ifoi)*2*pi);
                KERNEL  = (TAPER.*iEXP).';
                for isp = 1:ns
                    section = lfp(spXtr(isp,2),ceil(spXtr(isp,1))-floor(n_win/2):ceil(spXtr(isp,1))+ceil(n_win/2)-1);
                    X(isp,ifoi) = single(section*KERNEL);
                end
            end

            % PLV
            plv(isfsess,:) = abs(sum( X./abs(X))) ./size(X,1);
            
            % Rayleigh stat
            for ifoi =1:nfoi
                ray(isfsess,ifoi) = circ_rtest(angle(X(:,ifoi))); 
            end
            fprintf('. done (%.2fs)\n',toc)
        end
        save(sprintf('%s%s.mat',OUTDIR,outname),'plv','ray','chanid')
        clear plv ray chanid
        eval(sprintf('!mv %s%s_work %s%s_done',DIRLOG,outname,DIRLOG,outname))
    end
end
