function rawScout(day,rec,reclength,chans,run)
%
%  rawScout(day,rec,reclength,chans)
%
%   Inputs:  DAY = String.  Recording day.  For example '080926';
%            REC = String. Recording directory
%            reclength = Scalar. reclength of data segment to analyze in s.
%                     Defaults to 10.
%            CHANS  = Vector. Index for subset of channels to analyze.
%                     Defaults to all channels specified to be present in the
%                     experiment definition files.
%            RUN = Structure with fields spectra, spikes, lfp. Toggle on
%                  and off whether to plot or not with a boolean. Default = 1
%
% Generate plots about neural activity on an array based on a short scout
% recording. Operates on unpreprocessed data on the scratch raid of the
% DAQ machine. To be run on the DAQ machine. For NSpike/nstream. Creates
% the following folders with figures in the MONKEYDIR and the SCRATCH
% folder:
%
% spec: power spectra for each channel, sorts by 60Hz/240Hz, 60Hz/240Hz
%       topographies (SC32/SC96 arrays).
% spikes: average spiking activity (threshold crossings), sorts and
%         topographies (SC32/SC96), spike waveforms, isolation topographies
% lfp:  ICA components of Lfp, sorted by variance explained in the signal

global MONKEYDIR

if nargin<2
    rec = '001';
end
if nargin<3
    reclength = 30;
end
if nargin<5
    run.spectra = 1;
    run.spikes = 1;
    run.lfp = 1;
end

if ~isfield(run,'spectra'); run.spectra = 0; end
if ~isfield(run,'spikes'); run.spikes= 0; end
if ~isfield(run,'lfp'); run.lfp= 0; end

% parameters
threshfac = -3.5; % multi unit threshold factor
spikewin = 50; % window to plot spike waveforms, ms
spiket = 0-floor(spikewin./2):0+ceil(spikewin./2)-1;


% Directory checks
olddir = pwd;
load([MONKEYDIR '/mat/prototype.experiment.mat']);
base_dir = experiment.recording.base_path;
rec_dir = sprintf('%s/%s/%s/',base_dir,day,rec);
if ~exist(rec_dir); error('Recording directory does not exist\n');else;cd(rec_dir);end
fig_dirmain = sprintf('%s/figures/rawScout/%s/',MONKEYDIR,day);
if ~exist(fig_dirmain); mkdir(fig_dirmain); end

% Nspike recording information
nspike_format = 'short';
nspike_bytes = 2;
nspike_fs = 30e3;
nspike_chans = experiment.hardware.acquisition.num_channels;
if nargin<4; chans = 1:nspike_chans; end
nspike_file = sprintf('rec%s.nspike.dat',rec);
nspike_info = dir(nspike_file);
if isempty(nspike_info); error('No nspike recording');end
nspike_samples = nspike_info.bytes./(nspike_bytes.*nspike_chans);
nspike_reclength=nspike_samples./nspike_fs; % in s
reclength = min([reclength nspike_reclength]);
nspike_ns = nspike_fs.*reclength;
fprintf('%.2fs scout recording\nAnalyzing %.1fs and %d/%d chans\n',nspike_reclength,reclength,numel(chans),nspike_chans);

% read data
nspike_fid=fopen(nspike_file);
nspike=fread(nspike_fid,[nspike_chans, nspike_fs.*reclength],nspike_format);

