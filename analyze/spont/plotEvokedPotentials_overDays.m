global MONKEYDIR
MONKEYDIR = '/vol/sas2b/Spiff_NSpike_ecog_rig2';

meanRef = false;

microdrive = 'R_PMd_ecog';
Fs_raw           = 3e4;
Fs_lfp           = 1e3;
useLFP = true;
if useLFP
    Fs = Fs_lfp;
    fileTag = ['.', microdrive, '.clfp.dat'];
    datType = 'float';
    nChan  = 256;
else
    Fs = Fs_raw; %#ok<UNRCH>
    fileTag = ['.', microdrive, '.raw.dat'];
    datType = 'short';
    nChan   = 256;
end
stim = 1;
thresh = -2e4;
bn = [-100 400];

sigmaThreshold = 5;

%raw data recording properties
params.nChan     = 128;
params.recLength = 60*15;
params.Fs        = Fs;
params.fileTag   = fileTag;
params.datType   = datType;

params_comedi.recLength = params.recLength;
params_comedi.Fs        = 3e4;

initLightFlashingData;



stimTrig_stim = cell(length(days),1);
mEP_stim = nan(length(days), max([nChans{:}])+max([chanIDStarts{:}])-1, diff(bn)*Fs/1000+1);
mEP_stim_norm = mEP_stim;
mEP_stim_artrej = mEP_stim;
mEP_stim_norm_artrej = mEP_stim;

stimTrig_loff = cell(length(days),1);
mEP_loff      = nan(length(days), max([nChans{:}])+max([chanIDStarts{:}])-1, diff(bn)*Fs/1000+1);
mEP_loff_norm = mEP_loff;
mEP_loff_artrej = mEP_loff;
mEP_loff_norm_artrej = mEP_loff;

pos = cell(length(days),1);

nTr = 50e4*ones(length(days),1);
for iD=1:length(days)
    disp(days{iD})
    disp('Calculating Evoked Potentials with stim.')
    stimTrig_stim{iD} = cell(length(recs_stim{iD}));
    for iR = 1:length(recs_stim{iD})
        %iR
        %         if nChans{iD}(iR)==128
        %             outChanNum       = 1:128;
        %         elseif nChans{iD}(iR)==256
        %                 outChanNum = 1:256;
        %
        %         end
        outChanNum = 1:nChans{iD}(iR);
        
        chanID = (1:1:nChans{iD}(iR)) + chanIDStarts{iD}(iR)-1;
        
        
        %%%% note: change to use loadlfp. create events for lights off/on
        %%%% then load up lfp around light off/on trigger. 
        
        %load recordings
        d = readProcdData(days{iD}, recs_stim{iD}(iR), params);
        data = d(outChanNum,:);
        
        %re-ref data by subtracting mean
        if meanRef
            data = data - repmat(mean(data,1),size(data,1),1);
        end
        
        d = loadRawData_comedi(days{iD}, recs_stim{iD}(iR), params_comedi);
        lightData = d(lightChan{iD},:);
        lightData = lightData(1:Fs_raw/Fs:end);
        lightData = smooth(lightData,10);
        
        
        %get position info for electrodes
        [experiment, pos{iD}] = getElectrodePositions(days{iD}, recs_stim{iD}(iR));
        
        
        st = getEvokedPotentials(data, lightData, 1, bn, thresh, Fs, []);
        
        stimTrig_stim{iD}{iR} = st;
        
        %mean EP
        mEP_stim(iD,chanID,:) = mean(stimTrig_stim{iD}{iR},3);
        
        %zero potentials @ start of trial before taking average
        x = stimTrig_stim{iD}{iR} - repmat( stimTrig_stim{iD}{iR}(:,1,:), [1 size(stimTrig_stim{iD}{iR},2), 1]);
        mEP_stim_norm(iD,chanID,:) = mean( x, 3);
        
        %reject 'artifacts'
        st_corr = removeArtifacts_trialBased(stimTrig_stim{iD}{iR}, sigmaThreshold);
        
        %mean
        mEP_stim_artrej(iD,chanID,:) = nanmean(st_corr,3);
        
        %zero @ start
        x = st_corr - repmat( st_corr(:,1,:), [1 size(st_corr,2), 1]);
        mEP_stim_norm_artrej(iD,chanID,:) = nanmean( x, 3);
        
        nTr(iD) = min(nTr(iD), size(st, 3));
        
    end
    
    disp('Calculating Evoked Potentials with lights off.')
    
    for iR = 1:length(recs_loff{iD})
        %         if nChans{iD}(iR)==128
        %             outChanNum       = 1:128;
        %         elseif nChans{iD}(iR)==256
        %                 outChanNum = 1:256;
        %
        %         end
        outChanNum = 1:nChans{iD}(iR);
        
        chanID = (1:1:nChans{iD}(iR)) + chanIDStarts{iD}(iR)-1;
        
        
        %%%% note: change to use loadlfp. create events for lights off/on
        %%%% then load up lfp around light off/on trigger. 
        
        %load recordings
        d = readProcdData(days{iD}, recs_loff{iD}(iR), params);
        data = d(outChanNum,:);
        
        if meanRef
            data = data - repmat(mean(data,1),size(data,1),1);
        end
        
        d = loadRawData_comedi(days{iD}, recs_loff{iD}(iR), params_comedi);
        lightData = d(lightChan{iD},:);
        lightData = lightData(1:Fs_raw/Fs:end);
        lightData = smooth(lightData,10);
        
        
        st = getEvokedPotentials(data, lightData, 0, bn, thresh, Fs, nTr(iD));
        
        stimTrig_loff{iD}{iR} = st;
        
        %mean EP
        mEP_loff(iD,chanID,:) = mean(stimTrig_loff{iD}{iR},3);
        
        %zero potentials @ start of trial before taking average
        x = stimTrig_loff{iD}{iR} - repmat( stimTrig_loff{iD}{iR}(:,1,:), [1 size(stimTrig_loff{iD}{iR},2), 1]);
        mEP_loff_norm(iD,chanID,:) = mean( x, 3);
        
        %reject 'artifacts'
        st_corr = removeArtifacts_trialBased(stimTrig_loff{iD}{iR}, sigmaThreshold);
        
        %mean
        mEP_loff_artrej(iD,chanID,:) = nanmean(st_corr,3);
        
        %zero @ start
        x = st_corr - repmat( st_corr(:,1,:), [1 size(st_corr,2), 1]);
        mEP_loff_norm_artrej(iD,chanID,:) = nanmean( x, 3);
        
        nTr(iD) = min(nTr(iD), size(st, 3));
        
    end
    
