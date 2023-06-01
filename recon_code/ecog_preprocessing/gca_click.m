function gca_click(fig)

ax = gca;
if nargin > 0
    figure(fig);
    ax = gca;
end

gca_hittest_off;
ax.ButtonDownFcn = @button_click;
prev = 0;
    function button_click(~,event)
        if event.Button == 1
            fprintf('%f\t\t%f\n', event.IntersectionPoint(1), event.IntersectionPoint(1)-prev);
            prev = event.IntersectionPoint(1);
        elseif event.Button == 3
            fprintf('%f\n', event.IntersectionPoint(2));
        end
    end
end