%% power spectra of raw signals
if run.spectra==1;
    tic, fprintf('Power spectra: ');
    fig_dir = sprintf('%s%s/',fig_dirmain,'spec');
    if ~exist(fig_dir); mkdir(fig_dir); end
    
    [spec f] = tfspec(nspike,[0.5, 5],nspike_fs,1);
    spec =squeeze(mean(log(spec),2));
    
    figure('Visible','off','Position', [5 25 1920 978])
    ga = sq(log(mean(spec(chans,:,:))));
    subplot(2,2,1); plot(f,ga); xlim([0 500]); xlabel('Frequency (Hz)'); ylabel('LogPower'); axis square;
    subplot(2,2,2); plot(f,ga); xlim([0 1000]); xlabel('Frequency (Hz)'); ylabel('LogPower'); axis square;
    subplot(2,2,3); plot(f,ga); xlim([0 5000]); xlabel('Frequency (Hz)'); ylabel('LogPower'); axis square;
    subplot(2,2,4); plot(f,ga); xlim([0 1500]); xlabel('Frequency (Hz)'); ylabel('LogPower'); axis square;
    print(sprintf('%sgrandaverage.png',fig_dir),'-dpng')
    close
    for ichan = 1:numel(chans)
        figure('Visible','off','Position', [5 25 1920 978])
        e = squeeze(spec(chans(ichan),:));
        subplot(2,2,1); plot(f,e); xlim([0 500]); xlabel('Frequency (Hz)'); ylabel('LogPower'); axis square;
        subplot(2,2,2); plot(f,e); xlim([0 1000]); xlabel('Frequency (Hz)'); ylabel('LogPower'); axis square;
        subplot(2,2,3); plot(f,e); xlim([0 5000]); xlabel('Frequency (Hz)'); ylabel('LogPower'); axis square;
        subplot(2,2,4); plot(f,e); xlim([0 1500]); xlabel('Frequency (Hz)'); ylabel('LogPower'); axis square;
        title(sprintf('Electrode %d',chans(ichan)));;
        print(sprintf('%sElectrode_%04d.png',fig_dir,chans(ichan)),'-dpng')
        close
    end
    % 60Hz sorted bar plot
    figure('Visible','off','Position', [5 793 1675 210])
    [dummy i60] = min(abs(f-60));
    [dummy i40] = min(abs(f-40));
    p60 = spec(chans,i60);
    p40 = spec(chans,i40);
    p60 = log10(p60./p40);
    [p60s i60s]=sort(p60,'descend');
    bar(1:numel(p60s),p60s)
    axis tight
    a=axis;
    t = text(1:numel(chans),a(3).*ones(1,numel(chans)),num2str(i60s));
    set(t,'HorizontalAlignment','right','VerticalAlignment','top','Rotation',90)
    set(gca,'Xtick',1:numel(p60)),set(gca,'XtickLabel',{''});
    ylabel('LogPower 60Hz');
    print(sprintf('%sSorted_60Hz.png',fig_dir),'-dpng')
    close
    
    figure('Visible','off','Position', [5 793 1675 210])
    [dummy i240] = min(abs(f-240));
    p240 = spec(chans,i240);
    [p240s i240s]=sort(p240,'descend');
    bar(1:numel(p240s),p240s)
    axis tight
    a=axis;
    t = text(1:numel(chans),a(3).*ones(1,numel(chans)),num2str(i240s));
    set(t,'HorizontalAlignment','right','VerticalAlignment','top','Rotation',90)
    set(gca,'Xtick',1:numel(p240)),set(gca,'XtickLabel',{''});
    ylabel('LogPower 240Hz');
    print(sprintf('%sSorted_240Hz.png',fig_dir),'-dpng')
    close all
    
    % 60Hz (line noise) and 240Hz (eye tracker) topographies for SC32 or SC96
    if any(numel(chans)==[32 96])
        % general ploting options
        opt=[];
        opt.plotelectrodes = 1;
        opt.electrodemarkers = 'numbers'
        opt.plotcolorbar = 1;
        opt.showfigure = 0;
        cm = jet(150); cm=[cm;cm];
        opt.colormap = cm;
        
        % 60Hz
        opt.maxval = prctile(abs(p60),90);
%         opt.threshold = min(abs(p60));
        plotArray(abs(p60),opt);
        print(sprintf('%sTopo_60Hz.png',fig_dir),'-dpng')
        close
        
        % 240 Hz
        figure('Visible','off','Position',[697 36 1038 946])
        opt.maxval = prctile(p240,90);
        opt.threshold = min(p240);
        plotArray(p240,opt);
        print(sprintf('%sTopo_240Hz.png',fig_dir),'-dpng')
        close
        
        % RMS
        V = rms(nspike(chans,:),2);
        opt.maxval = prctile(V,90);
        opt.threshold = min(V);
        plotArray(V,opt);
        print(sprintf('%sTopo_RMS.png',fig_dir),'-dpng')
        close
    end
    eval(sprintf('!cp -r %s %s',fig_dir,rec_dir))
    fprintf(' done (%.2fs)\n',toc);
