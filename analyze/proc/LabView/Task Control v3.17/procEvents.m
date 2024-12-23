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
    display_events = load(['rec' recs{iRec} '.display.txt']);
    load(['rec' recs{iRec} '.Rec.mat']);
    if isfield(Rec,'BinaryDataFormat') format = Rec.BinaryDataFormat; else format = 'short'; end

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

        Events.Reward2T = zeros(ntr,1);
        Events.Choice = zeros(ntr,1);
        Events.RewardMag = zeros(ntr,1);
        Events.Reward = zeros(ntr,1);

        Events.ReachStart = zeros(ntr,1);   %  Time reach started
        Events.ReachStop = zeros(ntr,1);    %  Time reach stopped
        Events.SaccStart = zeros(ntr,1);    %  Time saccade started
        Events.SaccStop = zeros(ntr,1);     %  Time saccade finished

        Events.TargMove = zeros(ntr,1);     %  Time target is moved during adaptation

        Events.Reach = zeros(ntr,1);        %  Is Reach trial
        Events.Saccade = zeros(ntr,1);        %  Is Saccade trial
        %        Events.SaccBegin = zeros(ntr,20,2); %  Nth saccade beginning location
        %        Events.SaccEnd = zeros(ntr,20,2);   %  Nth saccade end location
        %        Events.NumSacc = zeros(ntr,1);      %  Number of saccades

        %        Events.NumLRSacc = zeros(ntr,1);      %  Number of LR saccades
        %        Events.LRSaccStart = zeros(ntr,1);   %  Time nth LR saccade started
        %        Events.LRSaccStop = zeros(ntr,1);    %  Time nth LR saccade finished
        %        Events.LRSaccBegin = zeros(ntr,2); %  Nth LR saccade beginning location
        %        Events.LRSaccEnd = zeros(ntr,2);   %  Nth LR saccade end location

        Events.Success = zeros(ntr,1);      %  Success variable
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

           
            if find(evs(:,2)==1)
                Ind_StartOn = find(evs(:,2)==1);

                Events.Trial(trial) = tr;
                temp = evs(Ind_StartOn-1,2)-30; %Added for v3.17
                Events.AdaptationFeedback(trial) = floor(temp/5);
                Events.AdaptationAction(trial) = mod(temp,5);
                Events.AdaptationPhase(trial) = evs(Ind_StartOn-2,2)-10;
                Events.LEDBoard(trial) = evs(Ind_StartOn-3,2)-30; %Added for v3.16
                Events.EyeTarget(trial) = evs(Ind_StartOn-4,2)-10+1; %Added for v3.15
                Events.Reward2T(trial) = evs(Ind_StartOn-5,2)-30+1;
                Events.Choice(trial) = evs(Ind_StartOn-6,2) - 10+1;
                Events.RewardMag(trial) = evs(Ind_StartOn-7,2) - 30+1;
                Events.Reward(trial) = evs(Ind_StartOn-8,2) - 10+1;
                Events.Target(trial) = evs(Ind_StartOn-9,2)-30+1;
                Events.StartHand(trial) = evs(Ind_StartOn-10,2)-10+1;
                Events.StartEye(trial) = evs(Ind_StartOn-11,2)-30+1;
                Events.HandCode(trial) = evs(Ind_StartOn-12,2)-10;
                Events.Joystick(trial) = evs(Ind_StartOn-13,2)-50;
                Events.TaskCode(trial) = evs(Ind_StartOn-14,2)-10;
                Events.TaskCode(trial)

                if find(evs(Ind_StartOn:end,2)==2);
                    index = find(evs(Ind_StartOn:end,2)==2);
                    Events.StartAq(trial) = evs(index(1)+Ind_StartOn-1,3);
                else
                    Events.StartAq(trial) = nan;
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
                        Events.TargsOn(trial) = evs(index(1),3);
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
                    if ~isempty(display_evs) && ~isempty(find(display_evs(:,2)>evs(index(1)+Ind_StartOn-1,3)-5, 1))
                        index = find(evs(Ind_StartOn:end,2)==16);
                        Events.Targ2On(trial) = min(display_evs(find(display_evs(:,2)>evs(index(1)+Ind_StartOn-1,3)-5),2));
                    else
                        index = find(evs(Ind_StartOn:end,2)==16);
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
                        Events.InstOn(trial) = evs(index(1),3);
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
                        start = Events.ReachGo(trial) - 100;
                    else
                        start = Events.Go(trial) - 100;
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
%                 Events.Saccade(trial) = isSaccadeTrial(Events.TaskCode(trial));
%                 Events.Reach(trial) = isReachTrial(Events.TaskCode(trial));
%                 if isSaccadeTrial(Events.TaskCode(trial)) && Events.Success(trial)
%                     fid = fopen(['rec' recs{iRec} '.eye.dat'],'r');
%                     start = Events.Go(trial); stop = Events.TargAq(trial);
%                     fseek(fid,2*2*start,'bof');
%                     ey = fread(fid,[2,stop-start],format);
%                     fclose(fid);
% 
%                     [b,g]=sgolay(5,51);
%                     sy = filter(g(:,2),1,ey').*1e3;
%                     vel = sqrt(sum(sy'.^2));
%                     vel(1:50) = vel(51);
%                     [s,sac] = max(vel);
%                     a = find(vel(max([1,sac-100]):sac) > 200);
%                     if isempty(a)
%                         a = find(vel(max([1,sac-100]):sac) > 150);
%                     end
%                     Events.SaccStart(trial) = start + max([1,sac-100])+ min(a);
%                     a = find(vel(sac:min([end,sac+100])) > 200);
%                     if isempty(a)
%                         a = find(vel(sac:min([end,sac+100])) > 150);
%                     end
% 
%                     Events.SaccStop(trial) = start + sac + max(a);
%                 end

                %pause
            end             %  End if not trial fragment
        end                 %  End for loop over trials
        if saveflag
            disp('Saving Events file');
            save(['rec' recs{iRec} '.Events.mat'],'Events');
        end
    end
end
