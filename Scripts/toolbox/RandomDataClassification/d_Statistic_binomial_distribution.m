% Description:
% This code computes and plots the statistical chance level as a function of trial number using the cumulative
% binomial distribution function.
%
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

%% 1 - Parameters to define:

p = [0.01 0.001 0.0001]; % p value
RangeEpoch = (20:8:500); % Number of epoch
NbClass = 2; % Number of classes

%% 2 - Construction label's vector:

for i = 1:length(RangeEpoch)% Epoch number loop
    ytemp = [];
    for k=1:NbClass % Class number loop
        ytemp = [ytemp;k.*ones(RangeEpoch(i)/NbClass,1)];
    end
    y{i} = ytemp;
    
    clear ytemp;
end
SeuilChance = 100/length(unique(y{1}));

%% 3 - Construction of stat values:

Tab{1,3} = 'Sample size';
Tab{3,1} = 'p value';
for i = 1:length(p) % p value loop
    pStr{i} = ['p<' num2str(p(i))];
    Tab{i+2,2} = pStr{i};
    for k = 1:length(RangeEpoch) % Epoch number loop
        st(k,i) = StatTh(y{k},p(i));
        Tab{i+2,k+2} = st(k,i);
        Tab{2,k+2} = RangeEpoch(k);
    end
end

%% 4 - Plot the results

figure(1)
plot(RangeEpoch,st,'.','MarkerSize',12)
legend(pStr),axis tight
xlabel('Sample size'),ylabel('Correct classification rate (%)')
title(['Figure 3: ' num2str(NbClass) ' classes'])
hold on
plot(RangeEpoch,SeuilChance.*ones(size(RangeEpoch)),'--','linewidth',2,'color','k')
ylim([0 100])

figure(2)
Uitable = uitable('Units','Normalize',...
    'position',[0 0 1 1],...
    'data',Tab);

