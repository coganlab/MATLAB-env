function legendf(labels_cell, colors_array)
% legendf -- a quick and dirty solution to providing a legend for figures
% labels_cell -- cell array of text to display
% colors_array -- Nx3 color matrix, with 0-1 range
% e.g. legendf({'data1', 'data2'}, [1 0 0; 0 1 0]);

f = figure;
f.Position([1 2]) = 0;

colors_array = colors_array(1:numel(labels_cell), :);

% script draws from bottom to top, so flip the input arrays
labels_cell = labels_cell(end:-1:1);
colors_array = colors_array(end:-1:1, :);

ax = axes;
bottom = 0;
height = 1;
width = 1;
for l = 1:numel(labels_cell)
    rectangle('Position', [0.5 bottom width height], 'FaceColor', colors_array(l,:));
    text(0.1, height/2 + bottom, strrep(labels_cell{l}, '_', '\_'), 'FontSize', 12);
    bottom = bottom + height;
end

ax.XLim = [0 1];
ax.XTick = [];
ax.YTick = [];

end