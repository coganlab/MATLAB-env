function [pacmag,pacphase,fphase,famp] = ...
    pacoupling(X,Y,tapers,sampling,dn,fk,pad,flag,direc) 
%  PAC Phase amplitude coupling between two time series.
%
% [PACMAG, PACPHASE, FPHASE, FAMP] = ...
%	PACOUPLING(X, Y, TAPERS, SAMPLING, DN, FK, PAD, FLAG, DIREC)
%
%  Inputs:  X		=  Time series array in [Space/Trials,Time] form. Phase
%                       data.
%	    Y		=  Time series array in [Space/Trials,Time] form. Amplitude
%                   data
%	    TAPERS 	=  Data tapers in [K,TIME], [N,P,K] or [N, W] form.
%			   	Defaults to [N,5,9] where N is the duration 
%				of X and Y.
%	    SAMPLING 	=  Sampling rate of time series X, in Hz. 
%				Defaults to 1.
%	    DN		=  Step size of moving windows.
%			       	Defaults to N./10;
%	    FK 	 	=  Frequency range to return in Hz in
%                   [Fphase1,Fphase2;
%                    Famp1, Famp2] for
%                   Defaults to [2 64; 4 128];
%                   Memory sensitive
%	    PAD		=  Padding factor for the FFT.  
%			      	i.e. For N = 500, if PAD = 2, we pad the FFT 
%			      	to 1024 points; if PAD = 4, we pad the FFT
%			      	to 2048 points.
%				Defaults to 2.
%	    flag    =  Normalization by an empirical resample distribution, shuffles trials
%                       0 no normalization
%                       1 gaussian assumptions, 1e3 resamples (memory friendly)
%                       2 non-parametric, 1e4 resamples, max z-score ~3.7 (memory intense)
%       direc   =  Direction
%                       0 X phase -> Y amp
%                       1 X phase -> Y amp as well as Y phase -> X amp,
%                           first two outputs will be a cell array where
%                           pacmag{1} X->Y
%                           pacmag{2} Y->X
%                  Default 0
%			      	
%  Outputs: PACMAG	        =  Magnitude of phase amplitude coupling between X and Y in [Freqphase,Freqamp] form.
%           PACPHASE        =  Preferred phase of phase amplitude coupling between X and Y in [Freqphase,Freqamp] form.
%           Fphase/Famp		=  Units of Frequency axes for PAC.
%
%  Written by:  David Hawellek NYU 2015 
%               based on tfcoh by Bijan Pesaran Caltech 1998
fprintf('pacoupling\n')

sX = size(X);
nt1 = sX(2);
nch1 = sX(1);

sY = size(Y);
nt2 = sY(2);
nch2 = sY(1);

if nt1 ~= nt2 error('Error: Time series are not the same length'); end
if nch1 ~= nch2 error('Error: Time series are incompatible'); end
nt = nt1;
nch = nch1;

if nargin < 4 sampling = 1; end
t = nt./sampling;
if nargin < 3 tapers = [t,5,9]; end
if length(tapers) == 2
    n = tapers(1);
    w = tapers(2);
    p = n*w;
    k = floor(2*p-1);
    tapers = [n,p,k];
end
if length(tapers) == 3
    tapers(1) = floor(tapers(1).*sampling);
    tapers = single(dpsschk(tapers));
end
if nargin < 5 || isempty(dn); dn = n./10; end
if nargin < 6 || isempty(fk); fk = [2 64; 4 128]; end
if length(fk) == 1
    fk = [0,fk];
end
if nargin < 7 || isempty(pad); pad = 2; end
if nargin < 8 || isempty(flag); flag = 0; end
if nargin < 8 || isempty(direc); direc = 0; end

K = length(tapers(1,:));
N = length(tapers(:,1));
if N > nt error('Error: Tapers are longer than time series'); end

% Determine outputs
errorchk = 0;
if nargout > 3 errorchk = 1; end

dn = floor(dn.*sampling);
nf = max(256, pad*2^nextpow2(N+1));
nfkp = floor([fk(1,1) fk(1,2)]./sampling.*nf); % phase frequency bins
nfka = floor([fk(2,1) fk(2,2)]./sampling.*nf); % amplitude frequency bins
nfk = floor([1 fk(2,2)]./sampling.*nf); % total frequency range, botk X and Y can be phase and amplitude delivering
nwin = floor((nt-N)./dn);           % calculate the number of windows
fphase = linspace(fk(1,1),fk(1,2),diff(nfkp));
famp = linspace(fk(2,1),fk(2,2),diff(nfka));
K = single(K);
nch = single(nch);

