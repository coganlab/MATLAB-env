function gca_hittest_off()
ax = gca;

for a = 1:numel(ax.Children)
    if isprop(ax.Children(a), 'HitTest')
        ax.Children(a).HitTest = 'off';
    end
end
end
