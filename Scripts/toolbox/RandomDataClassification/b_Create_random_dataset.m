% Description:
% This code simulates random datasets and associates a label vector to the
% data. The generated datasets are then used in the rest of the toolbox.
%
% by:
% Etienne Combrisson(1,2) [PhD student] / Contact: etienne.combrisson@inserm.fr 
% Karim Jerbi (1,3) [PhD, Assistant Professor] 
% 1 DYCOG Lab, Lyon Neuroscience Research Center, INSERM U1028, UMR 5292, University Lyon I, Lyon, France
% 2 Center of Research and Innovation in Sport, Mental Processes and Motor Performance, University of Lyon I, Lyon, France
% 3 Psychology Department, University of Montreal, QC, Canada
%
% Version 1.0
% Created: 21/10/2014
% Latest update: - 22/10/14
%
%--------------------------------------------------------------------------

close all;
clear all;
clc;

%% 1 - Parameters to define:

Nbepoch = 500;
NbClass = 2;
Ndataset = 100;
RdmIndex = 6; %(For reproducibility) 
path = 'C:\Users\Etienne Combrisson\Dropbox\INSERM\Classification\Function\18 Simulation Nb essais\Toolbox Simulation\';
%path = 'E:\Karim\kj matlab code\Etienne\Toolbox Simulation\'; % Set the path to the Toolbox Simulation folder here (This will be something like: C:\...\Toolbox Simulation\')

%% 2 - Construction of data & label vector:

% Rdm index (reproductibility):
rng(RdmIndex,'twister'); % 4 classes

% Create sample data:
x = [];
for k=1:NbClass
    x = [x;randn(Nbepoch/NbClass,Ndataset);];
end

% Create label data:
y = [];
for k=1:NbClass
    y = [y;k.*ones(Nbepoch/NbClass,1)];
end

% Randomize data:
rngindex = randperm(length(y));
x = x(rngindex,:);
y = y(rngindex);

%% 3 - Save datasets:

Name = ['RandomDataset' num2str(Ndataset) '_Nbclass' num2str(NbClass)];
save([path Name],'x','y','RdmIndex')