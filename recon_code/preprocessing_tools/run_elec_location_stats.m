function run_elec_location_stats(subj, options)
%RUN_ELEC_LOCATION_STATS Executes electrode location statistical analysis.
%
%   Executes electrode location statistical analysis over multiple
%   parcellations and measurement metrics, conditioned on the electrode type.
%
%   Arguments:
%       subj (string): Subject identifier 
%
%       options (struct): Specifies parameters for the analysis including 
%           millimeters and parcellations with default settings:
%           - mm [array]: Distances in millimeters for spatial statistical
%             analysis. Default is [1 3 5 7 9 10].
%           - parcs [cell array of strings]: Filenames or identifiers for
%             brain parcellations to be used in the analysis. Default
%             parcellations include 'aparc.BN_atlas+aseg.mgz',
%             'aparc.a2009s+aseg.mgz', and 'aparc+aseg.mgz'.
%
%   This function iterates through each specified parcellation and millimeter
%   specification. For each combination, it performs a statistical analysis of 
%   electrode locations. If the electrode type includes 'G', a specialized 
%   statistical analysis is conducted before the general analysis.
%
%   Example Usage:
%       subj = 'subject1';
%       options.mm = [1 3 5 7 9 10];
%       options.parcs = {'aparc.BN_atlas+aseg.mgz', 'aparc.a2009s+aseg.mgz', 'aparc+aseg.mgz'};
%       run_elec_location_stats(subj, options);
%
%   Notes:
%       - This function requires the external function `get_elec_type` to determine
%         the type of electrode from the subject data.
%       - The function `elec_location_stats` is used internally to calculate 
%         statistics for each combination of parcellation and millimeter measure.
%       - Ensure that both `get_elec_type` and `elec_location_stats` are in your
%         MATLAB path.


arguments
    subj
    options.mm = [1 3 5 7 9 10]
    options.parcs = {'aparc.BN_atlas+aseg.mgz','aparc.a2009s+aseg.mgz','aparc+aseg.mgz'};
end

% Retrieve electrode type based on subject data
etype = get_elec_type(subj);

% Extract parcellations and millimeters from options
parcs = options.parcs;
mm = options.mm;

% Loop over each parcellation and millimeter setting
for p = 1:numel(parcs)
    for m = 1:numel(mm)
        if contains(etype, 'G')
            % Conduct specialized statistical analysis for 'G' type electrodes
            elec_location_stats(subj, parcs{p}, mm(m), 1);
        end
        % Conduct general statistical analysis
        elec_location_stats(subj, parcs{p}, mm(m), 0);
    end
end

end
