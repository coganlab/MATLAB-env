clear all
matlabpool close
matlabpool open 4
load('IEEGData.mat'); % loads up data trials (IEEG) x channel x time
Subject = load('Trials.mat'); % load trial structure
Subject.Name = '1'; % Subject number

% Active channel index based on statistical tests of higher gamma responses (70-90 Hz)
Subject.AUD = [8,14,15,20,21,22,24,30]; % Auditory Channel Index
Subject.AUDd = [32,53]; % Auditory with Delay Channel Index
Subject.PROD = [27,29,34,6,38,40,49]; % Production Channel Index
Subject.PRODd = [42]; % Production with Delay Channel Index
Subject.SM = [43,48]; % Sensory-Motor Channel Index
Subject.SMd = [37,47]; % Sensory-Motor with Delay Channel Index


CondParams.Field = 'Auditory'; % time is aligned to auditory Onset
CondParams.bn = [-200,300]; % period in ms around Auditory Onset


AnalParams.Tapers = [0.5,10]; % Taper parameters for multitaper spectral analysis (0.5 s windows and 10 Hz Frequency Smoothing)
AnalParams.fk = 100; % frequency Range - Upper bound
AnalParams.dn=0.05; % step size in s
AnalParams.pad=1; % frequency padding
AnalParams.iter=100; % wilson factorization iteration maximum
AnalParams.nPerm=100; % number of shuffle permutations
AnalParams.srate=512; % sampling rate in Hz




%Subtract Common Avg from data
IEEG=IEEG-repmat(mean(IEEG,2),1,size(IEEG,2),1);




%Select Channels to use, can use any channels
chan1=Subject.AUDd(1);
chan2=Subject.SMd(1);

% define signals to go into Granger Calc
sig1=squeeze(IEEG(:,chan1,:));
sig2=squeeze(IEEG(:,chan2,:));

% Calculate Granger Causality.  Takes about 8 s per permutation for me with 4 cores open in matlabpool
% G is ([actual val, permuted iterations] x time x frequency)
tic
G = calcGrangerCausality(sig1, sig2, AnalParams.Tapers, AnalParams.srate, AnalParams.dn, [0 AnalParams.fk], AnalParams.pad,AnalParams.iter,AnalParams.nPerm);
toc



% % Plots

%load('GrangerTest.mat') % Uncomment to load example G for AUDd(1) to SMd(1) (chan 32 to chan 37)
fscale=linspace(0,250,size(G,3)); % Frequency Scale

% Raw
figure;
tvimage(squeeze(G(1,:,:)),'XRange',[CondParams.bn(1)./1000 CondParams.bn(2)./1000],'YRange',[0 AnalParams.fk])
xlabel('Time from Aud Onset (s)','FontSize',14)
ylabel('Frequency (Hz)','FontSize',14)
% caxis([0 0.02]);
title(['Raw Granger Causality Channel ' num2str(chan1) ' to ' num2str(chan2)],'FontSize',14);
colorbar


% Normalized Granger Calc
GZ=(squeeze(G(1,:,:))-squeeze(mean(G(2:end,:,:),1)))./squeeze(std(G(2:end,:,:),[],1)); % Calc Z score

figure;
tvimage(GZ,'XRange',[CondParams.bn(1)./1000 CondParams.bn(2)./1000],'YRange',[0 AnalParams.fk])
xlabel('Time from Aud Onset (s)','FontSize',14)
ylabel('Frequency (Hz)','FontSize',14)
% caxis([0 60]);
title(['Normalized Granger Causality Channel ' num2str(chan1) ' to ' num2str(chan2)],'FontSize',14);
colorbar

