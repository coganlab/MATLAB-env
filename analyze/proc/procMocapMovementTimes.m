function procMocapMovementTimes(day,rec)
%  procMocapMovementTimes calculates movement times from mocap 
%  marker files and then creates MocapEvents if it doesn't exist.
%
%  Inputs:  DAY        =   String. Day to detect saccades for
%           REC        =   String. Recording to detect saccades for
global MONKEYDIR

olddir = pwd;
recs= dayrecs(day);

nRecs = length(recs);
if nargin < 2
    num = [1,nRecs];
elseif ischar(rec)
    num = [find(strcmp(recs,rec)),find(strcmp(recs,rec))];
elseif length(rec)==1
    num = [rec,rec];
else
    num = rec;
end

[b,g] = sgolay(5,11);

for iRec = num(1):num(2)
    prenum = recs{iRec};
    disp(['Processing ' day ':' prenum]);
    cd([MONKEYDIR '/' day '/' prenum]);
    MarkerFilename = ['rec' prenum '.Body.Marker.mat'];
    
    %add for loop here that runs code, adding movement times to the MocapEvents structure 
    
%      load(['rec' prenum '.MocapEvents.mat']);
%     nTr = length(MocapEvents.Success);
%         wrist = loadMarker(['rec' prenum],MocapEvents,1:nTr,'StartOn',[0,3e3],'Body','R.Wrist');
%         for iTr = 1:nTr
%             nt = size(wrist{iTr},2);
%             if nt > size(g,1)
%                 vel = calcMarkerSpeed(sq(wrist{iTr}(2:end,:)), g);
%                 [dum,eventtime] = max(vel);
%                 %plot(vel); title(num2str(iTr)); line([eventtime,eventtime],[0,dum]); pause
%                 MocapEvents.WristMove(iTr,1) = eventtime*5 + MocapEvents.StartOn(iTr);
%             else
%                 MocapEvents.WristMove(iTr,1) = nan;
%             end
%         end
%     else
%         MocapEvents.WristMove = nan(nTr,1);
%     end
    save(['rec' prenum '.MocapEvents.mat'],'MocapEvents');
end