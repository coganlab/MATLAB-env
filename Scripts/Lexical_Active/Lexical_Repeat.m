function Lexical_Repeat(subject,taskn,practice)
% subject = subject number
% taskn =  task number. 1 = repeat 2 = lexical decision
% practice =  practice or full task. 1 = 12 trial practice run, 2 = 2 x 42 trials


sca;
 
%subject = 'Test2';
subjecDir = ['C:\Psychtoolbox_Scripts\Lexical_Repeat\' subject];
soundDirW = 'C:\Psychtoolbox_Scripts\Lexical_Repeat\stim\wordsR\';
soundDirNW= 'C:\Psychtoolbox_Scripts\Lexical_Repeat\stim\nonwordsR\';
nBlocks = 2; % 10
trialCount=0;
blockCount=0;
trialEnd=42; %54

nrchannels = 1;
freqS = 44100;
freqR = 20000;
fileSuff = '';
baseCircleDiam=75; % diameter of

repetitions = 1;
StartCue = 0;
WaitForDeviceStart = 1;

trialInfo=[];
if ~exist(subjecDir,'dir')
    mkdir(subjecDir)
end

if practice==1
    trialEnd = 12; %12
    nBlocks = 1;
    fileSuff = '_Pract';
end
%---------------
% Sound Setup
%---------------

% Initialize Sounddriver
InitializePsychSound(1);

% Load Sounds
% [heat]=audioread([soundDir 'heat.wav']);
% [hoot]=audioread([soundDir 'hoot.wav']);
% [hot]=audioread([soundDir 'hot.wav']);
% [hut]=audioread([soundDir 'hut.wav']);
% %[kig]=audioread([soundDir 'kig.wav'])';
% %[pob]=audioread([soundDir 'pob.wav'])';
% [dog]=audioread([soundDir 'DogBell18Sec.wav']);
% [mice]=audioread([soundDir 'HouseMice3Secs.wav']);
% [fame]=audioread([soundDir 'NotorietyFame.wav']);
% [tone500]=audioread([soundDir 'Tone500_3.wav']);

soundValsWords=[];
dirValsW=dir(soundDirW);
for iS=3:length(dirValsW)
    soundNameW=dirValsW(iS).name;
    soundValsWords{iS-2}.sound=audioread([soundDirW soundNameW]);
    soundValsWords{iS-2}.name=soundNameW;
end

soundValsNonWords=[];
dirValsNW=dir(soundDirNW);
for iS=3:length(dirValsNW)
    soundNameNW=dirValsNW(iS).name;
    soundValsNonWords{iS-2}.sound=audioread([soundDirNW soundNameNW]);
    soundValsNonWords{iS-2}.name=soundNameNW;
end

% trialorder
trialOrderWordsOrig=1:42; % 84
trialOrderNonWordsOrig=1:42; % 84
trialOrderWords=Shuffle(trialOrderWordsOrig);
trialOrderNonWords=Shuffle(trialOrderNonWordsOrig);

% Screen Setup
PsychDefaultSetup(2);
% Get the screen numbers
screens = Screen('Screens');
% Select the external screen if it is present, else revert to the native
% screen
screenNumber = max(screens);
% Define black, white and grey
black = BlackIndex(screenNumber);
white = WhiteIndex(screenNumber);
grey = white / 2;
% Open an on screen window and color it grey
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, black);
%[window, windowRect] = PsychImaging('OpenWindow', screenNumber,black,[0 0 500 500]);

% Set the blend funnction for the screen
Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
% Get the size of the on screen window in pixels
[screenXpixels, screenYpixels] = Screen('WindowSize', window);
ifi = Screen('GetFlipInterval', window);
% Get the centre coordinate of the window in pixels
[xCenter, yCenter] = RectCenter(windowRect);
% Set the text size
Screen('TextSize', window, 50);

