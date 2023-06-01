function updateType_NumTrialsConds(Type,SessNum)
%
%   updateType_NumTrialsConds(Type,SessNum)
%
%   Adds NumTrialsConds data structure to Type_NumTrialsConds file
%
%   Modified to accept sessnum list

global MONKEYDIR TASKLIST

%eval(['sess = ' Type '_Database;'])
Session = {};
load([MONKEYDIR '/mat/' Type '_Session.mat']);
if isfile([MONKEYDIR '/mat/' Type '/' Type '_NumTrialsConds.mat']);  %  Running when previously saved
    load([MONKEYDIR '/mat/' Type '/' Type '_NumTrialsConds.mat']);

    if nargin > 1  %  Input session numbers
        for iSess = 1:length(SessNum)
            %load([MONKEYDIR '/mat/' Type '/' Type '_NumTrialsConds.mat']);
            for iTask = 1:length(TASKLIST)
                SessionNumTrialsConds.(TASKLIST{iTask}) = 0;
            end
            SessionNumTrialsConds.SessionNumber = 0;
            Trials = sessTrials(Session{SessNum(iSess)});
            for iTask = 1:length(TASKLIST)
                myTrials = TaskTrials(Trials,TASKLIST{iTask});
              if ~isempty(myTrials)
                  Conds = trials2conds(myTrials);
              else 
                  Conds = zeros(5,5,15); 
              end
              SessionNumTrialsConds.(TASKLIST{iTask}) = Conds;
            end
            SessionNumTrialsConds.SessionNumber = Session{SessNum(iSess)}{6};
            NumTrialsConds(SessNum(iSess)) = SessionNumTrialsConds;
            save([MONKEYDIR '/mat/' Type '/' Type '_NumTrialsConds.mat'],'NumTrialsConds');
        end
    else  %  No input sessnums, just update the new sessions
        for iSess = length(NumTrialsConds)+1:length(Session)
            %load([MONKEYDIR '/mat/' Type '/' Type '_NumTrialsConds.mat']);
            for iTask = 1:length(TASKLIST)
                SessionNumTrialsConds.(TASKLIST{iTask}) = 0;
            end
            SessionNumTrialsConds.SessionNumber = 0;
            Trials = sessTrials(Session{iSess});
          for iTask = 1:length(TASKLIST)
            myTrials = TaskTrials(Trials,TASKLIST{iTask});
            if ~isempty(myTrials)
                Conds = trials2conds(myTrials);
            else 
                Conds = zeros(5,5,15); 
            end
            SessionNumTrialsConds.(TASKLIST{iTask}) = Conds;
          end
          SessionNumTrialsConds.SessionNumber = Session{iSess}{6};
          NumTrialsConds(iSess) = SessionNumTrialsConds;
          save([MONKEYDIR '/mat/' Type '/' Type '_NumTrialsConds.mat'],'NumTrialsConds');
        end
    end
else  %Running for all sessions
    for iTask = 1:length(TASKLIST)
      SessionNumTrialsConds.(TASKLIST{iTask}) = 0;
    end
    SessionNumTrialsConds.SessionNumber = 0;
    for iSess = 1:length(Session)
      Trials = sessTrials(Session{iSess});
      for iTask = 1:length(TASKLIST)
        myTrials = TaskTrials(Trials,TASKLIST{iTask});
        if ~isempty(myTrials)
            Conds = trials2conds(myTrials);
        else 
            Conds = zeros(5,5,15); 
        end
        SessionNumTrialsConds.(TASKLIST{iTask}) = Conds;
      end
      SessionNumTrialsConds.SessionNumber = Session{iSess}{6};
      NumTrialsConds(iSess) = SessionNumTrialsConds;
      save([MONKEYDIR '/mat/' Type '/' Type '_NumTrialsConds.mat'],'NumTrialsConds');
    end
end


