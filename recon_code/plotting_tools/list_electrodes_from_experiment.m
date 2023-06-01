function allchans = list_electrodes_from_experiment(subjs)
% LIST_ELECTRODES_FROM_EXPERIMENT    returns electrode labels for a given
% subject(s), taken from experiment.mat in the data folder.
% Usage:
%     list_electrodes_from_experiment({'D14', 'D15'});
global DUKEDIR;
allchans = {};
if ~exist(DUKEDIR, 'dir')
    warning('Please set the global variable DUKEDIR to point to subject DATA location. This is different than RECONDIR.');
    return;
end
if ~iscell(subjs)
    subjs = {subjs};
end

for s = 1:numel(subjs)
    load(fullfile(DUKEDIR, subjs{s}, 'mat', 'experiment.mat'));
    chan_names = {experiment.channels(:).name};
    for c = 1:numel(chan_names)
        chan_names{c} = sprintf('%s-%s', subjs{s}, chan_names{c});
    end
    allchans = cat(1, allchans, chan_names');
end

end