% D32 Conference 053119
global RECONDIR
RECONDIR='C:/Users/gcoga/Box/EcoG_Recon' % this is the directory with your recons
addpath(genpath(['c:/Users/gcoga/Box/EcoG_Recon/matlab_code/'])); % this is the matlab code directory

% plot all electrodes

cfg.hemisphere='l';
plot_subj('D32',cfg)

elecs=list_electrodes('D32'); % get electrode listing/names for subject
grouping=zeros(length(elecs),1);

% set up groups of ictal activity

elecsIctalOnset={'D32-LMMT1','D32-LMMT2','D32-LMMT3','D32-LMMT4','D32-LMMT5',...
    'D32-LPMT1','D32-LPMT2','D32-LPMT3','D32-LPMT4'};

elecsIctalEarly={'D32-LPIF1','D32-LPIF2','D32-LPIF3'};

elecsIctalLate={'D32-LAMT1','D32-LAMT2','D32-LAMT3',...
    'D32-LAI1','D32-LAI2','D32-LAI3','D32-LAI4','D32-LAI5',...
    'D32-LPI4','D32-LPI5','D32-LPI6','D32-LPI7','D32-LPI8'};

% color code groups

% Onset
for iElecs=1:length(elecs)
    for iOnset=1:length(elecsIctalOnset)
        if strcmp(elecs{iElecs},elecsIctalOnset{iOnset})
            grouping(iElecs)=1; % 1 = red
        end
    end
    
% Early    
    for iEarly=1:length(elecsIctalEarly)
        if strcmp(elecs{iElecs},elecsIctalEarly{iEarly})
            grouping(iElecs)=5; % 5 = orange
        end
    end

% Late    
    for iLate=1:length(elecsIctalLate)
        if strcmp(elecs{iElecs},elecsIctalLate{iLate})
            grouping(iElecs)=2; % 2 = green
        end
    end
end
% not active
iiNotActive=find(grouping==0);
grouping(iiNotActive)=21; % 20 = grey, 21 = white

% plot with electrode grouping
plot_subj_grouping(elecs,grouping,cfg);