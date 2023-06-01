function updateSpikeField_Figs(SessNum)
%
%   updateSpikeField_Figs(SessNum)
%
% MINSPIKEFIELDTRIALS = 50;

global MONKEYDIR CONTROLTASKLIST

MINSPIKEFIELDTRIALS = 50;

if isfile([MONKEYDIR '/mat/SpikeField_Session.mat']);
    load([MONKEYDIR '/mat/SpikeField_Session.mat']);
    load([MONKEYDIR '/mat/FieldField/FieldField_NumTrials.mat'])
    if nargin > 0  %  Input session numbers
        for iTask = 1:length(CONTROLTASKLIST)
            eval(['Num = NumTrials(iSess).' CONTROLTASKLIST{iTask} ';'])
            SysString = [Session{SessNum}{3}{1} Session{SessNum}{3}{2}];
            disp([SysString '_SF_' num2str(Session{SessNum}{6}(1)) '_' num2str(Session{SessNum}{6}(2)) '_' CONTROLTASKLIST{iTask}])
            fileEPS = fullfile(MONKEYDIR, 'fig', 'SpikeField', [SysString '_SF_' num2str(Session{SessNum}{6}(1)) ...
                '_' num2str(Session{SessNum}{6}(2)) '_' CONTROLTASKLIST{iTask} '.eps']);
            filePDF = fullfile(MONKEYDIR, 'fig', 'SpikeField', [SysString '_SF_' num2str(Session{SessNum}{6}(1)) ...
                '_' num2str(Session{SessNum}{6}(2)) '_' CONTROLTASKLIST{iTask} '.pdf']);
            fileJPG = fullfile(MONKEYDIR, 'fig', 'SpikeField', [SysString '_SF_' num2str(Session{SessNum}{6}(1)) ...
                '_' num2str(Session{SessNum}{6}(2)) '_' CONTROLTASKLIST{iTask} '.jpg']);
            if Num > MINFIELDFIELDTRIALS && ~isfile(fileEPS)
                sessPrintSFCoh(Session{SessNum},CONTROLTASKLIST{iTask})
                print(gcf,'-depsc2',fileEPS)
                cmd = ['LD_LIBRARY_PATH= epstopdf --outfile=' filePDF ' ' fileEPS];
                unix(cmd);
                saveas(gcf,fileJPG,'jpg')
                close all
            elseif isfile(fileEPS)
                disp([fileEPS ' exists']);
            end
        end
    else
        for iSess = 1:length(Session)
            for iTask = 1:length(CONTROLTASKLIST)
                eval(['Num = NumTrials(iSess).' CONTROLTASKLIST{iTask} ';'])
                SysString = [Session{iSess}{3}{1} Session{iSess}{3}{2}];
                disp([SysString '_SF_' num2str(Session{iSess}{6}(1)) '_' num2str(Session{iSess}{6}(2)) '_' CONTROLTASKLIST{iTask}])
                fileEPS = fullfile(MONKEYDIR, 'fig', 'SpikeField', [SysString '_SF_' num2str(Session{iSess}{6}(1)) ...
                    '_' num2str(Session{iSess}{6}(2)) '_' CONTROLTASKLIST{iTask} '.eps']);
                filePDF = fullfile(MONKEYDIR, 'fig', 'SpikeField', [SysString '_SF_' num2str(Session{iSess}{6}(1)) ...
                    '_' num2str(Session{iSess}{6}(2)) '_' CONTROLTASKLIST{iTask} '.pdf']);
                fileJPG = fullfile(MONKEYDIR, 'fig', 'SpikeField', [SysString '_SF_' num2str(Session{iSess}{6}(1)) ...
                    '_' num2str(Session{iSess}{6}(2)) '_' CONTROLTASKLIST{iTask} '.jpg']);
                if Num > MINSPIKEFIELDTRIALS && ~isfile(fileEPS)
                    sessPrintSFCoh(Session{iSess},CONTROLTASKLIST{iTask})
                    print(gcf,'-depsc2',fileEPS)
                    cmd = ['LD_LIBRARY_PATH= epstopdf --outfile=' filePDF ' ' fileEPS];
                    unix(cmd);
                    saveas(gcf,fileJPG,'jpg')
                    close all
                elseif isfile(fileEPS)
                    disp([fileEPS ' exists']);
                end
            end
        end
    end
else
    disp('No SpikeField_Session.mat file');
end