% Circle stuff for photodiode
baseCircle = [0 0 baseCircleDiam baseCircleDiam];
%centeredCircle = CenterRectOnPointd(baseCircle, screenXpixels-0.5*baseCircleDiam, screenYpixels-0.5*baseCircleDiam); %
centeredCircle = CenterRectOnPointd(baseCircle, screenXpixels-0.5*baseCircleDiam, 1+0.5*baseCircleDiam); %

circleColor1 = [1 1 1]; % white
circleColor2 = [0 0 0]; % black
% Query the frame duration


% Ready Loop

while ~KbCheck
    % Sleep one millisecond after each check, so we don't
    % overload the system in Rush or Priority > 0
     if taskn == 1 
                DrawFormattedText(window, 'Please repeat each word/non-word after the speak cue. Press any key to start. ', 'center', 'center', [1 1 1],58);
     elseif taskn == 2
                DrawFormattedText(window, 'Please say Yes for a word and No for a non-word after the speak cue. Press any key to start. ', 'center', 'center', [1 1 1],58);
     end
  %  DrawFormattedText(window, 'Please Repeat each word/non-word after the speak cue. Press any key to start. ', 'center', 'center', [1 1 1]);
    % Flip to the screen
    Screen('Flip', window);
    WaitSecs(0.001);
end



