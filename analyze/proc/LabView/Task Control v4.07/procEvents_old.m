function Events = procEvents(day, rec, saveflag)
%  PROCEVENTS converts file.ev.txt to Events data structure
%     for Reach Search task v7
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

global MONKEYDIR

try
    [blah monkey] = fileparts(MONKEYDIR);
    try
        lv_events = dlmread(fullfile(MONKEYDIR,day,'Labview',[day,'.reward.txt']));
    catch
        lv_events = dlmread(fullfile(MONKEYDIR,day,'Labview',[day,'.txt']));    %old naming convention
    end
    lv_events(1,:) = [];
    lv_st = lv_events(:,1);
    for i = 1:length(lv_st);
        z = num2str(lv_st(i));
        while length(z)<6; z = ['0',z]; end
        z1 = str2num(z(1:2)); z2 = str2num(z(3:4)); z3 = str2num(z(5:6));
        lv_events(i,1) = z1*60*60*1000 + z2*60*1000 + z3*1000;
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

    %RECORDING START TIME in ms
    hrs = Rec.StartTime(4)*60*60*1000;
    mins = Rec.StartTime(5)*60*1000;
    secs = Rec.StartTime(6)*1000;
    RecStartTime = hrs + mins + secs;

    clear Events
    if length(events)
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
        Events.StartHand = zeros(ntr,1);    %  Initial hand location code
        Events.StartEye = zeros(ntr,1);     %  Initial eye location code

        Events.RewardConfig = zeros(ntr,1);
        Events.Choice = zeros(ntr,1);
        Events.EyeRewardBlock = zeros(ntr,1);
        Events.HandRewardBlock = zeros(ntr,1);
        Events.RewardTask = zeros(ntr,1);

        Events.ReachStart = zeros(ntr,1);   %  Time reach started
        Events.ReachStop = zeros(ntr,1);    %  Time reach stopped
        Events.SaccStart = zeros(ntr,1);    %  Time saccade started
        Events.SaccStop = zeros(ntr,1);     %  Time saccade finished

        Events.TargMove = zeros(ntr,1);     %  Time target is moved during adaptation

        Events.Reach = zeros(ntr,1);        %  Is Reach trial
        Events.Saccade = zeros(ntr,1);        %  Is Saccade trial

        Events.AdaptationFeedback = zeros(ntr,1);
        Events.AdaptationAction = zeros(ntr,1);
        Events.AdaptationPhase = zeros(ntr,1);
        Events.LEDBoard = zeros(ntr,1);

        %        Events.SaccBegin = zeros(ntr,20,2); %  Nth saccade beginning location
        %        Events.SaccEnd = zeros(ntr,20,2);   %  Nth saccade end location
        %        Events.NumSacc = zeros(ntr,1);      %  Number of saccades

        %        Events.NumLRSacc = zeros(ntr,1);      %  Number of LR saccades
        %        Events.LRSaccStart = zeros(ntr,1);   %  Time nth LR saccade started
        %        Events.LRSaccStop = zeros(ntr,1);    %  Time nth LR saccade finished
        %        Events.LRSaccBegin = zeros(ntr,2); %  Nth LR saccade beginning location
        %        Events.LRSaccEnd = zeros(ntr,2);   %  Nth LR saccade end location

        Events.Success = zeros(ntr,1);      %  Success variable
        Events.AbortState = zeros(ntr,1);      %  State number when abort
        Events.End = zeros(ntr,1);          %  Time of trial end

        trial = 0;
        %     min(events(:,1))
        %     max(events(:,1))
        %     pause
        for tr = min(events(:,1))+1:max(events(:,1))-1  %  Skip first and
            %  last trials
            trial = trial+1;
            disp(['Trial ' num2str(trial)]);
            evs = events(find(events(:,1)==tr),:);
            if ~isempty(display_events)
                display_evs = display_events(find(display_events(:,1)==tr),:);
            else
                display_evs=[];
            end

            Ind_StartOn = find(evs(:,2)==1);

            if Ind_StartOn & Ind_StartOn~=size(evs,1)
                Events.Separable4T(trial) = evs(Ind_StartOn-1,2) - 30+1; %Added for v3.20
                Events.Trial(trial) = tr;
                temp = evs(Ind_StartOn-2,2)-10; %Added for v3.17
                Events.AdaptationFeedback(trial) = floor(temp/5);
                Events.AdaptationAction(trial) = mod(temp,5);
                Events.AdaptationPhase(trial) = evs(Ind_StartOn-3,2)-30;
                Events.LEDBoard(trial) = evs(Ind_StartOn-4,2)-10; %Added for v3.16
                Events.RewardConfig(trial) = evs(Ind_StartOn-5,2)-30+1;  %   Which configuration of alternatives
                Events.Choice(trial) = evs(Ind_StartOn-6,2) - 10+1;       %  Free or instructed choice

                Events.EyeRewardBlock(trial) = evs(Ind_StartOn-7,2) - 30+1;  %  Which mag or prob block encoded - need printout
                Events.HandRewardBlock(trial) = evs(Ind_StartOn-8,2) - 10+1;  %  Which mag or prob block encoded - need printout

                Events.RewardTask(trial) = evs(Ind_StartOn-9,2) - 30+1;   %  Which type of reward task - simple, 2t, 4t etc
                eyetarget = (evs(Ind_StartOn-11,2) - 30) * 10 + evs(Ind_StartOn-10,2) - 10 + 1;
                Events.EyeTarget(trial) = eyetarget; %Added for v3.15
                handtarget = (evs(Ind_StartOn-13,2) - 30) * 10 + evs(Ind_StartOn-12,2) - 10 + 1;
                Events.Target(trial) = handtarget;

                Events.StartHand(trial) = evs(Ind_StartOn-14,2)-10+1;
                Events.StartEye(trial) = evs(Ind_StartOn-15,2)-30+1;
                Events.HandCode(trial) = evs(Ind_StartOn-16,2)-10;
                Events.Joystick(trial) = evs(Ind_StartOn-17,2)-50;
                Events.TaskCode(trial) = evs(Ind_StartOn-18,2)-10;

                if length(display_evs)
                    if min(display_evs(find(display_evs(:,2)>evs(Ind_StartOn,3)),2)) - evs(Ind_StartOn,3) < 200
                        Events.StartOn(trial) = min(display_evs(find(display_evs(:,2)>evs(Ind_StartOn,3)-5),2));
                        display_evs = display_evs(2:end,:);
                    else
                        Events.StartOn(trial) = evs(Ind_StartOn,3);
                    end
                else
                    Events.StartOn(trial) = evs(Ind_StartOn,3);
                end

                % Set min time between event and display sensor change
                if Events.LEDBoard(trial)
                    minDisplayTime = 100;
                else
                    minDisplayTime = 40;
                end

                % Sam logic
                try
                    st = RecStartTime + Events.StartOn(trial);  % Time of trial in ms from start of day
                    [x lv_trial] = min(abs(st-lv_events(:,1)));
                    Events.RewardDur(trial,:) = lv_events(lv_trial,2:5);
                    Events.Delta(trial) = st - lv_events(lv_trial,1);
                end

                if find(evs(Ind_StartOn:end,2)==2);
                    index = find(evs(:,2)==2);
                    Events.StartAq(trial) = evs(index(1),3);
                end

                % Assigning Targets On
                if find(evs(Ind_StartOn:end,2)==3)
                    index = find(evs(:,2)==3);
                    if length(display_evs)
                        if min(display_evs(find(display_evs(:,2)>evs(index(1),3)),2)) - evs(index(1),3) < 200
                            Events.TargsOn(trial) = min(display_evs(find(display_evs(:,2)>evs(index(1),3)-5),2));
                            display_evs = display_evs(2:end,:);
                        else
                            Events.TargsOn(trial) = evs(index(1),3);
                        end
                    else
                        Events.TargsOn(trial) = evs(index(1),3);
                    end
                end


                if find(evs(Ind_StartOn:end,2)==15)
                    if length(display_evs)
                        index = find(evs(:,2)==15);
                        Events.EffInstOn(trial) = min(display_evs(find(display_evs(:,2)>evs(index(1),3)-5),2));
                        display_evs = display_evs(2:end,:);
                    else
                        index = find(evs(:,2)==15);
                        Events.EffInstOn(trial) = evs(index(1),3);
                    end
                end


                if find(evs(Ind_StartOn:end,2)==6)
                    if length(display_evs)
                        index = find(evs(:,2)==6);
                        Events.InstOn(trial) = min(display_evs(find(display_evs(:,2)>evs(index(1),3)-5),2));
                        display_evs = display_evs(2:end,:);
                    else
                        index = find(evs(:,2)==6);
                        Events.InstOn(trial) = evs(index(1),3);
                    end
                end


                if find(evs(Ind_StartOn:end,2)==4)
                    index = find(evs(:,2)==4);
                    if length(display_evs)
                        if min(display_evs(find(display_evs(:,2)>evs(index(1),3)),2)) - evs(index(1),3) < 200
                            Events.Go(trial) = min(display_evs(find(display_evs(:,2)>evs(index(1),3)-5),2));
                            display_evs = display_evs(2:end,:);
                        else
                            Events.Go(trial) = evs(index(1),3);
                        end
                    else
                        Events.Go(trial) = evs(index(1),3);
                    end
                    if length(display_evs) & (Events.TaskCode(trial) == 11) %detects the LED change during DS adaptation
                        Events.TargMove(trial) = min(display_evs(find(display_evs(:,2)>evs(index(1),3)-5),2));
                    end
                end

                if find(evs(Ind_StartOn:end,2)==5);
                    index = find(evs(:,2)==5);
                    Events.TargAq(trial) = evs(index(1),3);
                end


                if find(evs(Ind_StartOn:end,2)==9);
                    if length(display_evs) && Events.LEDBoard(trial)==1
                        index = find(evs(:,2)==9);
                        Events.TargetOff(trial) = min(display_evs(find(display_evs(:,2)>evs(index(1),3)-5),2));
                        display_evs = display_evs(2:end,:);
                    else
                        index = find(evs(:,2)==9);
                        Events.TargetOff(trial) = evs(index(1),3);
                    end
                end

                %---------------Specific to trial type---------------------------
                if Events.TaskCode(trial) == 20%%  Saccade then Reach task
                    if find(evs(Ind_StartOn:end,2)==12)
                        if length(display_evs)
                            index = find(evs(Ind_StartOn:end,2)==12);
                            Events.SaccadeGo(trial) = min(display_evs(find(display_evs(:,2)>evs(index(1)+Ind_StartOn-1,3)-5),2));
                            display_evs = display_evs(2:end,:);
                        else
                            index = find(evs(Ind_StartOn:end,2)==12);
                            Events.SaccadeGo(trial) = evs(index(1)+Ind_StartOn-1,3);
                        end
                    end

                    if find(evs(Ind_StartOn:end,2)==11)
