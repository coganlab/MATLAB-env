function Events = procEvents(day, rec, saveflag)
%  PROCEVENTS converts file.ev.txt to Events data structure
%     for Reach Search task v7.1
%
%  EVENTS = PROCEVENTS(DAY, REC, SAVEFLAG)
%
%  Inputs:  DAY    = String '030603'
%           REC    = String '001', or num [1,2]
%           SAVEFLAG    =   0: No save
%                           1: Save
%               Defaults to 1.
%
%  Outputs: EVENTS  = Event data structure
%

%  This needs
%  isReachTrial.m
%  isSaccadeTrial.m
%  isDoubleStepTrial.m

global MONKEYDIR

% eventTimestamps = [];
% targetTimestamps = [];
% startOnTimeVals = [];
% minTimeVals =[];
% recStartTimeVals = [];

%  Load Reward Duration data
if isfile(fullfile(MONKEYDIR, 'Labview',['Reward Duration.',day,'.txt']))
    copyfile(fullfile(MONKEYDIR,'Labview',['Reward Duration.',day,'.txt']),...
        fullfile(MONKEYDIR, day, 'Labview',['Reward Duration.',day,'.txt']));
end
try
    lv_events = dlmread(fullfile(MONKEYDIR,day,'Labview',['Reward Duration.',day,'.txt']));
    lv_events(1,:) = [];
    lv_st = lv_events(:,1);
    for i = 1:length(lv_st);
        z = num2str(lv_st(i));
        z_tok = strtok(z,'.'); z_dec = z(length(z_tok)+2:end); z = z_tok;
        while length(z)<6; z = ['0',z]; end
        while length(z_dec)<3; z_dec = [z_dec,'0']; end
        z1 = str2num(z(1:2)); z2 = str2num(z(3:4)); z3 = str2num(z(5:6));
        z4 = str2num(z_dec);
        lv_events(i,1) = z1*60*60*1000 + z2*60*1000 + z3*1000 + z4;  % Convert to milliseconds from start of day
    end
    if isfile(fullfile(MONKEYDIR, day, 'Labview',['Reward Duration.',day,'.txt']))
        if isfile(fullfile(MONKEYDIR,['/Labview/Reward Duration.' day '.txt']))
            % delete([MONKEYDIR '/Labview/Reward Duration.' day '.txt']);
        end
    end
end

%  Load Target Location data
if isfile(fullfile(MONKEYDIR, 'Labview',['Target Location.',day,'.txt']))
    copyfile(fullfile(MONKEYDIR,'Labview',['Target Location.',day,'.txt']),...
        fullfile(MONKEYDIR, day, 'Labview',['Target Location.',day,'.txt']));
end
try
    lv_target = dlmread(fullfile(MONKEYDIR,day,'Labview',['Target Location.',day,'.txt']));
    
    % targetTimestamps = lv_target(:,1);
    
    lv_target(1,:) = [];
    lv_st = lv_target(:,1);
    for i = 1:length(lv_st);
        z = num2str(lv_st(i));
        z_tok = strtok(z,'.'); z_dec = z(length(z_tok)+2:end); z = z_tok;
        while length(z)<6; z = ['0',z]; end
        while length(z_dec)<3; z_dec = [z_dec,'0']; end
        z1 = str2num(z(1:2)); z2 = str2num(z(3:4)); z3 = str2num(z(5:6));
        z4 = str2num(z_dec);
        lv_target(i,1) = z1*60*60*1000 + z2*60*1000 + z3*1000 + z4;   % Convert to milliseconds from start of day
    end
    if isfile(fullfile(MONKEYDIR, day, 'Labview',['Target Location.',day,'.txt']))
        if isfile(fullfile(MONKEYDIR,['/Labview/Target Location.' day '.txt']))
            % delete([MONKEYDIR '/Labview/Target Location.' day '.txt']);
        end
    end
end


%  Load Acquire Time data
if isfile(fullfile(MONKEYDIR, 'Labview',['Acquire Time.',day,'.txt']))
    copyfile(fullfile(MONKEYDIR,'Labview',['Acquire Time.',day,'.txt']),...
        fullfile(MONKEYDIR, day, 'Labview',['Acquire Time.',day,'.txt']));
end
try
    lv_acquire = dlmread(fullfile(MONKEYDIR,day,'Labview',['Acquire Time.',day,'.txt']));
    lv_acquire(1,:) = [];
    lv_st = lv_acquire(:,1);
    for i = 1:length(lv_st);
        z = num2str(lv_st(i));
        z_tok = strtok(z,'.'); z_dec = z(length(z_tok)+2:end); z = z_tok;
        while length(z)<6; z = ['0',z]; end
        while length(z_dec)<3; z_dec = [z_dec,'0']; end
        z1 = str2num(z(1:2)); z2 = str2num(z(3:4)); z3 = str2num(z(5:6));
        z4 = str2num(z_dec);
        lv_acquire(i,1) = z1*60*60*1000 + z2*60*1000 + z3*1000 + z4;   % Convert to milliseconds from start of day
    end
    if isfile(fullfile(MONKEYDIR, day, 'Labview',['Acquire Time.',day,'.txt']))
        if isfile(fullfile(MONKEYDIR,['/Labview/Acquire Time.' day '.txt']))
            % delete([MONKEYDIR '/Labview/Acquire Time.' day '.txt']);
        end
    end
end




