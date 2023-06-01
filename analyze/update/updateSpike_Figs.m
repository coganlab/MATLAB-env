function updateSpike_Figs(SessNum)
%
%   updateSpike_Figs(SessNum)
%
%   Calls sessPrintPSTH for each new field and saves the resulting
%   figure in fig/PSTHs

global MONKEYDIR CONTROLTASKLIST

Session = Spike_Database;

if isfile([MONKEYDIR '/mat/Spike_Session.mat']);  %  Running when previously saved
    SpikeSession = load([MONKEYDIR '/mat/Spike_Session.mat']);
    SpikeSession = SpikeSession.Session; % due to matlab's way of loading
    load([MONKEYDIR '/mat/Spike/Spike_NumTrialsConds.mat'])
    if nargin > 0  %  Input session numbers
        for iSess=1:length(SessNum)
            for iTask = 1:length(CONTROLTASKLIST)
                %Num = SpikeSession{SessNum(iSess)}{7}.(CONTROLTASKLIST{iTask});
                eval(['Num = NumTrialsConds(SessNum(iSess)).' CONTROLTASKLIST{iTask} ';'])
                if sum(sum(sum(Num))) >29
                    sessPrintPSTH(SpikeSession{SessNum(iSess)},CONTROLTASKLIST{iTask});
                    fileEPS = fullfile(MONKEYDIR,'fig','PSTHs',['PSTHSess' num2str(SessNum(iSess)) CONTROLTASKLIST{iTask} '.eps']);
                    filePDF = fullfile(MONKEYDIR,'fig','PSTHs',['PSTHSess' num2str(SessNum(iSess)) CONTROLTASKLIST{iTask} '.pdf']);
                    print(gcf,'-depsc2',fileEPS);
                    cmd = ['LD_LIBRARY_PATH= epstopdf --outfile=' filePDF ' ' fileEPS];
                    unix(cmd);
                    close all
                else % If number of trials is less than 30
                    disp('Oops!!!!! Too few trials');
                
                end
            end
        end
    else
        SpikeSession = load([MONKEYDIR '/mat/Spike_Session.mat']);% xtra
        SpikeSession = SpikeSession.Session; % due to matlab's way of loading
        
        for iSess =  1:length(SpikeSession)
            disp(['Length of SpikeSession is;' num2str(length(SpikeSession))]);
            disp(['Processing Spike Session: ' num2str(iSess)]);
            for iTask = 1:length(CONTROLTASKLIST)
                eval(['Num = NumTrialsConds(iSess).' CONTROLTASKLIST{iTask} ';'])
                if sum(sum(sum(Num))) > 29
                    fileEPS = fullfile(MONKEYDIR,'fig','PSTHs',['PSTHSess' num2str(iSess) CONTROLTASKLIST{iTask} '.eps']);
                    filePDF = fullfile(MONKEYDIR,'fig','PSTHs',['PSTHSess' num2str(iSess) CONTROLTASKLIST{iTask} '.pdf']);
                    if ~isfile(fileEPS)
                        sessPrintPSTH(SpikeSession{iSess},CONTROLTASKLIST{iTask})
                        print(gcf,'-depsc2',fileEPS);
                        cmd = ['LD_LIBRARY_PATH= epstopdf --outfile=' filePDF ' ' fileEPS];
                        unix(cmd);
                        close all
                    else
                        disp([fileEPS ' exists']);
                    end
                else % If number of trials is less than 30
                disp('Oops!!!!! Too few trials');
                end
            end
        end
    end
else
    %We actually need updateSpike_NumTrials to have run
end



