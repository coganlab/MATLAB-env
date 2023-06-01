function cumDepth = calcCumulativeChannelDepth(add_day, rec, tower)
%
%  cumDepth = getCumulativeChannelDepth(add_day, rec, tower)
%
%  Calculate the depth of all electrodes from the Movement_Database
%  specified by day,rec and tower

global MONKEYDIR

turnThrow = 125; % (um/turn)

if exist([MONKEYDIR '/m/depth/Movement_' tower '_StartDepth.m'],'file')
    eval(['Movement_' tower '_StartDepth']);
    cumDepth = StartDepth;
end

Session = loadMovement_Database;
Towers = sessTower(Session);


MSession = Session(ismember(Towers,tower));
MDays = sessDay(MSession);

for iDay = 1:(find(ismember(MDays,add_day))-1)
    curDay = MDays{iDay};
    %   allRecs = dayrecs(curDay);
    ['Movement_' tower '_' curDay];
    clear moveIter;
%     eval(['which Movement_' tower '_' curDay])
    eval(['Movement_' tower '_' curDay]);
    nIter = length(moveIter);
    for iIter = 1:nIter
        if ~isempty(moveIter(iIter).moveInc);
            cumDepth = cumDepth + turnThrow*moveIter(iIter).moveInc;
        end
    end
end
curDay = MDays{find(ismember(MDays,add_day))};
clear moveIter;
% eval(['which Movement_' tower '_' curDay])
eval(['Movement_' tower '_' curDay]);
nIter = length(moveIter);
if ischar(moveIter(2).rec)
    
    dayRecordings = dayrecs(add_day);
    for iDayRecordings = 1:find(ismember(dayRecordings,rec))
        curRec = dayRecordings{iDayRecordings};
        for iIter  = 1:nIter
            if isequal(moveIter(iIter).rec,curRec)
                cumDepth = cumDepth + turnThrow*moveIter(iIter).moveInc;
            end
        end
    end
else
    for iIter = 1:nIter
        if ~isempty(moveIter(iIter).moveInc);
            cumDepth = cumDepth + turnThrow*moveIter(iIter).moveInc;
        end
    end
end
end

% - Not sure how to implement multiple movements per day.

%   mRecs = [moveIter.rec];
%   for iRec = 1:length(allRecs)
%     curRec = allRecs{iRec};
%     [yn, mLoc] = ismember(str2num(allRecs{iRec}),mRecs);
%     if yn
%       end
%     end
%     depth = [ depth; cumDepth ];
%     days{dIndex} = curDay;
%     recs{dIndex} = allRecs{iRec};
%     dIndex = dIndex + 1;
%   end
% end
%
% if exist('ch','var') & ~isempty(ch)
%   cumDepth = cumDepth(:,ch);
%   depth = depth(:,ch);
% end