%  Load Brightness data
if isfile(fullfile(MONKEYDIR, 'Labview',['Brightness.',day,'.txt']))
    copyfile(fullfile(MONKEYDIR,'Labview',['Brightness.',day,'.txt']),...
        fullfile(MONKEYDIR, day, 'Labview',['Brightness.',day,'.txt']));
end
try
    lv_bright = dlmread(fullfile(MONKEYDIR,day,'Labview',['Brightness.',day,'.txt']));
    lv_bright(1,:) = [];
    lv_st = lv_bright(:,1);
    for i = 1:length(lv_st);
        z = num2str(lv_st(i));
        z_tok = strtok(z,'.'); z_dec = z(length(z_tok)+2:end); z = z_tok;
        while length(z)<6; z = ['0',z]; end
        while length(z_dec)<3; z_dec = [z_dec,'0']; end
        z1 = str2num(z(1:2)); z2 = str2num(z(3:4)); z3 = str2num(z(5:6));
        z4 = str2num(z_dec);
        lv_bright(i,1) = z1*60*60*1000 + z2*60*1000 + z3*1000 + z4;  % Convert to milliseconds from start of day
    end
    if isfile(fullfile(MONKEYDIR, day, 'Labview',['Brightness.',day,'.txt']))
        if isfile(fullfile(MONKEYDIR,['/Labview/Brightness.' day '.txt']))
            disp('deleting file...');
            % delete([MONKEYDIR '/Labview/Brightness.' day '.txt']);
        end
    end
end

%  Load Stim data
if isfile(fullfile(MONKEYDIR, 'Labview',['LaserStim.',day,'.txt']))
    copyfile(fullfile(MONKEYDIR,'Labview',['LaserStim.',day,'.txt']),...
        fullfile(MONKEYDIR, day, 'Labview',['LaserStim.',day,'.txt']));
end
try
    lv_stim = dlmread(fullfile(MONKEYDIR,day,'Labview',['LaserStim.',day,'.txt']));
    lv_stim(1,:) = [];
    lv_st = lv_stim(:,1);
    for i = 1:length(lv_st);
        z = num2str(lv_st(i));
        z_tok = strtok(z,'.'); z_dec = z(length(z_tok)+2:end); z = z_tok;
        while length(z)<6; z = ['0',z]; end
        while length(z_dec)<3; z_dec = [z_dec,'0']; end
        z1 = str2num(z(1:2)); z2 = str2num(z(3:4)); z3 = str2num(z(5:6));
        z4 = str2num(z_dec);
        lv_stim(i,1) = z1*60*60*1000 + z2*60*1000 + z3*1000 + z4;  % Convert to milliseconds from start of day
    end
    if isfile(fullfile(MONKEYDIR, day, 'Labview',['LaserStim.',day,'.txt']))
        if isfile(fullfile(MONKEYDIR,['/Labview/LaserStim.' day '.txt']))
            % delete([MONKEYDIR '/Labview/Reward Duration.' day '.txt']);
        end
    end
end




if nargin < 3 || isempty(saveflag) saveflag  = 1; end

olddir = pwd;
recs = dayrecs(day);
nRecs = length(recs);

if nargin < 2
    num = [1,nRecs];
elseif isstr(rec)
    num = [find(strcmp(recs,rec)),find(strcmp(recs,rec))];
elseif length(rec)==1
    num = [rec,rec];
else
    num = rec;
end
if nargin < 3  saveflag = 1; end

for iRec = num(1):num(2)
    cd([MONKEYDIR '/' day '/' recs{iRec}]);
    disp([MONKEYDIR '/' day '/' recs{iRec}]);
    %pause
    events = load(['rec' recs{iRec} '.ev.txt']);
    if exist(['rec' recs{iRec} '.display.txt'])
        display_events = load(['rec' recs{iRec} '.display.txt']);
    else
        display_events = [];
    end
    load(['rec' recs{iRec} '.Rec.mat']);
    if isfield(Rec,'BinaryDataFormat')
        format = Rec.BinaryDataFormat;
    else
        format = 'short';
    end
    
    if exist(['rec' recs{iRec} '.stimraw.txt'])
        stim_events = load(['rec' recs{iRec} '.stimraw.txt']);
    else
        stim_events = [];
    end

    %RECORDING START TIME in ms
    hrs = Rec.StartTime(4)*60*60*1000;
    mins = Rec.StartTime(5)*60*1000;
    secs = Rec.StartTime(6)*1000;
    RecStartTime = hrs + mins + secs;  % Convert to milliseconds from start of day

    % eventTimestamps = [ eventTimestamps; events ];
