function set_caxis_color(value, color)
cm = colormap;
ca = caxis;
scal = (value - ca(1)) / (ca(2)-ca(1));
cm(floor(scal*length(cm))+1, :) = color;
colormap(cm);