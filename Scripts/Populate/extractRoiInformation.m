function subjInfo = extractRoiInformation(Subject, options)
% Extracts region of interest (ROI) information for given subjects.
%
% Args:
%   Subject (struct array): Array of subject information.
%   options (struct, optional): Options for the extraction process.
%       - voxRad (double): Radius for electrode location analysis (default: 3).
%       - parcfn (string): Atlas parcellation function to retrieve ROI
%       information
%
% Returns:
%   subjInfo (struct array): Extracted ROI information for each subject.

arguments
    Subject
    options.voxRad = 3;  
    options.parcfn = 'aparc+aseg' % {'aparc.BN_atlas+aseg.mgz','aparc.a2009s+aseg.mgz','aparc+aseg.mgz'};
end

global RECONDIR

for iSubject = 1:length(Subject)
    clear elecIdx
    
    % Load electrode locations
    rfiledir = [RECONDIR filesep Subject(iSubject).Name filesep 'elec_recon' filesep];
    
    % Check if required files exist
    if ~isfile([rfiledir filesep Subject(iSubject).Name '_elec_locations_RAS.txt'])
        warning(['Skipping subject ' Subject(iSubject).Name '\n%s Reason: ' ...
            'missing required files in ' rfiledir ])
        continue
    end
    
    %elecs = list_electrodes(Subject(iSubject).Name);
    
    % Load electrode locations based on type (SEEG or ECoG)
    if strcmp(Subject(iSubject).Type, 'SEEG')
        filename = [rfiledir Subject(iSubject).Name '_elec_location_radius_' num2str(options.voxRad) 'mm_' options.parcfn '.mgz.csv'];
        elecInfo = parse_RAS_file([rfiledir Subject(iSubject).Name '_elec_locations_RAS.txt']);
       
    elseif strcmp(Subject(iSubject).Type, 'ECoG')
        filename = [rfiledir Subject(iSubject).Name '_elec_location_radius_' num2str(options.voxRad) 'mm_' options.parcfn '.mgz_brainshifted.csv'];
        
        % Load brain-shifted electrode locations
        elecInfo = parse_RAS_file([rfiledir Subject(iSubject).Name '_elec_locations_RAS_brainshifted.txt']);
        
    end
    % Check if the file exists, otherwise run location statistics
    if ~exist(filename)            
        run_elec_location_stats(Subject(iSubject).Name, mm = options.voxRad, parcs= {[options.parcfn '.mgz']});
    end
    % Read data from the xls file
    T = readtable(filename);
    TXT = T;
    NUM = table2array(T(:, [4, 6, 8, 10]));

    Tname = table2array(TXT(:, 2));
    Trest = table2cell(TXT);
    Tname = strcat(Subject(iSubject).Name, '-', Tname);
%     % Match electrode names and update indices
%     for iElec = 1:length(elecs)
%         for iElec2 = 1:size(TXT, 1)
%             if strcmp(elecs{iElec}, (strcat(Subject(iSubject).Name, '-', Tname(iElec2, :))))
%                 elecIdx(iElec) = iElec2;
%                 Tname(iElec2, :) = strcat(Subject(iSubject).Name, '-', Tname(iElec2, :));
%             end
%         end
%     end
%     
%     % Remove electrodes without matches
%     ii = elecIdx == 0;
%     elecIdx(ii) = [];
%     TXT = TXT(elecIdx, :);
%     NUM = NUM(elecIdx, :);
%     Tname = Tname(elecIdx, :);
%     Trest = Trest(elecIdx, :);
%     size(Trest)
%     size(elecInfo)
    % Store extracted information in the result struct
    subjInfo(iSubject).TXT = TXT;
    subjInfo(iSubject).NUM = NUM;
    subjInfo(iSubject).Tname = Tname;
    subjInfo(iSubject).Trest = Trest;  
    subjInfo(iSubject).elecInfo = elecInfo;
end
