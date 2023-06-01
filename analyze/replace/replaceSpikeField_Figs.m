function replaceSpikeField_Figs(SessNum)
%
%   replaceSpikeField_Figs(SessNum)
%
%  Input:  SessNum = Scalar.  Index the SpikeField_Session variable
%                       (Optional)
%  
%  Note:  replaceSpikeField_Figs(SessNum) is the same as
%  updateSpikeField_Figs except that it doesn't check if the file is
%  already present
%  

global MONKEYDIR CONTROLTASKLIST

MINSPIKEFIELDTRIALS = 50;

if isfile([MONKEYDIR '/mat/SpikeField_Session.mat']);
    load([MONKEYDIR '/mat/SpikeField_Session.mat']);
    if nargin > 0  %  Input session numbers
        for iTask = 1:length(CONTROLTASKLIST)
            eval(['Num = Session{SessNum}{7}.' CONTROLTASKLIST{iTask} ';'])
            if Num > MINSPIKEFIELDTRIALS;
                SysString = [Session{SessNum}{3}{1} Session{SessNum}{3}{2}];
                fileEPS = fullfile(MONKEYDIR, 'fig', 'SpikeField', [SysString '_SF_' num2str(Session{SessNum}{6}(1)) '_' num2str(Session{SessNum}{6}(2)) '_' CONTROLTASKLIST{iTask} '.eps']);
                filePDF = fullfile(MONKEYDIR, 'fig', 'SpikeField', [SysString '_SF_' num2str(Session{SessNum}{6}(1)) '_' num2str(Session{SessNum}{6}(2)) '_' CONTROLTASKLIST{iTask} '.pdf']);
                sessPrintSFCoh(Session{SessNum},CONTROLTASKLIST{iTask})
                print(gcf,'-depsc2',fileEPS)
                cmd = ['LD_LIBRARY_PATH= epstopdf --outfile=' filePDF ' ' fileEPS];
                unix(cmd);
                close all
            end
        end
    else
        for iSess = 1:length(Session)
            for iTask = 1:length(CONTROLTASKLIST)
                eval(['Num = Session{iSess}{7}.' CONTROLTASKLIST{iTask} ';'])
                if Num > MINSPIKEFIELDTRIALS;
                    SysString = [Session{iSess}{3}{1} Session{iSess}{3}{2}];
                    fileEPS = fullfile(MONKEYDIR, 'fig', 'SpikeField', [SysString '_SF_' num2str(Session{iSess}{6}(1)) '_' num2str(Session{iSess}{6}(2)) '_' CONTROLTASKLIST{iTask} '.eps']);
                    filePDF = fullfile(MONKEYDIR, 'fig', 'SpikeField', [SysString '_SF_' num2str(Session{iSess}{6}(1)) '_' num2str(Session{iSess}{6}(2)) '_' CONTROLTASKLIST{iTask} '.pdf']);
                    sessPrintSFCoh(Session{iSess},CONTROLTASKLIST{iTask})
                    print(gcf,'-depsc2',fileEPS)
                    cmd = ['LD_LIBRARY_PATH= epstopdf --outfile=' filePDF ' ' fileEPS];
                    unix(cmd);
                    close all
                end
            end
        end
    end
else
    disp('No SpikeField_Session.mat file');
end



