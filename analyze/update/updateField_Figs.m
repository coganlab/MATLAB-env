function updateField_Figs(SessNum)
%
%   updateField_Figs(SessNum)
%
%   Calls sessPrintSpectrogram for each new field and saves the resulting
%   figure in fig/Fields

global MONKEYDIR CONTROLTASKLIST

MINFIELDFIELDTRIALS = 30;
Session = loadField_Database;
PossibleTasks={'DelReachFix','DelSaccadeTouch','DelReachSaccade','DelReach','DelSaccade','DelSaccadethenReach','MemoryReachSaccade'};
AnalParams = [];
CondParams.Field = 'TargsOn';

if isfile([MONKEYDIR '/mat/Field_Session.mat']);  %  Running when previously saved
    FieldSession = load([MONKEYDIR '/mat/Field_Session.mat']);
    load([MONKEYDIR '/mat/Field/Field_NumTrialsConds.mat'])
    if nargin > 0  %  Input session numbers
        for iSess=1:length(SessNum)
            for iTask = 1:length(CONTROLTASKLIST)
                eval(['Num = NumTrialsConds(SessNum(iSess)).' CONTROLTASKLIST{iTask} ';'])
                if sum(sum(sum(Num))) > 50
                    CondParams.Task = CONTROLTASKLIST{iTask};
                    sessPrintSpectrogram(FieldSession.Session{SessNum(iSess)},CondParams,AnalParams)
                                        
                    FieldSession.Session{iSess}
                    fileEPS = fullfile(MONKEYDIR,'fig','Fields',['SpecSess' num2str(SessNum(iSess)) CONTROLTASKLIST{iTask} '.eps']);
                    filePDF = fullfile(MONKEYDIR,'fig','Fields',['SpecSess' num2str(SessNum(iSess)) CONTROLTASKLIST{iTask} '.pdf']);
                    fileJPG = fullfile(MONKEYDIR,'fig','Fields',['SpecSess' num2str(SessNum(iSess)) CONTROLTASKLIST{iTask} '.jpg']);
                    saveas(gcf,fileJPG,'jpg')
                    print(gcf, '-depsc2', fileEPS);
                    cmd = ['LD_LIBRARY_PATH= epstopdf --outfile=' filePDF ' ' fileEPS];
                    unix(cmd);
                    close;
                end
            end
        end
    else
        for iSess = 1:length(Session)
            for iTask = 1:length(CONTROLTASKLIST)
                eval(['Num = NumTrialsConds(iSess).' CONTROLTASKLIST{iTask} ';'])
                if sum(sum(sum(Num))) > 50
                    FieldSession.Session{iSess}
                    if ~isfile([MONKEYDIR '/fig/Fields/SpecSess' num2str(iSess) CONTROLTASKLIST{iTask} '.eps'])
                        CondParams.Task = CONTROLTASKLIST{iTask};
                        sessPrintSpectrogram(FieldSession.Session{iSess},CondParams,AnalParams)
                        fileEPS = fullfile(MONKEYDIR,'fig','Fields',['SpecSess' num2str(iSess) CONTROLTASKLIST{iTask} '.eps']);
                        filePDF = fullfile(MONKEYDIR,'fig','Fields',['SpecSess' num2str(iSess) CONTROLTASKLIST{iTask} '.pdf']);
                        fileJPG = fullfile(MONKEYDIR,'fig','Fields',['SpecSess' num2str(iSess) CONTROLTASKLIST{iTask} '.jpg']);
                        saveas(gcf,fileJPG,'jpg')
                        print(gcf,'-depsc2',fileEPS);
                        cmd = ['LD_LIBRARY_PATH= epstopdf --outfile=' filePDF ' ' fileEPS];
                        unix(cmd);
                        close;
                    end
                end
            end
        end
    end
else
    %We actually need updateField_NumTrials to have run
end



