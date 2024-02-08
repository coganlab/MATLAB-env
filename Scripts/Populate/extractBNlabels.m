function [roiLabels] = extractBNlabels(roiName,hemisphere)
% EXTRACTBNLABELS Extracts Brainnetome (BN) atlas labels for a specified region of interest (ROI) and hemisphere.
%
% The function takes in a region of interest (ROI) name and hemisphere specifier,
% and returns a cell array of strings containing the corresponding BN atlas labels.
%
% Usage:
%   roiLabels = extractBNlabels('middletemporal', 'lh')
%
% Arguments:
%   roiName (string) - The name of the ROI. Supported ROIs are:
%       'middletemporal', 'superiortemporal', 'inferiortemporal', 'ipc',
%       'ifg', 'rmfg', 'cmfg', 'smc', 'insula', 'sma'.
%
%   hemisphere (string) - The hemisphere specifier. Supported values are:
%       'lh' for left hemisphere, 'rh' for right hemisphere, and 'bh' for both hemispheres.
%
% Returns:
%   roiLabels (cell array) - A cell array of strings containing the BN atlas labels for the specified ROI and hemisphere.
%
% Example:
%   roiLabels = extractBNlabels('superiortemporal', 'rh')
%   This will return labels for the superior temporal region in the right hemisphere.
%
% See also: STRCAT

% Validate input arguments (not shown in the original function)
% Here you would normally check if the inputs are valid and throw an error if not

% Switch statement to select the appropriate ROI labels based on the roiName input
switch roiName
    case 'middletemporal'
        roiLabels = {'A21c','A21r', 'A37dl', 'aSTS'};
    case 'superiortemporal'
        roiLabels = {'A38m','A41/42','TE1.0','TE1.2','A22c','A38l','A22r','rpSTS','cpSTS'};
    case 'inferiortemporal'
        roiLabels = {'A20iv','A37elv','A20r','A37elv','A20r','A20il','A37vl','A20cl', 'A20cv','A20rv','A37mv','A37lv'};
    case 'ipc'
        roiLabels = {'A39c','A39rd','A40rd','A40c','A39rv','A40rv'};
    case 'ifg'
        roiLabels = {'A44d','IFS','A45c','A45r', 'A44op', 'A44v'};
    case 'rmfg'
        roiLabels = {'A46','A10l'};
    case 'cmfg'
        roiLabels = {'IFJ','A8vl','A6vl','A9/46d','A9/46v'};
    case 'smc'
        roiLabels = {'A4hf','A6cdl','A4ul','A4t','A4tl','A6cvl','A1/2/3ll','A4ll', 'A1/2/3ulhf','A1/2/3/tonla','A2','A1/2/3tru'};
    case 'insula'
        roiLabels = {'G','vIa','dIa','vId/vIg','dIg','dId'}; %insula
    case 'sma'
        roiLabels = {'A6m','A6dl'}; %sma
end
% Switch statement to select the appropriate hemisphere based on the hemisphere input
switch hemisphere
    case 'lh'
        roiLabels = strcat(roiLabels,'_L');
    case 'rh'
        roiLabels = strcat(roiLabels,'_R');
    case 'bh'
        roiLabels = {strcat(roiLabels,'_R'), strcat(roiLabels,'_L')};
end
end

