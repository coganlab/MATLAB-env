% Description:
% This code add the folder, where your toolbox is the located, to the
% Matlab default path.

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

% Path where the toolbox is located:
path = 'C:\Users\ECmb\RandomDataClassification';
addpath(genpath(path))