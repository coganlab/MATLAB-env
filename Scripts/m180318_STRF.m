% strf!

wordDir='G:\Scripts\Lexical_Active\stim\words\';
nonwordDir='G:\Scripts\Lexical_Active\stim\nonwords\';
load('test1.mat');

wordAudioFiles={};
wordAudioFilesList=dir(wordDir);
wordAudioFilesList([1:2,19])=[];
for iF=1:length(wordAudioFilesList);
    wordAudioFiles{iF}=[wordDir wordAudioFilesList(iF).name];
end

nonwordAudioFiles={};
nonwordAudioFilesList=dir(nonwordDir);
nonwordAudioFilesList([1:2,16])=[];
for iF=1:length(nonwordAudioFilesList);
    nonwordAudioFiles{iF}=[nonwordDir nonwordAudioFilesList(iF).name];
end


preprocStimParams = struct;      %create preprocessing param structure
preprocStimParams.tfType = 'stft'; %use short-time FT
tfParams = struct;               %create time-frequency params
tfParams.high_freq = 8000;       %specify max freq to analyze
tfParams.low_freq = 250;         %specify min freq to analyze
tfParams.log = 1;                %take log of spectrogram
tfParams.dbnoise = 80;           %cutoff in dB for log spectrogram, ignore anything below this
tfParams.refpow = 0;             %reference power for log spectrogram, set to zero for max of spectrograms across stimuli
preprocStimParams.tfParams = tfParams;

% make a temporary directory to store preprocessed sound files (should be
%  specific to parameters for preprocSound)
tempPreprocDir = tempname();    
[s,mess,messid] = mkdir(tempPreprocDir);
preprocStimParams.outputDir = tempPreprocDir;

[wordWholeStim, wordGroupIndex, wordStimInfo, wordPreprocStimParams] = preprocSound(wordAudioFiles, preprocStimParams);
[nonwordWholeStim, nonwordGroupIndex, nonwordStimInfo, nonwordPreprocStimParams] = preprocSound(nonwordAudioFiles, preprocStimParams);

tLag=200;

respInp=sq(mean(SPEC_N(:,501:end,70:150),3));
[M S]=normfit(respInp(:));
respInp=(respInp-M)./S;
% words!



for iTrials=1:length(iiW);
    tmp=trialInfo_new{iiW(iTrials)}.StimName;
    for iF=1:length(wordAudioFilesList);
        if strcmp(wordAudioFilesList(iF).name,tmp) == 1
            StimIdent(iTrials)=iF;
        end
    end
end

[I J]=sort(StimIdent);

for iTrials=1:length(J);
    wordRespInfo.responseLengths(iTrials)=wordStimInfo.stimLengths(iTrials);
    wordRespInfo.numTrials=1;
end

wordPreProcRespParams=wordRespInfo;

wordWholeResponse=[];
for iTrials=1:length(J)
    respTmp=respInp(J(iTrials),tLag+1:tLag+wordStimInfo.stimLengths(iTrials).*1000);
    wordWholeResponse=cat(2,wordWholeResponse,respTmp);
end

%[wholeResponse, groupIndex, respInfo, preprocRespParams] = preprocSpikeResponses(allSpikeTrials, preprocRespParams);

displayStimResp = 0;