% Subtract mean, transpose
% mX = sum(X)./nch; mY = sum(Y)./nch;
% X = (X - mX(ones(1,nch),:)).';
% Y = (Y - mY(ones(1,nch),:)).';

X=X.';
Y=Y.';


%% Multi taper fourier transform, keep tapers
tic, fprintf('Multitaper Fourier Transform, %d Tapers.. ',size(tapers,2))
S_X = zeros(nwin,nch,diff(nfk)+1,K,'single'); % phase timeseries
S_Y = zeros(nwin,nch,diff(nfk)+1,K,'single'); % amplitude timeseries
for iWin=1:nwin
    tmp1 = X(dn*(iWin-1)+1:dn*(iWin-1)+N,:);
    tmp2 = Y(dn*(iWin-1)+1:dn*(iWin-1)+N,:);
    for ch = 1:nch
        Xk = fft(tapers.*tmp1(:,ch*ones(1,K)),nf);
        S_X(iWin,ch,:,:) = Xk(1:nfk(2),:);
        Yk = fft(tapers.*tmp2(:,ch*ones(1,K)),nf);
        S_Y(iWin,ch,:,:) = Yk(1:nfk(2),:);
    end
end
fprintf('done (%.2fs)\n',toc)

%% Create phase amplitude combinatorial indices to reference all frequency
% pairs at once. Only phase-amplitude bins for which famp>=2.*fpha
phacind = nan(diff(nfkp).*diff(nfka),1);
ampcind = phacind;
revind=[];
npair=0;
indcount=0;
for iamp = 1:diff(nfka)
    for ipha = 1:diff(nfkp)
        indcount=indcount+1;
        if famp(iamp)>=2.*fphase(ipha);
            npair=npair+1;
            phacind(npair) = ipha;
            ampcind(npair) = iamp;
            revind = [revind indcount]; % vector to matrix
        end
    end
end
phacind(isnan(phacind))=[]; ampcind(isnan(ampcind))=[];

%% Compute all phase amplitude pairs at once, avoiding for-loops across frequency pairs
tic, fprintf('Computing PAC, %d freq pairs\n ',npair)
dirlabel={'X->Y','Y->X'};
for idir =1:direc+1
    pacmag{idir} = nan(npair,1,'single');
    pacphase{idir} = nan(npair,1,'single');
    tic, fprintf('%s .. ',dirlabel{idir})
    if idir == 1 % X->Y
        S_phase = reshape(S_X(:,:,[nfkp(1)+1:nfkp(2)],:),[nch*nwin diff(nfkp) K]); % Linearize time x trial
        S_amp = reshape(S_Y(:,:,[nfka(1)+1:nfka(2)],:),[nch*nwin diff(nfka) K]);
    elseif idir ==2 % Y->X
        S_phase = reshape(S_Y(:,:,[nfkp(1)+1:nfkp(2)],:),[nch*nwin diff(nfkp) K]); % Linearize time x trial
        S_amp = reshape(S_X(:,:,[nfka(1)+1:nfka(2)],:),[nch*nwin diff(nfka) K]);
    end
    tmp = sum(abs(S_amp(:,ampcind,:)) .* exp(1i.*angle(S_phase(:,phacind,:))))./(nch*nwin);
    
    % average across tapers
    pacmag{idir} = sum(abs(tmp),3)./K; % magnitude
    pacphase{idir} = angle(sum(tmp./abs(tmp),3)); % preferred phase
    
    t(idir) = toc;
    fprintf('done (%.2fs)\n',t(idir))
end
clear tmp
t=mean(t); % time estimate for resamples

