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
    load(['rec' recs{iRec} '.Rec.mat']);

    clear Events
    if length(events)
        ntr = max(events(:,1))-min(events(:,1))-1;

	Events.Trial = zeros(ntr,1);	%  Trial number in ev.txt

        Events.StartOn = zeros(ntr,1);      %  Time start on
        Events.StartAq = zeros(ntr,1);      %  Time start acquire
        Events.TargsOn = zeros(ntr,1);      %  Time targets on
        Events.Go = zeros(ntr,1);           %  Time of go signal for nth reach
        Events.TargAq = zeros(ntr,1);      %  Time nth reach acquired

        Events.HandCode = zeros(ntr,1);         %  Hand?.  1 = right.  0 = left. 2 = bimanual.
        Events.TaskCode = zeros(ntr,1);     %  Trial type?
        Events.Joystick = zeros(ntr,1);     %  Joystick?  0 = Touch; 1 = Joystick

        Events.Target = zeros(ntr,1);	    %  Target location code
        Events.StartHand = zeros(ntr,1);     %  Initial hand location code
        Events.StartEye = zeros(ntr,1);     %  Initial eye location code

        Events.ReachStart = zeros(ntr,1);   %  Time reach started
        Events.ReachStop = zeros(ntr,1);    %  Time reach stopped
        Events.SaccStart = zeros(ntr,1);   %  Time saccade started
        Events.SaccStop = zeros(ntr,1);    %  Time saccade finished

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
            evs = events(find(events(:,1)==tr),:)

            Ind_StartOn = find(evs(:,2)==1);

            if Ind_StartOn & Ind_StartOn~=size(evs,1)

		Events.Trial(trial) = tr;

                Events.Target(trial) = evs(Ind_StartOn-1,2)-30+1;
                Events.StartHand(trial) = evs(Ind_StartOn-2,2)-10+1;
                Events.StartEye(trial) = evs(Ind_StartOn-3,2)-30+1;
                Events.HandCode(trial) = evs(Ind_StartOn-4,2)-10;
                Events.Joystick(trial) = evs(Ind_StartOn-5,2)-30;
                Events.TaskCode(trial) = evs(Ind_StartOn-6,2)-10;

                Events.StartOn(trial) = evs(Ind_StartOn,3);

                if find(evs(:,2)==2);
                    index = find(evs(:,2)==2);
                    Events.StartAq(trial) = evs(index,3);
                end

                % Assigning Targets On
                if find(evs(:,2)==3)
                    index = find(evs(:,2)==3);
                    Events.TargsOn(trial) = evs(index,3);
                end

                if find(evs(:,2)==4);
                    index = find(evs(:,2)==4);
                    Events.Go(trial) = evs(index,3);
                end

                if find(evs(:,2)==5);
                    index = find(evs(:,2)==5);
                    Events.TargAq(trial) = evs(index,3);
                end

                %  Success or fail trial
                Ind_Success = find(evs(:,2)==7);
                Ind_Fail = find(evs(:,2)==8);

                if length(Ind_Success) == 1 & length(Ind_Fail)==0
                    Events.End(trial) = evs(Ind_Success,3);
                    Events.Success(trial) = 1;
                elseif length(Ind_Fail) == 1 & length(Ind_Success)==0
                    Events.End(trial) = evs(Ind_Fail,3);
                    Events.Success(trial) = 0;
                else
                    Events.Success(trial) = 0;
                    disp('Success/error failure')
                end

                %  Process movement information
                if isReachTrial(Events.TaskCode(trial)) & Events.TargAq(trial)
                    fid = fopen(['rec' recs{iRec} '.hnd.dat'],'r');
                    start = Events.Go(trial)-100; stop = Events.TargAq(trial)+200;
                    fseek(fid,2*2*start,'bof');
                    hnd = fread(fid,[2,stop-start],'short');
                    fclose(fid);
                    %plot(hnd(1,:)); hold on; plot(hnd(2,:),'r'); hold off
                    reaching = find(hnd(1,:) < 700);
                    if reaching
                        Events.ReachStart(trial) = reaching(1)+start;
                        %  Reassign reach acquire
                        Events.ReachStop(trial) = reaching(end)+start;
                    end
                end
                Events.Saccade(trial) = isSaccadeTrial(Events.TaskCode(trial));
                Events.Reach(trial) = isReachTrial(Events.TaskCode(trial));
                if isSaccadeTrial(Events.TaskCode(trial)) & Events.TargAq(trial)
                    fid = fopen(['rec' recs{iRec} '.eye.dat'],'r');
                    start = Events.Go(trial); stop = Events.TargAq(trial);
                    fseek(fid,2*2*start,'bof');
                    ey = fread(fid,[2,stop-start],'short');
                    fclose(fid);

                    [b,g]=sgolay(5,51);
                    sy = filter(g(:,2),1,ey').*1e3;
                    vel = sqrt(sum(sy'.^2));
                    vel(1:50) = vel(51);
                    [s,sac] = max(vel);
                    a = find(vel(max([1,sac-100]):sac) > 200);
                    Events.SaccStart(trial) = start + min(a);
                    a = find(vel(sac:min([sac+100,end])) > 200);
                    Events.SaccStop(trial) = start + max(a);
                end

                %pause
            end             %  End if not trial fragment
        end                 %  End for loop over trials
	Events.Target = [Events.Target(2:end)' 0]';
        if saveflag
            disp('Saving Events file');
            save(['rec' recs{iRec} '.Events.mat'],'Events');
        end
    end
end