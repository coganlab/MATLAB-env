function updateSpike_ControlTuning(SessNum)
%
%   updateSpike_ControlTuning(SessNum)
%
%   Saves ControlTuning data structure to Spike Session file
%

global MONKEYDIR TASKLIST CONTROLTASKLIST

ControlTasks = CONTROLTASKLIST;
%ControlTasks = {'DelReachSaccade','DelReachFix','DelSaccadeTouch','DelSaccade','DelReach'};
ControlEpochs = {'Cue','Delay','Movement','PostMovement'};
Session = Spike_Database;

if nargin == 0
    for iSess = 1:length(Session)
        if isfile([MONKEYDIR '/mat/Spike/Spike_ControlTuning.' num2str(iSess) '.mat']);
            %no need to recompute
            disp(['Spike_ControlTuning.' num2str(iSess) '.mat already exists'])
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
            save([MONKEYDIR '/mat/Spike/Spike_ControlTuning.' num2str(iSess) '.mat'],'ControlTuning');
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
        save([MONKEYDIR '/mat/Spike/Spike_ControlTuning.' num2str(SessNum(iSess)) '.mat'],'ControlTuning');
    end
end
% 
% 
% % OLD updateSpike_ControlTuning code
% 
% if isfile([MONKEYDIR '/mat/Spike_ControlTuning.mat']);
%     SpikeSession = load([MONKEYDIR '/mat/Spike_ControlTuning.mat']);
%     for iSess = length(SpikeSession.ControlTuning)+1:length(Session)
%         ControlTuning = struct([]);
%         for iTask = 1:length(ControlTasks)
%             for iEpoch = 1:length(ControlEpochs)
%                 Tuning = sessSpikeTuning(Session{iSess},...
%                     ControlTasks{iTask},ControlEpochs{iEpoch});
%                 Anova = sessSpikeAnova(Session{iSess},...
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
%         SpikeSession.ControlTuning(iSess) = ControlTuning;
%         save([MONKEYDIR '/mat/Spike_ControlTuning.mat'],'ControlTuning');
%     end
%     ControlTuning = SpikeSession.ControlTuning;
% else
%     ControlTuning = struct([]);
%     for iSess = 1:length(Session)
%         for iTask = 1:length(ControlTasks)
%             for iEpoch = 1:length(ControlEpochs)
%                 Tuning = sessSpikeTuning(Session{iSess},...
%                     ControlTasks{iTask},ControlEpochs{iEpoch});
%                 Anova = sessSpikeAnova(Session{iSess},...
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
%         SpikeSession.ControlTuning(iSess) = ControlTuning;
%         save([MONKEYDIR '/mat/Spike_ControlTuning.mat'],'ControlTuning');
%     end
%     ControlTuning = SpikeSession.ControlTuning;
% end
% 
% save([MONKEYDIR '/mat/Spike_ControlTuning.mat'],'ControlTuning');
% 
