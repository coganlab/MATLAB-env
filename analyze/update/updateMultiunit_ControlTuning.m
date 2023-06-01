function updateMultiunit_ControlTuning(SessNum)
%
%   updateMultiunit_ControlTuning(SessNum)
%
%   Saves ControlTuning data structure for Multiunit Session file
%

global MONKEYDIR CONTROLTASKLIST CONTROLEPOCHS

ControlTasks = CONTROLTASKLIST;
if isempty(CONTROLEPOCHS) 
    ControlEpochs = {'Cue','Delay','Movement','PostMovement'};
else
    ControlEpochs = CONTROLEPOCHS;
end
Session = loadMultiunit_Database;

if nargin == 0
    for iSess = 1:length(Session)
        if isfile([MONKEYDIR '/mat/Multiunit/Multiunit_ControlTuning.' num2str(iSess) '.mat']);
            %no need to recompute
            disp(['Multiunit_ControlTuning.' num2str(iSess) '.mat already exists'])
        else
            ControlTuning = struct([]);
            Sess = Session{iSess};
            Day = Sess{1};
            Sess{1} = sessTrials(Sess);
            for iTask = 1:length(ControlTasks)
                for iEpoch = 1:length(ControlEpochs)
                    disp([ControlTasks{iTask} ':' ControlEpochs{iEpoch}]);
                    Tuning = sessSpikeTuning(Sess,...
                        ControlTasks{iTask},ControlEpochs{iEpoch});
                    Anova = sessSpikeAnova(Sess,...
                        ControlTasks{iTask},ControlEpochs{iEpoch});
                    ControlTuning = setfield(ControlTuning,{1},...
                        ControlTasks{iTask},{1},...
                        ControlEpochs{iEpoch},'Tuning',Tuning);
                    ControlTuning = setfield(ControlTuning,{1},...
                        ControlTasks{iTask},{1},...
                        ControlEpochs{iEpoch},'Anova',Anova);
                end
            end
            Sess{1} = Day;
            ControlTuning.Session = Sess;
            save([MONKEYDIR '/mat/Multiunit/Multiunit_ControlTuning.' num2str(iSess) '.mat'],'ControlTuning');
        end
    end
else
    for iSess = 1:length(SessNum)
        Sess = Session{SessNum(iSess)};
        Day = Sess{1};                    %  Save Day
        Sess{1} = sessTrials(Sess);
        ControlTuning = struct([]);
        for iTask = 1:length(ControlTasks)
            for iEpoch = 1:length(ControlEpochs)
                disp([ControlTasks{iTask} ':' ControlEpochs{iEpoch}]);
                Tuning = sessSpikeTuning(Sess,...
                    ControlTasks{iTask},ControlEpochs{iEpoch});
                Anova = sessSpikeAnova(Sess,...
                    ControlTasks{iTask},ControlEpochs{iEpoch});
                ControlTuning = setfield(ControlTuning,{1},...
                    ControlTasks{iTask},{1},...
                    ControlEpochs{iEpoch},'Tuning',Tuning);
                ControlTuning = setfield(ControlTuning,{1},...
                    ControlTasks{iTask},{1},...
                    ControlEpochs{iEpoch},'Anova',Anova);
            end
        end
        Sess{1} = Day;              %Restore Day
        ControlTuning.Session = Sess;
        save([MONKEYDIR '/mat/Multiunit/Multiunit_ControlTuning.' num2str(SessNum(iSess)) '.mat'],'ControlTuning');
    end
end
%  

