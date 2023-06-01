function showcolormap(cm)
% SHOWCOLORMAP    display any Nx3 color array
% optional: cm
%     Nx3 RGB color array (0.0 - 1.0)

if nargin < 1
    load colors.mat;
    cm = colors;
end
figure;
imagesc(1:length(cm), [1 length(cm)]);
colormap(cm);
end