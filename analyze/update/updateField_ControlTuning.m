function updateField_ControlTuning(SessNum)
%
%   updateField_ControlTuning(SessNum)
%
%   Saves ControlTuning data structure to Field Session file
%

global MONKEYDIR TASKLIST CONTROLTASKLIST

ControlTasks = CONTROLTASKLIST;
%{'DelReachSaccade','DelReachFix','DelSaccadeTouch','DelSaccade','DelReach','MemReachSaccade'};
ControlEpochs = {'Cue','Delay','Movement','PostMovement'};
Session = loadField_Database;


if nargin == 0
    for iSess = 1:length(Session)
        if isfile([MONKEYDIR '/mat/Field/Field_ControlTuning.' num2str(iSess) '.mat']);
            %no need to recompute
            disp(['Field_ControlTuning.' num2str(iSess) '.mat already exists'])
        else
            ControlTuning = struct([]);
            SessionTrials = sessTrials(Session{iSess});
            CurrentSession = Session{iSess};
            CurrentSession{1} = SessionTrials;

            for iTask = 1:length(ControlTasks)
                for iEpoch = 1:length(ControlEpochs)
                    Tuning = sessFieldTuning(CurrentSession,...
                        ControlTasks{iTask},ControlEpochs{iEpoch});
                    Anova = sessFieldAnova(CurrentSession,...
                        ControlTasks{iTask},ControlEpochs{iEpoch});
                    ControlTuning = setfield(ControlTuning,{1},...
                        ControlTasks{iTask},{1},...
                        ControlEpochs{iEpoch},'Tuning',Tuning);
                    ControlTuning = setfield(ControlTuning,{1},...
                        ControlTasks{iTask},{1},...
                        ControlEpochs{iEpoch},'Anova',Anova);
                end
            end
            ControlTuning.Session = Session{iSess};
            save([MONKEYDIR '/mat/Field/Field_ControlTuning.' num2str(iSess) '.mat'],'ControlTuning');
        end
    end
else
    for iSess = 1:length(SessNum)
        ControlTuning = struct([]);
        SessionTrials = sessTrials(Session{SessNum(iSess)});
        CurrentSession = Session{SessNum(iSess)};
        CurrentSession{1} = SessionTrials;
        for iTask = 1:length(ControlTasks)
            for iEpoch = 1:length(ControlEpochs)
                Tuning = sessFieldTuning(CurrentSession,...
                    ControlTasks{iTask},ControlEpochs{iEpoch});
                Anova = sessFieldAnova(CurrentSession,...
                    ControlTasks{iTask},ControlEpochs{iEpoch});
                ControlTuning = setfield(ControlTuning,{1},...
                    ControlTasks{iTask},{1},...
                    ControlEpochs{iEpoch},'Tuning',Tuning);
                ControlTuning = setfield(ControlTuning,{1},...
                    ControlTasks{iTask},{1},...
                    ControlEpochs{iEpoch},'Anova',Anova);
            end
        end
        ControlTuning.Session = Session{SessNum(iSess)};
        save([MONKEYDIR '/mat/Field/Field_ControlTuning.' num2str(SessNum(iSess)) '.mat'],'ControlTuning');
    end
end
% 
% 
% % OLD updateField_ControlTuning code
% 
% if isfile([MONKEYDIR '/mat/Field_ControlTuning.mat']);
%     FieldSession = load([MONKEYDIR '/mat/Field_ControlTuning.mat']);
%     if nargin == 0
%         for iSess = length(FieldSession.ControlTuning)+1:length(Session)
%             ControlTuning = struct([]);
%             for iTask = 1:length(ControlTasks)
%                 for iEpoch = 1:length(ControlEpochs)
%                     Tuning = sessFieldTuning(Session{iSess},...
%                         ControlTasks{iTask},ControlEpochs{iEpoch});
%                     Anova = sessFieldAnova(Session{iSess},...
%                         ControlTasks{iTask},ControlEpochs{iEpoch});
%                     ControlTuning = setfield(ControlTuning,{1},...
%                         ControlTasks{iTask},{1},...
%                         ControlEpochs{iEpoch},'Tuning',Tuning);
%                     ControlTuning = setfield(ControlTuning,{1},...
%                         ControlTasks{iTask},{1},...
%                         ControlEpochs{iEpoch},'Anova',Anova);
%                 end
%             end
%             ControlTuning.Session = Session{iSess};
%             FieldSession.ControlTuning(iSess) = ControlTuning;
%         end
%         ControlTuning = FieldSession.ControlTuning;
%     else
%         for iSess = 1:length(SessNum)
%             ControlTuning = struct([]);
%             for iTask = 1:length(ControlTasks)
%                 for iEpoch = 1:length(ControlEpochs)
%                     Tuning = sessFieldTuning(Session{SessNum(iSess)},...
%                         ControlTasks{iTask},ControlEpochs{iEpoch});
%                     Anova = sessFieldAnova(Session{SessNum(iSess)},...
%                         ControlTasks{iTask},ControlEpochs{iEpoch});
%                     ControlTuning = setfield(ControlTuning,{1},...
%                         ControlTasks{iTask},{1},...
%                         ControlEpochs{iEpoch},'Tuning',Tuning);
%                     ControlTuning = setfield(ControlTuning,{1},...
%                         ControlTasks{iTask},{1},...
%                         ControlEpochs{iEpoch},'Anova',Anova);
%                 end
%             end
%             ControlTuning.Session = Session{SessNum(iSess)};
%             FieldSession.ControlTuning(SessNum(iSess)) = ControlTuning;
%             save([MONKEYDIR '/mat/Field_ControlTuning.mat'],'ControlTuning');
%         end
%         ControlTuning = FieldSession.ControlTuning;
%     end
% else
%     ControlTuning = struct([]);
%     for iSess = 1:length(Session)
%         for iTask = 1:length(ControlTasks)
%             for iEpoch = 1:length(ControlEpochs)
%                 Tuning = sessFieldTuning(Session{iSess},...
%                     ControlTasks{iTask},ControlEpochs{iEpoch});
%                 Anova = sessFieldAnova(Session{iSess},...
%                     ControlTasks{iTask},ControlEpochs{iEpoch});
%                 ControlTuning = setfield(ControlTuning,{1},...
%                     ControlTasks{iTask},{1},...
%                     ControlEpochs{iEpoch},'Tuning',Tuning);
%                 ControlTuning = setfield(ControlTuning,{1},...
%                     ControlTasks{iTask},{1},...
%                     ControlEpochs{iEpoch},'Anova',Anova);
%             end
%         end
%         ControlTuning.Session = Session{iSess};
%         FieldSession.ControlTuning(iSess) = ControlTuning;
%         save([MONKEYDIR '/mat/Field_ControlTuning.mat'],'ControlTuning');
%     end
%     ControlTuning = FieldSession.ControlTuning;
% end
% 
% save([MONKEYDIR '/mat/Field_ControlTuning.mat'],'ControlTuning');
% 