end

%% spiking activity
if run.spikes==1
    tic, fprintf('Spikes: ');
    fig_dir = sprintf('%s%s/',fig_dirmain,'spikes');
    if ~exist(fig_dir); mkdir(fig_dir); end
    
    % filter
    tapers = [0.01,3000];
    n = tapers(1);
    w = tapers(2);
    p = n*w;
    k = floor(2*p-1);
    tapers = [n,p,k];
    tapers(1) = tapers(1).*nspike_fs;
    tapers = dpsschk(tapers);
    Mufilt = 2*real(mtfilt(tapers, nspike_fs, 3300));
    
    % spike detection per channel
    nsp = zeros(numel(chans),1);
    for ichan=1:numel(chans)
        mu = conv(nspike(chans(ichan),:),Mufilt); % filtered data
        thresh = threshfac.*median(abs(mu(length(Mufilt)+1:end-length(Mufilt))))./0.6745; % threshold
        spikes = find(diff(mu < thresh)==1)+1; % threshold crossings
        nsp(ichan) = numel(spikes);
        if numel(spikes)>1 % at least two spikes for the interval
            figure('Visible','off','Position', [5 25 1920 978])
            % spike waveforms
            subplot(1,2,1)
            sp=[];
            for ispike=1:numel(spikes)
                winbounds = [spikes(ispike)-floor(spikewin./2) spikes(ispike)+ceil(spikewin./2)-1];
                if winbounds(1)>0 & winbounds(2)<=numel(mu)
                    hold on
                    spwave = mu(winbounds(1):winbounds(2));
                    plot(spiket,spwave,'k','LineWidth',.5)
                    sp = [sp; spwave];
                end
            end
            plot(spiket,mean(sp),'r','Linewidth',2)
            xlabel('Time (ms)'); ylabel('Amplitude')
            axis square tight
            
            % interspike intervals
            subplot(1,2,2)
            hist(diff(spikes)./nspike_fs.*1000,50);
            xlabel('ITI (ms)');ylabel('count')
            axis square
            print(sprintf('%sElectrode_%04d.png',fig_dir,chans(ichan)),'-dpng')
            close
        else
            fprintf('\nNo spikes for electrode %d\n',chans(ichan))
        end
    end
    
    % Spike count sorted bar plot
    figure('Visible','off','Position', [5 793 1675 210])
    [sps isps]=sort(nsp,'descend');
    bar(1:numel(sps),sps)
    axis tight
    a=axis;
    t = text(1:numel(chans),a(3).*ones(1,numel(chans)),num2str(isps));
    set(t,'HorizontalAlignment','right','VerticalAlignment','top','Rotation',90)
    set(gca,'Xtick',1:numel(nsp)),set(gca,'XtickLabel',{''});
    ylabel('SpikeCount');
    print(sprintf('%sSorted_SpikeCount.png',fig_dir),'-dpng')
    close all
    
    % Spike count topographies for SC32 or SC96
    if any(numel(chans)==[32 96])
        % general ploting options
        opt=[];
        opt.plotelectrodes = 1;
        opt.electrodemarkers = 'numbers'
        opt.plotcolorbar = 1;
        opt.showfigure = 0;
        cm = jet(150); cm=[cm;cm];
        opt.colormap = cm;
        
        % Spike Count
        figure('Visible','off','Position',[697 36 1038 946])
        opt.maxval = prctile(nsp,90);
        opt.threshold = min(nsp);
        plotArray(nsp,opt);
        print(sprintf('%sTopo_SpikeCount.png',fig_dir),'-dpng')
        close
    end
    eval(sprintf('!cp -r %s %s',fig_dir,rec_dir))
    fprintf(' done (%.2fs)\n',toc);
end

