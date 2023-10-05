function hCbar = cbarDGplus(pos,limits,cmap,nTick,units,unitLocation,fontSize,transPoint,clim)
%function hCbar = cbarDGplus(pos,limits,cmapName,nTick,units,unitLocation,fontSize)
%
% Adds a colorbar to a figure
%
% Required Inputs:
%   pos    - 4 element vector indicating axis position
%   limits - [minVal maxVal] 2 element vector indicating colorbar limits
%
% Optional Inputs:
%   cmapName - Name of colormap {default: 'parula' or 'jet' depending on
%              your version of MATLAB}
%   nTick    - # of color axis ticks {default: 5}
%   units    - Text plot next to colorbar to indicate units
%   unitLocation - 'top' || 'right': The place on the colorbar where units
%                  will be written
%
% Author:
% another sloppy function by David Groppe
% March 2016

if nargin<3,
    cmap=[];
end

if nargin<4,
    nTick=5;
end

if nargin<5,
    units=[];
end

if nargin<6,
    unitLocation='top';
elseif ~strcmpi(unitLocation,'top') && ~strcmpi(unitLocation,'right')
   error('unitLocation argument needs to be ''top'' or ''right''.'); 
end

if nargin<7,
   fontSize=20; 
end

if nargin<8,
   transPoint=[];
   
end

if nargin<9,
   clim=[];
   
end

cbar_min = clim(1);
cbar_max = clim(2);

% Colorbar for electrodes
hCbar=axes('position',pos);
if isempty(cmap)
    colormap('parula');
elseif isnumeric(cmap)
    if(size(cmap,1)>2)
        if(isempty(transPoint))
            rgb_vals = make_color_gradient_diff_steps(cmap,[300 700]);
        else
            n_steps = 1000;
            c_white = transPoint;
            c_array = linspace(cbar_min,cbar_max,n_steps);
            c_step_white = round(find(c_array>=c_white,1)/2);
            diff_step = n_steps-(size(cmap,1)-2).*c_step_white;
            rgb_vals = make_color_gradient_diff_steps(cmap, [repmat(c_step_white,1,(size(cmap,1)-2)) diff_step]);
         
        end
    else
        rgb_vals = make_color_gradient(cmap,1000);
    end
    colormap(rgb_vals);
else
    colormap(cmap);
end
map=colormap;
n_colors=size(map,1);

cbarDG(hCbar,1:n_colors,limits,nTick,cmap);
if strcmpi(unitLocation,'top')
    if ~isempty(units)
        ht=title(units);
        set(ht,'fontsize',fontSize);
    end
else
    ht=ylabel(units);
    set(ht,'fontsize',fontSize,'rotation',0,'VerticalAlignment','middle', ...
        'HorizontalAlignment','left');
end
ticklabels=cell(1,nTick);
ticks=linspace(limits(1),limits(2),nTick);
for a=1:nTick,
    ticklabels{a}=num2str(ticks(a),3);
end
set(hCbar,'yticklabel',ticklabels);


end

