function procSaccadesNoEyeScale(day,num,fracvar)
%
% procSaccadesNoEyeScale(day,num,fracvar)
%
% Determines saccade times without EyeScale. Based on local high variance 
% velocity components in single trial raw eye tracking signals.
%
%  Inputs:  DAY        =   String. Day to calibrate.
%           NUM        =   Cell. Recording number to calibrate
%                               Defaults to all recordings in given day
%                               with the "right" task type.
%           FRACVAR    = Optional. Float between 0 and 1. Fraction of local
%                        velocity variance used to determine Saccade start 
%                        and stop. Defaults to 0.5

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

if nargin < 3
    fracvar = 0.5;
end
swin = 50; % ms, window for determining large variance segments of position data
nfilt = 50;
[b,g] = sgolay(5,nfilt+11); % smoothing filter
fracvar = 0.5; % fraction of velocity variance the saccade has to explain
% saccount = 0;
% Raw data eye scale
Scale.Eye(1) = 1;
Scale.EyeOffset(1) = 0;
Scale.Eye(2) = 1;
Scale.EyeOffset(2) = 0;
Scale.Gradient = [1 0;0 1];
Scale.Flag = [];


%% Load all saccade data of the day to get an idea of the distributions of x/y signals
EG = []; % global eye data, each trial will be mean subtracted to account for shifts in eye positioning due to mirror/camera movements
for iNum = num(1):num(2)
    load([MONKEYDIR '/' day '/' recs{iNum} '/rec' recs{iNum} '.Events.mat']);
    for iTr = 1:length(Events.Trial)
        Tr = iTr;
        Events.Saccade(Tr);
        Events.TaskCode(Tr);
        if Events.Success(Tr) & Events.Saccade(Tr)
            Go = Events.Go(Tr); TA = Events.TargAq(Tr) + 100; Field = 'Go';
            if isfield(Events,'SaccadeGo') && length(Events.SaccadeGo)> Tr-1 && Events.SaccadeGo(Tr)>0 && Events.SaccadeAq(Tr)>0
                Go = Events.SaccadeGo(Tr); TA = Events.SaccadeAq(Tr) + 200; Field = 'SaccadeGo';
            end
            
            if TA-Go<100 TA = Go + 400; end
            if TA-Go>1000 TA = Go + 1000; end
            
            E = loadlpeye([MONKEYDIR '/' day '/' recs{iNum} '/rec' recs{iNum}],Events,Tr,Field,[-80,TA-Go],1,Scale);
            E = E-repmat(mean(E,2),1,size(E,2));
            EG=[EG E];
        end
    end
end
M=mean(EG');
S=std(EG');

%% Detect Saccades on Single trial basis
% overall saccade trial counts and successful timing counts
sc=0;
sct=0;
for iNum = num(1):num(2)
    load([MONKEYDIR '/' day '/' recs{iNum} '/rec' recs{iNum} '.Events.mat']);
    for iTr = 1:length(Events.Trial)
        Tr = iTr;
        Events.Saccade(Tr);
        Events.TaskCode(Tr);
        if Events.Success(Tr) & Events.Saccade(Tr)
            sc=sc+1;
            Go = Events.Go(Tr); TA = Events.TargAq(Tr) + 100; Field = 'Go';
            if isfield(Events,'SaccadeGo') && length(Events.SaccadeGo)> Tr-1 && Events.SaccadeGo(Tr)>0 && Events.SaccadeAq(Tr)>0
                Go = Events.SaccadeGo(Tr); TA = Events.SaccadeAq(Tr) + 200; Field = 'SaccadeGo';
            end
            
            if TA-Go<100 TA = Go + 400; end
            if TA-Go>1000 TA = Go + 1000; end
            
            E = loadlpeye([MONKEYDIR '/' day '/' recs{iNum} '/rec' recs{iNum}],Events,Tr,Field,[-80,TA-Go],1,Scale);
            ns = size(E,2);

            % Normalization with global x/y signals
            E=(E-repmat(mean(E,2),1,size(E,2)))';
            E=(E-repmat(M,size(E,1),1))./repmat(S,size(E,1),1);
            
            % smooth
            V = filter(g(:,2),1,E).*1e3;
            V(1:nfilt,1) = V(nfilt+1,1); V(1:nfilt,2) = V(nfilt+1,2);
            
            % combine x/y variance to make saccade judgement
            Vi = abs(V(:,1)+1i.*V(:,2));
            
            % compute local contributions to global velocity variance
            nwin = ns-swin;
            globvar = sum((Vi-mean(Vi)).^2);
            locvar = zeros(nwin,1);
            for iwin=1:nwin
                tmp = Vi;
                tmp(iwin:iwin-1+swin,:)=[]; % delete segment
                locvar(iwin) = (globvar - sum((tmp - mean(tmp)).^2))./globvar;
            end
            
            % SaccStart and Stop based on local velocity variance
            thresh = min([fracvar prctile(locvar,90)]);
            Sacc = find(locvar>thresh);
            SaccStart = min(Sacc(Sacc>80-swin/2)); % must be past Go

            if ~isempty(SaccStart)
                Events.SaccStart(Tr) = SaccStart + Go - 80 + swin/2;
                Events.SaccStop(Tr) = max(Sacc(Sacc<SaccStart+75)) + Go - 80 + swin/2; % maximal 75ms later
                sct=sct+1;

%                 saccount=saccount+1;
%                 tmpst=SaccStart+50;
%                 tmp=[nan(50,2); E; nan(50,2)];
%                 ex(saccount,:) = tmp(tmpst-50:tmpst+50,1);
%                 ey(saccount,:) = tmp(tmpst-50:tmpst+50,2);
% %                 keyboard
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
% keyboard
fprintf('Found Saccade Timing for %d of %d successful Saccade Trials\n',sct,sc)
saveTrials(day);
%saveErrorTrials(day);
cd(olddir);

% % Debug plot
% figure
% subplot(1,3,1)
% plot(amp)
% hold on
% if ~isempty(Sacc)
%     plot(Sacc,thresh,'r*')
% end
% axis tight square
% subplot(1,3,2)
% Z=zscore(E);
% plot(Z);
% axis tight square
% subplot(1,3,3)
% plot(V);
% axis tight square
% pause
% close all