%                         if length(display_evs)
%                             index = find(evs(Ind_StartOn:end,2)==11);
%                             Events.ReachGo(trial) = min(display_evs(find(display_evs(:,2)>evs(index(1)+Ind_StartOn-1,3)-5),2));
%                             display_evs = display_evs(2:end,:);
%                         else
                            index = find(evs(Ind_StartOn:end,2)==11);
                            Events.ReachGo(trial) = evs(index(1)+Ind_StartOn-1,3);
%                         end
                    end

                elseif Events.TaskCode(trial) == 19%% Reach then saccade task
                    if find(evs(Ind_StartOn:end,2)==11)
                        if length(display_evs)
                            index = find(evs(Ind_StartOn:end,2)==11);
                            Events.ReachGo(trial) = min(display_evs(find(display_evs(:,2)>evs(index(1)+Ind_StartOn-1,3)-5),2));
                            display_evs = display_evs(2:end,:);
                        else
                            index = find(evs(Ind_StartOn:end,2)==11);
                            Events.ReachGo(trial) = evs(index(1)+Ind_StartOn-1,3);
                        end
                    end

                    if find(evs(Ind_StartOn:end,2)==12)
                        if length(display_evs)
                            index = find(evs(Ind_StartOn:end,2)==12);
                            Events.SaccadeGo(trial) = min(display_evs(find(display_evs(:,2)>evs(index(1)+Ind_StartOn-1,3)-5),2));
                            display_evs = display_evs(2:end,:);
                        else
                            index = find(evs(Ind_StartOn:end,2)==12);
                            Events.SaccadeGo(trial) = evs(index(1)+Ind_StartOn-1,3);
                        end
                    end

                elseif Events.TaskCode(trial) == 21  || Events.TaskCode(trial) == 22 %% TOA task
                    if find(evs(Ind_StartOn:end,2)==12) & isempty(find(evs(Ind_StartOn:end,2)==11))
                        %  When there is a Saccade Go but no Reach Go.  ie TOA = 0;
                        if length(display_evs)
                            index = find(evs(Ind_StartOn:end,2)==12);
                            Events.SaccadeGo(trial) = min(display_evs(find(display_evs(:,2)>evs(index(1)+Ind_StartOn-1,3)-5),2));
                            if (Events.SaccadeGo(trial) - evs(index(1)+Ind_StartOn-1,3)) > minDisplayTime
                                Events.SaccadeGo(trial) = evs(index(1)+Ind_StartOn-1,3);
                            else
                                display_evs = display_evs(2:end,:);
                            end
                            Events.ReachGo(trial) = Events.SaccadeGo(trial);
                        else
                            index = find(evs(Ind_StartOn:end,2)==12);
                            Events.SaccadeGo(trial) = evs(index(1)+Ind_StartOn-1,3);
                            Events.ReachGo(trial) = Events.SaccadeGo(trial);
                        end
                    elseif find(evs(Ind_StartOn:end,2)==12) & find(evs(Ind_StartOn:end,2)==11)
                        %  When there is a Saccade Go and a Reach Go.  ie TOA > 0;
                        if length(display_evs)
                            index = find(evs(Ind_StartOn:end,2)==12);
                            Events.SaccadeGo(trial) = min(display_evs(find(display_evs(:,2)>evs(index(1)+Ind_StartOn-1,3)-5),2));
                            if (Events.SaccadeGo(trial) - evs(index(1)+Ind_StartOn-1,3)) > minDisplayTime
                                Events.SaccadeGo(trial) = evs(index(1)+Ind_StartOn-1,3);
                            else
                                display_evs = display_evs(2:end,:);
                            end
                            index = find(evs(Ind_StartOn:end,2)==11);
                            if find(display_evs(:,2)>evs(index(1)+Ind_StartOn-1,3))
                                Events.ReachGo(trial) = min(display_evs(find(display_evs(:,2)>evs(index(1)+Ind_StartOn-1,3)-5),2));
                            else
                                Events.ReachGo(trial) = evs(index(1)+Ind_StartOn-1,3);
                            end
                            if (Events.ReachGo(trial) - evs(index(1)+Ind_StartOn-1,3)) > minDisplayTime
                                Events.ReachGo(trial) = evs(index(1)+Ind_StartOn-1,3);
                            else
                                display_evs = display_evs(2:end,:);
                            end
                        else
                            index = find(evs(Ind_StartOn:end,2)==12);
                            Events.SaccadeGo(trial) = evs(index(1)+Ind_StartOn-1,3);
                            index = find(evs(Ind_StartOn:end,2)==11);
                            Events.ReachGo(trial) = evs(index(1)+Ind_StartOn-1,3);
                        end
                    end
                end
                %---------------End specific to trial type---------------------------

                if find(evs(Ind_StartOn:end,2)==10)  %Only for Memory trials
                    if length(display_evs)
                        index = find(evs(Ind_StartOn:end,2)==10);
                        Events.TargetRet(trial) = min(display_evs(find(display_evs(:,2)>evs(index(1)+Ind_StartOn-1,3)-5),2));
                        display_evs = display_evs(2:end,:);
                    else
                        index = find(evs(Ind_StartOn:end,2)==10);
                        Events.TargetRet(trial) = evs(index(1)+Ind_StartOn-1,3);
                    end
                end

                if find(evs(Ind_StartOn:end,2)==14);
                    index = find(evs(Ind_StartOn:end,2)==14);
                    Events.SaccadeAq(trial) = evs(index(1)+Ind_StartOn-1,3);
                    %pause
                else
                    Events.SaccadeAq(trial) = Events.TargAq(trial);
                    %pause
                end

                if find(evs(Ind_StartOn:end,2)==13);
                    index = find(evs(Ind_StartOn:end,2)==13);
                    Events.ReachAq(trial) = evs(index(1)+Ind_StartOn-1,3);
                else
                    Events.ReachAq(trial) = Events.TargAq(trial);
                end

                %  Success or fail trial
                Ind_Success = find(evs(:,2)==7);
                Ind_Fail = find(evs(:,2)==8);
                


                if length(Ind_Success) == 1 & length(Ind_Fail)==0
                    Events.End(trial) = evs(Ind_Success,3);
                    Events.Success(trial) = 1;
                    Events.AbortState(trial) = 0;
                elseif length(Ind_Fail) == 1 & length(Ind_Success)==0
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
                if (isReachTrial(Events.TaskCode(trial)) | Events.ReachGo(trial)>0) & Events.Success(trial)
                    fid = fopen(['rec' recs{iRec} '.hnd.dat'],'r');
                    if Events.ReachGo(trial)>0
                        start = Events.ReachGo(trial)-100;
                    else
                        start = Events.Go(trial)-100;
                    end
                    if Events.ReachAq(trial)>0
                        stop = Events.ReachAq(trial)+200;
                    else
                        stop = Events.TargAq(trial)+200;
                    end
                    fseek(fid,2*2*start,'bof');
                    stop-start;
                    hnd = fread(fid,[2,stop-start],format);
                    fclose(fid);
                    %plot(hnd(1,:)); hold on; plot(hnd(2,:),'r'); hold off
                    reaching = find(hnd(1,:) < 100);
                    if length(reaching)
                        Events.ReachStart(trial) = reaching(1)+start;
                        %  Reassign reach acquire
                        Events.ReachStop(trial) = reaching(end)+start;
                        if isReachTrial(Events.TaskCode(trial))
                            Events.TargAq(trial) = reaching(end)+start;
                        elseif Events.ReachGo(trial)>0
                            Events.ReachAq(trial) = reaching(end)+start;
                        end
                    end
                end
                Events.Saccade(trial) = isSaccadeTrial(Events.TaskCode(trial));
                Events.Reach(trial) = isReachTrial(Events.TaskCode(trial));
                if isSaccadeTrial(Events.TaskCode(trial)) && Events.Success(trial)
                    if Events.SaccadeGo(trial)>0
                        start = Events.SaccadeGo(trial)-100;
                    else
                        start = Events.Go(trial)-100;
                    end
                    if Events.SaccadeAq(trial)>0
                        stop = Events.SaccadeAq(trial)+200;
                    else
                        stop = Events.TargAq(trial)+200;
                    end
                    fid = fopen(['rec' recs{iRec} '.eye.dat'],'r');
                    fseek(fid,2*2*start,'bof');  %4b=2short=1floatingpoint  %2channels
                    ey = fread(fid,[2,stop-start],format);
                    fclose(fid);

                    [b,g]=sgolay(5,51);
                    sy = filter(g(:,2),1,ey').*1e3;
                    vel = sqrt(sum(sy'.^2));
                    vel(1:50) = vel(51);
                    [s,sac] = max(vel);
                    a = find(vel(max([1,sac-100]):sac) > 200);
                    if isempty(a)
                        a = find(vel(max([1,sac-100]):sac) > 150);
                    end
                    Events.SaccStart(trial) = start + max([1,sac-100])+ min(a);
                    a = find(vel(sac:min([end,sac+100])) > 200);
                    if isempty(a)
                        a = find(vel(sac:min([end,sac+100])) > 150);
                    end

                    Events.SaccStop(trial) = start + sac + max(a);
                end

                %pause
            end             %  End if not trial fragment
        end                 %  End for loop over trials
        if saveflag
            disp('Saving Events file');
            save(['rec' recs{iRec} '.Events.mat'],'Events');
        end
    end
end