% Block Loop
for iB=1:nBlocks %nBlocks;
trialOrderWordsBlock=trialOrderWords((iB-1)*21+1:(iB-1)*21+21);
trialOrderNonWordsBlock=trialOrderNonWords((iB-1)*21+1:(iB-1)*21+21);
coinToss=Shuffle(repmat([1,0],1,21));    
%     % Calibrate!
%     clear binCodeVals
%     TrigList=[251,201,151,101,51,1];
%     for i=1:6;
%         trigVal=TrigList(i); % trigger code for testing purposes
%         % Setup Binary Code for Triggers
%         binCode=zeros(10,1);
%         binCode(1)=1;
%         binCode(end)=0;
%         binCodeFill=fliplr(de2bi(trigVal));
%         binCode(end-length(binCodeFill):end-1)=binCodeFill;
%         binCodeVals(i,:)=binCode;
%     end
%     
%     binCodeVals=cat(1,binCodeVals,zeros(1,10));
%     
%     for i=1:size(binCodeVals,1); %nTrials;
%         for ii=1:10
%             iii=binCodeVals(i,ii);
%             
%             % Draw oval for 10 frames (duration of binary code with start/stop bit)
%             if iii==1
%                 Screen('FillOval', window, circleColor1, centeredCircle, baseCircleDiam);
%             else
%                 Screen('FillOval', window, circleColor2, centeredCircle, baseCircleDiam);
%             end
%             Screen('Flip', window);
%             
%         end
%     end
%     clear binCodeVals
    %
   % rotNumb = 18;
    nTrials=42; %168/4; %rotNumb*3;
    
   % [trialStruct,trialShuffle,shuffleIdx,shuffBase] = CreateTrialStructure(rotNumb,nTrials,practice);   

    
    % Actually only need 10! need to manually create structure I guesss
    

    
    cueTimeBaseSeconds= 0.5; % 0.5 Base Duration of Cue s
    delTimeBaseSecondsA = 1; % 0.75 Base Duration of Del s
    delTimeBaseSecondsB = 2.5;
    goTimeBaseSeconds = 0.5; % 0.5 Base Duration Go Cue Duration s
    respTimeSecondsA = 1.5; % 1.5 Response Duration s
    respTimeSecondsB = 3; % for sentences
    isiTimeBaseSeconds = 0.5; % 0.5 Base Duration of ISI s
    
    cueTimeJitterSeconds = 0.25; % 0.25; % Cue Jitter s
    delTimeJitterSeconds = 0.25;% 0.5; % Del Jitter s
    goTimeJitterSeconds = 0.25;% 0.25; % Go Jitter s
    isiTimeJitterSeconds = 0.25; % 0.5; % ISI Jitter s
    
   soundBlockPlay=[];
   counterW=0;
   counterNW=0;
   for i=1:trialEnd %trialEnd; %42
       
       if coinToss(i)==1
           trigVal=trialOrderWordsBlock(counterW+1);
           soundBlockPlay{i}.sound=soundValsWords{trialOrderWordsBlock(counterW+1)}.sound;
           soundBlockPlay{i}.name=soundValsWords{trialOrderWordsBlock(counterW+1)}.name;
           soundBlockPlay{i}.Trigger=trigVal;
           counterW=counterW+1;
       
       elseif coinToss(i)==0
           trigVal=100+trialOrderNonWordsBlock(counterNW+1);
           soundBlockPlay{i}.sound=soundValsNonWords{trialOrderNonWordsBlock(counterNW+1)}.sound;
           soundBlockPlay{i}.name=soundValsNonWords{trialOrderNonWordsBlock(counterNW+1)}.name;
           soundBlockPlay{i}.Trigger=trigVal;
           counterNW=counterNW+1;
       end
       %trigVals=trialOrderNonWordsBlock(i);
       
       %i+(iB; % trigger code for testing purposes
       % Setup Binary Code for Triggers
%        binCode=zeros(10,1);
%        binCode(1)=1;
%        binCode(end)=0;
%        binCodeFill=fliplr(de2bi(trigVal));
%        binCode(end-length(binCodeFill):end-1)=binCodeFill;
%        binCodeVals(i,:)=binCode;
   end
    
    
    %binCodeVals=repmat(binCodeVals,3,1);
   
    % Setup recording!
    %pahandle = PsychPortAudio('Open', [], 1, 1, freq, nrchannels,64);
    pahandle2 = PsychPortAudio('Open', [], 2, 0, freqR, nrchannels,64);
    
    % Preallocate an internal audio recording  buffer with a capacity of 10 seconds:
    PsychPortAudio('GetAudioData', pahandle2, 500); %nTrials
    
    %PsychPortAudio('Start', pahandle, repetitions, StartCue, WaitForDeviceStart);
    PsychPortAudio('Start', pahandle2, 0, 0, 1);
    
    % play tone!
        tone500=audioread('c:\psychtoolbox_scripts\Lexical_Passive\stim\tone500_3.wav');
       % tone500=.5*tone500;
        pahandle = PsychPortAudio('Open', [], 1, 1, freqS, nrchannels,64);
       % PsychPortAudio('Volume', pahandle, 1); % volume
        PsychPortAudio('FillBuffer', pahandle, 0.1*tone500');
        PsychPortAudio('Start', pahandle, repetitions, StartCue, WaitForDeviceStart);
        
       toneTimeSecs = (freqS+length(tone500))./freqS; %max(cat(1,length(kig),length(pob)))./freqS;
        toneTimeFrames = ceil(toneTimeSecs / ifi);
       for i=1:toneTimeFrames
            
            DrawFormattedText(window, '', 'center', 'center', [1 1 1]);
            % Flip to the screen
            Screen('Flip', window);
       end 
%         
      PsychPortAudio('Close', pahandle);
%while ~kbCheck
    for iTrials=1:trialEnd %trialEnd ;%nTrials %nTrials;
        
   % while KbCheck
    % Sleep one millisecond after each check, so we don't
    % overload the system in Rush or Priority > 0
  %  DrawFormattedText(window, 'Paused. ', 'center', 'center', [1 1 1]);
   % % Flip to the screen
   % Screen('Flip', window);
   % WaitSecs(0.001);
 %   end
     %   tmp1=KbCheck;
      %  while ~tmp1

    
%         valQ=GetChar;
%         
%         if strcmp(valQ,'q')==1
%             pause
%         end
%                    DrawFormattedText(window, 'Paused', 'center', 'center', [1 1 1]);
% %                 % Flip to the screen
%                  Screen('Flip', window);
%                  WaitSecs(0.001);
%                  valQ=[];
% %             end
%         end
        
        cue='Listen'; %trialStruct.cue{trialShuffle(1,iTrials)};
        %if CoinToss(iTrials)==1
        
        sound=soundBlockPlay{iTrials}.sound;%eval(trialStruct.sound{trialShuffle(2,iTrials)});
        sound=sound(:,1);
        go='Speak'; %trialStruct.go{trialShuffle(3,iTrials)};
         
        %if length(sound)/freqS<1
            delTimeBaseSeconds=delTimeBaseSecondsA;
            respTimeSeconds=respTimeSecondsA;
        %else
         %   delTimeBaseSeconds=delTimeBaseSecondsB;
          %  respTimeSeconds=respTimeSecondsB;
        %end
         
        soundTimeSecs = length(sound)./freqS; %max(cat(1,length(kig),length(pob)))./freqS;
        soundTimeFrames = ceil(soundTimeSecs / ifi);
        cueTimeBaseFrames = round((cueTimeBaseSeconds+(cueTimeJitterSeconds*rand(1,1))) / ifi);
       
        delTimeSeconds = delTimeBaseSeconds + delTimeJitterSeconds*rand(1,1);
        delTimeFrames = round(delTimeSeconds / ifi );
        goTimeSeconds = goTimeBaseSeconds +goTimeJitterSeconds*rand(1,1);
        goTimeFrames = round(goTimeSeconds / ifi);
        respTimeFrames = round(respTimeSeconds / ifi);
        
        
        % write trial structure
        trialInfo{trialCount+1}.cue = cue;
        trialInfo{trialCount+1}.sound = soundBlockPlay{iTrials}.name;%trialStruct.sound{trialShuffle(2,iTrials)};
        trialInfo{trialCount+1}.go = go;
        trialInfo{trialCount+1}.cueTime=GetSecs;
        trialInfo{trialCount+1}.block = iB;
        %trialInfo{trialCount+1}.cond = trialShuffle(4,iTrials);
        trialInfo{trialCount+1}.cueStart = GetSecs;
        trialInfo{trialCount+1}.Trigger=soundBlockPlay{iTrials}.Trigger;
         
    %   binCode=binCodeVals(iTrials,:);

        % Draw inital Cue text
        for i = 1:cueTimeBaseFrames
            % Draw oval for 10 frames (duration of binary code with start/stop bit)
            if i<=3 
            Screen('FillOval', window, circleColor1, centeredCircle, baseCircleDiam); % leave on!
            end
            % 
%             if i<=10 && binCode(i)==1
%                 Screen('FillOval', window, circleColor1, centeredCircle, baseCircleDiam);
%             elseif i<=10 && binCode(i)==0
%                 Screen('FillOval', window, circleColor2, centeredCircle, baseCircleDiam);
%             end
            
            % Draw text
            DrawFormattedText(window, cue, 'center', 'center', [1 1 1]);
            % Flip to the screen
            Screen('Flip', window);
        end
        trialInfo{trialCount+1}.cueEnd=GetSecs;
        
        %Play Sound
        pahandle = PsychPortAudio('Open', [], 1, 1, freqS, nrchannels,64);
        PsychPortAudio('FillBuffer', pahandle, sound');
        PsychPortAudio('Volume', pahandle, 0.5); % volume
        PsychPortAudio('Start', pahandle, repetitions, StartCue, WaitForDeviceStart);
        %
        % Draw blank for duration of sound
        for i=1:soundTimeFrames
            
            DrawFormattedText(window, '', 'center', 'center', [1 1 1]);
            % Flip to the screen
            Screen('Flip', window);
        end
        
       
        
        % % Delay
       
        trialInfo{trialCount+1}.delStart=GetSecs;
        for i=1:delTimeFrames
            Screen('Flip', window);
        end
        
        trialInfo{trialCount+1}.delEnd=GetSecs;
        % % Close Sound
        PsychPortAudio('Close', pahandle);
        
        % Setup recording!
        % % pahandle = PsychPortAudio('Open', [], 1, 1, freq, nrchannels,64);
        pahandle3 = PsychPortAudio('Open', [], 2, 0, freqR, nrchannels,64);
        %
        % % Preallocate an internal audio recording  buffer with a capacity of 10 seconds:
        PsychPortAudio('GetAudioData', pahandle3, 5);
        %
        % %PsychPortAudio('Start', pahandle, repetitions, StartCue, WaitForDeviceStart);
        PsychPortAudio('Start', pahandle3, 0, 0, 1);
        
        
        
        trialInfo{trialCount+1}.goStart=GetSecs;
        for i=1:goTimeFrames
            DrawFormattedText(window, go, 'center', 'center', [1 1 1]);
            Screen('Flip', window);
        end
        
        trialInfo{trialCount+1}.goEnd=GetSecs;
          
        trialInfo{trialCount+1}.respStart=GetSecs;
        for i=1:respTimeFrames
            %  DrawFormattedText(window,'','center','center',[1 1 1]);
            % Flip to the screen
            Screen('Flip', window);end
        
        trialInfo{trialCount+1}.respEnd=GetSecs;
        [audiodata offset overflow tCaptureStart] = PsychPortAudio('GetAudioData', pahandle3);
        filename = ([subject '_Block_' num2str(iB) '_Trial_' num2str(trialCount+1) fileSuff '.wav']);
        audiowrite([subjecDir '\' filename],audiodata,freqR);
        PsychPortAudio('Stop', pahandle3);
        PsychPortAudio('Close', pahandle3);
        
       % % PsychPortAudio('Stop', pahandle2);
       % % PsychPortAudio('Close', pahandle2);
        
        % ISI
        isiTimeSeconds = isiTimeBaseSeconds + isiTimeJitterSeconds*rand(1,1);
        isiTimeFrames=round(isiTimeSeconds / ifi );
        
        trialInfo{trialCount+1}.isiStart=GetSecs;
        for i=1:isiTimeFrames
            DrawFormattedText(window,'' , 'center', 'center', [1 1 1]);
            % Flip to the screen
            Screen('Flip', window);
        end
        
        trialInfo{trialCount+1}.isiEnd=GetSecs;
        save([subjecDir '\' subject '_Block_' num2str(blockCount+1) fileSuff '_TrialData.mat'],'trialInfo')
        
        trialCount=trialCount+1;
      
 %       end
%tmp1=0;
    end
    
    [audiodata offset overflow tCaptureStart] = PsychPortAudio('GetAudioData', pahandle2);
    filename = ([subject '_Block_' num2str(blockCount+1) fileSuff '_AllTrials.wav']);
    audiowrite([subjecDir '\' filename],audiodata,freqR);
    PsychPortAudio('Stop', pahandle2);
    PsychPortAudio('Close', pahandle2);
    % % Stop playback
    % %PsychPortAudio('Stop', pahandle);
    
    % Close the audio device
     
   % PsychPortAudio('Close', pahandle);
    blockCount=blockCount+1;
    
    % % Break Screen
    while ~KbCheck
        % Sleep one millisecond after each check, so we don't
        % overload the system in Rush or Priority > 0
       % if taskn == 1 
       %         DrawFormattedText(window, 'Please repeat each word/non-word after the speak cue. Press any key to start. ', 'center', 'center', [1 1 1]);
       % elseif taskn == 2
       %         DrawFormattedText(window, 'Please say Yes for a word and No for a non-word after the speak cue. Press any key to start. ', 'center', 'center', [1 1 1]);
       % end
        DrawFormattedText(window, 'Take a short break and press any key to continue', 'center', 'center', [1 1 1]);
        % Flip to the screen
        Screen('Flip', window);
        WaitSecs(0.001);
    end
    
end
sca
close all
%clear all