%     keyboard
    clear Events
    if ~isempty(events)
        ntr = max(events(:,1))-min(events(:,1))-1;

        Events.Trial = zeros(ntr,1);	%  Trial number in ev.txt

        Events.StartOn = zeros(ntr,1);      %  Time start on
        Events.StartAq = zeros(ntr,1);      %  Time start acquire
        Events.TargsOn = zeros(ntr,1);      %  Time targets on
        Events.Go = zeros(ntr,1);           %  Time of go signal for nth reach
        Events.TargAq = zeros(ntr,1);       %  Time nth reach acquired
        Events.TargetOff = zeros(ntr,1);
        Events.InstOn = zeros(ntr,1);
        Events.EffInstOn = zeros(ntr,1);
        Events.TargetRet = zeros(ntr,1);
        Events.ReachGo = zeros(ntr,1);      %  Time reach go for Then tasks
        Events.SaccadeGo = zeros(ntr,1);    %  Time saccade go for Then tasks
        Events.ReachAq = zeros(ntr,1);      %  Time reach acquired for Then tasks
        Events.SaccadeAq = zeros(ntr,1);    %  Time saccade acquire for Then tasks

        Events.HandCode = zeros(ntr,1);     %  Hand?.  1 = right.  0 = left. 2 = bimanual.
        Events.TaskCode = zeros(ntr,1);     %  Trial type?
        Events.Joystick = zeros(ntr,1);     %  Joystick?  0 = Touch; 1 = Joystick

        Events.Target = zeros(ntr,1);	    %  Target location code
        Events.EyeTarget = zeros(ntr,1);	%  Eye Target location code
        Events.StartHand = zeros(ntr,1);    %  Initial hand location code
        Events.StartEye = zeros(ntr,1);     %  Initial eye location code

        Events.EyeTargetLocation = zeros(ntr,2);
        Events.HandTargetLocation = zeros(ntr,2);
                
        Events.RewardConfig = zeros(ntr,1);
        Events.Choice = zeros(ntr,1);
        Events.EyeRewardBlock = zeros(ntr,1);
        Events.HandRewardBlock = zeros(ntr,1);
        Events.RewardTask = zeros(ntr,1);
        Events.HighReward = zeros(ntr,1);
        Events.ReachChoice = nan(ntr,1); 
        Events.SaccadeChoice = nan(ntr,1);
        Events.SaccadeCircleTarget = nan(ntr,1);
        Events.ReachCircleTarget = nan(ntr,1);
        Events.TargetDimming = zeros(ntr,1);
        
        
        Events.Separable4T = zeros(ntr,1);
        Events.Targ2 = zeros(ntr,1);

        Events.ReachStart = zeros(ntr,1);   %  Time reach started
        Events.ReachStop = zeros(ntr,1);    %  Time reach stopped
        Events.SaccStart = zeros(ntr,1);    %  Time saccade started
        Events.SaccStop = zeros(ntr,1);     %  Time saccade finished
        Events.Sacc2Start = zeros(ntr,1);    %  Time saccade started
        Events.Sacc2Stop = zeros(ntr,1);     %  Time saccade finished

        Events.TargMove = zeros(ntr,1);     %  Time target is moved during adaptation
        Events.Targ2On = zeros(ntr,1);     %  Time 2nd target appears in double step tasks

        Events.Reach = zeros(ntr,1);        %  Is Reach trial
        Events.Saccade = zeros(ntr,1);        %  Is Saccade trial
        Events.DoubleStep = zeros(ntr,1);        %  Is DoubleStep trial

        Events.AdaptationFeedback = zeros(ntr,1);
        Events.AdaptationAction = zeros(ntr,1);
        Events.AdaptationPhase = zeros(ntr,1);
        Events.LEDBoard = zeros(ntr,1);

        Events.MinReachRT = zeros(ntr,1);
        Events.MaxReachRT = zeros(ntr,1);
        Events.MinReachAq = zeros(ntr,1);
        Events.MaxReachAq = zeros(ntr,1);
        Events.MinSaccadeRT = zeros(ntr,1);
        Events.MaxSaccadeRT = zeros(ntr,1);
        Events.MinSaccadeAq = zeros(ntr,1);
        Events.MaxSaccadeAq = zeros(ntr,1);
        Events.MinSaccade2RT = zeros(ntr,1);
        Events.MaxSaccade2RT = zeros(ntr,1);
        Events.MinSaccade2Aq = zeros(ntr,1);
        Events.MaxSaccade2Aq = zeros(ntr,1);

        %        Events.SaccBegin = zeros(ntr,20,2); %  Nth saccade beginning location
        %        Events.SaccEnd = zeros(ntr,20,2);   %  Nth saccade end location
        %        Events.NumSacc = zeros(ntr,1);      %  Number of saccades

        %        Events.NumLRSacc = zeros(ntr,1);      %  Number of LR saccades
        %        Events.LRSaccStart = zeros(ntr,1);   %  Time nth LR saccade started
        %        Events.LRSaccStop = zeros(ntr,1);    %  Time nth LR saccade finished
        %        Events.LRSaccBegin = zeros(ntr,2); %  Nth LR saccade beginning location
        %        Events.LRSaccEnd = zeros(ntr,2);   %  Nth LR saccade end
        %        location

        Events.Success = zeros(ntr,1);      %  Success variable
        Events.AbortState = zeros(ntr,1);      %  State number when abort
        Events.End = zeros(ntr,1);          %  Time of trial end

        Events.StartTrial = zeros(ntr,1);      %  Start Trial variable
        Events.StartStim = zeros(ntr,1);
        
        Events.RewardDur = zeros(ntr,4);
        Events.Delta = zeros(ntr,1);
        Events.RewardDist = zeros(ntr,4);
        Events.TargetDelta = zeros(ntr,1);
        Events.T1T2Locations = zeros(ntr,2,2);
        Events.T1T2Delta = zeros(ntr,2);
        Events.TargetScale = zeros(ntr,1);
        Events.Target2Scale = zeros(ntr,1);
        Events.BrightVals = zeros(ntr,2);
        Events.BrightDist = zeros(ntr,4);
        
        
        trial = 0;
        %     min(events(:,1))
        %     max(events(:,1))
        %     pause
        for tr = min(events(:,1))+1:max(events(:,1))-1  %  Skip first and
            %  last trials
            trial = trial+1;
            %disp(['Trial ' num2str(trial)]);
            evs = events(find(events(:,1)==tr),:);
            if ~isempty(display_events) %I dont think this works -- RAS 12/26/13
                display_evs = display_events(find(display_events(:,1)==tr),:);
            else
                display_evs=[];
            end
            Ind_StartTrial = find(evs(:,2)==0);
            StartTrial = evs(Ind_StartTrial,3);
            
            if min(events(:,1)) == 0
                trialShift = 1;
            else
                trialShift = 0;
            end
            if ~isempty(stim_events)
                stim_evs = stim_events(find(stim_events(:,1)==tr+trialShift),:);
            else
                stim_evs=[];
            end
            
            Ind_StartOn = find(evs(:,2)==1);
            if isempty(Ind_StartOn) %at least once we went straight to about, no 1)
                Ind_StartOn = find(evs(:,2)==8);
            end
