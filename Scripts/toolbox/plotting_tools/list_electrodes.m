function out = list_electrodes(subj_list)
% LIST_ELECTRODES    returns electrode labels for a given subject(s)
%     Will also print out a summary of the label prefixes.
% Usage:
%     list_electrodes({'D14', 'D15'});

recondir = get_recondir();

if ~iscell(subj_list)
    subj_list = {subj_list};
end

out = {};

for s = 1:numel(subj_list)
    subj = subj_list{s};
    fn = fullfile(recondir, subj, 'elec_recon', [subj '_elec_locations_RAS.txt']);
    elec = parse_RAS_file(fn);
    ulabels = unique(elec.labelprefix);
 fprintf('%s\n', subj);
    for f = 1:numel(ulabels)
        fprintf('\t%s\n', ulabels{f});
    end
    
    subj_label = {};
    
    for f = 1:numel(elec.labels)
        subj_label{f,1} = [subj '-' elec.labels{f}];
    end

    out = cat(1, out, subj_label);
   
end
warning('Note, the output labels here might not match the order of channels in your edf/neural data.');
pause(.5);
end