end



addpath('/mnt/pesaranlab/People/Amy/cbrewer/')
plotColors = cbrewer('seq', 'GnBu', sum(nTr>200)*2+1);
plotColors = plotColors(2:end,:);
plotColors = plotColors(1:2:end,:);

t = bn(1):1/(Fs/1e3):bn(2);

ip = 1;

nFig = 4;
nPlt = ceil(size(mEP_stim(ip,:,:),2)/nFig);
cnt = 1;
figure
   
for i =1:size(mEP_stim(ip,:,:),2)
    
    if cnt>nPlt
        figure;
        cnt = 1;
    end
    subplot(ceil(sqrt(nPlt)),ceil(sqrt(nPlt)),cnt)
    %     plot(t, sq(mEP_stim(ip,i,:)), 'b', 'lineWidth', 3)
    %     hold on
    %     plot(t, sq(mEP_stim_norm(ip,i,:)), 'r', 'lineWidth', 3)
    %     plot(t, sq(mEP_stim_artrej(ip,i,:)), 'g', 'lineWidth', 3)
    cnt2 = 1;
    for iD = 1:size(mEP_stim,1);
        if nTr(iD) > 200
        plot(t, sq(mEP_stim_norm_artrej(iD,i,:)), 'color', plotColors(cnt2,:), 'lineWidth', 3)
        cnt2 = cnt2+1;
        hold on
        end
    end
    %plot(t, sq(mEP_loff(ip,i,:)), 'color', [0.6 0.6 0.6], 'lineWidth', 3)
    %y = [min( min(mEP_stim(1,i,:)),  min(mEP_loff(1,i,:)))*1.1 max( max(mEP_stim(1,i,:)), max(mEP_loff(1,i,:)))*1.1];
    %axis([bn(1) bn(2) y(1) y(2)])
    set(gca, 'xtick', [bn(1) 0 bn(2)], 'xlim', [bn(1) bn(2)])
    
    if cnt==1
        legend(days(nTr>200))
    end
    cnt=cnt+1;
end




t = bn(1):1/(Fs/1e3):bn(2);

ip = 1;

nFig = 4;
nPlt = ceil(size(mEP_loff(ip,:,:),2)/nFig);
cnt = 1;
figure
   
