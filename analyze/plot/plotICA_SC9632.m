function plotICA_SC9632(day,t)
% Plots the first nchan/2 independent components of array data sorted by
% explained signal variance for all recordings of a day. Uses fastica.
% Defaults to analyze the first minute (or t seconds) of 128 channel (SC96,
% SC32)raw data.
% To add fastica: create a folder  /mnt/raid/FastICA which contains the
% latest version of fast ICA; www.research.ics.aalto.fi/ica/fastica

global MONKEYDIR MONKEYNAME

% To add fastica: create a folder  /mnt/raid/FastICA which contains the
% latest version of fast ICA; www.research.ics.aalto.fi/ica/fastica
addpath(genpath('/mnt/raid/FastICA/')) 

% recording parameters
format = 'int16';
fs=30000;
nchan=128;
ncomp=floor(nchan/2);
if nargin<3 t=60; end % amount of data analyzed in s

% get experiment information
load(sprintf('%s/mat/prototype.experiment.mat',MONKEYDIR),'experiment')

recs = dir([MONKEYDIR '/' day '/0*']);

fprintf('Computing ICA for %d channels, %d recordings on %s\n',nchan,numel(recs),day)
for irec=1:numel(recs)
    % read raw data
    fid=fopen(sprintf('%s/%s/%s/rec%s.%s.raw.dat',MONKEYDIR,day,recs(irec).name,recs(irec).name,experiment.hardware.microdrive.name));
    raw=fread(fid,[nchan t*fs],format);
    
    % ICA
    [A,W] = fastica(raw,...
        'approach','defl',...
        'firstEig',1,...
        'lastEig',ncomp,...
        'numOfIC',ncomp,...
        'stabilization' ,'on',...
        'verbose','on',...
        'displayMode','off');
    
    % Figure directory
    DIRFIG = sprintf('%s/figures/ica/%s/%s/',MONKEYDIR,day,recs(irec).name);
    if ~exist(DIRFIG); mkdir(DIRFIG); end
    
    % crosscorrelation matrices
    r = (raw -repmat(mean(raw,2),1,size(raw,2)))./repmat(std(raw,[],2),1,size(raw,2));
    c = (r*r')./size(raw,2);
    rr = raw-repmat(mean(raw),size(raw,1),1);
    rr = (rr -repmat(mean(rr,2),1,size(rr,2)))./repmat(std(rr,[],2),1,size(rr,2));
    cr = (rr*rr')./size(rr,2);
    
    figure('Visible','off')
    subplot(1,2,1)
    imagesc(c); colorbar
    caxis([-1 1])
    axis square
    title('raw correlation')
    subplot(1,2,2)
    imagesc(cr); colorbar
    caxis([-1 1])
    axis square
    title('common average reference')
    print('-dpng',sprintf('%sCrossCorr.png',DIRFIG));
    close
    clear r rr c cr
    
    % resort un/mixing matrices by signal variance
    [dummy,var_index] = sort(-sum(A.^2));% A is backtransformation matrix. var of comp is 1, so the contribution of the component is in norm of A(:,comp_num)
    A=A(:,var_index);
    W=W(var_index,:);
    
    % unmix raw data
    comp=W*raw;
    tic
    for ic=1:ncomp
        fprintf('\rPloting rec %d/%d, Component %d/%d, %2fs',irec,numel(recs),ic,ncomp,toc)
        x=comp(ic,:);
        
        hFig = figure;
        set(hFig,'Visible','off')

        nfft = size(x,2); nfft=2^ceil(log2(nfft));
        temp = x .* (ones(size(x,1),1)*hamming(size(x,2))');
        temp = fft(temp,nfft,2);
        temp = temp(:,1:ceil(nfft/2+0.5)) .* conj(temp(:,1:ceil(nfft/2+0.5)));
        f = (0:size(temp,2)-1)/(size(temp,2)-1)*fs/2;
%         temp = conv2(temp,hanning(40)','same'); % smooth?

        % Full spectrum
        hAx = axes('position',[0.08,0.55,0.4,0.4]);
        semilogy(f,temp)
        xlabel('frequency [Hz]')
        ylabel('Power')
        axis tight
        title(sprintf('expl var: %.3f Perc',sum(A(:,ic).^2)./sum(A(:).^2)*100))
        a=axis;
        
        % LFP range
        hAx = axes('position',[0.55,0.55,0.4,0.4]);
        semilogy(f,temp)
        hold on
        plot([60,60],[a(3),a(4)],'k') % line noise and harmonics
        plot([120,120],[a(3),a(4)],'k')
        plot([180,180],[a(3),a(4)],'k')
        plot([240,240],[a(3),a(4)],'k')
        plot([18,18],[a(3),a(4)],'c') % building vibration
        semilogy(f,temp)
        a(2)=300; axis(a)
        xlabel('frequency [Hz]')
        
        % Time domain
        hAx = axes('position',[0.08,0.15,0.87,0.3]);
        plot((1:size(x,2))./fs,x,'b')
        ylabel('Amplitude')
%         a=axis; a(1)=time(1); a(2)=time(end); axis(a)
        grid on
        axis tight
        xlabel('time [s]')
        print('-dpng',sprintf('%sIC%.3i_1TF.png',DIRFIG,ic));
        close
        
        % Array topographies
        opt=[]; opt.electrodemakers='numbers'; opt.facealpha = 1;
        
        % spatial pattern of mixing
        opt.maxval=max(abs(A(:,ic)));
        IMG1=plotArray(A(1:96,ic),opt); % SC96
        IMG2=plotArray(A(97:128,ic),opt); % SC32
        IMG=[IMG1 IMG2];
        imwrite(IMG,sprintf('%sIC%.3i_2MIX.png',DIRFIG,ic),'PNG')
        
        % spatial pattern of umixing
        opt.maxval=max(abs(W(ic,:)));
        IMG1=plotArray(W(ic,1:96),opt); % SC96
        IMG2=plotArray(W(ic,97:128),opt); % SC32
        IMG=[IMG1 IMG2];
        imwrite(IMG,sprintf('%sIC%.3i_3UNMIX.png',DIRFIG,ic),'PNG')
        
        % relative contribution of this pattern to the signal of each
        % electrode
        E = abs(A(:,ic))./sum(abs(A),2)*100;
        opt.maxval=max(abs(E));
        IMG1=plotArray(E(1:96),opt); % SC96
        IMG2=plotArray(E(97:128),opt); % SC32
        IMG=[IMG1 IMG2];
        imwrite(IMG,sprintf('%sIC%.3i_4RELVAR.png',DIRFIG,ic),'PNG')
        clear IMG*
    end
    fprintf('\ndone, %.2fs\n,',toc)
end
