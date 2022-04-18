function set_colors
% SET_COLORS    tool to select colors from any image and print them to
%   command window.
% Usage:
%   Left click image to select color.
%   Press enter to print RGB values to command window.
%   Optionally, replace color_img.jpg with any image you wish.
%   Optionally, use showcolormap() to display the colors you picked.

f = figure;

cimg = imread('color_img.jpg');
ax = axes;
ax.Units = 'Pixels';
ax.Position = [0 0 size(cimg,2) size(cimg,1)];
ax.XLim = [0 size(cimg,2)];
ax.YLim = [0 size(cimg,1)];
i = image('CData', cimg);
f.UserData.i = i;
hide_axis(ax);

title('Press Enter to select color');

ax = axes();
ax.Units = 'Pixels';
ax.Position = [size(cimg,2) 0 100 size(cimg,1)];
f.Position = [f.Position(1) f.Position(2) size(cimg,2) + 100 f.Position(4)];
R = rectangle('Position', [0 0 1 1]);
hide_axis(ax);
i.UserData.R = R;
i.ButtonDownFcn = {@buttonpressed,f};
f.KeyPressFcn = @enterpressed;
f.CloseRequestFcn = @closereq;
fprintf('colors = [\n');

    function buttonpressed(handle, event, pFig)
        xy = floor(event.IntersectionPoint);
        rgb_norm = double(cimg(xy(2), xy(1),:)) / 255;
        handle.UserData.R.FaceColor = rgb_norm;
        pFig.UserData.last_chosen = rgb_norm;
    end

    function enterpressed(handle, event)
        if strcmp(event.Key, 'return')
            fprintf('%f %f %f;\n', handle.UserData.last_chosen);
        end
    end

    function closereq(~, ~)
        fprintf('];\n');
        delete(f);
    end

    function hide_axis(ax)
        pcolor = ax.Parent.Color;
        grid off;
        ax.Color = pcolor;
        ax.XTick = [];
        ax.YTick = [];
        ax.ZTick = [];
        ax.XColor = pcolor;
        ax.YColor = pcolor;
        ax.ZColor = pcolor;
    end

end