%             if ismember(trial,[269 270]) & str2num(recs{iRec})==5
%                 trial
%                disp('here'); 
%             end
            if Ind_StartOn && Ind_StartOn~=size(evs,1)
                
                n = 22; %number of states sent in preamble
                Events.TrialID(trial) = evs(Ind_StartOn-n+21,2) - 30;   %Added for v7.0, random number stream for aligning target location text file written by labview with recorded data  
                Events.ContinuousTargets(trial) = evs(Ind_StartOn-n+20,2)- 10;  %Added for v7.0
                Events.HighReward(trial) = evs(Ind_StartOn-n+19,2) - 30;   %  Which is the high reward target
                Events.StartTrial(trial) = StartTrial;
                Events.Targ2(trial) = evs(Ind_StartOn-n+18,2) - 10+1; %Added for v4.08
                Events.Separable4T(trial) = evs(Ind_StartOn-n+17,2) - 30+1; %Added for v3.20
                Events.Trial(trial) = tr;
                temp = evs(Ind_StartOn-n+16,2)-10; %Added for v3.17
                Events.AdaptationFeedback(trial) = floor(temp/5);
                Events.AdaptationAction(trial) = mod(temp,5);
                Events.AdaptationPhase(trial) = evs(Ind_StartOn-n+15,2)-30;
                Events.LEDBoard(trial) = evs(Ind_StartOn-n+14,2)-10; %Added for v3.16
                Events.RewardConfig(trial) = evs(Ind_StartOn-n+13,2)-30+1;  %   Which configuration of alternatives
                Events.Choice(trial) = evs(Ind_StartOn-n+12,2) - 10+1;       %  Free or instructed choice

                Events.EyeRewardBlock(trial) = evs(Ind_StartOn-n+11,2) - 30+1;  %  Which mag or prob block encoded - need printout
                Events.HandRewardBlock(trial) = evs(Ind_StartOn-n+10,2) - 10+1;  %  Which mag or prob block encoded - need printout

                Events.RewardTask(trial) = evs(Ind_StartOn-n+9,2) - 30+1;   %  Which type of reward task - simple, 2t, 4t etc
               
                if (~Events.ContinuousTargets(trial)) %Added for v7.0
                    eyetarget = (evs(Ind_StartOn-n+7,2) - 30) * 10 + evs(Ind_StartOn-n+8,2) - 10 + 1;
                    Events.EyeTarget(trial) = eyetarget; %Added for v3.15
                    handtarget = (evs(Ind_StartOn-n+5,2) - 30) * 10 + evs(Ind_StartOn-n+6,2) - 10 + 1;
                    if isReachTrial(Events.TaskCode(trial))
                        Events.Target(trial) = handtarget;
                    else
                        Events.Target(trial) = eyetarget;
                    end
                    Events.ContinuousTarget1(trial) = nan;
                    Events.ContinuousRadius1(trial) = nan;
                    Events.ContinuousTarget2(trial) = nan;
                    Events.ContinuousRadius2(trial) = nan;
                else
                    Events.Target(trial) = nan;
                    Events.ContinuousTarget1(trial) = evs(Ind_StartOn-n+5,2) - 30; % target 1 is always circle, target 2 is always triangle
                    Events.ContinuousRadius1(trial) = evs(Ind_StartOn-n+6,2) - 10;
                    Events.ContinuousTarget2(trial) = evs(Ind_StartOn-n+7,2) - 30;
                    Events.ContinuousRadius2(trial) = evs(Ind_StartOn-n+8,2) - 10;
                end
                
                Events.StartHand(trial) = evs(Ind_StartOn-n+4,2)-10+1;
                Events.StartEye(trial) = evs(Ind_StartOn-n+3,2)-30+1;
                Events.HandCode(trial) = evs(Ind_StartOn-n+2,2)-10;
                Events.Joystick(trial) = evs(Ind_StartOn-n+1,2)-50;
                Events.TaskCode(trial) = evs(Ind_StartOn-n,2)-10;
                
                % Set min time between event and display sensor change
                if Events.LEDBoard(trial)
                    minDisplayTime = 40;
                else
                    minDisplayTime = 100;
                end

                if ~isempty(display_evs) && ~isempty(find(display_evs(:,2)>evs(Ind_StartOn,3)-5, 1))
                    Events.StartOn(trial) = min(display_evs(find(display_evs(:,2)>evs(Ind_StartOn,3)-5),2));
                    if (Events.StartOn(trial) - evs(Ind_StartOn,3)) > minDisplayTime
                        Events.StartOn(trial) = evs(Ind_StartOn,3);
                    end
                else
                    Events.StartOn(trial) = evs(Ind_StartOn,3);
                end
                
                %assigning pulseTimes
                if ~isempty(stim_evs)
                    pulsesOn = stim_evs(1:2:end-1,2);
                    pulsesOff = stim_evs(2:2:end,2);
                    Events.PulseStarts{trial} = pulsesOn;
                    Events.PulseStops{trial} = pulsesOff;
                    if numel(pulsesOn) > 0
                        Events.StartStim(trial) = pulsesOn(1);
                    else
                        Events.StartStim(trial) = Events.StartOn(trial);
                    end
                else
                    Events.PulseStarts{trial} = Events.StartOn(trial);
                    Events.PulseStops{trial} = Events.StartOn(trial);
                    Events.StartStim(trial) = Events.StartOn(trial);
                end
                % Sam logic
