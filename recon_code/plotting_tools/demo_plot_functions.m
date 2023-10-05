

%% Using this demo
% Each section is a different demo. Just copy and paste the code into your
% Matlab command window.
% Most of the functions will assume you have the global variable RECONDIR set, which is the root
% directory for all recon folders (currently on Box). My startup.m has the
% following,
% global RECONDIR;
% RECONDIR = 'C:/Users/sf225/Box Sync/ECoG_Recon';
%
% Each subject folder has the following sub-folders:
%     elec_recon/  --  contains RAS coordinates text file
%     label/       --  contains anatomical atlas data
%     mri/         --  some MRI files
%     surf/        --  3D vertex/coordinate data for pial surfaces
%
% Right now, I am only uploading a small subset of the freesurfer output
% files. The full freesurfer results are large, ~500MB per subject, so I am
% only uploading the essential data. I can upload additional files upon
% request.
%
% contact: seth.foster@duke.edu


%% Basic plotting -- plot_surf, plot_elec, plot_annotation, with GUI file selector

    
plot_surf(); % navigate to .pial or .pial.mat file, under surf/

plot_elec(); % navigate to _elec_locations_RAS.txt file, under elec_recon/

plot_annotation(); % navigate to .annot or .annot.mat file, under label/
  

%% Plot a single subject
% Just a wrapper function for plot_surf(), plot_elec(), and
% plot_annotation()

cfg = [];
% cfg is a structure with some optional parameters to control the outcome
% of the plot, like font size, font color, electrode size, background
% color, etc. Type "help plot_defaults" to get the full list.
plot_subj('D14', cfg);


%% Plot just one hemisphere

cfg = [];
cfg.hemisphere = 'r';
plot_subj('D14', cfg);
  

%% Plot multiple subjects on average brain
 
cfg = [];
plot_subjs_on_average({'D14', 'D15'}, 'fsaverage', cfg);


%% Plot multiple subjects on average brain, but group electrodes with custom colors
% Example, if you want to group electrodes for active / inactive during
% auditory perception epoch.


cfg = [];
subj_labels = list_electrodes({'D14', 'D15'});
% Note, you don't have to use this ordering, you can provide your own cell
% array of labels, in any order, given each entry is formatted correctly, e.g.
% 'D7-RAMF3'. Also, you can provide just a subset of the possible labels,
% leaving out any that don't pertain to your analysis or visualization. The
% ones left out will not show.
% See list_electrodes_from_experiment() below for a function that gets the
% labels in the same order as the neural data.

% Set a color for each group. The first row corresponds to group idx 1, the
% second row to group idx 2, and so on. The code will use a default set of colors
% if this is not specified.
cfg.elec_colors = [
1 0 0; % red
0 1 1; % cyan
1 .5 0; % orange
0 0 1; % blue
];

% Set a size for each group. First row corresponds to group idx 1, etc.
cfg.elec_size = [
    200;
    150;
    100;
    50];

% For demonstration purposes, I'll assign a random integer 1 - 4, one per electrode these will be indices
% into the color array. Here your label IDs should have meaning, for example, 1 is
% for active, 2 is for inactive, etc.
grouping_idx = randi([1 4], numel(subj_labels), 1);

plot_subjs_on_average_grouping(subj_labels, grouping_idx, 'fsaverage', cfg);


%% Plot single subject on own brain, with grouping (see above)

cfg = [];
subj_labels = list_electrodes('D15');

grouping_idx = randi([1 4], numel(subj_labels), 1);

plot_subj_grouping(subj_labels, grouping_idx, cfg);

%% Plot electrode density maps

cfg = plot_defaults([]);
cfg.hemisphere = 'l';
plot_elec_density({'D70', 'D71'}, 10, 'fsaverage', cfg);
% if you want to fix color limits across different figures
%    >> figure(1); ca = caxis; figure(2); caxis(ca);
% if this causes 0 value to no longer be grey use
%    >> set_caxis_color(0, [.5 .5 .5]);

%% Plot subset of annotation labels
cfg = [];
cfg.show_annot = 1;
cfg.annot_index = [25 31]; % label indices
% Get label indices by first producing a plot with all labels
% (cfg.annot_index = []). The legend shows index values for each label.
cfg.alpha = 1;
plot_subj('D14', cfg);

cfg.annot_label_fn = 'h.aparc.a2009s.annot'; % cfg.hemisphere is automatically prepended. In case of cfg.hemisphere = 'b', '.mat' is appended.
plot_subj('D14', cfg);

%% Tips
% Each function also outputs the handles to the surface (patch), the
% electrodes (scatter3), and the labels(text). Therefore, if you want to
% further customize the plots, you can do so directly by accessing the
% property attributes in the handle.
handles = plot_subj('D14');
handles.surf
handles.elec
handles.labels

% When plotting grid subjects, sometimes it's good to set the alpha to 1 to
% see the pial in detail. However, sometimes the grid electrodes are hidden
% by the now opaque surface patch. Run the following.
cfg = [];
cfg.alpha = 1;
handles = plot_subj('D16', cfg);

% To remedy this, there are two functions that you can call to pull the
% electrodes and labels toward you (that is, it will pull to whereever the
% camera is positioned). This should only be used for displaying purposes
% only. Analysis of electrode positions should be done on the unaltered
% positions.

% FIRST: Position the camera to be perpendicular to the plane of the grid, as best
% as possible. Then run the following. You can run in steps of 1 mm until
% each electrode shows, then stop.

pull_elec_toward_camera(handles.elec, 14); % pull 12 mm toward camera
pull_labels_toward_camera(handles.labels, 28);

%% Some helpful tools to aid in plotting
% to select custom RGB colors in matlab
set_colors

% make a gradient of colors in N number of steps
colors = make_color_gradient([0.5 0.5 0.5; 1 1 0; 1 0 0], 100);
showcolormap(colors);

% to list subject's labels, in subj-label format
list_electrodes('D18');

% to get labels from experiment.mat, use the following
list_electrodes_from_experiment({'D18', 'D19'});

% to list subjects in recon folder
list_recon_subjs

% to list subjects and electrode type
list_recon_subjs_by_elec_type

% to set colorbar value to be a certain color
set_caxis_color

