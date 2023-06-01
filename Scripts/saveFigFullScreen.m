FigH = figure('Position', get(0, 'Screensize'));
F    = getframe(FigH);
imwrite(F.cdata, 'Foos.png', 'png')