%                 if ismember(trial,[269 270]) & str2num(recs{iRec})==5
%                   trial
%                   disp('here'); 
%                 end
                try
                    trial
                    st = RecStartTime + Events.StartTrial(trial);  % Time of trial in ms from start of day
                    [x lv_trial] = min(abs(st-lv_events(:,1)));
                    Events.RewardDur(trial,:) = lv_events(lv_trial,2:5);
                    Events.Delta(trial) = st - lv_events(lv_trial,1);
                    Events.RewardDist(trial,:) = lv_events(lv_trial,6:9);
                    if lv_trial == 1 | size(lv_events,2) < 12 % if it's the first trial or a labview task controller <7.14 is being used 
                        Events.RewardReceived(trial) = nan;
                    else 
                        Events.RewardReceived(trial) = lv_events(lv_trial+1,12);
                    end
                end
                
                %Target location data
                Events.EyeTargetLocation(trial,:) = nan;
                Events.HandTargetLocation(trial,:) = nan;
				try
					st = RecStartTime + Events.StartTrial(trial);  % Time of trial in ms from start of day
					[x lv_trial] = min(abs(st-lv_target(:,1)));
					if (~Events.ContinuousTargets(trial))
						Events.EyeTargetLocation(trial,:) = lv_target(lv_trial,4:5);
						Events.HandTargetLocation(trial,:) = lv_target(lv_trial,2:3);
						
						Events.ContinuousTarget1Cood(trial) = nan;
						Events.ContinuousTarget2Cood(trial) = nan;
						
					else
						
						Events.EyeTargetLocation(trial,:) = nan;
						Events.HandTargetLocation(trial,:) = nan;
						if Events.Choice(trial)==2
							Events.ContinuousTarget1Cood(trial,:) = lv_target(lv_trial,6:7);
							Events.ContinuousTarget2Cood(trial,:) = lv_target(lv_trial,8:9);
						else
							Events.ContinuousTarget1Cood(trial,:) = lv_target(lv_trial,4:5);
							Events.ContinuousTarget2Cood(trial,:) = lv_target(lv_trial,2:3);
						end
						
					end
					Events.TargetDelta(trial) = st - lv_target(lv_trial,1);
					if size(lv_target,2)>12 % task controller version 7.15 and higher
                       Events.TargetDimming(trial) = lv_target(lv_trial,13); 
                    end
					
					
				end
				
				%                     % We'd better be syunchronized within 10 seconds!
				%                     if abs(Events.TargetDelta(trial)) > 10000
				%                         Events.EyeTargetLocation(trial,:) = nan;
%                         Events.HandTargetLocation(trial,:) = nan;
%                     end
                end

                %Acquire time data
                try
                    st = RecStartTime + Events.StartTrial(trial);  % Time of trial in ms from start of day
                    [x lv_trial] = min(abs(st-lv_acquire(:,1)));
                    Events.MinReachRT(trial,:) = lv_acquire(lv_trial,2);
                    Events.MaxReachRT(trial,:) = lv_acquire(lv_trial,3);
                    Events.MinReachAq(trial,:) = lv_acquire(lv_trial,4);
                    Events.MaxReachAq(trial,:) = lv_acquire(lv_trial,5);
                    Events.MinSaccadeRT(trial,:) = lv_acquire(lv_trial,6);
                    Events.MaxSaccadeRT(trial,:) = lv_acquire(lv_trial,7);
                    Events.MinSaccadeAq(trial,:) = lv_acquire(lv_trial,8);
                    Events.MaxSaccadeAq(trial,:) = lv_acquire(lv_trial,9);
                    Events.MinSaccade2RT(trial,:) = lv_acquire(lv_trial,10);
                    Events.MaxSaccade2RT(trial,:) = lv_acquire(lv_trial,11);
                    Events.MinSaccade2Aq(trial,:) = lv_acquire(lv_trial,12);
                    Events.MaxSaccade2Aq(trial,:) = lv_acquire(lv_trial,13);
                end

                if find(evs(Ind_StartOn:end,2)==2);
                    index = find(evs(Ind_StartOn:end,2)==2);
                    Events.StartAq(trial) = evs(index(1)+Ind_StartOn-1,3);
                else
                    Events.StartAq(trial) = nan;
                end
                
                
                %Target location data - this is redundant with EyeTargetLocation and HandTargetLocation
                Events.T1T2Locations(trial,1:2,1:2) = nan;
                Events.T1T2Delta(trial,1:2) = nan;
                try
                    st = RecStartTime + Events.StartTrial(trial);  % Time of trial in ms from start of day
                     [x lv_trial] = min(abs(st-lv_target(:,1)));
                     
                     % recStartTimeVals = [ recStartTimeVals; st ];
                     % startOnTimeVals = [ startOnTimeVals; Events.StartOn(trial) ];
                     % minTimeVals = [minTimeVals x];
                     