%% Resamples, normalization
if flag == 1
    nressamp = 1e3;
    tic, fprintf('Resamples, gaussian assumptions\n Estimated duration: %.2fh\n',t.*nressamp./60./60)
    pacmean = zeros(direc+1,npair);
    pacvar = zeros(direc+1,npair);
    for ires = 1:nressamp
        [dummy permidx] = sort(rand(1,nch));
        for idir =1:direc+1
            if idir == 1 % X->Y
                S_phase = reshape(S_X(:,permidx,[nfkp(1)+1:nfkp(2)],:),[nch*nwin diff(nfkp) K]); % Linearize time x trial
                S_amp = reshape(S_Y(:,:,[nfka(1)+1:nfka(2)],:),[nch*nwin diff(nfka) K]);
            elseif idir ==2 % Y->X
                S_phase = reshape(S_Y(:,permidx,[nfkp(1)+1:nfkp(2)],:),[nch*nwin diff(nfkp) K]); % Linearize time x trial
                S_amp = reshape(S_X(:,:,[nfka(1)+1:nfka(2)],:),[nch*nwin diff(nfka) K]);
            end
            tmp = sum(abs(sum(abs(S_amp(:,ampcind,:)) .* exp(1i.*angle(S_phase(:,phacind,:))))./(nch*nwin)),3)./K;
            pacmean(idir,:) = pacmean(idir,:) + tmp;
            pacvar(idir,:) = pacvar(idir,:) + tmp.^2;
        end
        if mod(ires./nressamp.*100,1)==0
            fprintf('\r %d Percent (%.2fs)',ires./nressamp.*100,toc)
        end
    end
    
    % Mean and variance
    pacmean = pacmean./nressamp;
    pacvar = (pacvar./nressamp) - pacmean.^2;
    
    % Normalization (z-score)
    for idir=1:direc+1;
        pacmag{idir} = (abs(pacmag{idir}) - pacmean(idir,:)) ./sqrt(pacvar(idir,:));
    end
    
elseif flag == 2
    nressamp = 1e4;
    tic, fprintf('Resamples, non-parametric\n Estimated duration: %.2fh\n',t.*nressamp./60./60)
    pacres = nan(direc+1,npair,nressamp,'single');
    for ires = 1:nressamp
        [dummy permidx] = sort(rand(1,nch));
        for idir =1:direc+1
            if idir == 1 % X->Y
                S_phase = reshape(S_X(:,permidx,[nfkp(1)+1:nfkp(2)],:),[nch*nwin diff(nfkp) K]); % Linearize time x trial
                S_amp = reshape(S_Y(:,:,[nfka(1)+1:nfka(2)],:),[nch*nwin diff(nfka) K]);
            elseif idir ==2 % Y->X
                S_phase = reshape(S_Y(:,permidx,[nfkp(1)+1:nfkp(2)],:),[nch*nwin diff(nfkp) K]); % Linearize time x trial
                S_amp = reshape(S_X(:,:,[nfka(1)+1:nfka(2)],:),[nch*nwin diff(nfka) K]);
            end
            pacmean(idir,:,ires) = single(sum(abs(sum(abs(S_amp(:,ampcind,:)) .* exp(1i.*angle(S_phase(:,phacind,:))))./(nch*nwin)),3));
        end
        if mod(ires./nressamp.*100,1)==0
            fprintf('\r %d Percent (%.2fs)',ires./nressamp.*100,toc)
        end
    end
    
    % Normalization (rank-based)
    for idir =1:direc+1        
        ranked=round(tiedrank(squeeze(pacres(idir,:,:))')); % ranks, no ties
        dist = abs(ranked - repmat(pac{idir},size(ranked,1),1));
        p = nan(size(pac{idir}));
        for ipair = 1:npair
            p(ipair) = max(find(dist(:,ipair) == min(dist(:,ipair))))./nressamp;
        end
        z = norminv(p); z(isinf(z)) = sign(z(isinf(z))).*abs(norminv(1./nressamp));
        pacmag{idir} = z;
    end
end

% vector to matrix
for idir=1:direc+1
   tmp = nan(diff(nfkp),diff(nfka),'single');
   tmp2 = nan(diff(nfkp),diff(nfka),'single'); 
   tmp(revind) = pacmag{idir};
   tmp2(revind) = pacphase{idir};
   pacmag{idir} = tmp;
   pacphase{idir} = tmp2;
end

if direc == 0 % remove cell array for unidirectional call
    tmp = pacmag{1};
    tmp2 = pacphase{1};
    clear pacmag pacphase
    pacmag = tmp;
    pacphase = tmp2;
end
fprintf('\ndone (%.2fs)\n',toc)

