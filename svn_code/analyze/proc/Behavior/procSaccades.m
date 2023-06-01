function procSaccades(day,rec)
%  procSaccades determines saccade times for saccade trials
%
%  Inputs:  DAY        =   String. Day to detect saccades for
%

global MONKEYDIR MONKEYNAME

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

for iNum = num(1):num(2)
    load([MONKEYDIR '/' day '/' recs{iNum} '/rec' recs{iNum} '.Events.mat']);
    load([MONKEYDIR '/' day '/' recs{iNum} '/rec' recs{iNum} '.EyeScale.mat']);
    Success = find(Events.Success);
    for iTr = 1:length(Success)
        Tr = Success(iTr)
        Events.Saccade(Tr)
        Events.TaskCode(Tr)
        if Events.Success(Tr) & (Events.Saccade(Tr) | (Events.SaccadeGo(Tr)>0 & Events.ReachGo(Tr)>0))
            if Events.Saccade(Tr)
                Go = Events.Go(Tr); TA = Events.TargAq(Tr)+50; Field = 'Go';
            elseif Events.SaccadeGo(Tr)>0 & Events.ReachGo(Tr)>0
                Go = Events.SaccadeGo(Tr); TA = Events.SaccadeAq(Tr); Field = 'SaccadeGo';
            end
            TA-Go
            if TA-Go<100 Go = TA-200; end
            E = loadlpeye([MONKEYDIR '/' day '/' recs{iNum} '/rec' recs{iNum}],Events,Tr,Field,[0,TA-Go],1,EyeScale);
            [b,g]=sgolay(5,51);
            sy = filter(g(:,2),1,E').*1e3;
            vel = sqrt(sum(sy'.^2));
            vel(1:50) = vel(60);
            [s,sac] = max(vel);
            a = find(vel(max([1,sac-100]):sac) > 100);
            if length(a) == 0
                disp('No large velocity detection')
                a = find(vel(max([1,sac-100]):sac) > 20);
            end
            if length(a)
                Events.SaccStart(Tr) = min(a) + max([1,sac - 100]) + Go - 25;
            else
                Events.SaccStart(Tr) = Go;
            end
%             plot(E(:,max([1,sac-100-25]):min([sac+100-25,end]))');
%             pause
        end
    end
    save([MONKEYDIR '/' day '/' recs{iNum} '/rec' recs{iNum} '.Events.mat'],'Events');
end

saveTrials(day);

cd(olddir);