for i =1:size(mEP_loff(ip,:,:),2)
    
    if cnt>nPlt
        figure;
        cnt = 1;
    end
    subplot(ceil(sqrt(nPlt)),ceil(sqrt(nPlt)),cnt)
    %     plot(t, sq(mEP_stim(ip,i,:)), 'b', 'lineWidth', 3)
    %     hold on
    %     plot(t, sq(mEP_stim_norm(ip,i,:)), 'r', 'lineWidth', 3)
    %     plot(t, sq(mEP_stim_artrej(ip,i,:)), 'g', 'lineWidth', 3)
    cnt2 = 1;
    for iD = 1:size(mEP_stim,1);
        if nTr(iD) > 200
        plot(t, sq(mEP_loff_norm_artrej(iD,i,:)), 'color', plotColors(cnt2,:), 'lineWidth', 3)
        cnt2 = cnt2+1
        hold on
        end
    end
    %plot(t, sq(mEP_loff(ip,i,:)), 'color', [0.6 0.6 0.6], 'lineWidth', 3)
    %y = [min( min(mEP_stim(1,i,:)),  min(mEP_loff(1,i,:)))*1.1 max( max(mEP_stim(1,i,:)), max(mEP_loff(1,i,:)))*1.1];
    %axis([bn(1) bn(2) y(1) y(2)])
    set(gca, 'xtick', [bn(1) 0 bn(2)], 'xlim', [bn(1) bn(2)])
    
    if cnt==1
        legend(days(nTr>200))
    end
    cnt=cnt+1;
end


searchT = [0 150];
searchInds = t>=searchT(1) & t<=searchT(2);

peakMap = nan(length(days), max(pos{1}{1}(:,3))+1, max(pos{1}{1}(:,4))+1);
troughMap = peakMap;
for iD=1:length(days)
    
    %get evoked potential amplitude
    peak = max(sq(mEP_stim_norm_artrej(iD,:,searchInds)), [], 2);
    trough = min(sq(mEP_stim_norm_artrej(iD,:,searchInds)),[],2);

    for iE=1:size(peak,1);
        
        if ~any(isnan(pos{iD}{1}(iE,3:4)))
            peakMap(iD, pos{iD}{1}(iE,3)+1, pos{iD}{1}(iE,4)+1) = peak(iE);
            troughMap(iD, pos{iD}{1}(iE,3)+1, pos{iD}{1}(iE,4)+1) = trough(iE);
        end
    end
end


% 
% exampleChannels = 1:256; %[64 110 130 230 240]%
% 
% nFig = 4;
% nPlt = ceil(length(exampleChannels)/nFig);
% cnt = 1;
% figure
% 
% inds = find(nTr>200);
% inds = inds(end-3:end);
% %inds = inds(1:2:end);
% 
% for i =exampleChannels %size(mEP_stim(1,:,:),2)
%     
%     if cnt>nPlt
%         figure;
%         cnt = 1;
%     end
%     subplot(floor(sqrt(nPlt)),ceil(sqrt(nPlt)),cnt)
%     %     plot(t, sq(mEP_stim(ip,i,:)), 'b', 'lineWidth', 3)
%     %     hold on
%     %     plot(t, sq(mEP_stim_norm(ip,i,:)), 'r', 'lineWidth', 3)
%     %     plot(t, sq(mEP_stim_artrej(ip,i,:)), 'g', 'lineWidth', 3)
%     cnt2 = 1;
%     for iD = inds';
%         plot(t, sq(mEP_stim_norm_artrej(iD,i,:)), 'color', plotColors(cnt2,:), 'lineWidth', 3)
%         hold on
%         %plot(t, sq(mEP_loff_norm_artrej(iD,i,:)), 'color', plotColors(cnt2,:), 'lineWidth', 3, 'lineStyle', '--')
%         cnt2 = cnt2+1;
%     end
%     title(num2str(i))
%     plot([0 0], [-20 100], 'k--', 'lineWidth', 1)
%     %plot(t, sq(mEP_loff(ip,i,:)), 'color', [0.6 0.6 0.6], 'lineWidth', 3)
%     %y = [min( min(mEP_stim(1,i,:)),  min(mEP_loff(1,i,:)))*1.1 max( max(mEP_stim(1,i,:)), max(mEP_loff(1,i,:)))*1.1];
%     %axis([bn(1) bn(2) y(1) y(2)])
%     set(gca, 'xtick', [bn(1) 0 bn(2)], 'xlim', [bn(1) bn(2)], 'ytick', [-20 0 20 80], 'ylim', [-20 100], 'box', 'off', 'fontSize', 12)
% %     xlabel('Time (ms)')
% %     ylabel('Voltage (uV)')
%     
%     if cnt==1
%         legend(days(inds))
%     end
%     cnt=cnt+1;
% end