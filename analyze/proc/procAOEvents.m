function AOEvents = procAOEvents(day, rec, saveflag)
%  PROCEVENTS converts file.aoev.txt to AOEvents data structure
%     
%
%  AOEVENTS = PROCAOEVENTS(DAY, REC, SAVEFLAG)
%
%  Inputs:  DAY    = String '030603'
%           REC    = String '001', or num [1,2]
%           SAVEFLAG    =   0: No save
%                           1: Save
%               Defaults to 1.
%
%  Outputs: AOEVENTS  = AOEvent data structure
%



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

[ev,sig] = parseViewingPrefDisplay(day,rec);
Events = diff(sig);
plot(Events)
Sig_Events = find(Events>5000);
Sig_Events = Sig_Events/30;

for iRec = num(1):num(2)
    cd([MONKEYDIR '/' day '/' recs{iRec}]);
    disp([MONKEYDIR '/' day '/' recs{iRec}]);
    %pause
    aoevents = load(['rec' recs{iRec} '.aoev.txt']);
    load(['rec' recs{iRec} '.Rec.mat']);
    aoevents(:,3) = aoevents(:,3)+Sig_Events(1);
    clear AOEvents
    
    AOEvents.Trial = aoevents(:,1);
    AOEvents.Event = aoevents(:,2);
    AOEvents.Timestamp = aoevents(:,3);
    AOEvents.StartOn = aoevents(:,3)-1000;
    AOEvents.End = aoevents(:,3)+1000;           
            
        % 	Events.Target = [Events.Target(2:end)' 0]';  %Use for Task Control 2.4
        % 	and earlier
        if saveflag
            disp('Saving AOEvents file');
            save(['rec' recs{iRec} '.AOEvents.mat'],'AOEvents');
        end
end
