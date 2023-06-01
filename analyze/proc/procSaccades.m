function procSaccades(day,rec)
%  procSaccades determines saccade times for saccade trials
%
%  procSaccades(day,rec)
%
%  Inputs:  DAY        =   String. Day to detect saccades for
%       

global MONKEYDIR 

olddir = pwd;

recs = dayrecs(day);
nRecs = length(recs);

if nargin < 2
    num = [1,nRecs];
elseif ischar(rec)
    num = [find(strcmp(recs,rec)),find(strcmp(recs,rec))];
elseif length(rec)==1
    num = [rec,rec];
elseif length(rec)==2
    num = rec;
end
[b,g] = sgolay(5,51);

for iNum = num(1):num(2)
    load([MONKEYDIR '/' day '/' recs{iNum} '/rec' recs{iNum} '.Events.mat']);
    load([MONKEYDIR '/' day '/' recs{iNum} '/rec' recs{iNum} '.EyeScale.mat']);
    %Success = find(Events.Success);
    %for iTr = 1:length(Success)
    for iTr = 1:length(Events.Trial)
        %Tr = Success(iTr)
        Tr = iTr;
        Events.Saccade(Tr);
        Events.TaskCode(Tr);
        
        if Events.Success(Tr) && Events.Saccade(Tr)
            if Events.Saccade(Tr)
                Go = Events.Go(Tr); TA = Events.TargAq(Tr) + 100; Field = 'Go';
                if isfield(Events,'SaccadeGo') && length(Events.SaccadeGo)> Tr-1 && Events.SaccadeGo(Tr)>0 && Events.SaccadeAq(Tr)>0
                    Go = Events.SaccadeGo(Tr); TA = Events.SaccadeAq(Tr) + 100; Field = 'SaccadeGo';
                end
            else
                Go = Events.Go(Tr); TA = Events.TargAq(Tr) + 100; Field = 'Go';
            end
            TA-Go;
            if TA-Go<100 TA = Go + 400; end
            if TA-Go>850 TA = Go + 850; end
            E = loadlpeye([MONKEYDIR '/' day '/' recs{iNum} '/rec' recs{iNum}],Events,Tr,Field,[-80,TA-Go],1,EyeScale);
            vel = calcEyeVelocity(E, g);
           % plot(vel)
         %   pause
            t = find(vel > 100);
            if isempty(t)  %In case velocity never exceeds 100
                t = length(vel) - 50;  
            else
                if min(t) < 75 
                    t = length(vel) - 50;  
                end
            end
            [~,sac] = max(vel(1:min([min(t)+50,length(vel)])));
            a = find(vel(max([1,sac-100]):sac) > 100);
            if isempty(a)
                disp('No large velocity detection')
                keyboard
                a = find(vel(max([1,sac-100]):sac) > 20);
            else
                if sac > 100
                    b = find(vel(sac-100 + min(a) - 9:min(sac-100 + min(a),length(vel))) < 50) + min(a) - 10;
                    a = [max(b):max(a)]; %This will make min(a) when first vel > 50
                end
            end
            if ~isempty(a)
                Events.SaccStart(Tr) = min(a) + max([1,sac - 100]) + Go - 80 - 25;
            else
                Events.SaccStart(Tr) = Go;
            end
            SRT = Events.SaccStart(Tr) - Go
            
            %  Look up to 100 ms post-saccade velocity maximum
            a = vel(sac:min([length(vel),sac+50]));   
            if ~isempty(a)
                if find(a<50)
                    Events.SaccStop(Tr) = Go - 80 + sac + find(a<50,1,'first') - 25;
                    %                 Events.SaccStop(Tr) = Go - 80 + sac + max(a) - 25;
                else
                    Events.SaccStop(Tr) = Go + sac;
                end
            end
