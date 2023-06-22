addpath(genpath([BOX_DIR '\ECoG_Recon\matlab_code\']));
%addpath(genpath('E:\Box Sync\Box Sync\ECoG_Recon\matlab_code\'));
global DUKEDIR
DUKEDIR = [CoganLabDir '\D_Data\SentenceRep'];
dLabels = dir(DUKEDIR);
dLabels = dLabels(3:end);
resFold = 'D:\processed_results\sentence_rep_vowels_decoding\v2\';
tw = [-2 2]; % epoch time window
etw = [-1 1]; % high gamma time window

prtw = [-0.5 0]; % preonset time window
pstw = [0.25 0.75]; % postonset time window
gammaF = [70 150]; % frequency in Hz
Task.Name = 'SentenceRep';
Subject = popTaskSubjectData(Task);

%% Iterating through subjects
for iSubject = 1:length(Subject)% [4,10,11,15,19,23,30]
    % Update this code
    disp(['Loading Subject data:' Subject(iSubject).Name]);    
        d = []; ieegCarResp = []; ieegCarImpFilt = []; ieegGamma = []; ieegSplit = [];
        Experiment = Subject(iSubject).Experiment;
        fsD = Experiment.processing.ieeg.sample_rate;
        Trials = Subject(iSubject).Trials;
        allChannels = ({Subject(iSubject).ChannelInfo.Name});
        badChannels = Subject(iSubject).badChannels;
        trialInfo = Subject(iSubject).trialInfo;
    disp('done')
    %% Recon Visualization
%     iSubject = 1;
%     dLabels(iSubject).name = 'D2';
%     cfg = [];
%     % cfg.alpha = 0.4;
%     % cfg.use_brainshifted = 1;
%     handles = plot_subj(dLabels(iSubject).name, cfg);
    disp('Extracting anatomical channels')
        channelName = {Subject(iSubject).ChannelInfo.Location};
        channelName(cellfun(@isempty,channelName)) = {'dummy'};
        sensorymotorChan = contains(channelName,'central');
        whiteChan = contains(channelName,'white');
        ifgChan = contains(channelName,'opercularis');
        frontalChan = contains(channelName,'front');
        temporalChan = contains(channelName,'temporal');
        anatChan = sensorymotorChan;
        disp(['Number of anatomical channels : ' num2str(sum(anatChan))]);
    disp('done')

%% Loading all the data
    
    
    disp('Loading IEEG data'); 

        respId = find(~[Trials.NoResponse]);
        trialsResp = Trials(respId);
        [ieegSplit]=trialIEEG_sentResp(trialsResp,1:length(allChannels),'ResponseStart',tw.*1000);
        ieegSplit = permute(ieegSplit,[2,1,3]);
        ieegBase = squeeze(trialIEEG_sentResp(trialsResp,1:length(allChannels),'Start',tw.*1000));
        ieegBase = permute(ieegBase,[2,1,3]);        
        ieegSplitResp = ieegSplit;
        ieegBaseResp = ieegBase;
    disp('done');
    
    

%% Common average referencing
    disp('Common average referencing');
        ieegCarBase = carFilterImpedance(ieegBaseResp,badChannels);
        ieegCarSplit = carFilterImpedance(ieegSplitResp,badChannels);

        goodChannels = setdiff(1:size(ieegSplitResp,1),badChannels);

        [~,goodtrials] = remove_bad_trials(ieegCarSplit,10);
        %goodTrialsCommon = extractCommonTrials(goodtrials(anatChan));
        ieegBaseClean = ieegCarBase;
        ieegCarClean = ieegCarSplit;
    disp('done');
 %% High Gamma Extraction 
    disp('Extracting High Gamma')
        fsDown =200;
        gInterval = [70 150];
        normFactor = [];
        ieegGammaBasedown = [];
        ieegGammaRespdown = [];
        disp('Extracting Baseline HG');
        for iTrial = 1:size(ieegBaseClean,2)
            
            [~,ieegGammaBasedown(:,iTrial,:)] = EcogExtractHighGammaTrial(double(squeeze(ieegBaseClean(:,iTrial,:))),fsD,fsDown,[gInterval(1) gInterval(2)],tw,prtw,[],[]);
            [~,ieegGammaRespdown(:,iTrial,:)] = EcogExtractHighGammaTrial(double(squeeze(ieegCarClean(:,iTrial,:))),fsD,fsDown,[gInterval(1) gInterval(2)],tw,[-0.25 0.25],[]);
        
        end
    %     
        ieegGammaRespPower = (squeeze(mean(log10(ieegGammaRespdown.^2),3)));
        ieegGammaBasePower = (squeeze(mean(log10(ieegGammaBasedown.^2),3)));
        pChan = [];

        for iChan = 1:size(ieegGammaBasedown,1)
            normFactor(iChan,:) = [mean2(squeeze(ieegGammaBasedown(iChan,:,:))) std2(squeeze(ieegGammaBasedown(iChan,:,:)))];
            pChan(iChan) = permtest_sk((ieegGammaRespPower(iChan,:)),(ieegGammaBasePower(iChan,:)),10000);
    %         ieegGammaPowerNorm(iChan) = 10.*log10(mean(ieegGammaRespPower(iChan,goodtrials{iChan})./mean(ieegGammaBasePower(iChan,goodtrials{iChan}))));
    %         evokeSnr(iChan) = esnr(squeeze(ieegGammaRespdown(iChan,goodtrials{iChan},:)),squeeze(ieegGammaBasedown(iChan,goodtrials{iChan},:)));
        end
         [p_fdr, pvalsMCleanProd] = fdr( pChan, 0.05);
        disp(['Number of significant HG channels : ' num2str(sum(pvalsMCleanProd))]);
        ieegGamma = [];
        disp('Normalizing HG');
        for iTrial = 1:size(ieegCarClean,2)
            

              [~,ieegTmp] = EcogExtractHighGammaTrial(double(squeeze(ieegCarClean(:,iTrial,:))),fsD,fsDown,[gInterval(1) gInterval(2)],tw,etw,squeeze(normFactor),2);
              ieegGamma(:,iTrial,:) = ieegTmp;    

        end
        ieegGamma = squeeze(ieegGamma);
        timeGamma = linspace(etw(1),etw(2),size(ieegGamma,3));
    disp('done');
%% Phoneme feature labeling
    condIds = sentRepSort(trialInfo(respId));
    decodeCondIds = condIds(:,3)==1&condIds(:,2)<5;
    vowelIds = condIds(decodeCondIds,2);
%% Phoneme decoding
    sigChannel = [find(anatChan&pvalsMCleanProd) ];
    if(~isempty(sigChannel))
       
        
        CMatCat = [];         
        
        accPhoneme = 0;
        accPhonemeUnbias = 0;
        accPhonemeChance = 0;
        %if(sum(pvalsMCleanProd&anatChan)~=0)
        disp('Phoneme decoding...')                
                CmatPhoneme = zeros(4,4);
                for iTer = 1:5
                    [~,ytestAll,ypredAll,optimVarAll] = pcaLinearDecoderWrap(ieegGamma(sigChannel,decodeCondIds,:),vowelIds',etw,[-0.5 0.5],[2:2:98],20,0);
                   %[~,ytestAll,ypredAll,aucAll] = linearDecoder(ieegModel(pvalsMCleanProd&anatChan,:,:,:),phonIndClass,[0 1],[0 1],20,0);
                    CmatAll = confusionmat(ytestAll,ypredAll);
                    CmatPhoneme = CmatPhoneme + CmatAll;
                end
                CmatCatNorm = CmatPhoneme./sum(CmatPhoneme,2);
                accPhonemeUnbias = trace(CmatPhoneme)/sum(CmatPhoneme(:));
                accPhoneme = trace(CmatCatNorm)/size(CmatCatNorm,1);
                [~,ytestAll,ypredAll] = pcaLinearDecoderWrap(ieegGamma(sigChannel,decodeCondIds,:),shuffle(vowelIds'),etw,[-0.5 0.5],80,20,0);
                cmatshuff = confusionmat(ytestAll,ypredAll);
                cmatshuff = cmatshuff./sum(cmatshuff,2);
                accPhonemeChance = trace(cmatshuff)/size(cmatshuff,1);       
                %[phonError(iPhon),cmatvect,phonemeDistVect] = phonemeDistanceError(CmatCatNorm,1:9);
            
        disp('done')


        %end
                 
         save(strcat(resFold,'\',Subject(iSubject).Name,'_3vowelDecodeMotorHGPackSigChannelCarAnatSig.mat'),'allChannels','CMatCat','anatChan','pvalsMCleanProd','accPhoneme','accPhonemeUnbias','accPhonemeChance','sigChannel');
    end
close all;
end