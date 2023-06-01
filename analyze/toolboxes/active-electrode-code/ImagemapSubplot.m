
function M = ImagemapSubplot(data, numRowplot, numColplot, satMode, satMin, satMax, aspect_corr, titleStr, colorscale_label, save_fig, numRow, numCol, filename, normalizeMinScale, plotTitles, ySpace, color_map)

% data - first dimension has the data for each electrode
%       - second dimension has the separate image maps
% numRowplot - how many rows of image maps to make
% numColplot - how many cols of image maps to make
% satMode - sets how the image saturation for each frame should work
%           set to 'FIXED' for one colorscale for all images, provide in
%           next variables.
%           set to 'FRAME' for one saturation scale for each image
% satMin - if 'FRAME' : saturation point for each map in percent ( i.e 0.02 for 2%)
%          if 'FIXED' min color scale value for all images
% satMax - if 'FRAME' : saturation point for each map in percent ( i.e.0.98 for 98%)
%          if 'FIXED' max color scale value for all images
% aspect_corr - correct for aspect ratio, make the plots correctly sized to
%           match the electrode array length / width
% titleStr - title string for the figure - optional, send [] if none
% colorscale_label - label for the colorscale, units, etc...
% save_fig - 'TRUE' to write figure to disk, 'FALSE' if not
% numRow - number of electrode rows
% numCol - number of electrode columns
% filename - the current data filename
% M - returns figure frame to make movies
% normalizeMinScale - if true, subtract off minimum colorscale value
%               - used for resetting all delays to 0 ms
% plotTitles - titles for each plot
% ySpace - vertical spacing between plots (defaults to 0.05 * figure height
% color_map - custom color map to use

% setup defaults if data not provided
if (exist('save_fig', 'var') == 0) || (size(save_fig,1) == 0)
    save_fig = 'FALSE';
end

if (exist('aspect_corr', 'var') == 0) || (size(aspect_corr,1) == 0)
    aspect_corr = 'FALSE';
end

% setup defaults if data not provided
if (exist('satMode', 'var') == 0) || (size(save_fig,1) == 0)
    satMode = 'FRAME';
end

if (exist('satMin', 'var') == 0) || (size(satMin,1) == 0)
    satMin = 0.02;
end

if (exist('satMax', 'var') == 0) || (size(satMax,1) == 0)
    satMax = 0.98;
end

if (exist('normalizeMinScale', 'var') == 0) || (size(normalizeMinScale,1) == 0)
    normalizeMinScale = 'FALSE';
end

if (exist('ySpace', 'var') == 0) || (size(ySpace,1) == 0)
    ySpace = 0.01;
end

if ySpace > 0.90
    disp('Warning! ySpace too large!');
    ySpace = 0.90;
end

if ySpace <0.0
    disp('Warning! ySpace too small!');
    ySpace = 0.0;
end

numSubplot = size(data,2);       % how many per plot
if numSubplot > numRowplot*numColplot
    disp('Warning! More data provided to ImagemapSubplot than can be plotted!');
    numSubplot = numRowplot*numColplot;
end

screen_size = get(0, 'ScreenSize');
disp(['screen size ' num2str(screen_size)]);


%%%%%%%%%%%%%%%%%%%% How big is the figure we have to work with?

f1 = figure('color','white');
disp(['Screen Width = ' num2str(screen_size(3)) '; Screen Height = ' num2str(screen_size(4))]);
set(f1, 'Position', [0 0 screen_size(3) screen_size(4) ] );
figure_size = get(f1, 'position');
disp(['Figure width = ' num2str(figure_size(3)) '; Figure height = ' num2str(figure_size(4))])
screenWidth = figure_size(3);
screenHeight = figure_size(4);
screenAspect = screenWidth / screenHeight;
figureWidth = screenWidth * 0.85; % allow for the size of the scale bar on the right
figureHeight = screenHeight;
disp(['Figure width = ' num2str(figureWidth) '; Figure height = ' num2str(figureHeight)])
disp(['screenAspect = ' num2str(screenAspect)]);
clf

if (exist('titleStr', 'var') == 1) && (size(titleStr,1) > 0)
    title(titleStr);
end

%%%%%%%%%%%%%%%%%%%% Set inter-subplot spacing
ySpace = figureHeight * ySpace;
xSpace = ySpace;

disp(['xSpace = ' num2str(xSpace) '; ySpace = ' num2str(ySpace)]);

%%%%%%%%%%%%%%%%%%% Set the desired aspect ratio of each subplot
arrayAspect = numCol / numRow;
if strcmp(aspect_corr, 'TRUE')
    desiredAspect = arrayAspect;
else
    desiredAspect = 1.0;
end;

disp(['desiredAspect = ' num2str(desiredAspect) '.']);

%%%%%%%%%%%%%%%%%%%% How big can we make our subplots?
if numSubplot<numColplot
    maxSubplotWidth = figureWidth / numSubplot - xSpace;
    actualCols = numSubplot;
else
    maxSubplotWidth = figureWidth / numColplot - xSpace;
    actualCols = numColplot;
end;

disp(['maxSubplotWidth = ' num2str(maxSubplotWidth) '; actualCols = ' num2str(actualCols)]);

if numSubplot<(numColplot * numRowplot)
    actualRows = (1+floor((numSubplot-1)/numColplot));
    maxSubplotHeight = figureHeight / actualRows - ySpace;
    
else
    maxSubplotHeight = figureHeight / numRowplot - ySpace;
    actualRows = numRowplot;
end;

disp(['maxSubplotHeight = ' num2str(maxSubplotHeight) '; actualRows = ' num2str(actualRows)]);


if maxSubplotWidth / maxSubplotHeight > desiredAspect
    subplotHeight = maxSubplotHeight;
    subplotWidth = maxSubplotHeight * desiredAspect;
else
    subplotWidth = maxSubplotWidth;
    subplotHeight = maxSubplotWidth / desiredAspect;
end;

disp(['subplotWidth = ' num2str(subplotWidth) '; subplotHeight = ' num2str(subplotHeight)]);

scaledWidth = subplotWidth / screenWidth;
scaledHeight = subplotHeight / screenHeight;
scaledXinterval = (subplotWidth + xSpace) / screenWidth;
scaledYinterval = (subplotHeight + ySpace) / screenHeight;

disp(['scaledWidth = ' num2str(scaledWidth) '; scaledXinterval = ' num2str(scaledXinterval)]);
disp(['scaledHeight = ' num2str(scaledHeight) '; scaledYinterval = ' num2str(scaledYinterval)]);

xStart = (1.0 - scaledXinterval * actualCols) / 2.0;
yStart = (1.0 - scaledHeight + scaledYinterval * (actualRows-1.0)) / 2.0;

for i = 1:numSubplot
    % plot the source data
    h = subplot('Position',[xStart+mod(i-1,numColplot)*scaledXinterval yStart-(floor((i-1)/numColplot))*scaledYinterval scaledWidth scaledHeight]);
    
    
    % saturate min
    iso = data(:,i);
    
    % if frame saturation mode, then calculate a new color scale for each
    % frame (subplot)
    if strcmp(satMode, 'FRAME')
        sorted = sort(iso(:));
        minVal(i) = sorted(round(size(sorted,1) * satMin));
        maxVal(i) = sorted(round(size(sorted,1) * satMax));
        imagesc(reshape(iso,numRow,numCol), [minVal(i) maxVal(i)] )
    end
    
    % if fixed scale, just use the scale provided
    if strcmp(satMode, 'FIXED')
        imagesc(reshape(iso,numRow,numCol), [satMin satMax] )
    end
    
    % if the user provides their own color map, use it. otherwise, default
    if (exist('color_map', 'var') == 1) && (size(color_map,1) > 0)
        colormap(color_map)
    else
        colormap(jet(256))
    end
    
    set(gca,'XTick',[]);
    set(gca,'YTick',[]);
    if (exist('plotTitles', 'var') == 1) && (size(plotTitles,1) > 0)
        title(plotTitles(i,:))
    end
    
end

% plot colorscale
h = axes('Position', [0.05 0.31 0.91 0.45], 'Visible', 'off');

if strcmp(satMode, 'FRAME')
    
    if strcmp(normalizeMinScale, 'TRUE')
        caxis([0 mean(maxVal) - mean(minVal)])
        disp(['Colorscape minVal ' num2str(0) ' maxVal ' num2str(mean(maxVal) - mean(minVal))])
    else
        caxis([mean(minVal) mean(maxVal)])
        disp(['Colorscape minVal ' num2str(mean(minVal)) ' maxVal ' num2str(mean(maxVal))])
    end
end

if strcmp(satMode, 'FIXED')
        if strcmp(normalizeMinScale, 'TRUE')
    caxis([0 satMax - satMin])
        else
    caxis([satMin satMax])
        end
end

c=colorbar ('FontSize',16);
ylabel(c,colorscale_label)

if strcmp(save_fig, 'TRUE')
    [~,name] = fileparts(filename);
    mkdir(strcat(pwd,'.\figures\',date));
    fileString = strcat(pwd,'.\figures\',date,'\',name,'_',titleStr,'.fig');
    %set(gcf,'PaperPositionMode','auto')
    %print(gcf, '-dpng', fileString, '-r 300')
    saveas(gcf, fileString, 'fig')
end

M = getframe(gcf);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%