%             figure(8)
%             clf
%             plot(E');
%             hold on;
%             plot(Events.SaccStart(Tr)- Go + 80,E(1,Events.SaccStart(Tr)- Go + 80),'rx');
%             plot(Events.SaccStop(Tr)- Go + 80,E(1,Events.SaccStop(Tr)- Go + 80),'kx');
%             plot(Events.SaccStart(Tr)- Go + 80,E(2,Events.SaccStart(Tr)- Go + 80),'rx');
%             plot(Events.SaccStop(Tr)- Go + 80,E(2,Events.SaccStop(Tr)- Go + 80),'kx');
%                          pause
        else
            Events.SaccStart(Tr) = nan;
            Events.SaccStop(Tr) = nan;
        end

        if isfield(Events, 'DoubleStep')
            if Events.DoubleStep(Tr) && Events.Success(Tr)
                  
                if Events.Targ2On(Tr) > 0
                    Go = Events.Targ2On(Tr);
                    start = Events.Targ2On(Tr);
                    Field = 'Targ2On';
                else
                    Go = Events.SaccadeAq(Tr);
                    start = Events.SaccadeAq(Tr);
                    Field = 'SaccadeAq';
                end
                stop = Events.TargAq(Tr)+200;
                E = loadlpeye([MONKEYDIR '/' day '/' recs{iNum} '/rec' recs{iNum}],Events,Tr,Field,[0,stop-start],1,EyeScale);
                vel = calcEyeVelocity(E, g);                
                [s,sac] = max(vel);
               
                a = find(vel(max([1,sac-100]):sac) > 100);
                if isempty(a)
                    disp('No large velocity detection')
                    a = find(vel(max([1,sac-100]):sac) > 20);
                    keyboard
                end
                if ~isempty(a)
                    Events.Sacc2Start(Tr) = min(a) + max([1,sac - 100]) + Go - 25;
                else
                    Events.SaccS2tart(Tr) = Go;
                end
                a = find(vel(sac:min([end,sac+100])) > 100);
                if ~isempty(a)
                    Events.Sacc2Stop(Tr) = Go + sac + max(a) - 25;
                else
                    Events.Sacc2Stop(Tr) = Go + sac;
                end
            else
                Events.Sacc2Start(Tr) = nan;
                Events.Sacc2Stop(Tr) = nan;
            end
        end
    end

    NSuccess = find(Events.Success == 0);
    for iTr = 1:length(NSuccess)
        Tr = NSuccess(iTr);
        Events.Saccade(Tr);
        Events.TaskCode(Tr);
        if Events.Saccade(Tr) 
            if ~isfield(Events,'SaccadeGo') 
                Events.SaccadeGo(Tr) = Events.Go(Tr);
            elseif length(Events.SaccadeGo) < Tr
                Events.SaccadeGo(Tr) = Events.Go(Tr);
            end
        else
            Events.SaccadeGo(Tr) = nan;
        end
        if Events.Saccade(Tr) && Events.SaccadeGo(Tr) > 0
            Go = Events.SaccadeGo(Tr);
            TA = Events.End(Tr) + 200;
            Field = 'Go';
            if TA-Go > 200
                E = loadlpeye([MONKEYDIR '/' day '/' recs{iNum} '/rec' recs{iNum}],Events,Tr,Field,[-20,TA-Go],1,EyeScale);
                vel = calcEyeVelocity(E);                
                t = find(vel > 80);
                if isempty(t)  %In case velocity never exceeds 100
                    t = length(vel) - 50;
                else
                    if min(t) < 75
                        t = length(vel) - 50;
                    end
                end
                if length(vel) > min(t)+50
                    [s,sac] = max(vel(1:min(t)+50));
                    a = find(vel(max([1,sac-100]):sac) > 100);
                    if isempty(a)
                        disp('No large velocity detection')
                        a = find(vel(max([1,sac-100]):sac) > 20);
                        keyboard
                    else
                        if sac > 100
                            b = find(vel(sac-100 + min(a) - 10:sac-100 + min(a)) < 50) + min(a) - 10;
                            a = [max(b):max(a)]; %This will make min(a) when first vel > 50
                        end
                    end
                    if ~isempty(a)
                        Events.SaccStart(Tr) = min(a) + max([1,sac - 100]) + Go - 20 - 25;
                    else
                        Events.SaccStart(Tr) = Go;
                    end
                    a = vel(sac:min([end,sac+100]));
                    if ~isempty(a)
                        %                         if sac + max(a) + 10 < length(vel)
                        %                             b = find(vel(sac + max(a):sac + max(a) + 10) > 50) + max(a);
                        %                             a = [min(a):max(b)]; %This will make max(a) when first vel < 50
                        %                         end
                        if find(a<50)
                                                
                            Events.SaccStop(Tr) = Go - 20 + sac + find(a<50,1,'first') - 25;
                            %                         Events.SaccStop(Tr) = Go - 20 + sac + max(a) - 25;
                        else
                            Events.SaccStop(Tr) = Go + sac;
                        end
                    end
                else
                    Events.SaccStart(Tr) = nan;
                    Events.SaccStop(Tr) = nan;
                end
            else
                Events.SaccStart(Tr) = nan;
                Events.SaccStop(Tr) = nan;
            end
        else
            Events.SaccStart(Tr) = nan;
            Events.SaccStop(Tr) = nan;
        end
    end
    
    save([MONKEYDIR '/' day '/' recs{iNum} '/rec' recs{iNum} '.Events.mat'],'Events');
end

saveTrials(day);
%saveErrorTrials(day);

cd(olddir);