if displayStimResp
    nGroups = length(unique(wordGroupIndex));
    for k = 1:nGroups

        tRng = find(wordGroupIndex == k);

        stim = wordWholeStim(tRng, :);
        resp = wordWholeResponse(tRng);

        tInc = 1 / wordStimInfo.sampleRate;
        t = 0:tInc:(size(stim, 1)-1)*tInc;

        figure; hold on;
        
        %plot spectrogram
        subplot(2, 1, 1);
        imagesc(t, stimInfo.f, stim'); axis tight;
        axis xy;
        v_axis = axis;
        v_axis(1) = min(t); v_axis(2) = max(t);
        v_axis(3) = min(stimInfo.f); v_axis(4) = max(stimInfo.f);
        axis(v_axis);
        xlabel('Time (s)'); ylabel('Frequency (Hz)');

        %plot PSTH
        subplot(2, 1, 2);
        plot(t, resp, 'k-');% axis([0 max(t) 0 1]);
        xlabel('Time (s)'); ylabel('P[spike]');

        title(sprintf('Pair %d', k));
    end
end



%% Initialize strflab global variables with our stim and responses
global globDat
strfData(wordWholeStim, wordWholeResponse, wordGroupIndex);


%% Initialize a linear model that extends 75ms back in time
strfLength = 40;
strfDelays = 0:(strfLength-1);
modelParams = linInit(wordStimInfo.numStimFeatures, strfDelays);


%% pick training datasets for DirectFit
trainingGroups = 1:75;
trainingIndex = findIdx(trainingGroups, wordGroupIndex);


%% Initialize and run the DirectFit training routine
optOptions = trnDirectFit();
fprintf('\nRunning Direct Fit training...\n');
[modelParamsDF, optOptions] = strfOpt(modelParams, trainingIndex, optOptions);


%% pick training and early stopping datasets for Gradient and Coordinate Descent
trainingGroups = 1:75;
earlyStoppingGroups = [76];

trainingIndex = findIdx(trainingGroups, wordGroupIndex);
earlyStoppingIndex = findIdx(earlyStoppingGroups,wordGroupIndex);


%% Initialize and run Gradient Descent w/ early stopping
optOptions = trnGradDesc();
optOptions.display = 1;
optOptions.maxIter = 1000;
optOptions.stepSize = 2e-6;
optOptions.earlyStop = 1;
optOptions.gradNorm = 1;

fprintf('\nRunning Gradient Descent training...\n');
[modelParamsGradDesc, optOptions] = strfOpt(modelParams, trainingIndex, optOptions, earlyStoppingIndex);


%% Initialize and run Coordinate Descent w/ early stopping
optOptions = trnGradDesc();
optOptions.display = 1;
optOptions.maxIter = 300;
optOptions.stepSize = 1e-4;
optOptions.earlyStop = 1;
optOptions.coorDesc = 1;

fprintf('\nRunning Coordinate Descent training...\n');
[modelParamsCoorDesc, optOptions] = strfOpt(modelParams, trainingIndex, optOptions, earlyStoppingIndex);

% Don't have the trials!
%% split original spike trials into two PSTHs for purposes of validation
preprocRespParams.split = 1;
%[wordWholeSplitResponse, wordRespSplitInfo, wordPreprocRespParams] = preprocSpikeResponses(allSpikeTrials, wordPreprocRespParams);


%% compute responses to validation data for each STRF
validationGroups = [76:84];
respReal = [];
respRealHalf1 = [];
respRealHalf2 = [];
respDF = [];
respGradDesc = [];
respCoorDesc = [];
for k = 1:length(validationGroups)
   
    g = validationGroups(k);
    %gIndx = find(globDat.groupIdx == g);
    gIndx=find(wordGroupIndex == g);
    stim=wordWholeStim(gIndx');
    resp=wordWholeResponse(gIndx)';
  %  stim = globDat.stim(gIndx);
  %  resp = globDat.resp(gIndx);
    respH1 = wordWholeSplitResponse(1, gIndx);
    respH2 = wordWholeSplitResponse(2, gIndx);
        
    [modelParamsDF, resp1] = strfFwd(modelParamsDF, gIndx);
    [modelParamsGradDesc, resp2] = strfFwd(modelParamsGradDesc, gIndx);
    [modelParamsCoorDesc, resp3] = strfFwd(modelParamsCoorDesc, gIndx);
    
    respReal = [respReal resp];
    respRealHalf1 = [respRealHalf1 respH1];
    respRealHalf2 = [respRealHalf2 respH2];
    respDF = [respDF resp1'];
    respGradDesc = [respGradDesc resp2'];
    respCoorDesc = [respCoorDesc resp3'];
end


%% rescale model responses
respDF = (respDF / max(respDF))*max(respReal);
respGradDesc = (respGradDesc / max(respGradDesc))*max(respReal);
respCoorDesc = (respCoorDesc / max(respCoorDesc))*max(respReal);


%% Compute performance on validation datasets for each STRF
avgNumTrials = mean(respInfo.numTrials); %taking mean isn't necessary here
infoFreqCutoff = 90; %Hz
infoWindowSize = 0.500; %500ms
[cBound, cDF] = compute_coherence_full(respDF, respReal, respRealHalf1, respRealHalf2, stimInfo.sampleRate, avgNumTrials, infoFreqCutoff, infoWindowSize);
[cBound, cGradDesc] = compute_coherence_full(respGradDesc, respReal, respRealHalf1, respRealHalf2, stimInfo.sampleRate, avgNumTrials, infoFreqCutoff, infoWindowSize);
[cBound, cCoorDesc] = compute_coherence_full(respCoorDesc, respReal, respRealHalf1, respRealHalf2, stimInfo.sampleRate, avgNumTrials, infoFreqCutoff, infoWindowSize);


%% plot STRFS
figure; hold on;

subplot(3, 1, 1); hold on;
imagesc(strfDelays, stimInfo.f, modelParamsDF.w1); axis tight;
absmax = max(max(abs(modelParamsDF.w1)));
caxis([-absmax absmax]);
colorbar;
title(sprintf('Direct Fit | bias=%f', modelParamsDF.b1));

subplot(3, 1, 2); hold on;
imagesc(strfDelays, stimInfo.f, squeeze(modelParamsGradDesc.w1)); axis tight;
absmax = max(max(abs(modelParamsGradDesc.w1)));
caxis([-absmax absmax]);
colorbar;
title(sprintf('Gradient Descent | bias=%f', modelParamsGradDesc.b1));

subplot(3, 1, 3); hold on;
imagesc(strfDelays, stimInfo.f, squeeze(modelParamsCoorDesc.w1)); axis tight;
absmax = max(max(abs(modelParamsCoorDesc.w1)));
caxis([-absmax absmax]);
colorbar;
title(sprintf('Coordinate Descent | bias=%f', modelParamsCoorDesc.b1));


%% display predictions
displayPredictions = 1;
if displayPredictions
    
    tInc = 1 / stimInfo.sampleRate;
    t = 0:tInc:(length(respReal)-1)*tInc;
   
    figure; hold on;
    
    subplot(3, 1, 1); hold on;
    plot(t, respReal, 'k-');
    plot(t, respDF, 'r-');
    axis([min(t) max(t) 0 1]);
    title('Direct Fit');
    legend('Real', 'Model');
    
    subplot(3, 1, 2); hold on;
    plot(t, respReal, 'k-');
    plot(t, respGradDesc, 'r-');
    axis([min(t) max(t) 0 1]);
    title('Gradient Descent');
    legend('Real', 'Model');
    
    subplot(3, 1, 3); hold on;
    plot(t, respReal, 'k-');
    plot(t, respCoorDesc, 'r-');
    axis([min(t) max(t) 0 1]);
    title('Coordinate Descent');
    legend('Real', 'Model');
    
end


%% plot coherences and information
figure; hold on;
plot(cBound.f, cBound.c, 'k-', 'LineWidth', 2);
plot(cDF.f, cDF.c, 'b-');
plot(cGradDesc.f, cGradDesc.c, 'g-');
plot(cCoorDesc.f, cCoorDesc.c, 'r-');
axis tight;
title('Coherences for Validation Set');
legend('Upper Bound', 'Direct Fit', 'Grad Desc', 'Coord Desc');


%% compute performance ratios
perfDF = cDF.info / cBound.info;
perfGradDesc = cGradDesc.info / cBound.info;
perfCoorDesc = cCoorDesc.info / cBound.info;

fprintf('Performance Ratios:\n');
fprintf('\tDirect Fit: %f\n', perfDF);
fprintf('\tGradient Descent: %f\n', perfGradDesc);
fprintf('\tCoordinate Descent: %f\n', perfCoorDesc);

