function updateFieldField_Figs(SessNum)
%
%   updateFieldField_Figs(SessNum)
%
% MINFIELDFIELDTRIALS = 30;


global MONKEYDIR CONTROLTASKLIST

MINFIELDFIELDTRIALS = 30;
Session = loadFieldField_Database;
PossibleTasks={'DelReachFix','DelSaccadeTouch','DelReachSaccade','DelReach','DelSaccade','DelSaccadethenReach','MemoryReachSaccade'};
AnalParams = [];
CondParams.Field = 'TargsOn';

if isfile([MONKEYDIR '/mat/FieldField_Session.mat']);
    FieldFieldSession = load([MONKEYDIR '/mat/FieldField_Session.mat']);
    Session = FieldFieldSession.Session;
    load([MONKEYDIR '/mat/FieldField/FieldField_NumTrials.mat'])
    if nargin > 0  %  Input session numbers
        for iSess = 1:length(SessNum)
            for iTask = 1:length(CONTROLTASKLIST)
                eval(['Num = NumTrials(SessNum(iSess)).' CONTROLTASKLIST{iTask} ';'])
                if Num > MINFIELDFIELDTRIALS
                    CondParams.Task = CONTROLTASKLIST{iTask};
                    sessPrintFFCohChoice(Session{SessNum(iSess)},CONTROLTASKLIST{iTask});
                    SysString = [Session{SessNum(iSess)}{3}{1} Session{SessNum(iSess)}{3}{2}];
                    disp([SysString '_FF_' num2str(Session{SessNum(iSess)}{6}(1)) '_' num2str(Session{SessNum(iSess)}{6}(2)) '_' CONTROLTASKLIST{iTask}])
                    fileEPS = fullfile(MONKEYDIR ,'fig','FieldField/Choice',[SysString '_FF_' ...
                        num2str(Session{SessNum(iSess)}{6}(1)) '_' ...
                        num2str(Session{SessNum(iSess)}{6}(2)) '_' CONTROLTASKLIST{iTask} '.eps']);
                    filePDF = fullfile(MONKEYDIR ,'fig','FieldField/Choice',[SysString '_FF_' ...
                        num2str(Session{SessNum(iSess)}{6}(1)) '_' ...
                        num2str(Session{SessNum(iSess)}{6}(2)) '_' CONTROLTASKLIST{iTask} '.pdf']);
                    fileJPG = fullfile(MONKEYDIR ,'fig','FieldField/Choice',[SysString '_FF_' ...
                        num2str(Session{SessNum(iSess)}{6}(1)) '_' ...
                        num2str(Session{SessNum(iSess)}{6}(2)) '_' CONTROLTASKLIST{iTask} '.jpg']);
                    saveas(gcf,fileJPG,'jpg')
                    print(gcf,'-depsc2',fileEPS)
                    cmd = ['LD_LIBRARY_PATH= epstopdf --outfile=' filePDF ' ' fileEPS];
                    unix(cmd);
                    close all
                end
            end
        end
    else
        for iSess = 1:length(Session)
            for iTask = 1:length(CONTROLTASKLIST)
                eval(['Num = NumTrials(iSess).' CONTROLTASKLIST{iTask} ';'])
                if Num > MINFIELDFIELDTRIALS
                    SysString = [Session{iSess}{3}{1} Session{iSess}{3}{2}];
                    if ~isfile([MONKEYDIR '/fig/FieldField/SysString' '_FF_' num2str(Session{iSess}{6}(1)) '_' num2str(Session{iSess}{6}(2)) '_' CONTROLTASKLIST{iTask} '.eps']);
                        CondParams.Task = CONTROLTASKLIST{iTask};
                        sessPrintFFCohChoice(Session{iSess},CONTROLTASKLIST{iTask});
                        fileEPS = fullfile(MONKEYDIR ,'fig','FieldField/Choice',[SysString '_FF_' ...
                            num2str(Session{iSess}{6}(1)) '_' num2str(Session{iSess}{6}(2)) ...
                            '_' CONTROLTASKLIST{iTask} '.eps']);
                        filePDF = fullfile(MONKEYDIR ,'fig','FieldField/Choice',[SysString '_FF_' ...
                            num2str(Session{iSess}{6}(1)) '_' num2str(Session{iSess}{6}(2)) ...
                            '_' CONTROLTASKLIST{iTask} '.pdf']);
                        fileJPG = fullfile(MONKEYDIR ,'fig','FieldField/Choice',[SysString '_FF_' ...
                            num2str(Session{iSess}{6}(1)) '_' num2str(Session{iSess}{6}(2)) ...
                            '_' CONTROLTASKLIST{iTask} '.jpg']);
                        saveas(gcf,fileJPG,'jpg')
                        print(gcf,'-depsc2',fileEPS)
                        cmd = ['LD_LIBRARY_PATH= epstopdf --outfile=' filePDF ' ' fileEPS];
                        unix(cmd);
                        close all
                    end
                end
            end
        end
    end
else
    disp('No FieldField_Session.mat file');
end