%                     tOffset = lv_target(:,1)-st;
%                     tOffset(find(tOffset<0)) = Inf;
%                     [x lv_trial] = min(tOffset);
                    % [ x tOffset(lv_trial) ]
                    
                    Events.T1T2Locations(trial,:,:) = [lv_target(lv_trial,6:7); lv_target(lv_trial,8:9) ];
                    
%                     if lv_trial>200 % 500
%                         Events.Success(trial)
%                         Events.RewardTask(trial)
%                         disp('---');
%                         pause;
%                     end
                    
%                     if Events.RewardTask(trial)==9
%                         
%                     figure(1); hold on;
%                     plot(lv_target(lv_trial,6),lv_target(lv_trial,7),'ro');
%                     plot(lv_target(lv_trial,8),lv_target(lv_trial,9),'g+');
%                     
%                     T1T2 = squeeze(Events.T1T2Locations(trial,:,:));
%                     T1_x = T1T2(1,1);
%                     T1_y = T1T2(1,2);
%                     T2_x = T1T2(2,1);
%                     T2_y = T1T2(2,2);
%                     
%                     plot(T1_x,T1_y,'ko');
%                     plot(T2_x,T2_y,'b+');
%                     
%                     axis([-15 15 -15 15]);
%                     pause;
%                     clf;
%                     end
                    
                    Events.T1T2Delta(trial) = st - lv_target(lv_trial,1);
                    
                    try
                      Events.TargetScale(trial) = lv_target(lv_trial,12);
                      Events.Target2Scale(trial) = lv_target(lv_trial,13);
                    end
                end
                
                %Brightness  data
                try
                    st = RecStartTime + Events.StartTrial(trial);  % Time of trial in ms from start of day
                    [x lv_trial] = min(abs(st-lv_bright(:,1)));
                    Events.BrightVals(trial,:) = [lv_bright(lv_trial,2) lv_bright(lv_trial,3)]/100;
                    Events.BrightDist(trial,:) = [lv_bright(lv_trial,4) lv_bright(lv_trial,5) lv_bright(lv_trial,6) lv_bright(lv_trial,7)]/100;
                end
                
                %STIM data
                 try
                    st = RecStartTime + Events.StartTrial(trial);  % Time of trial in ms from start of day
                    [x lv_trial] = min(abs(st-lv_stim(:,1)));
                    Events.StimType(trial,:) = lv_stim(lv_trial,2);
                    %code for trial type:
                    %first digit (hundreds place): 3-closed, 2-poiss, 1-no stim
                    %second digit (tens): 1-freq band 1, 2-freq band 2
                    %third digit (ones): 1-phase, 2-(phase - pi)
                end
               
                % Assigning Targets On
                if find(evs(Ind_StartOn:end,2)==3)
                    index = find(evs(Ind_StartOn:end,2)==3);
                    if ~isempty(display_evs) && ~isempty(find(display_evs(:,2)>evs(index(1)+Ind_StartOn-1,3)-5, 1))
                        Events.TargsOn(trial) = min(display_evs(find(display_evs(:,2)>evs(index(1)+Ind_StartOn-1,3)-5),2));
                        if (Events.TargsOn(trial) - evs(index(1)+Ind_StartOn-1,3)) > minDisplayTime
                            Events.TargsOn(trial) = evs(index(1)+Ind_StartOn-1,3);
                        end
                    else
                        Events.TargsOn(trial) = evs(index(1)+Ind_StartOn-1,3);
                    end
                    Events.Go(trial) = Events.TargsOn(trial);
                    Events.ReachGo(trial) = Events.TargsOn(trial);
                    Events.SaccadeGo(trial) = Events.TargsOn(trial);
                else
                    Events.TargsOn(trial) = nan;
                    Events.ReachGo(trial) = nan;
                    Events.SaccadeGo(trial) = nan;
                end
                
                if find(evs(Ind_StartOn:end,2)==16)
                    index = find(evs(Ind_StartOn:end,2)==16);
                    if ~isempty(display_evs) && ~isempty(find(display_evs(:,2)>evs(index(1)+Ind_StartOn-1,3)-5, 1))
                        Events.Targ2On(trial) = min(display_evs(find(display_evs(:,2)>evs(index(1)+Ind_StartOn-1,3)-5),2));
                        if (Events.Targ2On(trial) - evs(index(1)+Ind_StartOn-1,3)) > minDisplayTime
                            Events.Targ2On(trial) = evs(index(1)+Ind_StartOn-1,3);
                        end
                   else
                         Events.Targ2On(trial) = evs(index(1)+Ind_StartOn-1,3);
                    end
                else
                    Events.Targ2On(trial) = nan;
                end
              
                % Instructions
                if find(evs(Ind_StartOn:end,2)==6)
                    index = find(evs(Ind_StartOn:end,2)==6);
                    if ~isempty(display_evs) && ~isempty(find(display_evs(:,2)>evs(index(1)+Ind_StartOn-1,3)-5, 1))
                        Events.InstOn(trial) = min(display_evs(find(display_evs(:,2)>evs(index(1)+Ind_StartOn-1,3)-5),2));
                        if (Events.InstOn(trial) - evs(index(1)+Ind_StartOn-1,3)) > minDisplayTime
                            Events.InstOn(trial) = evs(index(1)+Ind_StartOn-1,3);
                        end
                    else
                        Events.InstOn(trial) = evs(index(1)+Ind_StartOn-1,3);
                    end
                else
                    Events.InstOn(trial) = nan;
                end
                
                if find(evs(Ind_StartOn:end,2)==15)
                    index = find(evs(Ind_StartOn:end,2)==15);
                    if ~isempty(display_evs) && ~isempty(find(display_evs(:,2)>evs(index(1)+Ind_StartOn-1,3)-5, 1))
                        Events.EffInstOn(trial) = min(display_evs(find(display_evs(:,2)>evs(index(1)+Ind_StartOn-1,3)-5),2));
                        if (Events.EffInstOn(trial) - evs(index(1)+Ind_StartOn-1,3)) > minDisplayTime
                            Events.EffInstOn(trial) = evs(index(1)+Ind_StartOn-1,3);
                        end
                    else
                        Events.EffInstOn(trial) = evs(index(1)+Ind_StartOn-1,3);
                    end
                else
                    Events.EffInstOn(trial) = nan;
                end
                                

                % Go times
                if find(evs(Ind_StartOn:end,2)==12)
                    index = find(evs(Ind_StartOn:end,2)==12);
                    if ~isempty(display_evs) && ~isempty(find(display_evs(:,2)>evs(index(1)+Ind_StartOn-1,3)-5, 1))
                        Events.SaccadeGo(trial) = min(display_evs(find(display_evs(:,2)>evs(index(1)+Ind_StartOn-1,3)-5),2));
                        if (Events.SaccadeGo(trial) - evs(index(1)+Ind_StartOn-1,3)) > minDisplayTime
                            Events.SaccadeGo(trial) = evs(index(1)+Ind_StartOn-1,3);
                        end
                    else
                        Events.SaccadeGo(trial) = evs(index(1)+Ind_StartOn-1,3);
                    end
                    Events.Go(trial) = Events.SaccadeGo(trial);
                    Events.ReachGo(trial) = Events.SaccadeGo(trial);
                end
                
                if find(evs(Ind_StartOn:end,2)==11)
                    index = find(evs(Ind_StartOn:end,2)==11);
                    if ~isempty(display_evs) && ~isempty(find(display_evs(:,2)>evs(index(1)+Ind_StartOn-1,3)-5, 1))
                        Events.ReachGo(trial) = min(display_evs(find(display_evs(:,2)>evs(index(1)+Ind_StartOn-1,3)-5),2));
                        if (Events.ReachGo(trial) - evs(index(1)+Ind_StartOn-1,3)) > minDisplayTime
                            Events.ReachGo(trial) = evs(index(1)+Ind_StartOn-1,3);
                        end
                    else
                         Events.ReachGo(trial) = evs(index(1)+Ind_StartOn-1,3);
                    end
                    if Events.TaskCode(trial) == 21 || Events.TaskCode(trial) == 22 %We use auditory cues for SOA reach go
                        Events.ReachGo(trial) = evs(index(1)+Ind_StartOn-1,3);
                        if Events.ReachGo(trial) - Events.SaccadeGo(trial) < 0
                            Events.ReachGo(trial) = Events.SaccadeGo(trial);
                        end
                    end
                    Events.Go(trial) = Events.ReachGo(trial);
                end
                
                if find(evs(Ind_StartOn:end,2)==4)
                    index = find(evs(Ind_StartOn:end,2)==4);
                    if ~isempty(display_evs) && ~isempty(find(display_evs(:,2)>evs(index(1)+Ind_StartOn-1,3)-5, 1))
                        Events.Go(trial) = min(display_evs(find(display_evs(:,2)>evs(index(1)+Ind_StartOn-1,3)-5),2));
                        if (Events.Go(trial) - evs(index(1)+Ind_StartOn-1,3)) > minDisplayTime
                            Events.Go(trial) = evs(index(1)+Ind_StartOn-1,3);
                        end
                    else
                        Events.Go(trial) = evs(index(1)+Ind_StartOn-1,3);
                    end
                    if Events.ReachGo(trial) == 0 || Events.ReachGo(trial) == Events.TargsOn(trial)
                        Events.ReachGo(trial) = Events.Go(trial);
                    end
                    if Events.SaccadeGo(trial) == 0 || Events.SaccadeGo(trial) == Events.TargsOn(trial)
                        Events.SaccadeGo(trial) = Events.Go(trial);
                    end
                    if ~isempty(display_evs) && ~isempty(find(display_evs(:,2)>evs(index(1)+Ind_StartOn-1,3)-5, 1)) && (Events.TaskCode(trial) == 11) %detects the LED change during DS adaptation
                        Events.TargMove(trial) = min(display_evs(find(display_evs(:,2)>evs(index(1)+Ind_StartOn-1,3)-5),2));
                    else
                        Events.TargMove(trial) = nan;                        
                    end
                    if isnan(Events.Targ2On(trial)) && Events.TaskCode(trial)>41  %for DST2DRS an DRS2DST, Intervening=0;
                        Events.Targ2On(trial) = Events.Go(trial);
                    end
                end


                % Acquire times
                if find(evs(Ind_StartOn:end,2)==5);
                    index = find(evs(Ind_StartOn:end,2)==5);
                    Events.TargAq(trial) = evs(index(1)+Ind_StartOn-1,3);
                end

                if find(evs(Ind_StartOn:end,2)==14);
                    index = find(evs(Ind_StartOn:end,2)==14);
                    Events.SaccadeAq(trial) = evs(index(1)+Ind_StartOn-1,3);
                else
                    Events.SaccadeAq(trial) = Events.TargAq(trial);
                end

                if find(evs(Ind_StartOn:end,2)==13);
                    index = find(evs(Ind_StartOn:end,2)==13);
                    Events.ReachAq(trial) = evs(index(1)+Ind_StartOn-1,3);
                else
                    Events.ReachAq(trial) = Events.TargAq(trial);
                end

                
                if find(evs(Ind_StartOn:end,2)==9);
                    index = find(evs(Ind_StartOn:end,2)==9);
                    if ~isempty(display_evs) && ~isempty(find(display_evs(:,2)>evs(index(1)+Ind_StartOn-1,3)-5, 1))
                        Events.TargetOff(trial) = min(display_evs(find(display_evs(:,2)>evs(index(1)+Ind_StartOn-1,3)-5),2));
                        if (Events.TargetOff(trial) - evs(index(1)+Ind_StartOn-1,3)) > minDisplayTime
                            Events.TargetOff(trial) = evs(index(1)+Ind_StartOn-1,3);
                        end
                    else
                        Events.TargetOff(trial) = evs(index(1),3);
                    end
                else
                    Events.TargetOff(trial) = nan;
                end

                if find(evs(Ind_StartOn:end,2)==10)  %Only for Memory trials
                    index = find(evs(Ind_StartOn:end,2)==10);
                    if ~isempty(display_evs) && ~isempty(find(display_evs(:,2)>evs(index(1)+Ind_StartOn-1,3)-5, 1))
                        Events.TargetRet(trial) = min(display_evs(find(display_evs(:,2)>evs(index(1)+Ind_StartOn-1,3)-5),2));
                        if (Events.TargetRet(trial) - evs(index(1)+Ind_StartOn-1,3)) > minDisplayTime
                            Events.TargetRet(trial) = evs(index(1)+Ind_StartOn-1,3);
                        end
                    else
                        Events.TargetRet(trial) = evs(index(1)+Ind_StartOn-1,3);
                    end
                else
                    Events.TargetRet(trial) = nan;
                end

                %  Success or fail trial
                Ind_Success = find(evs(:,2)==7);
                Ind_Fail = find(evs(:,2)==8);

                if length(Ind_Success) == 1 && isempty(Ind_Fail)
                    Events.End(trial) = evs(Ind_Success,3);
                    Events.Success(trial) = 1;
                    Events.AbortState(trial) = 0;
                elseif length(Ind_Fail) == 1 && isempty(Ind_Success)
                    Events.End(trial) = evs(Ind_Fail,3);
                    Events.Success(trial) = 0;
                    Events.AbortState(trial) = evs(Ind_Fail-1,2);
                else
                    Events.Success(trial) = 0;
                    evs;
                    disp('Success/error failure')
                    %pause
                end
                
                %  Process movement information
                Events.Saccade(trial) = isSaccadeTrial(Events.TaskCode(trial));
                Events.Reach(trial) = isReachTrial(Events.TaskCode(trial));
                Events.DoubleStep(trial) = isDoubleStepTrial(Events.TaskCode(trial));

                if Events.Reach(trial) &&  (Events.ReachGo(trial)>0 || Events.Go(trial)>0)
                    fid = fopen(['rec' recs{iRec} '.hnd.dat'],'r');
                    if Events.ReachGo(trial) > 0
                        start = Events.ReachGo(trial) - 1;
                    else
                        start = Events.Go(trial) - 1;
                    end
                    if Events.ReachAq(trial)>0
                        stop = Events.ReachAq(trial) + 200;
                    elseif Events.TargAq(trial)>0
                        stop = Events.TargAq(trial) + 200;
                    else
                        stop = Events.End(trial) + 300;
                    end
                    fseek(fid,2*2*start,'bof');
                    stop - start;
                    hnd = fread(fid,[2,stop-start],format);
                    fclose(fid);
                    %plot(hnd(1,:)); hold on; plot(hnd(2,:),'r'); hold off
                    reaching = find(hnd(1,:) < 100);
                    if ~isempty(reaching)
                        Events.ReachStart(trial) = reaching(1) + start;
                        %  Reassign reach acquire
                        Events.ReachStop(trial) = reaching(end) + start;
                        %                         if isReachTrial(Events.TaskCode(trial))
                        %                             Events.TargAq(trial) = reaching(end)+start;
                        %                         elseif Events.ReachGo(trial)>0
                        Events.ReachAq(trial) = reaching(end) + start;
                        %                         end
                    end
                end

            end             %  End if not trial fragment
        end                 %  End for loop over trials
        if saveflag
            disp('Saving Events file');
            save(['rec' recs{iRec} '.Events.mat'],'Events');
        end
    end
end

% [ startOnTimeVals(1:20,1) targetTimestamps(1:20,1) ]
% figure(1); plot(minTimeVals); axis square;


