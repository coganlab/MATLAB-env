function gca_nav(xvals)
ax = gca;
f = gcf;
f.UserData.ax = ax;
f.UserData.xvals = xvals;
f.UserData.xL = length(xvals);
f.UserData.idx = 1;
f.KeyPressFcn = @keypress;

    function keypress(h, event)
        if strcmp(event.Key, 'rightarrow')
            if h.UserData.idx + 1 < h.UserData.xL
                h.UserData.idx = h.UserData.idx + 1;
            end
        elseif strcmp(event.Key, 'leftarrow')
            if h.UserData.idx - 1 > 0
                h.UserData.idx = h.UserData.idx - 1;
            end
        end
        
        curr_lims = h.UserData.ax.XLim;
        offset = h.UserData.xvals(h.UserData.idx) - curr_lims(1) - (curr_lims(2)-curr_lims(1))/2;
        h.UserData.ax.XLim = curr_lims + offset;
    end

end