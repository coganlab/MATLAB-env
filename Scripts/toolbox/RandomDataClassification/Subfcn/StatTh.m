function [threshold,nbclass] = StatTh(y,alpham)
%--------------------------------------------------------------------------
% This function is used to compute a statistical threshold using the
% binomial inverse cumulative distribution
% -> INPUT VARIABLES:
% - y: label vector (Ex: y = [1 1 1 2 2 2 3 3 3 4 4 4];)
% - alpham: p-value (Ex: alpham = 0.01) 
% -> OUTPUT VARIABLES:
% - threshold: as a percentage used for decoding accuracy
% - nbclass: number of class in label vector y
%
% It calls Matlab's built-in "binoinv" function
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

if (nargin < 2)
    alpham = 0.01;
end

nbepoch = length(y);
nbclass = length(unique(y));
threshold = binoinv(1-alpham,nbepoch,1/nbclass)*100/nbepoch;