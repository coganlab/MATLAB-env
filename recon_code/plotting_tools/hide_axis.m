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