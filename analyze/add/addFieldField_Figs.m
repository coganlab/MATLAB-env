function addFieldField_Figs(SessNum)
%
%   addFieldField_Figs(SessNum)
%
% MINFIELDFIELDTRIALS = 30;

global MONKEYDIR CONTROLTASKLIST

MINFIELDFIELDTRIALS = 30;


if isfile([MONKEYDIR '/mat/FieldField_Session.mat']);
    load([MONKEYDIR '/mat/FieldField_Session.mat']);
    for iTask = 1:length(CONTROLTASKLIST)
        eval(['Num = Session{SessNum}{7}.' CONTROLTASKLIST{iTask} ';'])
        SysString = [Session{SessNum}{3}{1} Session{SessNum}{3}{2}];
        fileEPS = fullfile(MONKEYDIR ,'fig','FieldField',[SysString '_FF_' num2str(Session{SessNum}{6}(1)) '_' num2str(Session{SessNum}{6}(2)) '_' CONTROLTASKLIST{iTask} '.eps']);
        filePDF = fullfile(MONKEYDIR ,'fig','FieldField',[SysString '_FF_' num2str(Session{SessNum}{6}(1)) '_' num2str(Session{SessNum}{6}(2)) '_' CONTROLTASKLIST{iTask} '.pdf']);
        if Num > MINFIELDFIELDTRIALS;
            sessPrintFFCoh(Session{SessNum},CONTROLTASKLIST{iTask})
            print(gcf,'-depsc2',fileEPS)
            cmd = ['LD_LIBRARY_PATH= epstopdf --outfile=' filePDF ' ' fileEPS];
            unix(cmd);
            close all
        end
    end
else
    disp('No FieldField_Session.mat file');
end



