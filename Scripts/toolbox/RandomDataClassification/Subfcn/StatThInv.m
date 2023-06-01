function p = StatThInv(y,DA)
%--------------------------------------------------------------------------
% This function return the associated p-value corresponding to a label
% vector and a decoding accuracy using the binomial inverse cumulative 
% distribution
% -> INPUT VARIABLES:
% - y: label vector (Ex: y = [1 1 1 2 2 2 3 3 3 4 4 4];)
% - DA: decoding accuracy (Ex: DA = 64%) 
% -> OUTPUT VARIABLES:
% - threshold = as a percentage used for decoding accuracy
%
% It calls Matlab's built-in "binocdf" function
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

NbEpoch = length(y);
NbClass = length(unique(y));

p = 1-binocdf(NbEpoch.*DA/100,NbEpoch,1/NbClass);

