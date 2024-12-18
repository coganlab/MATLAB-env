function isOk = bst_ft_init(isInteractive)
% BST_FT_INIT: Check FieldTrip installation and call ft_defaults.

% @=============================================================================
% This function is part of the Brainstorm software:
% https://neuroimage.usc.edu/brainstorm
% 
% Copyright (c)2000-2018 University of Southern California & McGill University
% This software is distributed under the terms of the GNU General Public License
% as published by the Free Software Foundation. Further details on the GPLv3
% license can be found at http://www.gnu.org/copyleft/gpl.html.
% 
% FOR RESEARCH PURPOSES ONLY. THE SOFTWARE IS PROVIDED "AS IS," AND THE
% UNIVERSITY OF SOUTHERN CALIFORNIA AND ITS COLLABORATORS DO NOT MAKE ANY
% WARRANTY, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO WARRANTIES OF
% MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, NOR DO THEY ASSUME ANY
% LIABILITY OR RESPONSIBILITY FOR THE USE OF THIS SOFTWARE.
%
% For more information type "brainstorm license" at command prompt.
% =============================================================================@
%
% Authors: Francois Tadel, 2015-2017

% Deployed: does not work
if exist('isdeployed', 'builtin') && isdeployed
    error(['FieldTrip functions cannot be called from the compiled version of Brainstorm.' 10 ...
           'We would need to compile Brainstorm and FieldTrip together. Doable but complicated.' 10 ...
           'Please post a message on the forum if you are interested in contributing.']);
end
% Default behavior
if (nargin < 1) || isempty(isInteractive)
    isInteractive = 0;
end
% Get the saved FieldTrip path
FieldTripDir = bst_get('FieldTripDir');
% Display the FieldTrip folder 
if ~isempty(FieldTripDir) && ~isInteractive
    disp(['BST> FieldTrip install: ' FieldTripDir]);
end

isOk = 0;
% If FieldTrip is not accessible in the path
if ~exist('ft_defaults', 'file')
    % If defined, add to the folder
    if ~isempty(FieldTripDir)
        addpath(FieldTripDir);
    % Else: Ask where is FieldTrip installed
    elseif isInteractive
        % Warning message
        if ~java_dialog('confirm', [...
            'This process require the FieldTrip toolbox to be installed on your computer.', 10, ...
            'Download the toolbox at: http://www.fieldtriptoolbox.org/download' 10 10 ...
            'Is FieldTrip already installed on your computer?'])
            bst_error('FieldTrip was not set up properly.', 'FieldTrip setup', 0);
            return;
        end
        % Loop until a correct folder was picked
        isStop = 0;
        while ~isStop
            % Open 'Select directory' dialog
            FieldTripDir = uigetdir(FieldTripDir, 'Select FieldTrip directory');
            % Exit if not set
            if isempty(FieldTripDir) || ~ischar(FieldTripDir)
                FieldTripDir = [];
                isStop = 1;
            elseif ~file_exist(bst_fullfile(FieldTripDir, 'ft_defaults.m'))
                bst_error('The folder you selected does not contain a valid FieldTrip installation.', 'FieldTrip setup', 0);
            else
                isStop = 1;
            end
        end
        % Nothing selected: return an error
        if isempty(FieldTripDir)
            bst_error('FieldTrip was not set up properly.', 'FieldTrip setup', 0);
            return;
        end
        % Add selected folder to Matlab path
        addpath(FieldTripDir);
        % Save this folder for future use
        bst_set('FieldTripDir', FieldTripDir);
        % Display folder
        disp(['BST> New FieldTrip folder: ' FieldTripDir]);
    % Just return an error
    else
        error(['Please download FieldTrip: http://www.fieldtriptoolbox.org/download' 10 ...
               'Then add the installation path in Brainstorm (File > Edit preferences).']);
    end
end

% Check if FieldTrip is already initialized
global ft_default;
if isempty(ft_default)
    ft_defaults;
end
isOk = 1;

% Add some subfolders
addpath(fullfile(FieldTripDir, 'specest'));
addpath(fullfile(FieldTripDir, 'preproc'));
addpath(fullfile(FieldTripDir, 'forward'));
addpath(fullfile(FieldTripDir, 'src'));
addpath(fullfile(FieldTripDir, 'utilities'));

    