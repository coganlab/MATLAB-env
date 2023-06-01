function updateType_NumTrials(Type,SessNum)
%
%   updateType_NumTrials(Type,SessNum)
%
%   Adds NumTrials data structure to Type_NumTrials file
%
%   Modified to accept sessnum list

global MONKEYDIR TASKLIST

%eval(['sess = ' Type '_Database;'])

load([MONKEYDIR '/mat/' Type '_Session.mat']);
if isfile([MONKEYDIR '/mat/' Type '/' Type '_NumTrials.mat']);  %  Running when previously saved
    load([MONKEYDIR '/mat/' Type '/' Type '_NumTrials.mat']);
    if nargin > 1  %  Input session numbers
        for iSess = 1:length(SessNum)
            disp(num2str(iSess))
            %load([MONKEYDIR '/mat/' Type '/' Type '_NumTrials.mat']);
            Trials = sessTrials(Session{SessNum(iSess)});
            for iTask = 1:length(TASKLIST)
                SessionNumTrials.(TASKLIST{iTask}) = ...
                    length(TaskTrials(Trials,TASKLIST{iTask}));
            end
            SessionNumTrials.SessionNumber = Session{SessNum(iSess)}{6};
            NumTrials(SessNum(iSess)) = SessionNumTrials;
            save([MONKEYDIR '/mat/' Type '/' Type '_NumTrials.mat'],'NumTrials');
        end
    else  %  No input sessnums, just update the new sessions
        for iSess = length(NumTrials)+1:length(Session)
          disp(num2str(iSess))
          %load([MONKEYDIR '/mat/' Type '/' Type '_NumTrials.mat']);
          Trials = sessTrials(Session{iSess});
          for iTask = 1:length(TASKLIST)
              SessionNumTrials.(TASKLIST{iTask}) = ...
                  length(TaskTrials(Trials,TASKLIST{iTask}));
          end
          SessionNumTrials.SessionNumber = Session{iSess}{6};
          NumTrials(iSess) = SessionNumTrials;
          save([MONKEYDIR '/mat/' Type '/' Type '_NumTrials.mat'],'NumTrials');
        end
    end
else  %Running for all sessions
    for iTask = 1:length(TASKLIST)
      SessionNumTrials.(TASKLIST{iTask}) = 0;
    end
    SessionNumTrials.SessionNumber = 0;
    for iSess = 1:length(Session)
      disp(num2str(iSess))
      Trials = sessTrials(Session{iSess});
      for iTask = 1:length(TASKLIST)
        SessionNumTrials.(TASKLIST{iTask}) = ...
          length(TaskTrials(Trials,TASKLIST{iTask}));
      end
      SessionNumTrials.SessionNumber = Session{iSess}{6};
      NumTrials(iSess) = SessionNumTrials;
      save([MONKEYDIR '/mat/' Type '/' Type '_NumTrials.mat'],'NumTrials');
    end
end


