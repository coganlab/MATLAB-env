function handle_scatter = plot_elec_data(elec_xyz, elec_size, colors)

handle_scatter = scatter3(elec_xyz(:,1), elec_xyz(:,2), elec_xyz(:,3), elec_size, colors, 'filled');

end