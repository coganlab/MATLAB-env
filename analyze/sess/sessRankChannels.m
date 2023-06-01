function [ranks,values]=sessRankChannels(sess,comp,jnt_file)
%
% function [ranks]=sessRankChannels(sess,comp)
%
% Adds text and fits it into the specified limits of endxpos.
%
% Inputs: sess = session string
%           comp - string, comparator type to use.
% Outputs: array of ranked channels
global MONKEYDIR

if(nargin < 2) 
        jnt_file = 'Calvin_130506';
end

recPath = [MONKEYDIR '/' sess{1} '/' sess{2}{1}];
load([recPath '/rec' sess{2}{1} '.experiment.mat']);
towers = experiment.hardware.microdrive;
if (length(towers) == 5)
    towers = towers(1:4);
end
ranks = [];
switch comp
    case 'Vpp'
        tmp = [];
        for i = 1:length(towers)
            tower = towers(i).name;
            filename = [MONKEYDIR '/' sess{1} '/' sess{2}{1} '/rec' sess{2}{1} '.' tower '.sp.mat' ];
            load(filename)
            for iCh = 1:length(sp)
                spikes = sp{iCh};
                m_wave = mean(spikes(:,2:end));
                tmp(iCh+(i-1)*32) = max(m_wave)-min(m_wave);
            end
        end
    case 'wSNR'
        tmp = [];
        for i = 1:length(towers)
            tower = towers(i).name;
            filename = [MONKEYDIR '/' sess{1} '/' sess{2}{1} '/rec' sess{2}{1} '.' tower '.sp.mat' ];
            load(filename)     
            for iCh = 1:length(sp)
                spikes = sp{iCh};
%                 figure
%                 plot(spikes(:,2:end)')
%                 pause
                m_wave = mean(spikes(:,2:end));
                sdWaveform = spikes(:,2:end) - m_wave(ones(1,size(spikes,1)),:);
                sd = std(sdWaveform(:));
                tmp(iCh+(i-1)*32) = (max(m_wave)-min(m_wave))./(2*sd);
            end
        end
    case 'aSNR'
        tmp = [];
        for i = 1:length(towers)
            tower = towers(i).name;
            filename = [MONKEYDIR '/' sess{1} '/' sess{2}{1} '/rec' sess{2}{1} '.' tower '.sp.mat' ];
            load(filename)     
            for iCh = 1:length(sp)
                spikes = sp{iCh};
%                 figure
%                 plot(spikes(:,2:end)')
%                 pause
                m_wave = mean(spikes(:,2:end));
                sd = std(spikes(:,end));
                tmp(iCh+(i-1)*32) = (max(m_wave)-min(m_wave))./(2*sd);
            end
        end
    case 'PCA'
        tmp = [];
        for i = 1:length(towers)
            tower = towers(i).name;
            filename = [MONKEYDIR '/' sess{1} '/' sess{2}{1} '/rec' sess{2}{1} '.' tower '.sp.mat' ];
            load(filename)     
            for iCh = 1:length(sp)
                spikes = sp{iCh};
                [pc,scorestmp,latenttmp] = princomp(spikes(1:min([2e3,end]),2:end));
                 U = spikes(1:min([2e3,end]),2:end)*pc;
                p = 0;
                if(p)
                    figure
                    plot(U(:,1),U(:,2),'kx')
                    title([tower ' ' ,num2str(iCh)])
                    pause
                end
                var1 = std(U(:,1));
                var2 = std(U(:,2));
                var3 = std(U(:,3));
                tmp(iCh+(i-1)*32) = (var1/var2)+(var1/var3);
            end
        end
    case 'Tuning'
        tmp = [];
        for i = 1:length(towers)
            tower = towers(i).name;
            for iCh = 1:32
                filename = [MONKEYDIR '/mat/Decode/Joints/' jnt_file '/Tuning/Spike/PCAJointKarma.Sess' num2str(sess{4}) '_' tower '_' num2str(iCh) '_PCA26Lag10.mat']
                load(filename)
                tmp(iCh+(i-1)*32) = max(nanmean([Results.Joint(1).PCA.CorrCoef;Results.Joint(2).PCA.CorrCoef]));
            end
        end
    case 'LFPTuning'
        tmp = [];
        for i = 1:length(towers)
            tower = towers(i).name;
            for iCh = 1:32
                filename = [MONKEYDIR '/mat/Decode/Joints/' jnt_file '/Tuning/LFP/PCAJointKarma.Sess' num2str(sess{4}) '_' tower '_' num2str(iCh) '_PCA26Lag10.mat']
                load(filename)
                tmp(iCh+(i-1)*32) = max(nanmean([Results.Joint(1).PCA.CorrCoef;Results.Joint(2).PCA.CorrCoef]));
            end
        end
    otherwise
        disp('Comparator not found')
end

[dum,ranks] = sort(tmp,2,'descend');
values = tmp;