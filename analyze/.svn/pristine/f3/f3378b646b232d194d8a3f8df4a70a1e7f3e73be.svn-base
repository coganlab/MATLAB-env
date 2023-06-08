function updateMultiunit_Directions(SessNum)
%
%   updateMultiunit_Directions(SessNum)
%
%   Saves Directions tuning data structure for Multiunit Session file
%

global MONKEYDIR 

ReachSaccadeCell = {'DelReachSaccade','MemoryReachSaccade'};
SaccadeCell = {'DelSaccadeTouch','MemorySaccadeTouch','DelSaccade'};
%ControlTasks = CONTROLTASKLIST;
ControlTasks = {{ReachSaccadeCell},{SaccadeCell}};
ControlTaskNames = {'ReachSaccade','Saccade'};
ControlEpochs = {'Cue','Delay','Movement','PostMovement'};
ControlFields = {'TargsOn','TargsOn','TargAq','TargAq'};
Controlbn = {[0,500],[500,1e3],[-250,50],[0,300]};
Session = loadMultiunit_Database;


if nargin == 0
    for iSess = 1:length(Session)
        if isfile([MONKEYDIR '/mat/Multiunit/Multiunit_Directions.' num2str(iSess) '.mat']);
            %no need to recompute
            disp(['Multiunit_Directions.' num2str(iSess) '.mat already exists'])
        else
            Directions = struct([]);
            Sess = Session{iSess};
            Day = Sess{1};
            Sess{1} = sessTrials(Sess);
	    Dirs = sessCalcDirections(Sess);
	    Directions(1).Dirs = Dirs;
            CondParams1.cond = {[Dirs(1)]};
            CondParams2.cond = {[Dirs(2)]};
            for iTask = 1:length(ControlTasks)
                Tuning = struct([]);
		CondParams1.Task = ControlTasks{iTask};  CondParams2.Task = ControlTasks{iTask};
                for iEpoch = 1:length(ControlEpochs)
                    disp([ControlTaskNames{iTask} ':' ControlEpochs{iEpoch}]);
		    CondParams1.Field = ControlFields{iEpoch}; CondParams2.Field = ControlFields{iEpoch};
		    CondParams1.bn = Controlbn{iEpoch}; CondParams2.bn = Controlbn{iEpoch};
    		    [p, D] = sessTestRateDiff(Sess, CondParams1, CondParams2);
    		    Tuning(1).p = p; Tuning(1).D = D;
    		    if p < 0.05
      		      if D>0 Tuning.Pref = Dirs(1); Tuning.Null = Dirs(2);
      		      else Tuning.Pref = Dirs(2); Tuning.Null = Dirs(1); end
    		    else
      		      Tuning.Pref = nan; Tuning.Null = nan;
    		    end
                    Directions = setfield(Directions,{1},...
                        ControlTaskNames{iTask},{1},...
                        ControlEpochs{iEpoch},Tuning);
                end
            end
            Sess{1} = Day;
            Directions.Session = Sess;
            save([MONKEYDIR '/mat/Multiunit/Multiunit_Directions.' num2str(iSess) '.mat'],'Directions');
        end
    end
else
    for iSess = 1:length(SessNum)
        Sess = Session{SessNum(iSess)};
        Directions = struct([]);
        Day = Sess{1};
        Sess{1} = sessTrials(Sess);
        Dirs = sessCalcDirections(Sess);
        Directions(1).Dirs = Dirs;
        CondParams1.cond = {[Dirs(1)]};
        CondParams2.cond = {[Dirs(2)]};
        for iTask = 1:length(ControlTasks)
          Tuning = struct([]);
          CondParams1.Task = ControlTasks{iTask};  CondParams2.Task = ControlTasks{iTask};
          for iEpoch = 1:length(ControlEpochs)
            disp([ControlTaskNames{iTask} ':' ControlEpochs{iEpoch}]);
            CondParams1.Field = ControlFields{iEpoch}; CondParams2.Field = ControlFields{iEpoch};
            CondParams1.bn = Controlbn{iEpoch}; CondParams2.bn = Controlbn{iEpoch};
    	    [p, D] = sessTestRateDiff(Sess, CondParams1, CondParams2);
            Tuning(1).p = p; Tuning(1).D = D;
            if p < 0.05
              if D>0 Tuning.Pref = Dirs(1); Tuning.Null = Dirs(2);
              else Tuning.Pref = Dirs(2); Tuning.Null = Dirs(1); end
            else
              Tuning.Pref = nan; Tuning.Null = nan;
            end
            Directions = setfield(Directions,{1},...
               ControlTaskNames{iTask},{1},...
               ControlEpochs{iEpoch},Tuning);
          end
        end
        Sess{1} = Day;              %Restore Day
        Directions.Session = Sess;
        save([MONKEYDIR '/mat/Multiunit/Multiunit_Directions.' num2str(SessNum(iSess)) '.mat'],'Directions');
    end
end
