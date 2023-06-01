% Description:
% This code computes and plots decoding accuracy as function of sample size
% for all datasets, using a Linear Discriminant Analysis (LDA).
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

RangeEpoch = (20:8:500); 
NbClass = 2; % Nb of classes
Ndataset = 100; % Nb of dataset
repetitions = 1; % Nb of repetitions for the cross-validation
cross_type = 'k'; % Type of cross-validation
cross_nb = 10; % Number of folds 
% Here, it's a 1 time 10-fold cross-validation

%% 2 - Load the dataset

% indicate here the location of the Folder that contains the simulated data
path = 'E:\Karim\kj matlab code\Etienne\Toolbox Simulation\'; 
%path = 'C:\Users\Etienne Combrisson\Dropbox\INSERM\Classification\Function\18 Simulation Nb essais\Toolbox Simulation\';
load([path 'RandomDataset' num2str(Ndataset) '_Nbclass' num2str(NbClass)]);

%% 3 - Run classification:

for i=1:Ndataset
    display(['Dataset: ' num2str(i)])
    for k = 1:length(RangeEpoch)
        percent(k,i) = ClassifyLDA(x(1:RangeEpoch(k),i),y(1:RangeEpoch(k)),cross_type,cross_nb,repetitions);
        clc;
    end
end

%% 4 - Plot results:

% Plot decoding for all dataset:
plot(RangeEpoch,percent','.');
% Plot a decoding example (black line filled)
PlotExample = 7;
hold on, plot(RangeEpoch,percent(:,PlotExample),'color','k','linewidth',2)
xlabel('Sample size'),ylabel('Correct classification rate (%)')
title(['Decoding rates as a function of sample size when applied to random data sets, Nb classes: ' num2str(NbClass)  ', Crosval ' cross_type ', Dataset=' num2str(Ndataset)])
axis tight
hold on
% Plot the chance level
ChanceLevel = 100/length(unique(y));
plot(RangeEpoch,ChanceLevel.*ones(size(RangeEpoch)),'--','linewidth',2,'color','k')
ylim([0 100])