%% lfp data
if run.lfp==1 
    if ~exist('/mnt/raid/FastICA/'); error('Please download FastICA and place it in /mnt/raid/FastICA\n'); end
    addpath(genpath('/mnt/raid/FastICA/')) 
    
    tic, fprintf('Lfp:\n');
    fig_dir = sprintf('%s%s/',fig_dirmain,'lfp');
    if ~exist(fig_dir); mkdir(fig_dir); end
    
    % lfp filtering, resampling
    tapers = [0.0025,400];
    n = tapers(1);
    w = tapers(2);
    p = n*w;
    k = floor(2*p-1);
    tapers = [n,p,k];
    tapers(1) = tapers(1).*nspike_fs;
    tapers = dpsschk(tapers);
    filt = mtfilt(tapers, nspike_fs, 0);
    Lfpfilt = single(filt./sum(filt));
    LfpNf = length(Lfpfilt);
    lfp_fs = 1e3;
    lfp = zeros(numel(chans),nspike_ns./30);
    for ichan=1:numel(chans)
        tmp = conv(nspike(chans(ichan),:),Lfpfilt);
        lfp(chans(ichan),:) = tmp(1,LfpNf./2:nspike_fs./1e3:nspike_ns+LfpNf./2-1);
    end

    % ICA
    ncomp = floor(numel(chans)./2);
    [A,W] = fastica(lfp,...
        'approach','defl',...
        'firstEig',1,...
        'lastEig',ncomp,...
        'numOfIC',ncomp,...
        'stabilization' ,'on',...
        'verbose','on',...
        'displayMode','off');
    
    % resort un/mixing matrices by signal variance
    [dummy,var_index] = sort(-sum(A.^2));% A is backtransformation matrix. var of comp is 1, so the contribution of the component is in norm of A(:,comp_num)
    A=A(:,var_index);
    W=W(var_index,:);
    
    % unmix lfp data
    comp=W*lfp;
    
    % spectral decomposition of IC components
    [spec f] = tfspec(comp,[0.5, 5],lfp_fs,1);
    spec = squeeze(mean(log(spec),2));
    
    for ic=1:ncomp
        x=comp(ic,:);
        fx=spec(ic,:);
        
        figure('Visible','off','Position', [5 25 1920 978]);
        % spectrum
        subplot(1,2,1)
        plot(f,fx,'k')
        hold on
        a=axis;
        plot([60,60],[a(3),a(4)],'r') % line noise and harmonics
        plot([120,120],[a(3),a(4)],'r')
        plot([180,180],[a(3),a(4)],'r')
        plot([240,240],[a(3),a(4)],'g') % eye tracker
        plot([18,18],[a(3),a(4)],'c') % building vibration
        plot(f,fx,'k')
        a(2)=300; axis(a)
        xlabel('frequency [Hz]'); ylabel('LogPower')
        axis square
        
        % Time course
        subplot(1,2,2)
        plot((1:size(x,2))./lfp_fs,x,'k')
        xlabel('time [s]'); ylabel('Amplitude')
        grid on
        axis square tight
        print('-dpng',sprintf('%sSpecTimeCourse_IC%04di.png',fig_dir,ic));
        close
        
        % Array topographies, if SC32 or SC96
        if any(numel(chans)==[32 96])
            m = A(:,ic); % spatial pattern of mixing
%             u = W(ic,:); % spatial pattern of unmixing
            ev = abs(m)./sum(abs(A),2)*100; % spatial pattern of explained variance
            % mixing
            opt=[];
            opt.plotelectrodes = 1;
            opt.electrodemarkers = 'numbers';
            opt.plotcolorbar = 1;
            cm = jet(150); cm=[cm;cm];
            opt.colormap = cm;
            opt.showfigure = 0;
%             opt.maxval = prctile(abs(m),90);
%             plotArray(m,opt);
%             opt.maxval = prctile(abs(u),90);
%             plotArray(u,opt); 
            opt.maxval = prctile(ev,90);
            opt.threshold = min(ev);
            
            figure('Visible','off','Position',[697 36 1038 946])
            plotArray(ev,opt);
            print(sprintf('%sTopoPercExplVar_IC%04d.png',fig_dir,ic),'-dpng')
            close
            clear IMG*
        end
    end
    fprintf(' done (%.2fs)\n',toc);
    eval(sprintf('!cp -r %s %s',fig_dir,rec_dir))
end
cd(olddir)