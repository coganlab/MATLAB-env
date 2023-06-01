function plot_subjs_on_average_activation(subj_labels, activation_values, avgsubj, cfg)
% PLOT_ELEC_ON_AVERAGE_ACTIVATION    Plots electrode activations on average brain.
% Electrodes with the same activation will have the same color.
%
% subj_labels  : cell array in subj-label format, e.g. {'D14-RPIP10', 'D14-RPIP9',...}
% activation_values : is an Nx1 matrix, where N is number of elements in subj_labels
% avgsubj      : char, the name of the average subject folder, e.g.
%                'fsaverage'
% Setting to parula color range
%colors = make_color_gradient([0.2422    0.1504    0.6603;0.0704    0.7457    0.7258;  0.9769    0.9839    0.0805], length(activation_values));
cfg.elec_colors = parula(length(activation_values));

%Normalizing activation values to discrete integer ids
%
% activation_norm = round(minmaxscaler(activation_values).*length(activation_values));
activation_norm = round(iqrnorm(activation_values').*length(activation_values));
activation_norm(activation_norm<1) = 1;
activation_norm(activation_norm>length(activation_values)) = length(activation_values);
plot_subjs_on_average_grouping(subj_labels, activation_norm', avgsubj, cfg);

end
