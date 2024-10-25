function default_cfg = plot_defaults(cfg)
% default_cfg.hemisphere       =  'b';                % r, l, or b (right, left, both hemisphere)
% default_cfg.use_brainshifted =  true;              % boolean, to use brainshifted electrodes, affects grid-only
% default_cfg.show_labels      =  true;               % boolean, to show elec labels
% default_cfg.show_annot       =  false;              % boolean, to show cortex color annotations
% default_cfg.annot_label_fn   = 'h.aparc.annot';     % filename of label in label/ directory. cfg.hemisphere will be prepended, in case of 'b', '.mat' will be appended
% default_cfg.annot_index      =  [];                 % array of indices into annotation label, so show subset of regions
% default_cfg.surf_color       =  [.7 .7 .7];         % color of surface patch
% default_cfg.alpha            =  .3;                 % alpha of surface patch
% default_cfg.background_color =  [1 1 1];            % background of plot
% default_cfg.elec_size        =  200; 
% default_cfg.elec_colors      =  colors;             % Nx3 color matrix, one for each depth/grid in elec_filename. Or, 1x3 for single color.
% default_cfg.font_size        =  8;
% default_cfg.font_color       =  [0 0 0];
% default_cfg.label_every_n    =  3;                  % 3 means only label every 3rd electrode, just to reduce clutter
% default_cfg.subj_labels      =  [];                 % provide only a subset of the labels to show, in {'D14-RPIP10',..} format
% default_cfg.grouping_idx     =  [];                 % same length as .labels, an integer which indexes into .colors
%
% optional input: cfg
%   If provided, this function will merge default_cfg parameters with
%   user-specified cfg parameters.
%   This allows the user to only specify a subset of parameters, and the
%   script will fill in the rest with default values.

load colors.mat;
default_cfg.hemisphere       =  'b';                % r, l, or b (right, left, both hemisphere)
default_cfg.use_brainshifted =  true;              % boolean, to use brainshifted electrodes, affects grid-only
default_cfg.show_labels      =  true;               % boolean, to show elec labels
default_cfg.show_annot       =  false;              % boolean, to show cortex color annotations
default_cfg.annot_label_fn   = 'h.aparc.annot';     % filename of label in label/ directory. cfg.hemisphere will be prepended, in case of 'b', '.mat' will be appended
default_cfg.annot_index      =  [];                 % array of indices into annotation label, so show subset of regions
default_cfg.surf_color       =  [.7 .7 .7];         % color of surface patch
default_cfg.alpha            =  .3;                 % alpha of surface patch
default_cfg.background_color =  [1 1 1];            % background of plot
default_cfg.elec_size        =  200; 
default_cfg.elec_colors      =  colors;             % Nx3 color matrix, one for each depth/grid in elec_filename. Or, 1x3 for single color.
default_cfg.font_size        =  8;
default_cfg.font_color       =  [0 0 0];
default_cfg.label_every_n    =  3;                  % 3 means only label every 3rd electrode, just to reduce clutter
default_cfg.subj_labels      =  [];                 % provide only a subset of the labels to show, in {'D14-RPIP10',..} format
default_cfg.grouping_idx     =  [];                 % same length as .labels, an integer which indexes into .colors



if nargin > 0 
    default_cfg = merge_structs(default_cfg, cfg);
end

assert(size(default_cfg.elec_colors, 1) >= numel(unique(default_cfg.grouping_idx(default_cfg.grouping_idx>0))));
assert(numel(default_cfg.subj_labels) == numel(default_cfg.grouping_idx));
