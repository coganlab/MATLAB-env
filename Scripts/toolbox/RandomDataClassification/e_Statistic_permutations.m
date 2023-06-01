% Description:
% This code computes and plots the statistical chance level using 
% permutations, depending of the number of trials. This code can be very
% long to run, depending on the required p-value levels (i.e. which is related to the number of permutations needed).
%
% by:
% Etienne Combrisson (1,2) [PhD student] / Contact: etienne.combrisson@inserm.fr 
% Karim Jerbi (1,3) [PhD, Assistant Professor] 
% 1 DYCOG Lab, Lyon Neuroscience Research Center, INSERM U1028, UMR 5292, University Lyon I, Lyon, France
% 2 Center of Research and Innovation in Sport, Mental Processes and Motor Performance, University of Lyon I, Lyon, France
% 3 Psychology Department, University of Montreal, QC, Canada
%
% Version 1.0
% Created: 21/10/2014
% Latest update: - 23/10/14
%
%--------------------------------------------------------------------------
close all;
clear all;
clc;

%% 1 - Parameters:

NbClass = 2; % Number of class
RangeEpoch = (20:8:500);
Ndataset = 100;
p = [0.01 0.001 0.0001]; % required p-value thresholds of interest. Obviosuly, the smaller the required p-value the higher the number of permutations will be.

repetitions = 1; % Nb of repetitions for the cross-validation
cross_type = 'k'; % Type of cross-validation
cross_nb = 10; % Number of folds in the K-fold cross-validation (10 indicated a 10-fold cross-validation) 
% The default parameters here indicate: a 10-fold cross-validation, repeated only once.

%% 2 - Load the dataset

% indicate here the location of the Folder that contains the simulated data
path = 'E:\Karim\kj matlab code\Etienne\Toolbox Simulation\'; 
%path = 'C:\Users\Etienne Combrisson\Dropbox\INSERM\Classification\Function\18 Simulation Nb essais\Toolbox Simulation\';
load([path 'RandomDataset' num2str(Ndataset) '_Nbclass' num2str(NbClass)]);

%% 3 - Launch the classification:

permutations = 1/min(p);
for i=1:Ndataset
    display(['-> Dataset: ' num2str(i)])

    percent(1,i) = ClassifyLDA(x(:,i),y,cross_type,cross_nb,repetitions);
    
    for k=1:permutations
        display(['  -> Permutations :' num2str(k)])
        rng_idx = randi([6000 8000],1,1);
        rng(k,'twister')
        
        y_perm = y(randperm(length(y)));
        for j=1:length(RangeEpoch)
            percent_perm(k,i,j) = ClassifyLDA(x(1:RangeEpoch(j),i),y_perm(1:RangeEpoch(j)),cross_type,cross_nb,repetitions);
        end
    end
    clc;
end

%% 4 - Analyse the data:

ChanceLevel = 100/length(unique(y));
PercDatasetsM = squeeze(mean(percent_perm,2));
for i=1:size(percent_perm,2)
    display(['Dataset: ' num2str(i)])

    for j=1:length(RangeEpoch)
        CurPercPerm = sort(squeeze(percent_perm(:,i,j)));
        [u,~] = find(percent(i) < CurPercPerm);
        for k=1:length(p)
            LegStr{k} = ['p<' num2str(p(k))];
            Nperm = p(k)*permutations;
            DA(i,j,k) = CurPercPerm(end-Nperm+1);
        end
    end
    clc;
end

DAm = squeeze(mean(DA,1));

%% 5 - Plot results:

plot(RangeEpoch,DAm,'.','MarkerSize',12)
legend(LegStr),axis tight
xlabel('Trial Number'),ylabel('Statistical chance level')
title(['Permutations ' num2str(NbClass) ' classes'])
hold on
plot(RangeEpoch,ChanceLevel.*ones(size(RangeEpoch)),'--','linewidth',2,'color','k')
ylim([0 100])
